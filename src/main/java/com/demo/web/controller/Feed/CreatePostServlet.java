package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.FeedPost;
import com.demo.web.model.FeedProfile;
import com.demo.web.model.Memory;
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
public class CreatePostServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CreatePostServlet.class.getName());
    private FeedPostDAO feedPostDAO;
    private FeedProfileDAO feedProfileDAO;
    private memoryDAO memoryDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        feedPostDAO = new FeedPostDAO();
        feedProfileDAO = new FeedProfileDAO();
        memoryDao = new memoryDAO();
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
            feedProfile = feedProfileDAO.findByUserId(userId);
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", feedProfile);
        }

        if ("selectMemory".equals(action)) {
            // Show memory selector page
            try {
                List<Memory> allMemories = memoryDao.getMemoriesByUserId(userId);
                List<Memory> availableMemories = new java.util.ArrayList<>();

                logger.info("[CreatePostServlet] Found " + allMemories.size() + " total memories for user " + userId);

                // Filter out already-posted memories and populate cover URLs
                for (Memory memory : allMemories) {
                    boolean isPosted = feedPostDAO.isMemoryPosted(memory.getMemoryId(), feedProfile.getFeedProfileId());

                    if (!isPosted) {
                        Integer mediaId = feedPostDAO.getFirstMediaId(memory.getMemoryId());
                        if (mediaId != null) {
                            // Construct viewMedia URL for browser
                            String coverUrl = request.getContextPath() + "/viewMedia?mediaId=" + mediaId;
                            memory.setCoverUrl(coverUrl);
                        }
                        availableMemories.add(memory);
                    }
                }

                logger.info("[CreatePostServlet] " + availableMemories.size() + " memories available to post");

                request.setAttribute("memories", availableMemories);
            } catch (java.sql.SQLException e) {
                logger.severe("[CreatePostServlet] Error fetching memories: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("memories", new java.util.ArrayList<Memory>());
            }
            request.setAttribute("feedProfile", feedProfile);
            // TEMP: Using test JSP to debug blank page issue
            request.getRequestDispatcher("/views/app/testSelectMemory.jsp").forward(request, response);
        } else {
            // Show main create post page with options
            logger.info("[CreatePostServlet] Showing create post page for user " + userId);
            request.setAttribute("feedProfile", feedProfile);
            request.getRequestDispatcher("/views/app/createPost.jsp").forward(request, response);
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

            // Verify memory belongs to user
            Memory memory = memoryDao.getMemoryById(memoryId);
            if (memory == null || memory.getUserId() != userId) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "Memory not found or access denied");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Get user's feed profile
            FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
            if (feedProfile == null) {
                feedProfile = feedProfileDAO.findByUserId(userId);
                if (feedProfile == null) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("error", "Feed profile not found");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }
            }

            // Check if already posted
            if (feedPostDAO.isMemoryPosted(memoryId, feedProfile.getFeedProfileId())) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "This memory is already posted");
                response.setStatus(HttpServletResponse.SC_CONFLICT);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Create the post
            FeedPost post = new FeedPost(memoryId, feedProfile.getFeedProfileId());
            post.setCaption(caption != null ? caption.trim() : memory.getDescription());

            int postId = feedPostDAO.createPost(post);

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

        } catch (NumberFormatException e) {
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
