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

    // Path where media files are saved
    private static final String UPLOAD_DIR = "media_uploads";
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();
        memberDAO = new MemoryMemberDAO();

        // Create the upload directory if it doesn't exist
        try {
            Files.createDirectories(Paths.get(PHYSICAL_UPLOAD_PATH));
            System.out.println("Media upload directory ready: " + PHYSICAL_UPLOAD_PATH);
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

        // Check if creating a collab memory
        String type = request.getParameter("type");
        request.setAttribute("isCollaborative", "collab".equals(type));

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
            String isCollabParam = request.getParameter("isCollaborative");
            boolean isCollaborative = "true".equalsIgnoreCase(isCollabParam) || "on".equalsIgnoreCase(isCollabParam);

            if (memoryName == null || memoryName.trim().isEmpty()) {
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Memory name is required\"}");
                return;
            }

            Memory memory = new Memory();
            memory.setTitle(memoryName.trim());
            memory.setDescription(memoryDate != null ? "Created on " + memoryDate : "");
            memory.setUserId(userId);
            memory.setPublic(false);
            memory.setCollaborative(isCollaborative);

            int memoryId;
            if (isCollaborative) {
                // Create collaborative memory
                memoryId = memoryDAO.createCollabMemory(memory);
                // Add creator as owner
                memberDAO.addMember(memoryId, userId, "owner");
                System.out.println("Collaborative memory created with ID: " + memoryId);
            } else {
                // Create regular memory
                memoryId = memoryDAO.createMemory(memory);
                System.out.println("Memory created with ID: " + memoryId);
            }

            Collection<Part> fileParts = request.getParts();
            int uploadedCount = 0;

            for (Part filePart : fileParts) {
                if (!"mediaFiles".equals(filePart.getName()) || filePart.getSize() == 0)
                    continue;

                String originalFilename = getFileName(filePart);
                if (originalFilename == null || originalFilename.isEmpty())
                    continue;

                System.out.println("Processing file: " + originalFilename + " (" + filePart.getSize() + " bytes)");

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

                int mediaId = mediaDAO.createMediaItem(mediaItem, null);

                memoryDAO.linkMediaToMemory(memoryId, mediaId);
                uploadedCount++;

                System.out.println("Uploaded: " + originalFilename + " (media_id: " + mediaId + ")");
            }

            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_OK);
            try (PrintWriter out = response.getWriter()) {
                out.write(String.format(
                        "{\"success\": true, \"memoryId\": %d, \"filesUploaded\": %d, \"isCollaborative\": %s}",
                        memoryId, uploadedCount, isCollaborative));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed: " + e.getMessage().replace("\"", "'") + "\"}");
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