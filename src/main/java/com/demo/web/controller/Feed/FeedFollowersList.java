package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedFollowersViewDTO;
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
 * FollowersViewController - Displays followers/following lists.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedFollowersList extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedFollowersList.class.getName());
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

        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            try { currentUserProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (currentUserProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", currentUserProfile);
        }

        // 2. Extract parameters
        String type = request.getParameter("type");
        String profileIdStr = request.getParameter("profileId");

        // 3. Delegate to service
        FeedFollowersViewDTO dto = feedService.getFollowersViewData(type, profileIdStr, currentUserProfile);

        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // Set follow status for each user in the list
        for (FeedProfile profile : dto.getUserList()) {
            boolean isFollowing = feedService.isFollowing(
                    currentUserProfile.getFeedProfileId(),
                    profile.getFeedProfileId());
            request.setAttribute("isFollowing_" + profile.getFeedProfileId(), isFollowing);
        }

        // 4. Set attributes from DTO and forward
        request.setAttribute("userList", dto.getUserList());
        request.setAttribute("pageTitle", dto.getPageTitle());
        request.setAttribute("profileToView", dto.getProfileToView());
        request.setAttribute("currentUserProfile", dto.getCurrentUserProfile());
        request.setAttribute("isOwnProfile", dto.isOwnProfile());
        request.setAttribute("profileUsername", dto.getProfileUsername());
        request.setAttribute("currentProfileId", dto.getCurrentProfileId());

        logger.info("[FollowersController] Forwarding to " + dto.getJspPage() + " with " + dto.getUserList().size() + " users");
        request.getRequestDispatcher(dto.getJspPage()).forward(request, response);
    }
}
