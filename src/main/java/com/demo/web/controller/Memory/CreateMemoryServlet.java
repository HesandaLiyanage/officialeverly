package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;
import com.demo.web.util.EncryptionService;
import com.demo.web.util.EncryptionService.EncryptedData;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.*;
import java.util.Collection;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 50,       // 50MB per file
        maxRequestSize = 1024 * 1024 * 100    // 100MB total request
)
public class CreateMemoryServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;

    // Configure your upload directory
    private static final String UPLOAD_DIR = "encrypted_uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();

        // Create upload directory if it doesn't exist
        try {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
        } catch (Exception e) {
            throw new ServletException("Failed to create upload directory", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to create memory JSP
        request.getRequestDispatcher("/WEB-INF/views/memories/createMemory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Validate session
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Get master key from session
        SecretKey masterKey = (SecretKey) session.getAttribute("masterKey");
        if (masterKey == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Encryption not available. Please logout and login again.\"}");
            return;
        }

        try {
            // Get form data
            String memoryName = request.getParameter("memoryName");
            String memoryDate = request.getParameter("memoryDate");

            if (memoryName == null || memoryName.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Memory name is required\"}");
                return;
            }

            // Create Memory object
            Memory memory = new Memory();
            memory.setTitle(memoryName.trim());
            memory.setDescription(memoryDate != null ? "Created on " + memoryDate : "");
            memory.setUserId(userId);
            memory.setPublic(false);

            // Save memory to database
            int memoryId = memoryDAO.createMemory(memory);

            System.out.println("✓ Memory created with ID: " + memoryId);

            // Process uploaded files
            Collection<Part> fileParts = request.getParts();
            int uploadedCount = 0;

            for (Part filePart : fileParts) {
                // Skip non-file parts
                if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0) {
                    continue;
                }

                String fileName = getFileName(filePart);
                if (fileName == null || fileName.isEmpty()) {
                    continue;
                }

                System.out.println("Processing file: " + fileName + " (" + filePart.getSize() + " bytes)");

                // Read file data
                byte[] fileData = readFileData(filePart);

                // Upload with encryption
                int mediaId = uploadEncryptedMedia(
                        userId,
                        masterKey,
                        fileData,
                        fileName,
                        filePart.getContentType()
                );

                // Link media to memory
                memoryDAO.linkMediaToMemory(memoryId, mediaId);

                uploadedCount++;
                System.out.println("✓ Uploaded and encrypted: " + fileName + " (media_id: " + mediaId + ")");
            }

            // Set first uploaded media as cover (if any)
            if (uploadedCount > 0) {
                // You can implement logic to set cover photo here
                System.out.println("✓ Total files uploaded: " + uploadedCount);
            }

            // Success response
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_OK);

            try (PrintWriter out = response.getWriter()) {
                out.write(String.format(
                        "{\"success\": true, \"memoryId\": %d, \"filesUploaded\": %d}",
                        memoryId, uploadedCount
                ));
            }


        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to create memory: " + e.getMessage() + "\"}");
        }
    }

    /*
     * Upload and encrypt media file
     */
    private int uploadEncryptedMedia(int userId, SecretKey userMasterKey,
                                     byte[] fileData, String originalFilename,
                                     String mimeType) throws Exception {

        // 1. Generate unique media encryption key
        SecretKey mediaKey = EncryptionService.generateKey();
        String keyId = EncryptionService.generateKeyId();

        // 2. Encrypt the file data
        EncryptedData encryptedFile = EncryptionService.encrypt(fileData, mediaKey);

        // 3. Save encrypted file to disk
        String encryptedFilename = keyId + ".enc";
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        String filePath = uploadPath + File.separator + encryptedFilename;

        saveEncryptedFile(encryptedFile.getEncryptedData(), filePath);

        // 4. Encrypt the media key with user's master key
        EncryptedData encryptedMediaKey = EncryptionService.encryptKey(mediaKey, userMasterKey);

        // 5. Store encrypted media key in database
        mediaDAO.storeMediaEncryptionKey(
                keyId,
                userId,
                encryptedMediaKey.getEncryptedData(),
                encryptedMediaKey.getIv()
        );

        // 6. Create media item metadata
        MediaItem mediaItem = new MediaItem();
        mediaItem.setUserId(userId);
        mediaItem.setFilename(encryptedFilename);
        mediaItem.setOriginalFilename(originalFilename);
        mediaItem.setFilePath(UPLOAD_DIR + "/" + encryptedFilename);
        mediaItem.setFileSize(encryptedFile.getEncryptedData().length);
        mediaItem.setOriginalFileSize(fileData.length);
        mediaItem.setMimeType(mimeType);
        mediaItem.setMediaType(mimeType.startsWith("image/") ? "IMAGE" : "VIDEO");
        mediaItem.setTitle(originalFilename);
        mediaItem.setEncrypted(true);
        mediaItem.setEncryptionKeyId(keyId);

        // 7. Save media metadata to database
        return mediaDAO.createMediaItem(mediaItem, encryptedFile.getIv());
    }

    /**
     * Read file data from Part
     */
    private byte[] readFileData(Part filePart) throws IOException {
        try (InputStream inputStream = filePart.getInputStream();
             ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            return outputStream.toByteArray();
        }
    }

    /**
     * Save encrypted file to disk
     */
    private void saveEncryptedFile(byte[] encryptedData, String filePath) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            fos.write(encryptedData);
        }
    }

    /**
     * Extract filename from Part header
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return null;
        }

        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }

        return null;
    }
}

/*
 * HOW THIS WORKS:
 *
 * 1. User uploads memory with photos/videos
 * 2. For each file:
 *    a. Generate random media key (AES-256)
 *    b. Encrypt file with media key → save to disk as .enc
 *    c. Encrypt media key with user's master key
 *    d. Store encrypted media key in encryption_keys table
 *    e. Store file metadata in media_items table
 * 3. Link all media to the memory
 *
 * SECURITY:
 * - Files encrypted at rest (disk)
 * - Media keys encrypted with master key (database)
 * - Master key only in session (memory)
 * - Each file has unique encryption key
 *
 * FLOW:
 * Original File → Encrypt → Save .enc → Database metadata
 *                    ↓
 *              Media Key → Encrypt with Master Key → Database
 */