package com.demo.web.controller;

import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;
import com.demo.web.model.Group;

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
    private memoryDAO memoryDao;
    private MemoryMemberDAO memberDao;
    private FeedPostDAO feedPostDAO;
    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;

    // Must match the physical path used in CreateMemoryServlet
    private static final String PHYSICAL_UPLOAD_PATH = "/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads";

    @Override
    public void init() throws ServletException {
        super.init();
        mediaDAO = new MediaDAO();
        memoryDao = new memoryDAO();
        memberDao = new MemoryMemberDAO();
        feedPostDAO = new FeedPostDAO();
        groupDAO = new GroupDAO();
        groupMemberDAO = new GroupMemberDAO();
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

            // Security check: Verify user has access to this media
            boolean hasAccess = false;

            // Check 1: User owns this media
            if (mediaItem.getUserId() == userId) {
                hasAccess = true;
                System.out.println("  - Access granted: User owns media");
            }

            // Check 2: Media belongs to a collaborative memory and user is a member
            if (!hasAccess) {
                try {
                    int memoryId = mediaDAO.getMemoryIdForMedia(mediaId);
                    if (memoryId > 0) {
                        // Check if collaborative memory and user is member
                        Memory memory = memoryDao.getMemoryById(memoryId);
                        if (memory != null && memory.isCollaborative()) {
                            if (memberDao.isMember(memory.getMemoryId(), userId)) {
                                hasAccess = true;
                                System.out.println(
                                        "  - Access granted: User is member of collab memory " + memory.getMemoryId());
                            }
                        }

                        // Check 3: Media is part of a public feed post
                        if (!hasAccess && feedPostDAO.isMemorySharedInFeed(memoryId)) {
                            hasAccess = true;
                            System.out.println("  - Access granted: Media is part of a public feed post");
                        }

                        // Check 4: Media belongs to a group memory and user is a group member
                        if (!hasAccess && memory != null && memory.getGroupId() != null) {
                            int groupId = memory.getGroupId();
                            Group group = groupDAO.findById(groupId);
                            boolean isGroupAdmin = (group != null && group.getUserId() == userId);
                            boolean isGroupMember = groupMemberDAO.isUserMember(groupId, userId);
                            if (isGroupAdmin || isGroupMember) {
                                hasAccess = true;
                                System.out.println("  - Access granted: User is member of group " + groupId);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("  - Error checking memory access: " + e.getMessage());
                }
            }

            if (!hasAccess) {
                System.out.println("ERROR: Access denied. User " + userId + " doesn't have access to media");
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