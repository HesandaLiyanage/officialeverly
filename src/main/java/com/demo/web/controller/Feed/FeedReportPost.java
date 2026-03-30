package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
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
 * FeedReportPost - Handles reporting a post from the feed.
 * Thin controller — all business logic delegated to FeedService.
 */
@WebServlet("/reportpost")
public class FeedReportPost extends HttpServlet {

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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"Not authenticated\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");

        // 2. Extract parameters
        String postIdStr = request.getParameter("postId");
        String reason = request.getParameter("reason");

        if (postIdStr == null || postIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Post ID is required\"}");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(postIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"success\": false, \"message\": \"Invalid post ID\"}");
            return;
        }

        // 3. Delegate to service
        FeedActionResponse result = feedService.reportPost(postId, reason, userId);

        // 4. Return response
        out.write("{\"success\": " + result.isSuccess() + ", \"message\": \"" +
                (result.isSuccess() ? result.getMessage() : result.getError()) + "\"}");
    }
}
