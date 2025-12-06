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
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 50,       // 50MB per file
        maxRequestSize = 1024 * 1024 * 100    // 100MB total request
)
public class CreateMemoryServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;

    // Logical path stored in DB (for future production use)
    private static final String LOGICAL_UPLOAD_DIR = "encrypted_uploads";

    // REAL physical path where encrypted files are saved (your dev path)
    private static final String PHYSICAL_UPLOAD_PATH =
            "/home/hesanda/IdeaProjects/officialeverly/src/main/webapp/media_uploads_encrypted";

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();

        // Create the physical directory if it doesn't exist
        try {
            Files.createDirectories(Paths.get(PHYSICAL_UPLOAD_PATH));
            System.out.println("Encrypted upload directory ready: " + PHYSICAL_UPLOAD_PATH);
        } catch (IOException e) {
            throw new ServletException("Failed to create encrypted upload directory", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/memories/createMemory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        SecretKey masterKey = (SecretKey) session.getAttribute("masterKey");
        if (masterKey == null) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"error\": \"Encryption key missing\"}");
            return;
        }

        try {
            String memoryName = request.getParameter("memoryName");
            String memoryDate = request.getParameter("memoryDate");

            if (memoryName == null || memoryName.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Memory name is required\"}");
                return;
            }

            Memory memory = new Memory();
            memory.setTitle(memoryName.trim());
            memory.setDescription(memoryDate != null ? "Created on " + memoryDate : "");
            memory.setUserId(userId);
            memory.setPublic(false);

            int memoryId = memoryDAO.createMemory(memory);
            System.out.println("Memory created with ID: " + memoryId);

            Collection<Part> fileParts = request.getParts();
            int uploadedCount = 0;

            for (Part filePart : fileParts) {
                if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0) continue;

                String fileName = getFileName(filePart);
                if (fileName == null || fileName.isEmpty()) continue;

                System.out.println("Processing file: " + fileName + " (" + filePart.getSize() + " bytes)");

                byte[] fileData = readFileData(filePart);

                int mediaId = uploadEncryptedMedia(
                        userId, masterKey, fileData, fileName, filePart.getContentType()
                );

                memoryDAO.linkMediaToMemory(memoryId, mediaId);
                uploadedCount++;

                System.out.println("Uploaded & encrypted: " + fileName + " (media_id: " + mediaId + ")");
            }

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
            response.getWriter().write("{\"error\": \"Failed: " + e.getMessage() + "\"}");
        }
    }

    private int uploadEncryptedMedia(int userId, SecretKey userMasterKey,
                                     byte[] fileData, String originalFilename, String mimeType) throws Exception {

        SecretKey mediaKey = EncryptionService.generateKey();
        String keyId = EncryptionService.generateKeyId();

        EncryptedData encryptedFile = EncryptionService.encrypt(fileData, mediaKey);

        String encryptedFilename = keyId + ".enc";

        // PHYSICAL SAVE LOCATION (your custom path)
        String physicalPath = PHYSICAL_UPLOAD_PATH + File.separator + encryptedFilename;
        saveEncryptedFile(encryptedFile.getEncryptedData(), physicalPath);

        EncryptedData encryptedMediaKey = EncryptionService.encryptKey(mediaKey, userMasterKey);

        mediaDAO.storeMediaEncryptionKey(
                keyId, userId,
                encryptedMediaKey.getEncryptedData(),
                encryptedMediaKey.getIv()
        );

        MediaItem mediaItem = new MediaItem();
        mediaItem.setUserId(userId);
        mediaItem.setFilename(encryptedFilename);
        mediaItem.setOriginalFilename(originalFilename);
        // LOGICAL path stored in DB (so it works in production later)
        mediaItem.setFilePath(LOGICAL_UPLOAD_DIR + "/" + encryptedFilename);
        mediaItem.setFileSize(encryptedFile.getEncryptedData().length);
        mediaItem.setOriginalFileSize(fileData.length);
        mediaItem.setMimeType(mimeType);
        mediaItem.setMediaType(mimeType.startsWith("image/") ? "IMAGE" : "VIDEO");
        mediaItem.setTitle(originalFilename);
        mediaItem.setEncrypted(true);
        mediaItem.setEncryptionKeyId(keyId);

        return mediaDAO.createMediaItem(mediaItem, encryptedFile.getIv());
    }

    private byte[] readFileData(Part filePart) throws IOException {
        try (InputStream in = filePart.getInputStream();
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            return out.toByteArray();
        }
    }

    private void saveEncryptedFile(byte[] encryptedData, String filePath) throws IOException {
        Files.write(Paths.get(filePath), encryptedData);
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String partHeader : header.split(";")) {
            if (partHeader.trim().startsWith("filename")) {
                String filename = partHeader.substring(partHeader.indexOf('=') + 1).trim().replace("\"", "");
                return filename.substring(filename.lastIndexOf('/') + 1)
                        .substring(filename.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
}