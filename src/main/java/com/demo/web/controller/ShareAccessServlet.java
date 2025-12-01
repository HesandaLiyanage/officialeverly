//package com.demo.web.controller;
//
//import com.demo.web.dao.MediaDAO;
//import com.demo.web.model.MediaItem;
//import com.demo.web.model.MediaShare;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.io.File;
//import java.nio.file.Files;
//import java.nio.file.Paths;
//import java.sql.SQLException;
//
//public class ShareAccessServlet extends HttpServlet {
//    private MediaDAO MediaDAO;
//
//    @Override
//    public void init() throws ServletException {
//        MediaDAO = new MediaDAO();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String shareKey = request.getParameter("key");
//
//        if (shareKey == null || shareKey.isEmpty()) {
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Share key required");
//            return;
//        }
//
//        try {
//            // Get share by key
//            MediaShare share = MediaDAO.getShareByKey(shareKey);
//
//            if (share == null) {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid or expired share link");
//                return;
//            }
//
//            // Get media item
//            MediaItem mediaItem = MediaDAO.getMediaItemById(share.getMediaId());
//
//            if (mediaItem == null) {
//                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Media not found");
//                return;
//            }
//
//            // Check if share is still valid
//            if (share.getExpiresAt() != null && share.getExpiresAt().before(new java.util.Date())) {
//                response.sendError(HttpServletResponse.SC_GONE, "Share link has expired");
//                return;
//            }
//
//            // For link sharing, we can serve the encrypted file (user needs key to decrypt)
//            // In a real implementation, you'd have a more sophisticated approach
//            String filePath = getServletContext().getRealPath("") + File.separator + mediaItem.getFilePath();
//
//            // Set appropriate headers
//            response.setContentType(mediaItem.getMimeType());
//            response.setHeader("Content-Disposition", "inline; filename=\"" + mediaItem.getOriginalFilename() + "\"");
//
//            // Stream the file
//            Files.copy(Paths.get(filePath), response.getOutputStream());
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving media");
//        }
//    }
//}