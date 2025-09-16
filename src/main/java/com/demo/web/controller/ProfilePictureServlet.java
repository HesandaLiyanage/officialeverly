package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.model.user;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfilePictureServlet extends HttpServlet {
    private static final String DEFAULT_UPLOAD_DIR = "uploads/profile_pictures";
    private userDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new userDAO();

        // Get custom upload path from init parameter
        String customUploadPath = getServletConfig().getInitParameter("upload.path");

        if (customUploadPath != null && !customUploadPath.isEmpty()) {
            File uploadDir = new File(customUploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            getServletContext().setAttribute("profile.upload.path", customUploadPath);
        } else {
            // Use default path within web application
            String defaultPath = getServletContext().getRealPath("") + File.separator + DEFAULT_UPLOAD_DIR;
            File uploadDir = new File(defaultPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            getServletContext().setAttribute("profile.upload.path", defaultPath);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        try {
            Part filePart = request.getPart("profilePicture");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            if (fileName != null && !fileName.isEmpty()) {
                // Validate file type
                if (!isValidImageFile(fileName)) {
                    request.setAttribute("error", "Please upload a valid image file (JPG, PNG, GIF)");
                    request.getRequestDispatcher("/views?page=profile").forward(request, response);
                    return;
                }

                // Generate unique filename
                String uniqueFileName = userId + "_" + System.currentTimeMillis() + "_" + fileName;

                // Get upload path from servlet context
                String uploadPath = (String) getServletContext().getAttribute("profile.upload.path");
                String filePath = uploadPath + File.separator + uniqueFileName;

                // Save file
                Files.copy(filePart.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);

                // Store relative path in database (or full path if needed)
                String relativePath = getRelativePath(uploadPath, uniqueFileName);
                boolean updated = userDAO.updateProfilePicture(userId, relativePath);

                if (updated) {
                    request.setAttribute("success", "Profile picture updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update profile picture");
                }
            } else {
                request.setAttribute("error", "Please select a file to upload");
            }

            request.getRequestDispatcher("/views?page=profile").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred while updating profile picture");
            request.getRequestDispatcher("/views?page=profile").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error occurred while uploading file: " + e.getMessage());
            request.getRequestDispatcher("/views?page=profile").forward(request, response);
        }
    }

    private boolean isValidImageFile(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        return extension.equals("jpg") || extension.equals("jpeg") ||
                extension.equals("png") || extension.equals("gif");
    }

    private String getRelativePath(String uploadPath, String fileName) {
        // If using custom path, you might want to store the full path
        String customPath = getServletConfig().getInitParameter("upload.path");
        if (customPath != null && !customPath.isEmpty()) {
            return uploadPath + File.separator + fileName;
        } else {
            // For default path, keep relative for web serving
            return DEFAULT_UPLOAD_DIR + "/" + fileName;
        }
    }
}