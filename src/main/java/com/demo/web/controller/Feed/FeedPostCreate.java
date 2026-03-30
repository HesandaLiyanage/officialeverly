package com.demo.web.controller.Feed;

import com.demo.web.service.FeedService;
import com.demo.web.dto.Feed.FeedPostCreateRequest;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.Memory;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Handles post creation for the public feed.
 * 
 * GET: Shows the create post page with user's memories
 * POST: Creates a post from selected memory
 */
public class FeedPostCreate extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedPostCreate.class.getName());
    private FeedService feedService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
        gson = new Gson();
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
        String action = request.getParameter("action");

        // Get user's feed profile
        FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (feedProfile == null) {
            try {
                feedProfile = feedService.getFeedProfileByUserId(userId);
            } catch (Exception e) { /* ignored, defaults handled */ }
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", feedProfile);
        }

        if ("selectMemory".equals(action)) {
            // Show memory selector page
            try {
                List<Memory> availableMemories = feedService.getAvailableMemoriesForPost(userId, feedProfile.getFeedProfileId(), request.getContextPath());
                request.setAttribute("memories", availableMemories);
            } catch (Exception e) {
                request.setAttribute("memories", new java.util.ArrayList<Memory>());
            }
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/selectMemoryForPost.jsp").forward(request, response);
        } else {
            // Show main create post page with options
            logger.info("[CreatePostServlet] Showing create post page for user " + userId);
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/createPost.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("application/json");

        JsonObject jsonResponse = new JsonObject();

        if (session == null || session.getAttribute("user_id") == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Get memory ID from request
            String memoryIdStr = request.getParameter("memoryId");
            String caption = request.getParameter("caption");

            if (memoryIdStr == null || memoryIdStr.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Memory ID is required");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int memoryId = Integer.parseInt(memoryIdStr);

            FeedPostCreateRequest createReq = new FeedPostCreateRequest(memoryId, caption, userId);
            int postId = feedService.createFeedPost(createReq);

            if (postId > 0) {
                logger.info("[CreatePostServlet] Post created: " + postId + " for memory: " + memoryId);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("postId", postId);
                jsonResponse.addProperty("message", "Post created successfully!");
                response.getWriter().write(gson.toJson(jsonResponse));
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Failed to create post");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write(gson.toJson(jsonResponse));
            }

        } catch (IllegalArgumentException | IllegalStateException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Invalid memory ID");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            logger.severe("[CreatePostServlet] Error: " + e.getMessage());
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Server error: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
