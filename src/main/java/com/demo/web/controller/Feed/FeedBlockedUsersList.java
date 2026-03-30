package com.demo.web.controller.Feed;

import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * BlockedUsersViewController - Handles the blocked users page.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedBlockedUsersList extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedBlockedUsersList.class.getName());
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1. Resolve profile
        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentProfile == null) {
            try { currentProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (currentProfile != null) session.setAttribute("feedProfile", currentProfile);
        }

        // Handle flash messages
        String flashMessage = (String) session.getAttribute("flashMessage");
        String flashType = (String) session.getAttribute("flashType");
        if (flashMessage != null) {
            if ("success".equals(flashType)) {
                request.setAttribute("successMessage", flashMessage);
            } else {
                request.setAttribute("errorMessage", flashMessage);
            }
            session.removeAttribute("flashMessage");
            session.removeAttribute("flashType");
        }

        // 2. Delegate to service
        if (currentProfile != null) {
            List<FeedProfile> blockedUsers = feedService.getBlockedUsers(currentProfile.getFeedProfileId());
            request.setAttribute("blockedUsers", blockedUsers);
            logger.info("[BlockedUsersController] Loaded " + blockedUsers.size() + " blocked users");
        }

        // 3. Forward to view
        request.getRequestDispatcher("/WEB-INF/views/app/Feed/blockedusers.jsp").forward(request, response);
    }
}
