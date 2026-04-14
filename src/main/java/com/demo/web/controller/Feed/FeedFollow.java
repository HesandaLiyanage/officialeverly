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
 * FollowServlet - Handles follow/unfollow actions via AJAX.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedFollow extends HttpServlet {

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
        String action = request.getParameter("action");
        String targetProfileIdStr = request.getParameter("targetProfileId");

        if (action == null || targetProfileIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);

            // 3. Delegate to service
            FeedActionResponse result = feedService.handleFollow(action, currentProfile.getFeedProfileId(), targetProfileId);

            // 4. Return response
            if (!result.isSuccess()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"" + result.getError() + "\"}");
            } else {
                out.print("{\"success\": " + result.isSuccess() +
                        ", \"action\": \"" + result.getAction() + "\"" +
                        ", \"isFollowing\": " + result.getIsFollowing() +
                        ", \"followerCount\": " + result.getFollowerCount() +
                        ", \"followingCount\": " + result.getFollowingCount() + "}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid profile ID\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Authenticate
        FeedProfile currentProfile = resolveProfile(request, response);
        if (currentProfile == null) return;

        // 2. Extract parameters
        String targetProfileIdStr = request.getParameter("targetProfileId");
        if (targetProfileIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Missing profile ID\"}");
            return;
        }

        try {
            int targetProfileId = Integer.parseInt(targetProfileIdStr);

            // 3. Delegate to service
            FeedActionResponse result = feedService.checkFollowStatus(currentProfile.getFeedProfileId(), targetProfileId);

            // 4. Return response
            out.print("{\"success\": true, \"isFollowing\": " + result.getIsFollowing() + "}");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid profile ID\"}");
        }
    }

    private FeedProfile resolveProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\": false, \"message\": \"Not logged in\"}");
            return null;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile profile = (FeedProfile) session.getAttribute("feedProfile");
        if (profile == null) {
            try { profile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
        }

        if (profile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"message\": \"No feed profile found\"}");
            return null;
        }
        return profile;
    }
}
