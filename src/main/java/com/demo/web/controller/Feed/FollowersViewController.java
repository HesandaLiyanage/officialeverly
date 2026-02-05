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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * FollowersViewController - Displays followers/following lists.
 * 
 * Routes:
 * - /followersview?type=followers&profileId=xxx
 * - /followersview?type=following&profileId=xxx
 */
public class FollowersViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FollowersViewController.class.getName());
    private FeedFollowDAO feedFollowDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        feedFollowDAO = new FeedFollowDAO();
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get current user's feed profile
        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            currentUserProfile = feedProfileDAO.findByUserId(userId);
            if (currentUserProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", currentUserProfile);
        }

        String type = request.getParameter("type");
        String profileIdStr = request.getParameter("profileId");

        logger.info("[FollowersViewController] Request received - type: " + type + ", profileId: " + profileIdStr);

        // Default to current user's profile if no profileId specified
        int profileId = currentUserProfile.getFeedProfileId();
        if (profileIdStr != null && !profileIdStr.isEmpty()) {
            try {
                profileId = Integer.parseInt(profileIdStr);
            } catch (NumberFormatException e) {
                profileId = currentUserProfile.getFeedProfileId();
            }
        }

        // Get the profile being viewed
        FeedProfile profileToView;
        if (profileId == currentUserProfile.getFeedProfileId()) {
            profileToView = currentUserProfile;
        } else {
            profileToView = feedProfileDAO.findByFeedProfileId(profileId);
            if (profileToView == null) {
                logger.warning("[FollowersViewController] Profile not found: " + profileId);
                response.sendRedirect(request.getContextPath() + "/feed");
                return;
            }
        }

        List<FeedProfile> userList = new ArrayList<>();
        String pageTitle;
        String jspPage;

        if ("following".equals(type)) {
            pageTitle = "Following";
            jspPage = "/views/app/following.jsp";
        } else {
            pageTitle = "Followers";
            jspPage = "/views/app/followers.jsp";
        }

        try {
            if ("following".equals(type)) {
                // Get following list
                userList = feedFollowDAO.getFollowing(profileId);
                logger.info("[FollowersViewController] Getting following for profile " + profileId
                        + ": " + userList.size() + " users");
            } else {
                // Default to followers
                userList = feedFollowDAO.getFollowers(profileId);
                logger.info("[FollowersViewController] Getting followers for profile " + profileId
                        + ": " + userList.size() + " users");
            }

            // For each user, check if current user follows them
            for (FeedProfile profile : userList) {
                boolean isFollowing = feedFollowDAO.isFollowing(
                        currentUserProfile.getFeedProfileId(),
                        profile.getFeedProfileId());
                request.setAttribute("isFollowing_" + profile.getFeedProfileId(), isFollowing);
            }

        } catch (Exception e) {
            logger.warning(
                    "[FollowersViewController] Error getting follow list (table may not exist): " + e.getMessage());
            // Continue with empty list - page will show "no followers/following yet"
        }

        // Set attributes
        request.setAttribute("userList", userList);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("profileToView", profileToView);
        request.setAttribute("currentUserProfile", currentUserProfile);
        request.setAttribute("isOwnProfile", profileId == currentUserProfile.getFeedProfileId());

        logger.info("[FollowersViewController] Forwarding to " + jspPage + " with " + userList.size() + " users");
        request.getRequestDispatcher(jspPage).forward(request, response);
    }
}
