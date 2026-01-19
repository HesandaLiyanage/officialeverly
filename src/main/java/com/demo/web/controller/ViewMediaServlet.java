package com.demo.web.controller;

import com.demo.web.dao.MediaDAO;
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

    // Must match the physical path used in CreateMemoryServlet
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

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

            // Security check: Verify user owns this media
            if (mediaItem.getUserId() != userId) {
                System.out.println("ERROR: Access denied. User " + userId + " doesn't own media (owned by "
                        + mediaItem.getUserId() + ")");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Serve the file directly
            serveFile(mediaItem, response);

        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid mediaId format: " + mediaIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid mediaId");
        } catch (Exception e) {
            System.out.println("ERROR serving media: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error serving media: " + e.getMessage());
        }
    }

    /**
     * Serve file directly from disk
     */
    private void serveFile(MediaItem mediaItem, HttpServletResponse response) throws IOException {
        // Extract just the filename from the relative path
        String filename = mediaItem.getFilePath();
        if (filename.contains("/")) {
            filename = filename.substring(filename.lastIndexOf("/") + 1);
        }
        if (filename.contains(File.separator)) {
            filename = filename.substring(filename.lastIndexOf(File.separator) + 1);
        }

        String filePath = PHYSICAL_UPLOAD_PATH + File.separator + filename;
        File file = new File(filePath);

        System.out.println("  → Looking for file at: " + filePath);

        if (!file.exists()) {
            throw new FileNotFoundException("File not found: " + filePath);
        }

        // Set response headers
        response.setContentType(mediaItem.getMimeType());
        response.setContentLength((int) file.length());
        response.setHeader("Cache-Control", "private, max-age=3600"); // Cache 1 hour

        // Stream file to browser
        try (FileInputStream fis = new FileInputStream(file);
                OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }

            out.flush();
        }

        System.out.println("✓ Served media: " + mediaItem.getOriginalFilename() +
                " (" + file.length() + " bytes)");
    }
}