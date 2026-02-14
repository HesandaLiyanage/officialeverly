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
 * Servlet for loading memory data into edit form.
 * Supports both personal memories (owner-only) and group memories
 * (admin/editor).
 */
public class EditMemoryServlet extends HttpServlet {

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

            Memory memory = memoryDao.getMemoryById(memoryId);

            if (memory == null) {
                request.setAttribute("errorMessage", "Memory not found");
                response.sendRedirect("/memories");
                return;
            }

            boolean canEdit = false;
            boolean isGroupMemory = (memory.getGroupId() != null);

            if (isGroupMemory) {
                int groupId = memory.getGroupId();
                Group group = groupDAO.findById(groupId);
                boolean isAdmin = (group != null && group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                canEdit = isAdmin || "editor".equals(memberRole);

                if (canEdit) {
                    request.setAttribute("group", group);
                    request.setAttribute("isGroupMemory", true);
                }
            } else {
                // Personal memory — only owner can edit
                canEdit = (memory.getUserId() == userId);
            }

            if (!canEdit) {
                request.setAttribute("errorMessage", "You don't have permission to edit this memory");
                if (isGroupMemory) {
                    response.sendRedirect("/groupmemories?groupId=" + memory.getGroupId());
                } else {
                    response.sendRedirect("/memories");
                }
                return;
            }

            List<MediaItem> mediaItems = mediaDao.getMediaByMemoryId(memoryId);

            request.setAttribute("memory", memory);
            request.setAttribute("mediaItems", mediaItems);

            request.getRequestDispatcher("/views/app/editmemory.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/memories");
        }
    }
}
