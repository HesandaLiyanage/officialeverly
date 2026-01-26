package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.UUID;

/**
 * Servlet for updating memory details including adding/removing media
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB per file
        maxRequestSize = 1024 * 1024 * 100 // 100MB total request
)
public class UpdateMemoryServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MediaDAO mediaDao;

    // Path where media files are saved (same as CreateMemoryServlet)
    private static final String UPLOAD_DIR = "media_uploads";
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();

        // Ensure upload directory exists
        try {
            Files.createDirectories(Paths.get(PHYSICAL_UPLOAD_PATH));
        } catch (IOException e) {
            throw new ServletException("Failed to create upload directory", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            // Get form parameters
            String memoryIdParam = request.getParameter("memoryId");
            String title = request.getParameter("memoryName");
            String description = request.getParameter("memoryDescription");
            String[] removedMediaIds = request.getParameterValues("removedFileIds[]");

            // Debug logging
            System.out.println("=== UpdateMemoryServlet Debug ===");
            System.out.println("memoryId param: " + memoryIdParam);
            System.out.println("memoryName param: " + title);
            System.out.println("memoryDescription param: " + description);
            System.out.println("userId from session: " + userId);

            if (memoryIdParam == null || memoryIdParam.isEmpty()) {
                System.out.println("ERROR: memoryId is null or empty!");
                response.sendRedirect("/memories");
                return;
            }

            int memoryId = Integer.parseInt(memoryIdParam);

            // Fetch existing memory
            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null) {
                System.out.println("ERROR: Memory not found for id: " + memoryId);
                request.setAttribute("errorMessage", "Memory not found");
                response.sendRedirect("/memories");
                return;
            }

            // Check ownership
            if (memory.getUserId() != userId) {
                System.out.println("ERROR: User " + userId + " doesn't own memory " + memoryId + " (owned by "
                        + memory.getUserId() + ")");
                request.setAttribute("errorMessage", "You don't have permission to edit this memory");
                response.sendRedirect("/memories");
                return;
            }

            // Update memory fields
            if (title != null && !title.trim().isEmpty()) {
                memory.setTitle(title.trim());
            }
            if (description != null) {
                memory.setDescription(description.trim());
            }

            // Save title/description updates
            boolean updated = memoryDao.updateMemory(memory);
            System.out.println("Memory title/description update result: " + updated);

            // Handle removed media items
            if (removedMediaIds != null && removedMediaIds.length > 0) {
                System.out.println("Processing " + removedMediaIds.length + " media items for removal...");
                for (String mediaIdStr : removedMediaIds) {
                    try {
                        int mediaId = Integer.parseInt(mediaIdStr);
                        boolean unlinked = memoryDao.unlinkMediaFromMemory(memoryId, mediaId);
                        System.out.println("Unlinked media " + mediaId + " from memory " + memoryId + ": " + unlinked);

                        // Optionally delete the media item itself (and file)
                        // For now, just unlink it from the memory
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid media ID: " + mediaIdStr);
                    }
                }
            }

            // Handle new file uploads
            Collection<Part> fileParts = request.getParts();
            int uploadedCount = 0;

            for (Part filePart : fileParts) {
                if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0)
                    continue;

                String originalFilename = getFileName(filePart);
                if (originalFilename == null || originalFilename.isEmpty())
                    continue;

                System.out.println("Processing new file: " + originalFilename + " (" + filePart.getSize() + " bytes)");

                // Generate unique filename
                String uniqueFilename = UUID.randomUUID().toString() + "_" + originalFilename;

                // Save file to disk
                String physicalPath = PHYSICAL_UPLOAD_PATH + File.separator + uniqueFilename;
                saveFile(filePart.getInputStream(), physicalPath);

                // Create media item in database
                MediaItem mediaItem = new MediaItem();
                mediaItem.setUserId(userId);
                mediaItem.setFilename(uniqueFilename);
                mediaItem.setOriginalFilename(originalFilename);
                mediaItem.setFilePath(UPLOAD_DIR + "/" + uniqueFilename);
                mediaItem.setFileSize(filePart.getSize());
                mediaItem.setOriginalFileSize(filePart.getSize());
                mediaItem.setMimeType(filePart.getContentType());
                mediaItem.setMediaType(filePart.getContentType().startsWith("image/") ? "IMAGE" : "VIDEO");
                mediaItem.setTitle(originalFilename);
                mediaItem.setEncrypted(false);
                mediaItem.setEncryptionKeyId(null);

                int mediaId = mediaDao.createMediaItem(mediaItem, null);

                // Link new media to memory
                memoryDao.linkMediaToMemory(memoryId, mediaId);
                uploadedCount++;

                System.out.println("Added new media: " + originalFilename + " (media_id: " + mediaId + ")");
            }

            System.out.println("Memory updated successfully! Added " + uploadedCount + " new files.");

            // Redirect to memory view
            response.sendRedirect("/memoryview?id=" + memoryId);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating memory: " + e.getMessage());
            response.sendRedirect("/memories");
        }
    }

    private void saveFile(InputStream inputStream, String filePath) throws IOException {
        try (OutputStream out = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null)
            return null;
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
