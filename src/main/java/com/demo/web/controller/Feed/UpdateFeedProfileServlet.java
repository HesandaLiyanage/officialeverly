package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * UpdateFeedProfileServlet - Handles feed profile updates.
 * 
 * Route: /updateFeedProfile
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UpdateFeedProfileServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UpdateFeedProfileServlet.class.getName());
    private FeedProfileDAO feedProfileDAO;

    // Allowed image extensions
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

    @Override
    public void init() throws ServletException {
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Get current user's feed profile
        FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (feedProfile == null) {
            feedProfile = feedProfileDAO.findByUserId(userId);
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
        }

        try {
            // Get form data
            String bio = request.getParameter("bio");
            if (bio != null) {
                bio = bio.trim();
                if (bio.length() > 500) {
                    bio = bio.substring(0, 500);
                }
                feedProfile.setFeedBio(bio);
            }

            // Handle profile picture upload
            Part filePart = request.getPart("profile_picture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Validate file extension
                    String extension = getFileExtension(fileName);
                    if (isAllowedExtension(extension)) {
                        // Generate unique filename
                        String newFileName = "feed_" + userId + "_" + UUID.randomUUID().toString() + extension;

                        // Save to uploads directory
                        String uploadDir = getServletContext().getRealPath("/uploads/feed-profiles");
                        File uploadDirFile = new File(uploadDir);
                        if (!uploadDirFile.exists()) {
                            uploadDirFile.mkdirs();
                        }

                        Path filePath = Paths.get(uploadDir, newFileName);
                        Files.copy(filePart.getInputStream(), filePath);

                        String profilePictureUrl = "/uploads/feed-profiles/" + newFileName;
                        feedProfile.setFeedProfilePictureUrl(profilePictureUrl);
                        logger.info("[UpdateFeedProfile] Uploaded new profile picture: " + profilePictureUrl);
                    }
                }
            }

            // Save to database
            boolean updated = feedProfileDAO.updateProfile(feedProfile);

            if (updated) {
                // Update session with new profile data
                session.setAttribute("feedProfile", feedProfile);
                request.setAttribute("successMessage", "Profile updated successfully!");
                logger.info("[UpdateFeedProfile] Profile updated for @" + feedProfile.getFeedUsername());
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                logger.warning("[UpdateFeedProfile] Failed to update profile for @" + feedProfile.getFeedUsername());
            }

            // Set profile data and forward back to edit page
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/views/app/editpublicprofile.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[UpdateFeedProfile] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/views/app/editpublicprofile.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            return fileName.substring(lastDot).toLowerCase();
        }
        return "";
    }

    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}
