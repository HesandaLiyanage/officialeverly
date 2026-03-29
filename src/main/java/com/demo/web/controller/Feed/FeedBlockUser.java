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
import java.io.PrintWriter;

/**
 * BlockUserServlet - Handles blocking users from the feed.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedBlockUser extends HttpServlet {

    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Authenticate
        FeedProfile currentProfile = resolveProfile(request, response);
        if (currentProfile == null) return;

        // 2. Extract parameters
        String targetProfileIdStr = request.getParameter("targetProfileId");
        if (targetProfileIdStr == null || targetProfileIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Missing targetProfileId\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);

            // 3. Delegate to service
            FeedActionResponse result = feedService.blockUser(currentProfile.getFeedProfileId(), targetProfileId);

            // 4. Return response
            out.write("{\"success\": " + result.isSuccess() + ", \"message\": \"" +
                    (result.isSuccess() ? result.getMessage() : result.getError()) + "\"}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Invalid targetProfileId\"}");
        }
    }

    private FeedProfile resolveProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Not logged in\"}");
            return null;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile profile = (FeedProfile) session.getAttribute("feedProfile");
        if (profile == null) {
            try { profile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
        }

        if (profile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"No feed profile found\"}");
            return null;
        }
        return profile;
    }
}
