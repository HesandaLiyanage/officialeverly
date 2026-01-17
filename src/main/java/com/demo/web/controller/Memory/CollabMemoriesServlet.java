package com.demo.web.controller.Memory;

import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Memory;
import com.demo.web.model.MemoryMember;
import com.demo.web.model.MediaItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet to list collaborative memories for the current user.
 * Shows memories where the user is either the owner or a member.
 */
@WebServlet("/collabmemories")
public class CollabMemoriesServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MemoryMemberDAO memberDao;
    private MediaDAO mediaDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        memberDao = new MemoryMemberDAO();
        mediaDao = new MediaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            // Get all memberships for this user
            List<MemoryMember> memberships = memberDao.getCollaborativeMemoriesForUser(userId);

            // Convert memberships to Memory objects
            List<Memory> collabMemories = new ArrayList<>();
            for (MemoryMember membership : memberships) {
                Memory memory = memoryDao.getMemoryById(membership.getMemoryId());
                if (memory != null) {
                    collabMemories.add(memory);

                    // Get cover image
                    String coverUrl = null;
                    if (memory.getCoverMediaId() != null && memory.getCoverMediaId() > 0) {
                        coverUrl = request.getContextPath() + "/viewMedia?mediaId=" + memory.getCoverMediaId();
                    } else {
                        // Try to get first media item as cover
                        List<MediaItem> mediaItems = mediaDao.getMediaForMemory(memory.getMemoryId());
                        if (mediaItems != null && !mediaItems.isEmpty()) {
                            coverUrl = request.getContextPath() + "/viewMedia?mediaId="
                                    + mediaItems.get(0).getMediaId();
                        }
                    }
                    request.setAttribute("cover_" + memory.getMemoryId(), coverUrl);

                    // Get member count
                    int memberCount = memberDao.getMemberCount(memory.getMemoryId());
                    request.setAttribute("memberCount_" + memory.getMemoryId(), memberCount);

                    // Check if user is owner
                    boolean isOwner = "owner".equals(membership.getRole());
                    request.setAttribute("isOwner_" + memory.getMemoryId(), isOwner);
                }
            }

            request.setAttribute("collabMemories", collabMemories);
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading collab memories: " + e.getMessage());
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
        }
    }
}
