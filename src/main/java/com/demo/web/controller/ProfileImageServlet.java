package com.demo.web.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/profile-image/*")
public class ProfileImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the image path from URL
        String imagePath = request.getPathInfo(); // e.g., /123_1234567890_profile.jpg

        // Validate path
        if (imagePath == null || imagePath.isEmpty() || imagePath.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid image path");
            return;
        }

        // Remove leading slash
        String fileName = imagePath.substring(1);

        // Security check: prevent directory traversal attacks
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid file path");
            return;
        }

        // Validate file extension
        if (!isValidImageFile(fileName)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file type");
            return;
        }

        // Get upload path from servlet context
        String uploadPath = (String) getServletContext().getAttribute("profile.upload.path");
        if (uploadPath == null || uploadPath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Upload path not configured");
            return;
        }

        // Construct full file path
        String fullPath = uploadPath + File.separator + fileName;
        File imageFile = new File(fullPath);

        // Check if file exists
        if (!imageFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
            return;
        }

        // Security check: verify file is within upload directory
        Path uploadDirPath = Paths.get(uploadPath).toAbsolutePath().normalize();
        Path imagePathNormalized = imageFile.toPath().toAbsolutePath().normalize();

        if (!imagePathNormalized.startsWith(uploadDirPath)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // Optional: Check if user has permission to access this image
        // You could implement user-specific image access here

        // Set appropriate content type
        String extension = getFileExtension(fileName).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                response.setContentType("image/jpeg");
                break;
            case "png":
                response.setContentType("image/png");
                break;
            case "gif":
                response.setContentType("image/gif");
                break;
            default:
                response.setContentType("image/jpeg"); // Default fallback
                break;
        }

        // Set cache headers for better performance
        response.setHeader("Cache-Control", "public, max-age=3600"); // 1 hour
        response.setDateHeader("Expires", System.currentTimeMillis() + 3600000);

        // Stream the file to response
        try {
            Files.copy(imageFile.toPath(), response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            System.err.println("Error serving image: " + e.getMessage());
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving image");
            }
        }
    }

    /**
     * Validate if file is a supported image type
     */
    private boolean isValidImageFile(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        return extension.matches("^(jpg|jpeg|png|gif)$");
    }

    /**
     * Extract file extension from filename
     */
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1);
        }
        return "";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Only allow GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Only allow GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Only allow GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}