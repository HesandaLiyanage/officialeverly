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
import java.util.List;
import java.util.logging.Logger;

/**
 * BlockedUsersViewController - Handles the blocked users page.
 * Loads the list of blocked users and forwards to blockedusers.jsp.
 */
public class BlockedUsersViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(BlockedUsersViewController.class.getName());
    private BlockedUserDAO blockedUserDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        blockedUserDAO = new BlockedUserDAO();
        feedProfileDAO = new FeedProfileDAO();
        blockedUserDAO.ensureTableExists();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");

        if (currentProfile == null) {
            currentProfile = feedProfileDAO.findByUserId(userId);
            if (currentProfile != null) {
                session.setAttribute("feedProfile", currentProfile);
            }
        }

        // Handle flash messages from redirect
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

        if (currentProfile != null) {
            try {
                List<FeedProfile> blockedUsers = blockedUserDAO.getBlockedUsers(currentProfile.getFeedProfileId());
                request.setAttribute("blockedUsers", blockedUsers);
                logger.info("[BlockedUsersViewController] Loaded " + blockedUsers.size()
                        + " blocked users for profile " + currentProfile.getFeedProfileId());
            } catch (Exception e) {
                logger.severe("[BlockedUsersViewController] Error loading blocked users: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error loading blocked users");
            }
        }

        request.getRequestDispatcher("/views/app/blockedusers.jsp").forward(request, response);
    }
}
