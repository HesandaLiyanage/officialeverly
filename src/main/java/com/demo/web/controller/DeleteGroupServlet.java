package com.demo.web.controller;

import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Group;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;


public class DeleteGroupServlet extends HttpServlet {

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
                System.out.println("[DEBUG DeleteGroupServlet] No groupId provided");
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            int groupId = Integer.parseInt(groupIdStr);
            System.out.println("[DEBUG DeleteGroupServlet] Attempting to delete group ID: " + groupId);

            // Verify ownership before deletion
            Group existingGroup = groupDAO.findById(groupId);
            if (existingGroup == null) {
                System.out.println("[DEBUG DeleteGroupServlet] Group not found: " + groupId);
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            if (existingGroup.getUserId() != userId) {
                System.out.println("[DEBUG DeleteGroupServlet] User " + userId + " does not own group " + groupId);
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            // Delete the group (this will also delete all members via the DAO)
            boolean success = groupDAO.deleteGroup(groupId);

            if (success) {
                System.out.println("[DEBUG DeleteGroupServlet] Group deleted successfully: " + groupId);
                // Redirect to groups page with success message
                response.sendRedirect(request.getContextPath() + "/groups?deleted=success");
            } else {
                System.out.println("[DEBUG DeleteGroupServlet] Failed to delete group: " + groupId);
                response.sendRedirect(request.getContextPath() + "/groupmemories?groupId=" + groupId + "&error=delete_failed");
            }

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG DeleteGroupServlet] Invalid groupId format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/groups");
        } catch (Exception e) {
            System.out.println("[DEBUG DeleteGroupServlet] Error deleting group: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/groups?error=delete_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST (security measure)
        response.sendRedirect(request.getContextPath() + "/groups");
    }
}