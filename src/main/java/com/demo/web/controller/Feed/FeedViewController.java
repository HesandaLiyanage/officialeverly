package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedFollowDAO;
import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedPost;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * FeedViewController - Handles feed page access with profile check.
 * 
 * Before showing the feed, this controller checks if the user has a feed
 * profile. If no profile exists, redirects to the welcome/setup flow.
 * Also fetches posts for the FYP and recommended users for sidebar.
 */
public class FeedViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedViewController.class.getName());
    private FeedProfileDAO feedProfileDAO;
    private FeedPostDAO feedPostDAO;
    private FeedFollowDAO feedFollowDAO;

    @Override
    public void init() throws ServletException {
        feedProfileDAO = new FeedProfileDAO();
        feedPostDAO = new FeedPostDAO();
        feedFollowDAO = new FeedFollowDAO();
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

        Integer userId = (Integer) session.getAttribute("user_id");
        logger.info("[FeedViewController] Checking feed profile for user: " + userId);

        try {
            // Check if user already has a feed profile in session
            FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");

            // If not in session, check database
            if (feedProfile == null) {
                feedProfile = feedProfileDAO.findByUserId(userId);

                if (feedProfile != null) {
                    // Cache in session for future requests
                    session.setAttribute("feedProfile", feedProfile);
                    logger.info("[FeedViewController] Feed profile loaded from DB and cached: @"
                            + feedProfile.getFeedUsername());
                }
            }

            if (feedProfile == null) {
                // No feed profile exists, redirect to welcome page
                logger.info("[FeedViewController] No feed profile found, redirecting to welcome");
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }

            // Fetch all posts for FYP (random order)
            List<FeedPost> posts = feedPostDAO.findAllPosts();

            // For posts without cover media, try to get first media
            for (FeedPost post : posts) {
                if (post.getCoverMediaUrl() == null) {
                    Integer mediaId = feedPostDAO.getFirstMediaId(post.getMemoryId());
                    if (mediaId != null) {
                        // Construct viewMedia URL for browser
                        post.setCoverMediaUrl(request.getContextPath() + "/viewMedia?mediaId=" + mediaId);
                    }
                }
            }

            // Get recommended users for sidebar (5 random users not followed)
            List<FeedProfile> recommendedUsers;
            try {
                recommendedUsers = feedFollowDAO.getRecommendedUsers(feedProfile.getFeedProfileId(), 5);
            } catch (Exception e) {
                // Fallback: just get random profiles from the database
                logger.warning("[FeedViewController] feed_follows table may not exist, using fallback");
                recommendedUsers = feedProfileDAO.findRandomProfiles(feedProfile.getFeedProfileId(), 5);
            }

            logger.info("[FeedViewController] Feed profile found: @" + feedProfile.getFeedUsername()
                    + ", posts: " + posts.size()
                    + ", recommended: " + recommendedUsers.size());

            // Set attributes and show feed
            request.setAttribute("feedProfile", feedProfile);
            request.setAttribute("posts", posts);
            request.setAttribute("recommendedUsers", recommendedUsers);
            request.getRequestDispatcher("/views/app/publicfeed.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[FeedViewController] Error: " + e.getMessage());
            e.printStackTrace();
            // On error, just show the feed page with defaults
            request.getRequestDispatcher("/views/app/publicfeed.jsp").forward(request, response);
        }
    }
}
