package com.demo.web.controller.Feed;

import com.demo.web.dao.Feed.PostReportDAO;
import com.demo.web.dao.Feed.FeedProfileDAO;
import com.demo.web.model.Feed.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

/**
 * FeedReportPost - Handles reporting a post from the feed.
 * POST /reportpost - creates a new report for a post.
 * Returns JSON response for AJAX calls.
 */
@WebServlet("/reportpost")
public class FeedReportPost extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedReportPost.class.getName());
    private PostReportDAO postReportDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        postReportDAO = new PostReportDAO();
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String postIdStr = request.getParameter("postId");
        String reason = request.getParameter("reason");

        if (postIdStr == null || postIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Post ID is required\"}");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(postIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Invalid post ID\"}");
            return;
        }

        // Get the reporter's feed profile
        FeedProfile reporterProfile = feedProfileDAO.findByUserId(userId);
        if (reporterProfile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Feed profile not found\"}");
            return;
        }

        // Check if already reported
        if (postReportDAO.hasUserReported(postId, reporterProfile.getFeedProfileId())) {
            out.write("{\"success\": false, \"message\": \"You have already reported this post\"}");
            return;
        }

        // Create the report
        boolean created = postReportDAO.createReport(postId, reporterProfile.getFeedProfileId(), reason);

        if (created) {
            logger.info("[FeedReportPost] Post " + postId + " reported by user " + userId + " reason: " + reason);
            out.write("{\"success\": true, \"message\": \"Post reported successfully. Our team will review it.\"}");
        } else {
            out.write("{\"success\": false, \"message\": \"Failed to report post. Please try again.\"}");
        }
    }
}
