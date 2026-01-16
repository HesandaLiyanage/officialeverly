package com.demo.web.controller.Memory;

import com.demo.web.dao.InviteLinkDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;
import com.demo.web.util.EncryptionService;
import com.demo.web.util.EncryptionService.EncryptedData;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

/**
 * Servlet for generating invite links for collaborative memories
 * 
 * POST /memory/generate-invite
 * Parameters:
 * - memoryId: ID of the memory to generate invite for
 * - expiresInHours: (optional) hours until link expires
 * - maxUses: (optional) maximum number of uses
 */
public class GenerateInviteLinkServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private InviteLinkDAO inviteLinkDao;
    private MemoryMemberDAO memberDao;
    private MediaDAO mediaDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        inviteLinkDao = new InviteLinkDAO();
        memberDao = new MemoryMemberDAO();
        mediaDao = new MediaDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        SecretKey masterKey = (SecretKey) session.getAttribute("masterKey");

        if (masterKey == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.write("{\"error\": \"Encryption key missing. Please log out and log in again.\"}");
            return;
        }

        try {
            // Parse parameters
            String memoryIdParam = request.getParameter("memoryId");
            if (memoryIdParam == null || memoryIdParam.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\": \"Memory ID is required\"}");
                return;
            }

            int memoryId = Integer.parseInt(memoryIdParam);

            // Get the memory
            Memory memory = memoryDao.getMemoryById(memoryId);
            if (memory == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\": \"Memory not found\"}");
                return;
            }

            // Check if the user owns this memory
            if (memory.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("{\"error\": \"You don't have permission to share this memory\"}");
                return;
            }

            // If memory is not yet collaborative, make it collaborative
            if (!memory.isCollaborative()) {
                // Generate a new group key for this collaborative memory
                SecretKey groupKey = EncryptionService.generateKey();
                String groupKeyId = EncryptionService.generateKeyId();

                // Encrypt the group key with the owner's master key (for owner access)
                EncryptedData encryptedGroupKey = EncryptionService.encryptGroupKeyForUser(groupKey, masterKey);

                // Add owner as the first member
                memberDao.addMember(memoryId, userId, "owner",
                        encryptedGroupKey.getEncryptedData(),
                        encryptedGroupKey.getIv());

                // Generate the invite token FIRST (needed to encrypt group key for sharing)
                String token = EncryptionService.generateInviteToken();
                byte[] salt = EncryptionService.generateSalt();

                // OPTION C: Encrypt group key with token-derived key for sharing
                EncryptedData tokenEncryptedGroupKey = EncryptionService.encryptGroupKeyWithToken(
                        groupKey, token, salt);

                // Store both the memory collab status AND token-encrypted group key
                memoryDao.storeTokenEncryptedGroupKey(memoryId, groupKeyId,
                        tokenEncryptedGroupKey.getEncryptedData(),
                        salt,
                        tokenEncryptedGroupKey.getIv());

                System.out.println("Memory " + memoryId + " is now collaborative with groupKeyId: " + groupKeyId);

                // Re-encrypt existing media keys with the group key so collaborators can access
                List<MediaItem> existingMedia = mediaDao.getMediaForMemory(memoryId);
                for (MediaItem media : existingMedia) {
                    if (media.isEncrypted() && media.getEncryptionKeyId() != null) {
                        // Get owner's encrypted media key
                        MediaDAO.EncryptionKeyData ownerKeyData = mediaDao.getMediaEncryptionKey(
                                media.getEncryptionKeyId(), userId);
                        if (ownerKeyData != null) {
                            // Decrypt with owner's master key
                            SecretKey mediaKey = EncryptionService.decryptKey(
                                    ownerKeyData.getEncryptedKey(),
                                    ownerKeyData.getIv(),
                                    masterKey);
                            // Re-encrypt with group key
                            EncryptedData groupEncryptedKey = EncryptionService.encryptKey(mediaKey, groupKey);
                            // Store group-key-encrypted version
                            mediaDao.storeGroupKeyEncryptedMediaKey(
                                    media.getEncryptionKeyId(),
                                    memoryId,
                                    groupEncryptedKey.getEncryptedData(),
                                    groupEncryptedKey.getIv());
                            System.out.println("  Re-encrypted media key for: " + media.getOriginalFilename());
                        }
                    }
                }
                System.out.println("Re-encrypted " + existingMedia.size() + " media keys with group key");

                // Parse optional expiration time
                Timestamp expiresAt = null;
                String expiresInHoursParam = request.getParameter("expiresInHours");
                if (expiresInHoursParam != null && !expiresInHoursParam.isEmpty()) {
                    int hours = Integer.parseInt(expiresInHoursParam);
                    expiresAt = new Timestamp(System.currentTimeMillis() + (hours * 60L * 60L * 1000L));
                }

                // Parse optional max uses
                Integer maxUses = null;
                String maxUsesParam = request.getParameter("maxUses");
                if (maxUsesParam != null && !maxUsesParam.isEmpty()) {
                    maxUses = Integer.parseInt(maxUsesParam);
                }

                // Create the invite link with the token we already generated
                inviteLinkDao.createInviteLinkWithToken(memoryId, userId, token, expiresAt, maxUses);

                // Build the full invite URL
                String baseUrl = request.getScheme() + "://" + request.getServerName();
                if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                    baseUrl += ":" + request.getServerPort();
                }
                baseUrl += request.getContextPath();
                String inviteUrl = baseUrl + "/invite/" + token;

                // Return success response
                response.setStatus(HttpServletResponse.SC_OK);
                out.write("{\"success\": true, \"token\": \"" + token + "\", \"inviteUrl\": \"" + inviteUrl + "\"}");
                return;
            }

            // Memory is already collaborative - just generate a new invite link
            // (uses existing token-encrypted group key)

            // Parse optional expiration time
            Timestamp expiresAt = null;
            String expiresInHoursParam = request.getParameter("expiresInHours");
            if (expiresInHoursParam != null && !expiresInHoursParam.isEmpty()) {
                int hours = Integer.parseInt(expiresInHoursParam);
                expiresAt = new Timestamp(System.currentTimeMillis() + (hours * 60L * 60L * 1000L));
            }

            // Parse optional max uses
            Integer maxUses = null;
            String maxUsesParam = request.getParameter("maxUses");
            if (maxUsesParam != null && !maxUsesParam.isEmpty()) {
                maxUses = Integer.parseInt(maxUsesParam);
            }

            // For already-collaborative memory, we need to generate a new token
            // and re-encrypt the group key with it
            // First, get the current group key by decrypting owner's copy
            SecretKey groupKey = null;
            var ownerMember = memberDao.getMember(memoryId, userId);
            if (ownerMember != null) {
                groupKey = EncryptionService.decryptGroupKeyForUser(
                        ownerMember.getEncryptedGroupKey(),
                        ownerMember.getGroupKeyIv(),
                        masterKey);
            }

            if (groupKey == null) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.write("{\"error\": \"Could not retrieve group key\"}");
                return;
            }

            // Generate new token and encrypt group key with it
            String token = EncryptionService.generateInviteToken();
            byte[] salt = EncryptionService.generateSalt();
            EncryptedData tokenEncryptedGroupKey = EncryptionService.encryptGroupKeyWithToken(
                    groupKey, token, salt);

            // Update memory with new token-encrypted group key
            memoryDao.storeTokenEncryptedGroupKey(memoryId, memory.getGroupKeyId(),
                    tokenEncryptedGroupKey.getEncryptedData(),
                    salt,
                    tokenEncryptedGroupKey.getIv());

            // Generate the invite link
            inviteLinkDao.createInviteLinkWithToken(memoryId, userId, token, expiresAt, maxUses);

            // Build the full invite URL
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            baseUrl += request.getContextPath();
            String inviteUrl = baseUrl + "/invite/" + token;

            // Return success response
            response.setStatus(HttpServletResponse.SC_OK);
            out.write("{\"success\": true, \"token\": \"" + token + "\", \"inviteUrl\": \"" + inviteUrl + "\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"error\": \"Invalid parameter format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Failed to generate invite link: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET is not supported, return method not allowed
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"error\": \"Use POST to generate invite links\"}");
    }
}
