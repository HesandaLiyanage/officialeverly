package com.demo.web.controller.Api;

import com.demo.web.dto.Feed.FeedViewDTO;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/feed")
public class FeedApiServlet extends HttpServlet {
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
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Not authenticated");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            Integer userId = (Integer) session.getAttribute("user_id");
            FeedProfile profile = feedService.getFeedProfileByUserId(userId);
            
            if (profile == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("error", "No feed profile found");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Get standard feed structure from service
            FeedViewDTO data = feedService.getFeedViewData(profile, request.getContextPath());
            
            // Send back array of posts
            response.getWriter().write(gson.toJson(data.getPosts()));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
