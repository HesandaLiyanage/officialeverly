package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedProfileViewDTO;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * FeedProfileViewController - Handles feed profile page display.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedProfileView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedProfileView.class.getName());
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authenticate
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Resolve current user's feed profile
        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            try { currentUserProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (currentUserProfile != null) {
                session.setAttribute("feedProfile", currentUserProfile);
            } else {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
        }

        // 2. Extract parameters
        String targetUsername = request.getParameter("username");

        // 3. Delegate to service
        FeedProfileViewDTO dto = feedService.getProfileViewData(targetUsername, currentUserProfile, request.getContextPath());

        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // 4. Set attributes from DTO and forward
        request.setAttribute("profileToView", dto.getProfileToView());
        request.setAttribute("isOwnProfile", dto.isOwnProfile());
        request.setAttribute("isFollowing", dto.isFollowing());
        request.setAttribute("followerCount", dto.getFollowerCount());
        request.setAttribute("followingCount", dto.getFollowingCount());
        request.setAttribute("postCount", dto.getPostCount());
        request.setAttribute("userPosts", dto.getUserPosts());
        request.setAttribute("savedPosts", dto.getSavedPosts());
        request.setAttribute("recommendedUsers", dto.getRecommendedUsers());
        request.setAttribute("currentUserProfile", dto.getCurrentUserProfile());
        request.setAttribute("isBlocked", dto.isBlocked());
        request.setAttribute("profileUsername", dto.getProfileUsername());
        request.setAttribute("profilePic", dto.getProfilePic());
        request.setAttribute("profileBio", dto.getProfileBio());
        request.setAttribute("profileInitials", dto.getProfileInitials());
        request.setAttribute("profileId", dto.getProfileId());
        request.setAttribute("hasProfilePic", dto.isHasProfilePic());

        logger.info("[ProfileViewController] Displaying profile: @" + dto.getProfileUsername());

        request.getRequestDispatcher("/WEB-INF/views/app/Feed/userprofile.jsp").forward(request, response);
    }
}
