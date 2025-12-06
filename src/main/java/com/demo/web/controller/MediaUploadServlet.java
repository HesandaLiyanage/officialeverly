//package com.demo.web.controller;
//
//import com.demo.web.dao.MediaDAO;
//import com.demo.web.dao.userDAO;
//import com.demo.web.model.*;
//import com.demo.web.util.EncryptionService;
//
//import javax.crypto.SecretKey;
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.http.*;
//import java.io.*;
//import java.nio.file.Files;
//import java.nio.file.Paths;
//import java.nio.file.StandardCopyOption;
//import java.sql.SQLException;
//import java.util.UUID;
//
//@MultipartConfig(
//        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
//        maxFileSize = 1024 * 1024 * 500,     // 500MB
//        maxRequestSize = 1024 * 1024 * 1000  // 1GB
//)
//public class MediaUploadServlet extends HttpServlet {
//    private static final String UPLOAD_DIR = "uploads/media";
//    private static final long SPLIT_THRESHOLD = 50 * 1024 * 1024; // 50MB
//    private static final int CHUNK_SIZE = 10 * 1024 * 1024; // 10MB chunks
//
//    private MediaDAO mediaDAO;
//    private userDAO userDAO;
//
//    @Override
//    public void init() throws ServletException {
//        mediaDAO = new MediaDAO();
//        userDAO = new userDAO();
//        // Create upload directory if it doesn't exist
//        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) {
//            uploadDir.mkdirs();
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Check if user is logged in
//        HttpSession session = request.getSession(false);
//        if (session == null || session.getAttribute("user_id") == null) {
//            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
//            return;
//        }
//
//        int userId = (Integer) session.getAttribute("user_id");
//        String action = request.getParameter("action");
//
//        try {
//            if ("upload".equals(action)) {
//                handleEncryptedMediaUpload(request, response, userId);
//            } else if ("createMemory".equals(action)) {
//                handleCreateMemory(request, response, userId);
//            } else if ("sharePublic".equals(action)) {
//                handlePublicShare(request, response, userId);
//            } else if ("shareLink".equals(action)) {
//                handleLinkShare(request, response, userId);
//            } else if ("shareGroup".equals(action)) {
//                handleGroupShare(request, response, userId);
//            } else {
//                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Database error occurred");
//            forwardToView(request, response, "memories");
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Error occurred while processing request: " + e.getMessage());
//            forwardToView(request, response, "memories");
//        }
//    }
//
//    private void handleEncryptedMediaUpload(HttpServletRequest request, HttpServletResponse response, int userId)
//            throws ServletException, IOException, SQLException, Exception {
//
//        Part filePart = request.getPart("mediaFile");
//        String title = request.getParameter("title");
//        String description = request.getParameter("description");
//        String memoryId = request.getParameter("memoryId");
//
//        if (filePart == null || filePart.getSize() == 0) {
//            request.setAttribute("error", "Please select a file to upload");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//
//        if (!isValidMediaFile(fileName)) {
//            request.setAttribute("error", "Please upload a valid media file");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        // Read file data
//        byte[] fileData = filePart.getInputStream().readAllBytes();
//        long originalFileSize = fileData.length;
//
//        // Determine if file should be split
//        boolean shouldSplit = fileData.length > SPLIT_THRESHOLD;
//        int splitCount = 1;
//        boolean isSplit = false;
//
//        // Generate encryption key
//        SecretKey encryptionKey = EncryptionService.generateKey();
//        String keyId = EncryptionService.generateKeyId();
//
//        // Encrypt file data
//        EncryptionService.EncryptedData encryptedData = EncryptionService.encrypt(fileData, encryptionKey);
//
//        // Split if necessary
//        String[] filePaths;
//        if (shouldSplit) {
//            byte[][] chunks = EncryptionService.splitFile(encryptedData.getEncryptedData(), CHUNK_SIZE);
//            splitCount = chunks.length;
//            isSplit = true;
//
//            // Save each chunk
//            filePaths = new String[splitCount];
//            for (int i = 0; i < chunks.length; i++) {
//                String chunkFileName = userId + "_" + System.currentTimeMillis() + "_" + i + "_" + fileName + ".enc";
//                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
//                String chunkPath = uploadPath + File.separator + chunkFileName;
//
//                // Combine IV and chunk data
//                byte[] ivAndChunk = new byte[encryptedData.getIv().length + chunks[i].length];
//                System.arraycopy(encryptedData.getIv(), 0, ivAndChunk, 0, encryptedData.getIv().length);
//                System.arraycopy(chunks[i], 0, ivAndChunk, encryptedData.getIv().length, chunks[i].length);
//
//                Files.write(Paths.get(chunkPath), ivAndChunk);
//                filePaths[i] = UPLOAD_DIR + "/" + chunkFileName;
//            }
//        } else {
//            // Save single encrypted file
//            String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName + ".enc";
//            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
//            String filePath = uploadPath + File.separator + uniqueFileName;
//
//            // Combine IV and encrypted data
//            byte[] ivAndEncrypted = new byte[encryptedData.getIv().length + encryptedData.getEncryptedData().length];
//            System.arraycopy(encryptedData.getIv(), 0, ivAndEncrypted, 0, encryptedData.getIv().length);
//            System.arraycopy(encryptedData.getEncryptedData(), 0, ivAndEncrypted, encryptedData.getIv().length, encryptedData.getEncryptedData().length);
//
//            Files.write(Paths.get(filePath), ivAndEncrypted);
//            filePaths = new String[]{UPLOAD_DIR + "/" + uniqueFileName};
//        }
//
//        // Create MediaItem object
//        MediaItem mediaItem = new MediaItem(
//                userId,
//                Paths.get(filePaths[0]).getFileName().toString(),
//                fileName,
//                filePaths[0], // Main file path
//                filePart.getSize(),
//                filePart.getContentType(),
//                getMediaType(fileName),
//                getUserStorageBucket(userId)
//        );
//
//        mediaItem.setTitle(title != null && !title.isEmpty() ? title : fileName);
//        mediaItem.setDescription(description);
//        mediaItem.setEncrypted(true);
//        mediaItem.setEncryptionKeyId(keyId);
//        mediaItem.setSplitCount(splitCount);
//        mediaItem.setSplit(isSplit);
//        mediaItem.setOriginalFileSize(originalFileSize);
//
//        // Save to database
//        boolean saved = mediaDAO.saveMediaItem(mediaItem);
//
//        if (saved) {
//            // Save encryption key (encrypted with user's master key - simplified here)
//            EncryptionKey encKey = new EncryptionKey(keyId, userId, EncryptionService.keyToString(encryptionKey).getBytes());
//            mediaDAO.saveEncryptionKey(encKey);
//
//            // If adding to memory
//            if (memoryId != null && !memoryId.isEmpty()) {
//                try {
//                    int memId = Integer.parseInt(memoryId);
//                    mediaDAO.addMediaToMemory(memId, mediaItem.getMediaId());
//                    request.setAttribute("success", "Encrypted media uploaded and added to memory successfully!");
//                } catch (NumberFormatException e) {
//                    request.setAttribute("success", "Encrypted media uploaded successfully!");
//                }
//            } else {
//                request.setAttribute("success", "Encrypted media uploaded successfully!");
//            }
//        } else {
//            request.setAttribute("error", "Failed to save encrypted media information");
//        }
//
//        forwardToView(request, response, "memories");
//    }
//
//    // Add this missing method
//    private void handleCreateMemory(HttpServletRequest request, HttpServletResponse response, int userId)
//            throws ServletException, IOException, SQLException {
//
//        String title = request.getParameter("memoryTitle");
//        String description = request.getParameter("memoryDescription");
//
//        if (title == null || title.trim().isEmpty()) {
//            request.setAttribute("error", "Memory title is required");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        Memory memory = new Memory(userId, title.trim(), description);
//        boolean created = mediaDAO.createMemory(memory);
//
//        if (created) {
//            request.setAttribute("success", "Memory created successfully!");
//        } else {
//            request.setAttribute("error", "Failed to create memory");
//        }
//
//        forwardToView(request, response, "memories");
//    }
//
//    private void handlePublicShare(HttpServletRequest request, HttpServletResponse response, int userId)
//            throws ServletException, IOException, SQLException {
//
//        String mediaId = request.getParameter("mediaId");
//
//        if (mediaId == null) {
//            request.setAttribute("error", "Media selection required");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        try {
//            int medId = Integer.parseInt(mediaId);
//
//            MediaShare share = new MediaShare(medId, MediaShare.SHARE_TYPE_PUBLIC);
//            boolean shared = mediaDAO.createMediaShare(share);
//
//            if (shared) {
//                request.setAttribute("success", "Media shared publicly!");
//            } else {
//                request.setAttribute("error", "Failed to share media publicly");
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("error", "Invalid media selection");
//        }
//
//        forwardToView(request, response, "memories");
//    }
//
//    private void handleLinkShare(HttpServletRequest request, HttpServletResponse response, int userId)
//            throws ServletException, IOException, SQLException {
//
//        String mediaId = request.getParameter("mediaId");
//        String expiryHours = request.getParameter("expiryHours");
//
//        if (mediaId == null) {
//            request.setAttribute("error", "Media selection required");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        try {
//            int medId = Integer.parseInt(mediaId);
//
//            MediaShare share = new MediaShare(medId, MediaShare.SHARE_TYPE_LINK);
//            share.setShareKey(UUID.randomUUID().toString()); // Generate unique share key
//
//            if (expiryHours != null && !expiryHours.isEmpty()) {
//                long expiryMillis = System.currentTimeMillis() + (Long.parseLong(expiryHours) * 60 * 60 * 1000);
//                share.setExpiresAt(new java.sql.Timestamp(expiryMillis));
//            }
//
//            boolean shared = mediaDAO.createMediaShare(share);
//
//            if (shared) {
//                String shareLink = request.getRequestURL().toString().replace("media", "share?key=" + share.getShareKey());
//                request.setAttribute("success", "Media shared! Link: " + shareLink);
//            } else {
//                request.setAttribute("error", "Failed to create share link");
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("error", "Invalid media or expiry selection");
//        }
//
//        forwardToView(request, response, "memories");
//    }
//
//    private void handleGroupShare(HttpServletRequest request, HttpServletResponse response, int userId)
//            throws ServletException, IOException, SQLException {
//
//        String mediaId = request.getParameter("mediaId");
//        String groupId = request.getParameter("groupId");
//
//        if (mediaId == null || groupId == null) {
//            request.setAttribute("error", "Media and group selection required");
//            forwardToView(request, response, "memories");
//            return;
//        }
//
//        try {
//            int medId = Integer.parseInt(mediaId);
//            int grpId = Integer.parseInt(groupId);
//
//            boolean shared = mediaDAO.shareMediaWithGroup(grpId, medId, userId);
//
//            if (shared) {
//                request.setAttribute("success", "Media shared with group successfully!");
//            } else {
//                request.setAttribute("error", "Failed to share media with group");
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute("error", "Invalid media or group selection");
//        }
//
//        forwardToView(request, response, "memories");
//    }
//
//    private boolean isValidMediaFile(String fileName) {
//        String extension = getFileExtension(fileName).toLowerCase();
//        return extension.matches("^(jpg|jpeg|png|gif|bmp|webp|mp4|mov|avi|mkv|mp3|wav|flac|m4a|pdf|doc|docx)$");
//    }
//
//    private String getMediaType(String fileName) {
//        String extension = getFileExtension(fileName).toLowerCase();
//
//        if (extension.matches("^(jpg|jpeg|png|gif|bmp|webp)$")) {
//            return "IMAGE";
//        } else if (extension.matches("^(mp4|mov|avi|mkv)$")) {
//            return "VIDEO";
//        } else if (extension.matches("^(mp3|wav|flac|m4a)$")) {
//            return "AUDIO";
//        } else {
//            return "DOCUMENT";
//        }
//    }
//
//    private String getFileExtension(String fileName) {
//        int lastDotIndex = fileName.lastIndexOf('.');
//        return lastDotIndex > 0 ? fileName.substring(lastDotIndex + 1) : "";
//    }
//
//    private String getUserStorageBucket(int userId) {
//        return "user-" + userId + "-bucket";
//    }
//
//    private void forwardToView(HttpServletRequest request, HttpServletResponse response, String page)
//            throws ServletException, IOException {
//        request.getRequestDispatcher("/views?page=" + page).forward(request, response);
//    }
//}