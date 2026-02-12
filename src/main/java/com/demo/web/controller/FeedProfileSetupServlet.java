package com.demo.web.controller;

import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.regex.Pattern;

/**
 * Servlet for handling Feed Profile setup and creation.
 * Maps to /feedProfileSetupServlet
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15 // 15MB
)
public class FeedProfileSetupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedProfileDAO feedProfileDAO;

    // Username pattern: 3-30 chars, alphanumeric and underscores only
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");

    // Allowed image extensions
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

    @Override
    public void init() throws ServletException {
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if user already has a feed profile
        FeedProfile existingProfile = feedProfileDAO.findByUserId(userId);
        if (existingProfile != null) {
            // Already has profile, redirect to feed
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // Forward to setup page
        request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if user already has a feed profile (prevent duplicate submissions)
        FeedProfile existingProfile = feedProfileDAO.findByUserId(userId);
        if (existingProfile != null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // Get form parameters
        String feedUsername = request.getParameter("feedUsername");
        String feedBio = request.getParameter("feedBio");

        // Validate username
        if (feedUsername == null || feedUsername.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username is required.");
            request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
            return;
        }

        feedUsername = feedUsername.trim().toLowerCase();

        // Validate username format
        if (!USERNAME_PATTERN.matcher(feedUsername).matches()) {
            request.setAttribute("errorMessage",
                    "Username must be 3-30 characters and can only contain letters, numbers, and underscores.");
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedBio", feedBio);
            request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
            return;
        }

        // Check if username is taken
        if (feedProfileDAO.usernameExists(feedUsername)) {
            request.setAttribute("errorMessage", "This username is already taken. Please choose another.");
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedBio", feedBio);
            request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
            return;
        }

        // Validate bio length
        if (feedBio != null && feedBio.length() > 500) {
            request.setAttribute("errorMessage", "Bio must be 500 characters or less.");
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedBio", feedBio);
            request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
            return;
        }

        // Handle profile picture upload
        String profilePictureUrl = null;
        try {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Validate file extension
                    String extension = getFileExtension(fileName);
                    if (!isAllowedExtension(extension)) {
                        request.setAttribute("errorMessage",
                                "Invalid file type. Allowed: JPG, JPEG, PNG, GIF, WEBP");
                        request.setAttribute("feedUsername", feedUsername);
                        request.setAttribute("feedBio", feedBio);
                        request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
                        return;
                    }

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

                    profilePictureUrl = "/uploads/feed-profiles/" + newFileName;
                }
            }
        } catch (Exception e) {
            System.err.println("Error handling profile picture upload: " + e.getMessage());
            // Continue without profile picture
        }

        // Set default profile picture if none uploaded
        if (profilePictureUrl == null || profilePictureUrl.isEmpty()) {
            profilePictureUrl = "/resources/assets/default-feed-avatar.png";
        }

        // Create feed profile
        try {
            FeedProfile newProfile = new FeedProfile();
            newProfile.setUserId(userId);
            newProfile.setFeedUsername(feedUsername);
            newProfile.setFeedProfilePictureUrl(profilePictureUrl);
            newProfile.setFeedBio(feedBio != null ? feedBio.trim() : "");

            boolean created = feedProfileDAO.createProfile(newProfile);

            if (created) {
                // Store feed profile in session for quick access
                session.setAttribute("feedProfile", newProfile);

                System.out.println("✓ Feed profile created for user " + userId + ": @" + feedUsername);

                // Redirect to feed
                response.sendRedirect(request.getContextPath() + "/feed");
            } else {
                request.setAttribute("errorMessage", "Failed to create profile. Please try again.");
                request.setAttribute("feedUsername", feedUsername);
                request.setAttribute("feedBio", feedBio);
                request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedBio", feedBio);
            request.getRequestDispatcher("/views/app/feedProfileSetup.jsp").forward(request, response);
        }
    }

    /**
     * Get the submitted file name from a Part
     */
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim()
                            .replace("\"", "");
                }
            }
        }
        return null;
    }

    /**
     * Get file extension from filename
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            return fileName.substring(lastDot).toLowerCase();
        }
        return "";
    }

    /**
     * Check if file extension is allowed
     */
    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}
