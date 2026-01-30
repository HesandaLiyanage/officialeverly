package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;

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
 * profile.
 * If no profile exists, redirects to the welcome/setup flow.
 */
public class FeedViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedViewController.class.getName());
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
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

            // Feed profile exists, set it as request attribute and show feed
            logger.info("[FeedViewController] Feed profile found: @" + feedProfile.getFeedUsername());
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/views/app/publicfeed.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("[FeedViewController] Error checking feed profile: " + e.getMessage());
            e.printStackTrace();
            // On error, just show the feed page with defaults
            request.getRequestDispatcher("/views/app/publicfeed.jsp").forward(request, response);
        }
    }
}
