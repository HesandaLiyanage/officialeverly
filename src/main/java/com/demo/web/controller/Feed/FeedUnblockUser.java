package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * UnblockUserServlet - Handles unblocking users.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedUnblockUser extends HttpServlet {

    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
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

        // 1. Resolve profile
        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentProfile == null) {
            try { currentProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
        }

        if (currentProfile == null) {
            if (isAjax) {
                sendJsonResponse(response, false, "No feed profile found");
            } else {
                response.sendRedirect(request.getContextPath() + "/blockedusers");
            }
            return;
        }

        // 2. Extract parameters
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

            // 3. Delegate to service
            FeedActionResponse result = feedService.unblockUser(currentProfile.getFeedProfileId(), blockedProfileId);

            // 4. Return response
            if (isAjax) {
                sendJsonResponse(response, result.isSuccess(),
                        result.isSuccess() ? result.getMessage() : result.getError());
            } else {
                if (result.isSuccess()) {
                    session.setAttribute("flashMessage", "User unblocked successfully");
                    session.setAttribute("flashType", "success");
                } else {
                    session.setAttribute("flashMessage", result.getError());
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
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }
}
