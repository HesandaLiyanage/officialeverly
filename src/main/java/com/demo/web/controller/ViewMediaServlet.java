package com.demo.web.controller;

import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.MediaItem;

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
    private MemoryMemberDAO memberDAO;

    // Physical path where files are stored
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        mediaDAO = new MediaDAO();
        memberDAO = new MemoryMemberDAO();
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
            System.out.println("  - filePath: " + mediaItem.getFilePath());
            System.out.println("  - mimeType: " + mediaItem.getMimeType());
            System.out.println("  - mediaUserId: " + mediaItem.getUserId());

            // Security check: Verify user has access (owner OR collaborative memory member)
            boolean hasAccess = (mediaItem.getUserId() == userId);

            if (!hasAccess) {
                // Check if user is a member of a collaborative memory that contains this media
                Integer memoryId = mediaDAO.getMemoryIdForMedia(mediaId);
                if (memoryId != null) {
                    try {
                        hasAccess = memberDAO.isUserMemberOf(memoryId, userId);
                        if (hasAccess) {
                            System.out.println("Access granted through collaborative memory membership");
                        }
                    } catch (Exception e) {
                        System.out.println("Error checking membership: " + e.getMessage());
                    }
                }
            }

            if (!hasAccess) {
                System.out.println("ERROR: Access denied. User " + userId + " doesn't have access to media");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Read and serve the file directly
            byte[] fileData = readFile(mediaItem.getFilePath());

            // Set response headers
            response.setContentType(mediaItem.getMimeType());
            response.setContentLength(fileData.length);

            // Cache headers (optional - improves performance)
            response.setHeader("Cache-Control", "private, max-age=3600"); // Cache 1 hour

            // Send file to browser
            OutputStream out = response.getOutputStream();
            out.write(fileData);
            out.flush();

            System.out.println("✓ Served media: " + mediaItem.getOriginalFilename() +
                    " (" + fileData.length + " bytes)");

        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid mediaId format: " + mediaIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid mediaId");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error serving media: " + e.getMessage());
        }
    }

    /**
     * Read file from disk
     */
    private byte[] readFile(String relativePath) throws IOException {
        // Extract just the filename from the relative path
        String filename = relativePath;
        if (relativePath.contains("/")) {
            filename = relativePath.substring(relativePath.lastIndexOf("/") + 1);
        }
        if (relativePath.contains(File.separator)) {
            filename = relativePath.substring(relativePath.lastIndexOf(File.separator) + 1);
        }

        // Use the physical upload path where files are stored
        String uploadPath = PHYSICAL_UPLOAD_PATH + File.separator + filename;
        File file = new File(uploadPath);

        System.out.println("  → Looking for file at: " + uploadPath);

        if (!file.exists()) {
            throw new FileNotFoundException("File not found: " + uploadPath);
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
}

/*
 * HOW THIS WORKS:
 *
 * 1. Browser requests: /viewMedia?mediaId=101
 * 2. Check user is logged in
 * 3. Get media metadata from database
 * 4. Verify user has access (owner or collaborative memory member)
 * 5. Read file from disk
 * 6. Send bytes to browser
 * 7. Browser displays image/video!
 *
 * SECURITY:
 * - Only logged-in users can access
 * - Only file owner or collaborative memory members can view
 */