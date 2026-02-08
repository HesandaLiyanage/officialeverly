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
 * EditFeedProfileViewController - Loads feed profile data for editing.
 * 
 * Route: /feededitprofileview
 */
public class EditFeedProfileViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(EditFeedProfileViewController.class.getName());
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

        // Get current user's feed profile
        FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (feedProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            feedProfile = feedProfileDAO.findByUserId(userId);
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", feedProfile);
        }

        logger.info("[EditFeedProfileViewController] Loading profile for editing: @" + feedProfile.getFeedUsername());

        // Set profile data for the form
        request.setAttribute("feedProfile", feedProfile);
        request.setAttribute("feedUsername", feedProfile.getFeedUsername());
        request.setAttribute("feedBio", feedProfile.getFeedBio());
        request.setAttribute("feedProfilePicture", feedProfile.getFeedProfilePictureUrl());

        request.getRequestDispatcher("/views/app/editpublicprofile.jsp").forward(request, response);
    }
}
