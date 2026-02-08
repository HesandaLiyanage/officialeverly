package com.demo.web.controller.Feed;

import com.demo.web.dao.SavedPostDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

/**
 * SavePostServlet - Handles save/unsave (bookmark) actions for posts.
 * 
 * Route: /savePost
 * Method: POST
 * Parameters: action (save/unsave), postId
 */
public class SavePostServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(SavePostServlet.class.getName());
    private SavedPostDAO savedPostDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        savedPostDAO = new SavedPostDAO();
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"error\": \"Not authenticated\"}");
            return;
        }

        // Get current user's feed profile
        FeedProfile currentUserProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentUserProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            currentUserProfile = feedProfileDAO.findByUserId(userId);
            if (currentUserProfile == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"No feed profile\"}");
                return;
            }
            session.setAttribute("feedProfile", currentUserProfile);
        }

        String action = request.getParameter("action");
        String postIdStr = request.getParameter("postId");

        if (action == null || postIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing parameters\"}");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(postIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
            return;
        }

        int currentProfileId = currentUserProfile.getFeedProfileId();
        boolean success = false;
        boolean isSaved = false;

        try {
            if ("save".equals(action)) {
                success = savedPostDAO.savePost(currentProfileId, postId);
                isSaved = true;
                logger.info("[SavePostServlet] Profile " + currentProfileId + " saved post " + postId);
            } else if ("unsave".equals(action)) {
                success = savedPostDAO.unsavePost(currentProfileId, postId);
                isSaved = false;
                logger.info("[SavePostServlet] Profile " + currentProfileId + " unsaved post " + postId);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Invalid action\"}");
                return;
            }

            // Return JSON response
            String json = String.format(
                    "{\"success\": %b, \"isSaved\": %b}",
                    success, isSaved);
            out.print(json);

        } catch (Exception e) {
            logger.severe("[SavePostServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }
}
