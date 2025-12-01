package com.demo.web.controller;

import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Group;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditGroupServlet extends HttpServlet {

    private GroupDAO groupDAO;

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
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

        try {
            // Get group ID from form
            String groupIdStr = request.getParameter("groupId");
            if (groupIdStr == null || groupIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            int groupId = Integer.parseInt(groupIdStr);

            // Verify ownership
            Group existingGroup = groupDAO.findById(groupId);
            if (existingGroup == null || existingGroup.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            // Get form parameters
            String groupName = request.getParameter("g_name");
            String groupDescription = request.getParameter("g_description");
            String customLink = request.getParameter("customLink");

            // Validate required fields
            if (groupName == null || groupName.trim().isEmpty() ||
                    customLink == null || customLink.trim().isEmpty()) {
                request.setAttribute("error", "Group name and link are required");
                request.getRequestDispatcher("/views/app/editgroup.jsp").forward(request, response);
                return;
            }

            // Check if URL is taken by another group
            if (!customLink.equals(existingGroup.getGroupUrl())) {
                if (groupDAO.isUrlTaken(customLink)) {
                    request.setAttribute("error", "This group link is already taken. Please choose another.");
                    request.setAttribute("group", existingGroup);
                    request.getRequestDispatcher("/views/app/editgroup.jsp").forward(request, response);
                    return;
                }
            }

            // Handle file upload
            Part filePart = request.getPart("group_pic");
            String groupPicUrl = existingGroup.getGroupPicUrl(); // Keep existing if no new file

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                // Define upload path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "groups";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Save file
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Set relative URL for database
                groupPicUrl = request.getContextPath() + "/uploads/groups/" + uniqueFileName;
            }

            // Update group object
            existingGroup.setName(groupName.trim());
            existingGroup.setDescription(groupDescription != null ? groupDescription.trim() : "");
            existingGroup.setGroupPicUrl(groupPicUrl);
            existingGroup.setGroupUrl(customLink.trim());

            // Update in database
            boolean success = groupDAO.updateGroup(existingGroup);

            if (success) {
                System.out.println("[DEBUG EditGroupServlet] Group updated successfully: " + existingGroup);
                response.sendRedirect(request.getContextPath() + "/groupmemories?groupId=" + groupId);
            } else {
                System.out.println("[DEBUG EditGroupServlet] Failed to update group");
                request.setAttribute("error", "Failed to update group. Please try again.");
                request.setAttribute("group", existingGroup);
                request.getRequestDispatcher("/views/app/editgroup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("[DEBUG EditGroupServlet] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the group");
            response.sendRedirect(request.getContextPath() + "/groups");
        }
    }
}