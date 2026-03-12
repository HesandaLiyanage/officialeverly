package com.demo.web.controller.Admin;

import com.demo.web.dao.Feed.PostReportDAO;

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
 * AdminContentView - View controller for the admin content management page.
 * Loads ONLY reported posts (not all posts) and forwards to admincontent.jsp.
 */
public class AdminContentView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminContentView.class.getName());
    private PostReportDAO postReportDAO;

    @Override
    public void init() throws ServletException {
        postReportDAO = new PostReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get filter parameter
            String statusFilter = request.getParameter("status");

            List<Map<String, Object>> reportedPosts;
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")) {
                reportedPosts = postReportDAO.getReportedPostsByStatus(statusFilter);
            } else {
                reportedPosts = postReportDAO.getReportedPosts();
            }

            request.setAttribute("reportedPosts", reportedPosts);
            request.setAttribute("currentFilter", statusFilter != null ? statusFilter : "all");

            // Report stats
            Map<String, Integer> reportStats = postReportDAO.getReportStats();
            request.setAttribute("reportStats", reportStats);
            request.setAttribute("pendingCount", reportStats.getOrDefault("pending", 0));
            request.setAttribute("reviewedCount", reportStats.getOrDefault("reviewed", 0));
            request.setAttribute("dismissedCount", reportStats.getOrDefault("dismissed", 0));
            request.setAttribute("actionTakenCount", reportStats.getOrDefault("action_taken", 0));
            request.setAttribute("totalReports", reportStats.getOrDefault("total", 0));

            logger.info("[AdminContentView] Loaded " + reportedPosts.size() + " reported posts");

        } catch (Exception e) {
            logger.severe("[AdminContentView] Error loading content: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Admin/admincontent.jsp").forward(request, response);
    }
}
