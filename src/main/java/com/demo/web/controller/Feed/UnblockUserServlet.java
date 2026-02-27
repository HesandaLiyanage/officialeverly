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
import java.util.logging.Logger;

/**
 * UnblockUserServlet - Handles unblocking users from the blocked users page.
 * Called via POST form submission from blockedusers.jsp.
 * Redirects back to the blocked users page after processing.
 */
public class UnblockUserServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UnblockUserServlet.class.getName());
    private BlockedUserDAO blockedUserDAO;
    private FeedProfileDAO feedProfileDAO;

    @Override
    public void init() throws ServletException {
        blockedUserDAO = new BlockedUserDAO();
        feedProfileDAO = new FeedProfileDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (session == null || session.getAttribute("user_id") == null) {
            if (isAjax) {
                sendJsonResponse(response, false, "Not logged in");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");

        if (currentProfile == null) {
            currentProfile = feedProfileDAO.findByUserId(userId);
        }

        if (currentProfile == null) {
            if (isAjax) {
                sendJsonResponse(response, false, "No feed profile found");
            } else {
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }
            return;
        }

        String blockedProfileIdStr = request.getParameter("profileId");
        if (blockedProfileIdStr == null || blockedProfileIdStr.isEmpty()) {
            if (isAjax) {
                sendJsonResponse(response, false, "Missing profile ID");
            } else {
                request.setAttribute("errorMessage", "Missing profile ID");
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }
            return;
        }

        try {
            int blockedProfileId = Integer.parseInt(blockedProfileIdStr);
            boolean success = blockedUserDAO.unblockUser(currentProfile.getFeedProfileId(), blockedProfileId);

            if (isAjax) {
                sendJsonResponse(response, success, success ? "User unblocked" : "Could not unblock user");
            } else {
                if (success) {
                    logger.info("[UnblockUserServlet] User " + currentProfile.getFeedProfileId()
                            + " unblocked user " + blockedProfileId);
                    session.setAttribute("flashMessage", "User unblocked successfully");
                    session.setAttribute("flashType", "success");
                } else {
                    session.setAttribute("flashMessage", "Could not unblock user");
                    session.setAttribute("flashType", "error");
                }
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }

        } catch (NumberFormatException e) {
            if (isAjax) {
                sendJsonResponse(response, false, "Invalid profile ID");
            } else {
                session.setAttribute("flashMessage", "Invalid profile ID");
                session.setAttribute("flashType", "error");
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }
        } catch (Exception e) {
            logger.severe("[UnblockUserServlet] Error: " + e.getMessage());
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(response, false, "Server error occurred");
            } else {
                session.setAttribute("flashMessage", "Server error occurred");
                session.setAttribute("flashType", "error");
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
}
