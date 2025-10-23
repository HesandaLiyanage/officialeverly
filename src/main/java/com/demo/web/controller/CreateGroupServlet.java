package com.demo.web.controller;

import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Group;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.util.UUID;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class CreateGroupServlet extends HttpServlet {

    private GroupDAO groupDAO;
    private static final String UPLOAD_DIR = "resources/db images";

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
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

        // Forward to the create group JSP page
        request.getRequestDispatcher("/creategroup").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG CreateGroupServlet] POST request received");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG CreateGroupServlet] User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        System.out.println("[DEBUG CreateGroupServlet] User ID from session: " + userId);

        try {
            // Get form parameters
            String groupName = request.getParameter("g_name");
            String groupDescription = request.getParameter("g_description");
            String customLink = request.getParameter("customLink");

            System.out.println("[DEBUG CreateGroupServlet] Group Name: " + groupName);
            System.out.println("[DEBUG CreateGroupServlet] Group Description: " + groupDescription);
            System.out.println("[DEBUG CreateGroupServlet] Custom Link: " + customLink);

            // Validate required fields
            if (groupName == null || groupName.trim().isEmpty()) {
                System.out.println("[DEBUG CreateGroupServlet] Group name is empty");
                request.setAttribute("error", "Group name is required");
                request.getRequestDispatcher("/creategroup").forward(request, response);
                return;
            }

            if (customLink == null || customLink.trim().isEmpty()) {
                System.out.println("[DEBUG CreateGroupServlet] Custom link is empty");
                request.setAttribute("error", "Group URL is required");
                request.getRequestDispatcher("/creategroup").forward(request, response);
                return;
            }

            // Clean the custom link (remove special characters, convert to lowercase, replace spaces with hyphens)
            String cleanedLink = customLink.trim().toLowerCase()
                    .replaceAll("[^a-z0-9-]", "-")
                    .replaceAll("-+", "-")
                    .replaceAll("^-|-$", "");

            System.out.println("[DEBUG CreateGroupServlet] Cleaned Link: " + cleanedLink);

            // Check if URL is already taken
            if (groupDAO.isUrlTaken(cleanedLink)) {
                System.out.println("[DEBUG CreateGroupServlet] URL already taken: " + cleanedLink);
                request.setAttribute("error", "This group URL is already taken. Please choose another one.");
                request.setAttribute("g_name", groupName);
                request.setAttribute("g_description", groupDescription);
                request.setAttribute("customLink", customLink);
                request.getRequestDispatcher("creategroup").forward(request, response);
                return;
            }

            // Handle file upload
            String groupPicUrl = null;
            Part filePart = request.getPart("group_pic");

            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("[DEBUG CreateGroupServlet] File part received: " + filePart.getSubmittedFileName());
                System.out.println("[DEBUG CreateGroupServlet] File size: " + filePart.getSize() + " bytes");

                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "group_" + UUID.randomUUID().toString() + fileExtension;

                // Get the real path to the uploads directory
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + UPLOAD_DIR;

                System.out.println("[DEBUG CreateGroupServlet] Application path: " + applicationPath);
                System.out.println("[DEBUG CreateGroupServlet] Upload path: " + uploadPath);

                // Create the upload directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    System.out.println("[DEBUG CreateGroupServlet] Upload directory created: " + created);
                }

                // Save the file
                String filePath = uploadPath + File.separator + uniqueFileName;
                System.out.println("[DEBUG CreateGroupServlet] Saving file to: " + filePath);

                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("[DEBUG CreateGroupServlet] File saved successfully");
                }

                // Set the URL for the database (relative path for web access)
                groupPicUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                System.out.println("[DEBUG CreateGroupServlet] Group pic URL: " + groupPicUrl);
            } else {
                System.out.println("[DEBUG CreateGroupServlet] No file uploaded");
            }

            // Create Group object
            Group newGroup = new Group();
            newGroup.setName(groupName.trim());
            newGroup.setDescription(groupDescription != null ? groupDescription.trim() : "");
            newGroup.setUserId(userId);
            newGroup.setGroupPicUrl(groupPicUrl);
            newGroup.setGroupUrl(cleanedLink);
            newGroup.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            System.out.println("[DEBUG CreateGroupServlet] Group object created: " + newGroup);

            // Save to database
            boolean success = groupDAO.createGroup(newGroup);

            if (success) {
                System.out.println("[DEBUG CreateGroupServlet] Group created successfully");
                // Redirect to groups dashboard with success message
                session.setAttribute("successMessage", "Group created successfully!");
                response.sendRedirect(request.getContextPath() + "/groups");
            } else {
                System.out.println("[DEBUG CreateGroupServlet] Failed to create group");
                request.setAttribute("error", "Failed to create group. Please try again.");
                request.setAttribute("g_name", groupName);
                request.setAttribute("g_description", groupDescription);
                request.setAttribute("customLink", customLink);
                request.getRequestDispatcher("/creategroup").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("[DEBUG CreateGroupServlet] Exception occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the group: " + e.getMessage());
            request.getRequestDispatcher("/creategroup").forward(request, response);
        }
    }
}