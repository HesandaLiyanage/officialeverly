package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MediaItem;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for listing collaborative memories
 */
public class CollabMemoriesServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MediaDAO mediaDAO;
    private MemoryMemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        mediaDAO = new MediaDAO();
        memberDAO = new MemoryMemberDAO();
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
            // Get all collab memories where user is owner or member
            List<Memory> memories = memoryDAO.getCollabMemoriesByUserId(userId);

            System.out.println("Found " + memories.size() + " collab memories for user " + userId);

            // For each memory, get cover image and member count
            for (Memory memory : memories) {
                try {
                    // Get media items for this memory
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());

                    if (!mediaItems.isEmpty()) {
                        MediaItem coverMedia = mediaItems.get(0);
                        request.setAttribute("cover_" + memory.getMemoryId(),
                                request.getContextPath() + "/viewMedia?mediaId=" + coverMedia.getMediaId());
                    }

                    // Get member count
                    int memberCount = memberDAO.getMemberCount(memory.getMemoryId());
                    request.setAttribute("memberCount_" + memory.getMemoryId(), memberCount);

                    // Check if current user is owner
                    boolean isOwner = memberDAO.isOwner(memory.getMemoryId(), userId);
                    request.setAttribute("isOwner_" + memory.getMemoryId(), isOwner);

                } catch (Exception e) {
                    System.err.println("Error getting data for memory " + memory.getMemoryId() + ": " + e.getMessage());
                }
            }

            request.setAttribute("memories", memories);
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading collab memories: " + e.getMessage());
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
        }
    }
}
