// File: com.demo.web.controller.Memory.MemoriesListServlet.java
package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class MemoriesListServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;

    @Override
    public void init() throws ServletException {
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();
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

        try {
            List<Memory> memories = memoryDAO.getMemoriesByUserId(userId);

            // For each memory, get cover image (first media item)
            for (Memory memory : memories) {
                List<MediaItem> mediaList = mediaDAO.getMediaByMemoryId(memory.getMemoryId());
                String coverUrl = null;
                if (!mediaList.isEmpty()) {
                    MediaItem firstMedia = mediaList.get(0);
                    coverUrl = request.getContextPath() + "/viewmedia?id=" + firstMedia.getMediaId();
                }
                // Store cover URL in a map or directly in request
                request.setAttribute("cover_" + memory.getMemoryId(), coverUrl);
            }

            // At the end of doGet()
            request.setAttribute("memories", memories);
            request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load memories");
            request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);
        }
    }
}