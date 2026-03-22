package com.demo.web.controller.Api;

import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Memory.MediaItem;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/memories")
public class MemoriesApiServlet extends HttpServlet {
    private memoryDAO memoryDao;
    private MediaDAO mediaDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();
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
            List<Memory> memories = memoryDao.getMemoriesByUserId(userId);

            // Fetch cover media for each 
            for(Memory mem : memories) {
                try {
                    List<MediaItem> items = mediaDao.getMediaByMemoryId(mem.getMemoryId());
                    if (items != null && !items.isEmpty()) {
                        mem.setCoverUrl(request.getContextPath() + "/viewmedia?id=" + items.get(0).getMediaId());
                    }
                } catch(Exception e) {}
            }
            
            response.getWriter().write(gson.toJson(memories));

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
