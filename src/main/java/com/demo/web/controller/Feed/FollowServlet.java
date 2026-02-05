package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedFollowDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

/**
 * FollowServlet - Handles follow/unfollow actions via AJAX.
 * 
 * Endpoints:
 * POST /followUser?action=follow&targetProfileId=xxx
 * POST /followUser?action=unfollow&targetProfileId=xxx
 */
public class FollowServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FollowServlet.class.getName());
    private FeedFollowDAO feedFollowDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        feedFollowDAO = new FeedFollowDAO();
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        // Get current user's feed profile
        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            currentUserProfile = feedProfileDAO.findByUserId(userId);
            if (currentUserProfile == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"No feed profile found\"}");
                return;
            }
        }

        String action = request.getParameter("action");
        String targetProfileIdStr = request.getParameter("targetProfileId");

        if (action == null || targetProfileIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);
            int currentProfileId = currentUserProfile.getFeedProfileId();

            // Prevent self-follow
            if (targetProfileId == currentProfileId) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Cannot follow yourself\"}");
                return;
            }

            boolean success = false;
            String resultAction = "";

            if ("follow".equals(action)) {
                success = feedFollowDAO.follow(currentProfileId, targetProfileId);
                resultAction = "followed";
                logger.info("[FollowServlet] User " + currentProfileId + " followed " + targetProfileId);
            } else if ("unfollow".equals(action)) {
                success = feedFollowDAO.unfollow(currentProfileId, targetProfileId);
                resultAction = "unfollowed";
                logger.info("[FollowServlet] User " + currentProfileId + " unfollowed " + targetProfileId);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Invalid action\"}");
                return;
            }

            // Get updated counts
            int followerCount = feedFollowDAO.getFollowerCount(targetProfileId);
            int followingCount = feedFollowDAO.getFollowingCount(currentProfileId);
            boolean isNowFollowing = feedFollowDAO.isFollowing(currentProfileId, targetProfileId);

            out.print("{\"success\": " + success +
                    ", \"action\": \"" + resultAction + "\"" +
                    ", \"isFollowing\": " + isNowFollowing +
                    ", \"followerCount\": " + followerCount +
                    ", \"followingCount\": " + followingCount + "}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid profile ID\"}");
        } catch (Exception e) {
            logger.severe("[FollowServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Server error\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Support GET for checking follow status
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            currentUserProfile = feedProfileDAO.findByUserId(userId);
        }

        if (currentUserProfile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"No feed profile found\"}");
            return;
        }

        String targetProfileIdStr = request.getParameter("targetProfileId");
        if (targetProfileIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Missing profile ID\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);
            boolean isFollowing = feedFollowDAO.isFollowing(
                    currentUserProfile.getFeedProfileId(), targetProfileId);

            out.print("{\"success\": true, \"isFollowing\": " + isFollowing + "}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid profile ID\"}");
        }
    }
}
