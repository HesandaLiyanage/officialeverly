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

@WebServlet("/api/memory")
public class MemoryDetailApiServlet extends HttpServlet {
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
            String idParam = request.getParameter("id");
            
            if(idParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("error", "Missing id");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int memoryId = Integer.parseInt(idParam);
            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null || memory.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                jsonResponse.addProperty("error", "Memory not found or access denied");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Retrieve all media
            List<MediaItem> items = mediaDao.getMediaByMemoryId(memoryId);
            com.google.gson.JsonArray mediaArray = new com.google.gson.JsonArray();
            for(MediaItem item : items) {
                JsonObject jsonItem = gson.toJsonTree(item).getAsJsonObject();
                jsonItem.addProperty("mediaUrl", request.getContextPath() + "/viewmedia?id=" + item.getMediaId());
                mediaArray.add(jsonItem);
            }
            
            // Re-use transient memory.setMediaItems if it existed, otherwise set it via manual JSON build
            // Actually our Memory model might not have media items embedded. I'll just attach it dynamically
            JsonObject jsonMem = gson.toJsonTree(memory).getAsJsonObject();
            jsonMem.add("media", mediaArray);
            
            response.getWriter().write(gson.toJson(jsonMem));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("error", "Invalid ID");
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("error", e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
