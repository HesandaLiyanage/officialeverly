package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminDashboardDAO;
import com.demo.web.dao.Feed.PostReportDAO;
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
 * AdminOverviewView - View controller for the admin overview/dashboard page.
 * Loads real statistics from the database and forwards to admindahboard.jsp.
 */
public class AdminOverviewView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminOverviewView.class.getName());
    private AdminDashboardDAO dashboardDAO;
    private PostReportDAO postReportDAO;

    @Override
    public void init() throws ServletException {
        dashboardDAO = new AdminDashboardDAO();
        postReportDAO = new PostReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AdminAccessUtil.requireAdmin(request, response)) {
            return;
        }

        try {
            // Overview stats
            int totalUsers = dashboardDAO.getTotalUsers();
            int activeUsers = dashboardDAO.getActiveUsers();
            int newUsersWeek = dashboardDAO.getNewUsersThisWeek();
            int totalContent = dashboardDAO.getTotalContent();
            int pendingReports = postReportDAO.getPendingReportCount();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("newUsersWeek", newUsersWeek);
            request.setAttribute("totalContent", totalContent);
            request.setAttribute("pendingReports", pendingReports);

            // Recent signups for the sidebar
            List<Map<String, Object>> recentSignups = dashboardDAO.getRecentSignups(5);
            request.setAttribute("recentSignups", recentSignups);

            // Content breakdown
            Map<String, Integer> contentBreakdown = dashboardDAO.getContentBreakdown();
            request.setAttribute("contentBreakdown", contentBreakdown);

            // Report stats
            Map<String, Integer> reportStats = postReportDAO.getReportStats();
            request.setAttribute("reportStats", reportStats);

            logger.info("[AdminOverviewView] Dashboard loaded - Users: " + totalUsers +
                       ", Content: " + totalContent + ", Pending Reports: " + pendingReports);

        } catch (Exception e) {
            logger.severe("[AdminOverviewView] Error loading dashboard: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Admin/admindahboard.jsp").forward(request, response);
    }
}
