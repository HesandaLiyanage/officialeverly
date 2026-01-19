package com.demo.web.controller.Admin;

import com.demo.web.dao.userDAO;
import com.demo.web.model.user;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/adminuser")
public class AdminUserServlet extends HttpServlet {

    private userDAO userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new userDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in and is admin
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = (String) session.getAttribute("username");
        if (!"admin".equals(username)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // Get all users except admin
        List<user> users = userDao.getAllUsersExceptAdmin();
        request.setAttribute("users", users);

        // Get user activity stats
        List<Map<String, Object>> activityStats = userDao.getUsersWithActivityStats();
        request.setAttribute("activityStats", activityStats);

        // Get most active (top 5)
        int limit = Math.min(5, activityStats.size());
        request.setAttribute("mostActive", activityStats.subList(0, limit));

        // Get least active (bottom 5)
        if (activityStats.size() > 5) {
            int start = Math.max(0, activityStats.size() - 5);
            request.setAttribute("leastActive", activityStats.subList(start, activityStats.size()));
        } else {
            request.setAttribute("leastActive", activityStats);
        }

        // Total user count
        request.setAttribute("totalUsers", userDao.getTotalUserCount());

        // Forward to JSP
        request.getRequestDispatcher("/views/app/Admin/usermgmt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        JsonObject json = new JsonObject();

        // Check if user is logged in and is admin
        if (session == null || session.getAttribute("user_id") == null) {
            json.addProperty("success", false);
            json.addProperty("error", "Not logged in");
            response.getWriter().write(json.toString());
            return;
        }

        String username = (String) session.getAttribute("username");
        if (!"admin".equals(username)) {
            json.addProperty("success", false);
            json.addProperty("error", "Access denied");
            response.getWriter().write(json.toString());
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));

                // Prevent admin from deleting themselves
                Integer currentUserId = (Integer) session.getAttribute("user_id");
                if (currentUserId != null && currentUserId == userId) {
                    json.addProperty("success", false);
                    json.addProperty("error", "Cannot delete your own account");
                    response.getWriter().write(json.toString());
                    return;
                }

                boolean deleted = userDao.deleteUser(userId);

                if (deleted) {
                    json.addProperty("success", true);
                    json.addProperty("message", "User deleted successfully");
                } else {
                    json.addProperty("success", false);
                    json.addProperty("error", "User not found");
                }

            } catch (NumberFormatException e) {
                json.addProperty("success", false);
                json.addProperty("error", "Invalid user ID");
            } catch (Exception e) {
                json.addProperty("success", false);
                json.addProperty("error", "Error deleting user: " + e.getMessage());
            }
        } else {
            json.addProperty("success", false);
            json.addProperty("error", "Invalid action");
        }

        response.getWriter().write(json.toString());
    }
}
