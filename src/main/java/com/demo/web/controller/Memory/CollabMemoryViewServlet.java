package com.demo.web.controller.Memory;

import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;
import com.demo.web.model.MemoryMember;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for viewing a collaborative memory with member list
 */
public class CollabMemoryViewServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MediaDAO mediaDao;
    private MemoryMemberDAO memberDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();
        memberDao = new MemoryMemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("/collabmemories");
            return;
        }

        try {
            int memoryId = Integer.parseInt(idParam);
            int userId = (int) session.getAttribute("user_id");

            // Fetch memory
            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null) {
                request.setAttribute("errorMessage", "Memory not found");
                request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
                return;
            }

            // Check if this is a collaborative memory
            if (!memory.isCollaborative()) {
                // Redirect to regular memory view
                response.sendRedirect("/memoryview?id=" + memoryId);
                return;
            }

            // Check if user is a member
            if (!memberDao.isMember(memoryId, userId)) {
                request.setAttribute("errorMessage", "You don't have access to this memory");
                request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
                return;
            }

            // Fetch associated media items
            List<MediaItem> mediaItems = mediaDao.getMediaByMemoryId(memoryId);

            // Fetch members
            List<MemoryMember> members = memberDao.getMembers(memoryId);

            // Check if current user is owner
            boolean isOwner = memberDao.isOwner(memoryId, userId);

            // Set attributes for JSP
            request.setAttribute("memory", memory);
            request.setAttribute("mediaItems", mediaItems);
            request.setAttribute("members", members);
            request.setAttribute("isOwner", isOwner);
            request.setAttribute("currentUserId", userId);

            // Forward to view page
            request.getRequestDispatcher("/views/app/collabmemoryview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/collabmemories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory: " + e.getMessage());
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
        }
    }
}
