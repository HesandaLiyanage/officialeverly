package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedFollowDAO;
import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.dao.SavedPostDAO;
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
 * FeedProfileViewController - Handles feed profile page display.
 * 
 * Routes:
 * - /publicprofile (current user's profile)
 * - /publicprofile?username=xxx (view another user's profile)
 */
public class FeedProfileViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedProfileViewController.class.getName());
    private FeedProfileDAO feedProfileDAO;
    private FeedPostDAO feedPostDAO;
    private FeedFollowDAO feedFollowDAO;
    private SavedPostDAO savedPostDAO;

    @Override
    public void init() throws ServletException {
        feedProfileDAO = new FeedProfileDAO();
        feedPostDAO = new FeedPostDAO();
        feedFollowDAO = new FeedFollowDAO();
        savedPostDAO = new SavedPostDAO();
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

        // Get current user's feed profile from session
        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            currentUserProfile = feedProfileDAO.findByUserId(userId);
            if (currentUserProfile != null) {
                session.setAttribute("feedProfile", currentUserProfile);
            } else {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
        }

        String targetUsername = request.getParameter("username");
        FeedProfile profileToView;
        boolean isOwnProfile;

        if (targetUsername != null && !targetUsername.isEmpty()) {
            // Viewing another user's profile
            profileToView = feedProfileDAO.findByUsername(targetUsername);
            if (profileToView == null) {
                response.sendRedirect(request.getContextPath() + "/feed");
                return;
            }
            isOwnProfile = (profileToView.getFeedProfileId() == currentUserProfile.getFeedProfileId());
        } else {
            // Viewing own profile
            profileToView = currentUserProfile;
            isOwnProfile = true;
        }

        try {
            // Get profile stats
            int followerCount = feedFollowDAO.getFollowerCount(profileToView.getFeedProfileId());
            int followingCount = feedFollowDAO.getFollowingCount(profileToView.getFeedProfileId());

            // Get user's posts
            List<FeedPost> userPosts = feedPostDAO.findByFeedProfileId(profileToView.getFeedProfileId());

            // For posts without cover media, try to get first media
            for (FeedPost post : userPosts) {
                if (post.getCoverMediaUrl() == null) {
                    Integer mediaId = feedPostDAO.getFirstMediaId(post.getMemoryId());
                    if (mediaId != null) {
                        post.setCoverMediaUrl(request.getContextPath() + "/viewMedia?mediaId=" + mediaId);
                    }
                }
            }

            // Get saved posts (only for own profile)
            List<FeedPost> savedPosts = null;
            if (isOwnProfile) {
                savedPosts = savedPostDAO.getSavedPosts(currentUserProfile.getFeedProfileId());
                // Fix cover URLs for saved posts
                for (FeedPost post : savedPosts) {
                    if (post.getCoverMediaUrl() == null) {
                        Integer mediaId = feedPostDAO.getFirstMediaId(post.getMemoryId());
                        if (mediaId != null) {
                            post.setCoverMediaUrl(request.getContextPath() + "/viewMedia?mediaId=" + mediaId);
                        }
                    }
                }
            }

            // Check if current user follows this profile (if not own profile)
            boolean isFollowing = false;
            if (!isOwnProfile) {
                isFollowing = feedFollowDAO.isFollowing(
                        currentUserProfile.getFeedProfileId(),
                        profileToView.getFeedProfileId());
            }

            // Get recommended users for sidebar
            List<FeedProfile> recommendedUsers = feedFollowDAO.getRecommendedUsers(
                    currentUserProfile.getFeedProfileId(), 5);

            logger.info("[FeedProfileViewController] Displaying profile: @" + profileToView.getFeedUsername()
                    + ", posts: " + userPosts.size()
                    + ", followers: " + followerCount
                    + ", following: " + followingCount
                    + (savedPosts != null ? ", saved: " + savedPosts.size() : ""));

            // Set attributes
            request.setAttribute("profileToView", profileToView);
            request.setAttribute("isOwnProfile", isOwnProfile);
            request.setAttribute("isFollowing", isFollowing);
            request.setAttribute("followerCount", followerCount);
            request.setAttribute("followingCount", followingCount);
            request.setAttribute("postCount", userPosts.size());
            request.setAttribute("userPosts", userPosts);
            request.setAttribute("savedPosts", savedPosts);
            request.setAttribute("recommendedUsers", recommendedUsers);
            request.setAttribute("currentUserProfile", currentUserProfile);

            request.getRequestDispatcher("/views/app/userprofile.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[FeedProfileViewController] Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/feed");
        }
    }
}
