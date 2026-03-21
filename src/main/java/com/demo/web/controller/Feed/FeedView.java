package com.demo.web.controller.Feed;

import com.demo.web.dao.Feed.BlockedUserDAO;
import com.demo.web.dao.Feed.FeedFollowDAO;
import com.demo.web.dao.Feed.FeedPostDAO;
import com.demo.web.dao.Feed.FeedPostLikeDAO;
import com.demo.web.dao.Feed.FeedProfileDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.MediaItem;

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
public class FeedView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedView.class.getName());
    private FeedProfileDAO feedProfileDAO;
    private FeedPostDAO feedPostDAO;
    private FeedFollowDAO feedFollowDAO;
    private FeedPostLikeDAO feedPostLikeDAO;
    private MediaDAO mediaDAO;
    private BlockedUserDAO blockedUserDAO;

    @Override
    public void init() throws ServletException {
        feedProfileDAO = new FeedProfileDAO();
        feedPostDAO = new FeedPostDAO();
        feedFollowDAO = new FeedFollowDAO();
        feedPostLikeDAO = new FeedPostLikeDAO();
        mediaDAO = new MediaDAO();
        blockedUserDAO = new BlockedUserDAO();
        blockedUserDAO.ensureTableExists();
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

            // Filter out posts from blocked users
            List<Integer> blockedProfileIds = blockedUserDAO.getBlockedProfileIds(feedProfile.getFeedProfileId());
            if (!blockedProfileIds.isEmpty()) {
                posts.removeIf(post -> {
                    FeedProfile poster = post.getFeedProfile();
                    return poster != null && blockedProfileIds.contains(poster.getFeedProfileId());
                });
                logger.info(
                        "[FeedViewController] Filtered out posts from " + blockedProfileIds.size() + " blocked users");
            }

            // Load all media items for each post (for carousel)
            for (FeedPost post : posts) {
                try {
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(post.getMemoryId());
                    post.setMediaItems(mediaItems);

                    // Set cover URL from first media if not set
                    if (post.getCoverMediaUrl() == null && mediaItems != null && !mediaItems.isEmpty()) {
                        post.setCoverMediaUrl(
                                request.getContextPath() + "/viewmedia?id=" + mediaItems.get(0).getMediaId());
                    }

                    // Load like data for this post
                    post.setLikeCount(feedPostLikeDAO.getLikeCount(post.getPostId()));
                    post.setLikedByCurrentUser(
                            feedPostLikeDAO.hasLikedPost(post.getPostId(), feedProfile.getFeedProfileId()));
                } catch (Exception e) {
                    logger.warning("[FeedViewController] Error loading media for post " + post.getPostId() + ": "
                            + e.getMessage());
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

            // Pre-compute display values for the JSP
            String feedUsername = feedProfile.getFeedUsername() != null ? feedProfile.getFeedUsername() : "user";
            String feedProfilePic = feedProfile.getFeedProfilePictureUrl() != null
                    ? feedProfile.getFeedProfilePictureUrl()
                    : "/resources/assets/default-feed-avatar.png";
            String feedInitials = feedProfile.getInitials() != null ? feedProfile.getInitials() : "U";
            boolean hasDefaultPic = feedProfilePic.startsWith("/resources/assets/default")
                    || feedProfilePic.contains("default");
            int currentProfileId = feedProfile.getFeedProfileId();

            // Set attributes and show feed
            request.setAttribute("feedProfile", feedProfile);
            request.setAttribute("posts", posts);
            request.setAttribute("recommendedUsers", recommendedUsers);
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedProfilePic", feedProfilePic);
            request.setAttribute("feedInitials", feedInitials);
            request.setAttribute("hasDefaultPic", hasDefaultPic);
            request.setAttribute("currentProfileId", currentProfileId);
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/publicfeed.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[FeedViewController] Error: " + e.getMessage());
            e.printStackTrace();
            // On error, just show the feed page with defaults
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/publicfeed.jsp").forward(request, response);
        }
    }
}
