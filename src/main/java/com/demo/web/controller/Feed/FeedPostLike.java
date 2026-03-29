package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to handle post like/unlike AJAX operations.
 * Thin controller — all business logic delegated to FeedService.
 */
@WebServlet("/postLike")
public class FeedPostLike extends HttpServlet {

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
        String postIdStr = request.getParameter("postId");
        String action = request.getParameter("action");

        if (postIdStr == null || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing required parameters\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);

            // 3. Delegate to service
            FeedActionResponse result = feedService.handlePostLike(postId, action, currentProfile);

            // 4. Return response
            if (!result.isSuccess()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"" + result.getError() + "\"}");
            } else {
                out.print(String.format("{\"success\": true, \"isLiked\": %b, \"likeCount\": %d}",
                        result.getIsLiked(), result.getLikeCount()));
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
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
        }

        if (profile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"No feed profile found\"}");
            return null;
        }
        return profile;
    }
}
