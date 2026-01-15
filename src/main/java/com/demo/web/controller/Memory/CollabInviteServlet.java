package com.demo.web.controller.Memory;

import com.demo.web.dao.InviteLinkDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.InviteLink;
import com.demo.web.model.Memory;
import com.demo.web.model.MemoryMember;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for handling collaborative memory invite links
 * 
 * GET /invite/{token} - Show join page or auto-join if already logged in
 * POST /invite/{token} - Join the memory
 */
public class CollabInviteServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private InviteLinkDAO inviteLinkDao;
    private MemoryMemberDAO memberDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        inviteLinkDao = new InviteLinkDAO();
        memberDao = new MemoryMemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        // Extract token from path
        String token = extractToken(pathInfo);
        if (token == null || token.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        try {
            // Validate the invite link
            InviteLink inviteLink = inviteLinkDao.getInviteLinkByToken(token);

            if (inviteLink == null) {
                request.setAttribute("error", "This invite link does not exist.");
                request.getRequestDispatcher("/views/app/joinMemory.jsp").forward(request, response);
                return;
            }

            if (!inviteLink.isValid()) {
                String reason = "This invite link is no longer valid.";
                if (!inviteLink.isActive()) {
                    reason = "This invite link has been revoked.";
                } else if (inviteLink.getExpiresAt() != null &&
                        inviteLink.getExpiresAt().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
                    reason = "This invite link has expired.";
                } else if (inviteLink.getMaxUses() != null && inviteLink.getUseCount() >= inviteLink.getMaxUses()) {
                    reason = "This invite link has reached its maximum number of uses.";
                }
                request.setAttribute("error", reason);
                request.getRequestDispatcher("/views/app/joinMemory.jsp").forward(request, response);
                return;
            }

            // Get the memory details
            Memory memory = memoryDao.getMemoryById(inviteLink.getMemoryId());
            if (memory == null) {
                request.setAttribute("error", "The memory associated with this link no longer exists.");
                request.getRequestDispatcher("/views/app/joinMemory.jsp").forward(request, response);
                return;
            }

            // Check if user is logged in
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                // Store the invite URL in session for after login
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("pendingInviteToken", token);
                response.sendRedirect(request.getContextPath() + "/login?return=" +
                        java.net.URLEncoder.encode("/invite/" + token, "UTF-8"));
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            // Check if already a member
            if (memberDao.isUserMemberOf(memory.getMemoryId(), userId)) {
                // Already a member, redirect to the memory
                response.sendRedirect(request.getContextPath() + "/memoryViewServlet?id=" + memory.getMemoryId());
                return;
            }

            // Set attributes for JSP
            request.setAttribute("memory", memory);
            request.setAttribute("token", token);
            request.setAttribute("inviteLink", inviteLink);

            request.getRequestDispatcher("/views/app/joinMemory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your invite.");
            request.getRequestDispatcher("/views/app/joinMemory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        String pathInfo = request.getPathInfo();
        String token = extractToken(pathInfo);

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Please log in to join this memory\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        SecretKey masterKey = (SecretKey) session.getAttribute("masterKey");

        if (masterKey == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Encryption key missing. Please log out and log in again.\"}");
            return;
        }

        try {
            // Validate the invite link
            InviteLink inviteLink = inviteLinkDao.getInviteLinkByToken(token);

            if (inviteLink == null || !inviteLink.isValid()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"This invite link is not valid\"}");
                return;
            }

            Memory memory = memoryDao.getMemoryById(inviteLink.getMemoryId());
            if (memory == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Memory not found\"}");
                return;
            }

            // Check if already a member
            if (memberDao.isUserMemberOf(memory.getMemoryId(), userId)) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(
                        "{\"success\": true, \"message\": \"You are already a member of this memory\", \"memoryId\": "
                                + memory.getMemoryId() + "}");
                return;
            }

            // Get the owner's encrypted group key to decrypt and re-encrypt for the new
            // member
            MemoryMember ownerMember = getOwnerMember(memory.getMemoryId());
            if (ownerMember == null) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Could not find memory owner\"}");
                return;
            }

            // For now, we need the current user's session to have access to decrypt group
            // key
            // In a real scenario, we'd need a server-side mechanism to re-encrypt
            // Since we're using client-side encryption, we'll store a reference
            // The actual group key sharing happens when the owner or existing member
            // re-encrypts for the new user

            // For simplicity in this implementation, we'll generate a new encrypted copy
            // using the same group key that was encrypted for the owner
            // This requires the owner to be online OR we store the group key server-side
            // (less secure)

            // Simplified approach: Use the memory's group_key_id to look up and share
            // In production, you'd want a more sophisticated key exchange protocol

            // Get owner's group key data
            byte[] ownerEncryptedKey = ownerMember.getEncryptedGroupKey();
            byte[] ownerKeyIv = ownerMember.getGroupKeyIv();

            // Since we can't decrypt the owner's key without owner's master key,
            // we'll store a placeholder and have the owner/system share the key
            // For this demo, we'll need to implement an alternative approach

            // Alternative: Store the raw group key in a secure table on the server
            // and encrypt it for each new user when they join
            // This is a trade-off between pure E2E encryption and usability

            // For now, add member with placeholder key data
            // The member will request key from owner when viewing
            memberDao.addMember(memory.getMemoryId(), userId, "contributor",
                    ownerEncryptedKey, ownerKeyIv);

            // Increment the use count
            inviteLinkDao.incrementUseCount(token);

            System.out.println("User " + userId + " joined memory " + memory.getMemoryId());

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"success\": true, \"memoryId\": " + memory.getMemoryId() + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter()
                    .write("{\"error\": \"Failed to join memory: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private String extractToken(String pathInfo) {
        if (pathInfo == null || pathInfo.isEmpty()) {
            return null;
        }
        // Remove leading slash
        String token = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        // Remove any trailing path segments
        int slashIndex = token.indexOf('/');
        if (slashIndex > 0) {
            token = token.substring(0, slashIndex);
        }
        return token;
    }

    private MemoryMember getOwnerMember(int memoryId) throws Exception {
        java.util.List<MemoryMember> members = memberDao.getMembersOfMemory(memoryId);
        for (MemoryMember member : members) {
            if ("owner".equals(member.getRole())) {
                return member;
            }
        }
        return null;
    }
}
