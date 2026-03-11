package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminUserDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

/**
 * AdminUserAction - Handles admin user management actions (toggle status, delete).
 * POST-only servlet that performs the action then redirects back to /adminuser.
 */
public class AdminUserAction extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminUserAction.class.getName());
    private AdminUserDAO adminUserDAO;

    @Override
    public void init() throws ServletException {
        adminUserDAO = new AdminUserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (action == null || userIdStr == null) {
            session.setAttribute("adminFlashMessage", "Invalid request parameters.");
            session.setAttribute("adminFlashType", "error");
            response.sendRedirect(request.getContextPath() + "/adminuser");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("adminFlashMessage", "Invalid user ID.");
            session.setAttribute("adminFlashType", "error");
            response.sendRedirect(request.getContextPath() + "/adminuser");
            return;
        }

        // Prevent self-deletion / self-deactivation
        Integer currentUserId = (Integer) session.getAttribute("user_id");
        if (currentUserId != null && currentUserId == userId) {
            session.setAttribute("adminFlashMessage", "You cannot modify your own account from the admin panel.");
            session.setAttribute("adminFlashType", "error");
            response.sendRedirect(request.getContextPath() + "/adminuser");
            return;
        }

        Map<String, Object> targetUser = adminUserDAO.getUserById(userId);
        String targetUsername = targetUser != null ? (String) targetUser.get("username") : "User #" + userId;

        switch (action) {
            case "activate":
                if (adminUserDAO.setUserActiveStatus(userId, true)) {
                    session.setAttribute("adminFlashMessage", "User '" + targetUsername + "' has been activated.");
                    session.setAttribute("adminFlashType", "success");
                } else {
                    session.setAttribute("adminFlashMessage", "Failed to activate user '" + targetUsername + "'.");
                    session.setAttribute("adminFlashType", "error");
                }
                break;

            case "deactivate":
                if (adminUserDAO.setUserActiveStatus(userId, false)) {
                    session.setAttribute("adminFlashMessage", "User '" + targetUsername + "' has been deactivated.");
                    session.setAttribute("adminFlashType", "success");
                } else {
                    session.setAttribute("adminFlashMessage", "Failed to deactivate user '" + targetUsername + "'.");
                    session.setAttribute("adminFlashType", "error");
                }
                break;

            case "delete":
                if (adminUserDAO.deleteUser(userId)) {
                    session.setAttribute("adminFlashMessage", "User '" + targetUsername + "' has been permanently deleted.");
                    session.setAttribute("adminFlashType", "success");
                } else {
                    session.setAttribute("adminFlashMessage", "Failed to delete user '" + targetUsername + "'.");
                    session.setAttribute("adminFlashType", "error");
                }
                break;

            default:
                session.setAttribute("adminFlashMessage", "Unknown action: " + action);
                session.setAttribute("adminFlashType", "error");
                break;
        }

        logger.info("[AdminUserAction] Action '" + action + "' on user " + userId + " by admin " + currentUserId);
        response.sendRedirect(request.getContextPath() + "/adminuser");
    }
}
