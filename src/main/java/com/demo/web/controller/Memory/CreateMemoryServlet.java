package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.MemoryMemberDAO;
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

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB per file
        maxRequestSize = 1024 * 1024 * 100 // 100MB total request
)
public class CreateMemoryServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;
    private MemoryMemberDAO memberDAO;

    // Logical path stored in DB
    private static final String LOGICAL_UPLOAD_DIR = "media_uploads";

    // Physical path where files are saved
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();
        memberDAO = new MemoryMemberDAO();

        // Create the physical directory if it doesn't exist
        try {
            Files.createDirectories(Paths.get(PHYSICAL_UPLOAD_PATH));
            System.out.println("Upload directory ready: " + PHYSICAL_UPLOAD_PATH);
        } catch (IOException e) {
            throw new ServletException("Failed to create upload directory", e);
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
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            String memoryName = request.getParameter("memoryName");
            String memoryDate = request.getParameter("memoryDate");

            if (memoryName == null || memoryName.trim().isEmpty()) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Memory name is required\"}");
                return;
            }

            // Check if this is a collaborative memory
            String isCollabParam = request.getParameter("isCollab");
            boolean isCollab = "true".equalsIgnoreCase(isCollabParam);

            Memory memory = new Memory();
            memory.setTitle(memoryName.trim());
            memory.setDescription(memoryDate != null ? "Created on " + memoryDate : "");
            memory.setUserId(userId);
            memory.setPublic(false);

            int memoryId = memoryDAO.createMemory(memory);
            System.out.println("Memory created with ID: " + memoryId);

            // If collaborative, set is_collaborative flag and add creator as owner
            if (isCollab) {
                memoryDAO.setMemoryCollaborative(memoryId);
                memberDAO.addMemberSimple(memoryId, userId, "owner");
                System.out.println("Set memory " + memoryId + " as collaborative, added user " + userId + " as owner");
            }

            Collection<Part> fileParts = request.getParts();
            int uploadedCount = 0;

            for (Part filePart : fileParts) {
                if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0)
                    continue;

                String fileName = getFileName(filePart);
                if (fileName == null || fileName.isEmpty())
                    continue;

                System.out.println("Processing file: " + fileName + " (" + filePart.getSize() + " bytes)");

                byte[] fileData = readFileData(filePart);

                int mediaId = uploadMedia(userId, fileData, fileName, filePart.getContentType());

                memoryDAO.linkMediaToMemory(memoryId, mediaId);
                uploadedCount++;

                System.out.println("Uploaded: " + fileName + " (media_id: " + mediaId + ")");
            }

            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_OK);
            try (PrintWriter out = response.getWriter()) {
                out.write(String.format(
                        "{\"success\": true, \"memoryId\": %d, \"filesUploaded\": %d}",
                        memoryId, uploadedCount));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    /**
     * Upload media file directly without encryption
     */
    private int uploadMedia(int userId, byte[] fileData, String originalFilename, String mimeType) throws Exception {
        // Generate a unique filename
        String uniqueId = UUID.randomUUID().toString();
        String extension = "";
        int dotIndex = originalFilename.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalFilename.substring(dotIndex);
        }
        String uniqueFilename = uniqueId + extension;

        // Physical save location
        String physicalPath = PHYSICAL_UPLOAD_PATH + File.separator + uniqueFilename;
        saveFile(fileData, physicalPath);

        // Create media item
        MediaItem mediaItem = new MediaItem();
        mediaItem.setUserId(userId);
        mediaItem.setFilename(uniqueFilename);
        mediaItem.setOriginalFilename(originalFilename);
        mediaItem.setFilePath(LOGICAL_UPLOAD_DIR + "/" + uniqueFilename);
        mediaItem.setFileSize(fileData.length);
        mediaItem.setOriginalFileSize(fileData.length);
        mediaItem.setMimeType(mimeType);
        mediaItem.setMediaType(mimeType.startsWith("image/") ? "IMAGE" : "VIDEO");
        mediaItem.setTitle(originalFilename);
        mediaItem.setEncrypted(false);
        mediaItem.setEncryptionKeyId(null);

        return mediaDAO.createMediaItemSimple(mediaItem);
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

    private void saveFile(byte[] data, String filePath) throws IOException {
        Files.write(Paths.get(filePath), data);
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