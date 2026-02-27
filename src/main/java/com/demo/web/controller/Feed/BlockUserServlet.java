package com.demo.web.controller.Feed;

import com.demo.web.dao.BlockedUserDAO;
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
 * BlockUserServlet - Handles blocking users from the feed.
 * Called via AJAX from the feed post options menu.
 * Returns JSON response.
 */
public class BlockUserServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(BlockUserServlet.class.getName());
    private BlockedUserDAO blockedUserDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        blockedUserDAO = new BlockedUserDAO();
        feedProfileDAO = new FeedProfileDAO();
        // Ensure the blocked_users table exists
        blockedUserDAO.ensureTableExists();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");

        if (currentProfile == null) {
            currentProfile = feedProfileDAO.findByUserId(userId);
        }

        if (currentProfile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"No feed profile found\"}");
            return;
        }

        String targetProfileIdStr = request.getParameter("targetProfileId");
        if (targetProfileIdStr == null || targetProfileIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Missing targetProfileId\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);

            if (targetProfileId == currentProfile.getFeedProfileId()) {
                out.write("{\"success\": false, \"message\": \"Cannot block yourself\"}");
                return;
            }

            boolean success = blockedUserDAO.blockUser(currentProfile.getFeedProfileId(), targetProfileId);

            if (success) {
                logger.info("[BlockUserServlet] User " + currentProfile.getFeedProfileId()
                        + " blocked user " + targetProfileId);
                out.write("{\"success\": true, \"message\": \"User blocked successfully\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"User is already blocked or could not be blocked\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Invalid targetProfileId\"}");
        } catch (Exception e) {
            logger.severe("[BlockUserServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"Server error\"}");
        }
    }
}
