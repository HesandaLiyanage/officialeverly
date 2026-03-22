package com.demo.web.controller.Feed;

import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;
import com.demo.web.dto.Feed.FeedViewDTO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
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
                feedProfile = feedService.getFeedProfileByUserId(userId);

                if (feedProfile != null) {
                    session.setAttribute("feedProfile", feedProfile);
                    logger.info("[FeedViewController] Feed cached");
                }
            }

            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }

            // Retrieve data via service and DTO
            FeedViewDTO data = feedService.getFeedViewData(feedProfile, request.getContextPath());

            request.setAttribute("feedProfile", data.getFeedProfile());
            request.setAttribute("posts", data.getPosts());
            request.setAttribute("recommendedUsers", data.getRecommendedUsers());
            request.setAttribute("feedUsername", data.getFeedUsername());
            request.setAttribute("feedProfilePic", data.getFeedProfilePic());
            request.setAttribute("feedInitials", data.getFeedInitials());
            request.setAttribute("hasDefaultPic", data.hasDefaultPic());
            request.setAttribute("currentProfileId", data.getCurrentProfileId());
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/publicfeed.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[FeedViewController] Error: " + e.getMessage());
            e.printStackTrace();
            // On error, just show the feed page with defaults
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/publicfeed.jsp").forward(request, response);
        }
    }
}
