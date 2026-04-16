package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminUserDAO;
import com.demo.web.util.AdminAccessUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * AdminUserView - View controller for the admin user management page.
 * Loads all users from the database and forwards to adminuser.jsp.
 */
public class AdminUserView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminUserView.class.getName());
    private AdminUserDAO adminUserDAO;

    @Override
    public void init() throws ServletException {
        adminUserDAO = new AdminUserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AdminAccessUtil.requireAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        try {
            // Load all users
            List<Map<String, Object>> allUsers = adminUserDAO.getAllUsers();
            request.setAttribute("allUsers", allUsers);

            // Load stats
            int totalUsers = adminUserDAO.getTotalUserCount();
            int activeUsers = adminUserDAO.getActiveUserCount();
            int inactiveUsers = adminUserDAO.getInactiveUserCount();
            int newUsers = adminUserDAO.getNewUsersCount();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("inactiveUsers", inactiveUsers);
            request.setAttribute("newUsersCount", newUsers);

            // Load most/least active users for sidebar
            List<Map<String, Object>> mostActiveUsers = adminUserDAO.getMostActiveUsers(3);
            List<Map<String, Object>> leastActiveUsers = adminUserDAO.getLeastActiveUsers(3);

            request.setAttribute("mostActiveUsers", mostActiveUsers);
            request.setAttribute("leastActiveUsers", leastActiveUsers);

            // Handle flash messages from redirect (after action)
            String flashMessage = (String) session.getAttribute("adminFlashMessage");
            String flashType = (String) session.getAttribute("adminFlashType");
            if (flashMessage != null) {
                request.setAttribute("flashMessage", flashMessage);
                request.setAttribute("flashType", flashType);
                session.removeAttribute("adminFlashMessage");
                session.removeAttribute("adminFlashType");
            }

            logger.info("[AdminUserView] Loaded " + allUsers.size() + " users for admin view");
        } catch (Exception e) {
            logger.severe("[AdminUserView] Error loading user data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("flashMessage", "Error loading user data: " + e.getMessage());
            request.setAttribute("flashType", "error");
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Admin/adminuser.jsp").forward(request, response);
    }
}
