package com.demo.web.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.demo.web.dao.userDAO;
// Remove userSessionDAO import if not needed for other features in this servlet
// import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;
// Remove UserSession model import if not needed for other features in this servlet
// import com.demo.web.model.UserSession;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class editprofileservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private userDAO userDAO;
    // Remove userSessionDAO instance if not needed for other features in this servlet
    // private userSessionDAO userSessionDAO;

    public void init() {
        userDAO = new userDAO();
        // Remove userSessionDAO initialization if not needed for other features in this servlet
        // userSessionDAO = new userSessionDAO();
    }

    // GET method - Display the edit profile page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve the user ID from the HTTP session (as set by LoginServlet)
        HttpSession httpSession = request.getSession(false);
        Integer userIdFromHttpSession = (Integer) httpSession.getAttribute("user_id"); // Get user_id as Integer

        // Validate the HTTP session: check if user_id exists
        if (httpSession == null || userIdFromHttpSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch the current user object from the database using the validated user_id
        user currentUser = userDAO.findById(userIdFromHttpSession);
        if (currentUser == null) {
            // User ID in session doesn't correspond to a valid user in DB
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/editprofile").forward(request, response);
    }

    // POST method - Handle form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve the user ID from the HTTP session (as set by LoginServlet)
        HttpSession httpSession = request.getSession(false);
        Integer userIdFromHttpSession = (Integer) httpSession.getAttribute("user_id"); // Get user_id as Integer

        // Validate the HTTP session: check if user_id exists
        if (httpSession == null || userIdFromHttpSession == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch the current user object from the database using the validated user_id
        user currentUser = userDAO.findById(userIdFromHttpSession);
        if (currentUser == null) {
            // User ID in session doesn't correspond to a valid user in DB
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String username = request.getParameter("username");
        String bio = request.getParameter("bio");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DatabaseUtil.getConnection();

            // Check if username is already taken by another user (excluding current user)
            if (username != null && !username.trim().isEmpty()) {
                user existingUser = userDAO.findByUsername(username.trim());
                if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                    request.setAttribute("error", "Username is already taken");
                    request.getRequestDispatcher("/editprofile").forward(request, response);
                    return;
                }
            }

            // Handle profile picture upload
            Part filePart = request.getPart("profilePicture");
            String profilePictureUrl = currentUser.getProfilePictureUrl();

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                filePart.write(filePath);
                profilePictureUrl = uniqueFileName;
            }

            // Handle password change
            String newPasswordHash = null;
            String newSalt = null;

            if (currentPassword != null && !currentPassword.isEmpty()
                    && newPassword != null && !newPassword.isEmpty()) {

                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New passwords do not match");
                    request.getRequestDispatcher("/editprofile").forward(request, response);
                    return;
                }

                // Verify current password against the fetched user object
                if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getSalt(), currentUser.getPassword())) {
                    request.setAttribute("error", "Current password is incorrect");
                    request.getRequestDispatcher("/editprofile").forward(request, response);
                    return;
                }

                // Generate new salt and hash for new password
                newSalt = PasswordUtil.generateSalt();
                newPasswordHash = PasswordUtil.hashPassword(newPassword, newSalt);
            }

            // Build dynamic UPDATE query
            StringBuilder sql = new StringBuilder("UPDATE users SET ");
            boolean needsComma = false;

            if (username != null && !username.trim().isEmpty()) {
                sql.append("username = ?");
                needsComma = true;
            }

            if (needsComma) sql.append(", ");
            sql.append("bio = ?");

            if (profilePictureUrl != null && !profilePictureUrl.equals(currentUser.getProfilePictureUrl())) {
                sql.append(", profile_picture_url = ?");
            }

            if (newPasswordHash != null && newSalt != null) {
                sql.append(", password = ?, salt = ?");
            }

            sql.append(" WHERE user_id = ?");

            stmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            if (username != null && !username.trim().isEmpty()) {
                stmt.setString(paramIndex++, username.trim());
            }

            stmt.setString(paramIndex++, bio != null ? bio.trim() : "");

            if (profilePictureUrl != null && !profilePictureUrl.equals(currentUser.getProfilePictureUrl())) {
                stmt.setString(paramIndex++, profilePictureUrl);
            }

            if (newPasswordHash != null && newSalt != null) {
                stmt.setString(paramIndex++, newPasswordHash);
                stmt.setString(paramIndex++, newSalt);
            }

            stmt.setInt(paramIndex, currentUser.getId());

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Update the user object fetched from DB with new values
                if (username != null && !username.trim().isEmpty()) {
                    currentUser.setUsername(username.trim());
                }
                currentUser.setBio(bio != null ? bio.trim() : "");

                if (profilePictureUrl != null) {
                    currentUser.setProfilePictureUrl(profilePictureUrl);
                }

                if (newPasswordHash != null && newSalt != null) {
                    currentUser.setPassword(newPasswordHash);
                    currentUser.setSalt(newSalt);
                }

                // Update the user object in the HTTP session
                httpSession.setAttribute("user", currentUser);
                // If username is also stored in session, update it
                httpSession.setAttribute("username", currentUser.getUsername());

                request.setAttribute("success", "Profile updated successfully");
                request.getRequestDispatcher("/editprofile").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update profile");
                request.getRequestDispatcher("/editprofile").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/editprofile").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}