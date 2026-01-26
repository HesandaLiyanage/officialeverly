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

public class MemoriesServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Get all memories for this user
            List<Memory> memories = memoryDAO.getMemoriesByUserId(userId);

            System.out.println("Found " + memories.size() + " memories for user " + userId);

            // For each memory, get the first media item as cover image
            for (Memory memory : memories) {
                try {
                    // Get media items for this memory
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());

                    if (!mediaItems.isEmpty()) {
                        // Use first media item as cover
                        MediaItem coverMedia = mediaItems.get(0);

                        // Store media ID for cover (served directly by ViewMediaServlet)
                        request.setAttribute("cover_" + memory.getMemoryId(),
                                request.getContextPath() + "/viewMedia?mediaId=" + coverMedia.getMediaId());

                        System.out.println("Set cover for memory " + memory.getMemoryId() +
                                ": media_id=" + coverMedia.getMediaId());
                    } else {
                        // No media for this memory - use default
                        System.out.println("No media for memory " + memory.getMemoryId());
                    }
                } catch (Exception e) {
                    System.err
                            .println("Error getting media for memory " + memory.getMemoryId() + ": " + e.getMessage());
                    // Continue with other memories
                }
            }

            // Set memories in request
            request.setAttribute("memories", memories);

            // Forward to JSP
            request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memories: " + e.getMessage());
            request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);
        }
    }
}