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
 * SavePostServlet - Handles save/unsave (bookmark) actions for posts.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedPostSave extends HttpServlet {

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

        // 3. Delegate to service
        FeedActionResponse result = feedService.handlePostSave(postId, action, currentProfile.getFeedProfileId());

        // 4. Return response
        if (!result.isSuccess() && result.getError() != null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"" + result.getError() + "\"}");
        } else {
            out.print(String.format("{\"success\": %b, \"isSaved\": %b}", result.isSuccess(), result.getIsSaved()));
        }
    }

    private FeedProfile resolveProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\": false, \"error\": \"Not authenticated\"}");
            return null;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile profile = (FeedProfile) session.getAttribute("feedProfile");
        if (profile == null) {
            try { profile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (profile != null) session.setAttribute("feedProfile", profile);
        }

        if (profile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"No feed profile\"}");
            return null;
        }
        return profile;
    }
}
