package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminDashboardDAO;
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
 * AdminAnalyticsView - View controller for the admin analytics page.
 * Loads analytics data from the database and forwards to adminanalytics.jsp.
 */
public class AdminAnalyticsView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminAnalyticsView.class.getName());
    private AdminDashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new AdminDashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AdminAccessUtil.requireAdmin(request, response)) {
            return;
        }

        try {
            // User stats
            int totalUsers = dashboardDAO.getTotalUsers();
            int activeUsers = dashboardDAO.getActiveUsers();
            int newUsersMonth = dashboardDAO.getNewUsersThisMonth();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("newUsersMonth", newUsersMonth);

            // Content stats
            int totalPosts = dashboardDAO.getTotalPosts();
            int totalMemories = dashboardDAO.getTotalMemories();
            int totalJournals = dashboardDAO.getTotalJournals();

            request.setAttribute("totalPosts", totalPosts);
            request.setAttribute("totalMemories", totalMemories);
            request.setAttribute("totalJournals", totalJournals);

            // Content breakdown for chart
            Map<String, Integer> contentBreakdown = dashboardDAO.getContentBreakdown();
            request.setAttribute("contentBreakdown", contentBreakdown);

            // Top posters
            List<Map<String, Object>> topPosters = dashboardDAO.getTopPosters(5);
            request.setAttribute("topPosters", topPosters);

            // Most liked posts
            List<Map<String, Object>> mostLikedPosts = dashboardDAO.getMostLikedPosts(5);
            request.setAttribute("mostLikedPosts", mostLikedPosts);

            // Registration trend (last 30 days)
            List<Map<String, Object>> registrationTrend = dashboardDAO.getUserRegistrationTrend(30);
            request.setAttribute("registrationTrend", registrationTrend);

            logger.info("[AdminAnalyticsView] Analytics loaded - Users: " + totalUsers +
                       ", Posts: " + totalPosts + ", Memories: " + totalMemories);

        } catch (Exception e) {
            logger.severe("[AdminAnalyticsView] Error loading analytics: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Admin/adminanalytics.jsp").forward(request, response);
    }
}
