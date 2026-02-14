package com.demo.web.controller.Memory;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Group;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for viewing a single memory with its associated media.
 * Supports personal memories and group memories with role-based access.
 */
public class MemoryViewServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MediaDAO mediaDao;
    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();
        groupDAO = new GroupDAO();
        groupMemberDAO = new GroupMemberDAO();
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
            response.sendRedirect("/memories");
            return;
        }

        try {
            int memoryId = Integer.parseInt(idParam);
            int userId = (int) session.getAttribute("user_id");

            // Fetch memory
            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null) {
                request.setAttribute("errorMessage", "Memory not found");
                request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);
                return;
            }

            // Check access permissions
            boolean isOwner = (memory.getUserId() == userId);
            boolean isGroupMemory = (memory.getGroupId() != null);
            boolean hasAccess = isOwner;
            boolean isAdmin = false;
            boolean canEdit = isOwner;
            String userRole = isOwner ? "admin" : null;
            Group group = null;

            if (isGroupMemory) {
                int groupId = memory.getGroupId();
                group = groupDAO.findById(groupId);
                isAdmin = (group != null && group.getUserId() == userId);
                boolean isMember = groupMemberDAO.isUserMember(groupId, userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);

                hasAccess = isAdmin || isMember;
                userRole = isAdmin ? "admin" : memberRole;
                canEdit = isAdmin || "editor".equals(memberRole);
            }

            if (!hasAccess) {
                request.setAttribute("errorMessage", "You don't have permission to view this memory");
                request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);
                return;
            }

            // Fetch associated media items
            List<MediaItem> mediaItems = mediaDao.getMediaByMemoryId(memoryId);

            // Set attributes for JSP
            request.setAttribute("memory", memory);
            request.setAttribute("mediaItems", mediaItems);
            request.setAttribute("isGroupMemory", isGroupMemory);
            request.setAttribute("canEdit", canEdit);
            request.setAttribute("userRole", userRole);
            request.setAttribute("isAdmin", isAdmin || isOwner);
            if (group != null) {
                request.setAttribute("group", group);
            }

            // Forward to view page
            request.getRequestDispatcher("/views/app/memoryview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory: " + e.getMessage());
            request.getRequestDispatcher("/views/app/memories.jsp").forward(request, response);
        }
    }
}
