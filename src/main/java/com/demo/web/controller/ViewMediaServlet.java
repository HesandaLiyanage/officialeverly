package com.demo.web.controller;

import com.demo.web.dao.MediaDAO;
import com.demo.web.model.MediaItem;
import com.demo.web.util.EncryptionService;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;

@WebServlet("/viewMedia")
public class ViewMediaServlet extends HttpServlet {

    private MediaDAO mediaDAO;

    // Must match the physical path used in CreateMemoryServlet
    private static final String PHYSICAL_UPLOAD_PATH = "/home/hesanda/IdeaProjects/officialeverly/src/main/webapp/media_uploads_encrypted";

    @Override
    public void init() throws ServletException {
        super.init();
        mediaDAO = new MediaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Get master key from session
        SecretKey masterKey = (SecretKey) session.getAttribute("masterKey");
        if (masterKey == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Encryption not available. Please logout and login again.");
            return;
        }

        // Get media ID from URL (support both 'id' and 'mediaId' parameters)
        String mediaIdParam = request.getParameter("id");
        if (mediaIdParam == null || mediaIdParam.isEmpty()) {
            mediaIdParam = request.getParameter("mediaId");
        }
        if (mediaIdParam == null || mediaIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id parameter");
            return;
        }

        try {
            int mediaId = Integer.parseInt(mediaIdParam);
            System.out.println("=== ViewMediaServlet Debug ===");
            System.out.println("Requested media ID: " + mediaId);
            System.out.println("User ID from session: " + userId);

            // Get media metadata from database
            MediaItem mediaItem = mediaDAO.getMediaById(mediaId);

            if (mediaItem == null) {
                System.out.println("ERROR: Media not found in database for ID: " + mediaId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Media not found");
                return;
            }

            System.out.println("Found media: " + mediaItem.getOriginalFilename());
            System.out.println("  - isEncrypted: " + mediaItem.isEncrypted());
            System.out.println("  - encryptionKeyId: " + mediaItem.getEncryptionKeyId());
            System.out.println("  - filePath: " + mediaItem.getFilePath());
            System.out.println("  - mimeType: " + mediaItem.getMimeType());
            System.out.println("  - mediaUserId: " + mediaItem.getUserId());

            // Security check: Verify user owns this media
            if (mediaItem.getUserId() != userId) {
                // TODO: Also check if user has access through group sharing
                System.out.println("ERROR: Access denied. User " + userId + " doesn't own media (owned by "
                        + mediaItem.getUserId() + ")");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Check if file is encrypted
            if (!mediaItem.isEncrypted()) {
                // File not encrypted - serve directly (shouldn't happen with new system)
                System.out.println("File is NOT encrypted, serving directly");
                serveUnencryptedFile(mediaItem, response);
                return;
            }

            System.out.println("Starting decryption process...");
            // Decrypt and serve the file
            byte[] decryptedData = decryptMediaFile(mediaItem, masterKey);

            // Set response headers
            response.setContentType(mediaItem.getMimeType());
            response.setContentLength(decryptedData.length);

            // Cache headers (optional - improves performance)
            response.setHeader("Cache-Control", "private, max-age=3600"); // Cache 1 hour

            // Send decrypted file to browser
            OutputStream out = response.getOutputStream();
            out.write(decryptedData);
            out.flush();

            System.out.println("✓ Served decrypted media: " + mediaItem.getOriginalFilename() +
                    " (" + decryptedData.length + " bytes)");

        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid mediaId format: " + mediaIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid mediaId");
        } catch (Exception e) {
            System.out.println("ERROR during decryption: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error decrypting media: " + e.getMessage());
        }
    }

    /**
     * Decrypt media file
     */
    private byte[] decryptMediaFile(MediaItem mediaItem, SecretKey userMasterKey) throws Exception {

        // Step 1: Get encrypted media key from database
        MediaDAO.EncryptionKeyData keyData = mediaDAO.getMediaEncryptionKey(
                mediaItem.getEncryptionKeyId(),
                mediaItem.getUserId());

        if (keyData == null) {
            throw new Exception("Encryption key not found for media: " + mediaItem.getMediaId());
        }

        // Step 2: Decrypt media key using user's master key
        SecretKey mediaKey = EncryptionService.decryptKey(
                keyData.getEncryptedKey(),
                keyData.getIv(),
                userMasterKey);

        System.out.println("  → Decrypted media key for: " + mediaItem.getOriginalFilename());

        // Step 3: Read encrypted file from disk
        byte[] encryptedFileData = readEncryptedFile(mediaItem.getFilePath());

        System.out.println("  → Read encrypted file: " + encryptedFileData.length + " bytes");

        // Step 4: Decrypt file data
        byte[] decryptedData = EncryptionService.decrypt(
                encryptedFileData,
                mediaItem.getEncryptionIv(),
                mediaKey);

        System.out.println("  → Decrypted to: " + decryptedData.length + " bytes");

        return decryptedData;
    }

    /**
     * Read encrypted file from disk
     */
    private byte[] readEncryptedFile(String relativePath) throws IOException {
        // Extract just the filename from the relative path (e.g.,
        // "encrypted_uploads/xxx.enc" -> "xxx.enc")
        String filename = relativePath;
        if (relativePath.contains("/")) {
            filename = relativePath.substring(relativePath.lastIndexOf("/") + 1);
        }
        if (relativePath.contains(File.separator)) {
            filename = relativePath.substring(relativePath.lastIndexOf(File.separator) + 1);
        }

        // Use the physical upload path where files are actually stored
        String uploadPath = PHYSICAL_UPLOAD_PATH + File.separator + filename;
        File file = new File(uploadPath);

        System.out.println("  → Looking for encrypted file at: " + uploadPath);

        if (!file.exists()) {
            throw new FileNotFoundException("Encrypted file not found: " + uploadPath);
        }

        // Read file into byte array
        try (FileInputStream fis = new FileInputStream(file);
                ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }

            return baos.toByteArray();
        }
    }

    /**
     * Serve unencrypted file (for backwards compatibility)
     */
    private void serveUnencryptedFile(MediaItem mediaItem, HttpServletResponse response)
            throws IOException {

        String uploadPath = getServletContext().getRealPath("") + File.separator + mediaItem.getFilePath();
        File file = new File(uploadPath);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        response.setContentType(mediaItem.getMimeType());
        response.setContentLength((int) file.length());

        try (FileInputStream fis = new FileInputStream(file);
                OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }

            out.flush();
        }
    }
}

/*
 * HOW THIS WORKS:
 *
 * 1. Browser requests: /viewMedia?mediaId=101
 * 2. Check user is logged in
 * 3. Check user has master key in session
 * 4. Get media metadata from database
 * 5. Verify user owns this media (security check)
 * 6. Get encrypted media key from database
 * 7. Decrypt media key using master key
 * 8. Read encrypted file from disk
 * 9. Decrypt file using media key
 * 10. Send decrypted bytes to browser
 * 11. Browser displays image!
 *
 * SECURITY:
 * - Only logged-in users can access
 * - Only file owner can view (or group members - todo)
 * - All decryption happens server-side
 * - Decrypted data only in memory, never saved to disk
 * - Master key only in session (memory), not database
 */