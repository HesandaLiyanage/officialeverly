package com.demo.web.controller.Memory;

import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;
import com.demo.web.model.Group;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for deleting a memory and its associated media
 */
public class DeleteMemoryServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MediaDAO mediaDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
                response.sendRedirect("/memories");
                return;
            }

            // Check delete permissions
            boolean canDelete = false;
            boolean isGroupMemory = (memory.getGroupId() != null);
            Integer groupId = memory.getGroupId();

            if (isGroupMemory) {
                GroupDAO groupDAO = new GroupDAO();
                GroupMemberDAO groupMemberDAO = new GroupMemberDAO();
                Group group = groupDAO.findById(groupId);
                boolean isAdmin = (group != null && group.getUserId() == userId);
                String memberRole = groupMemberDAO.getMemberRole(groupId, userId);
                canDelete = isAdmin || "editor".equals(memberRole);
            } else {
                canDelete = (memory.getUserId() == userId);
            }

            if (!canDelete) {
                if (isGroupMemory) {
                    response.sendRedirect("/groupmemories?groupId=" + groupId);
                } else {
                    response.sendRedirect("/memories");
                }
                return;
            }

            // Get associated media items to delete files
            List<MediaItem> mediaItems = mediaDao.getMediaByMemoryId(memoryId);

            // Delete physical media files
            for (MediaItem item : mediaItems) {
                try {
                    String filePath = item.getFilePath();
                    if (filePath != null && !filePath.isEmpty()) {
                        File file = new File(filePath);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                    // Delete media record from database
                    mediaDao.deleteMediaItem(item.getMediaId());
                } catch (Exception e) {
                    e.printStackTrace();
                    // Continue deleting other items
                }
            }

            // Delete memory (memory_media entries will cascade)
            memoryDao.deleteMemory(memoryId);

            // Redirect back
            if (isGroupMemory && groupId != null) {
                response.sendRedirect("/groupmemories?groupId=" + groupId);
            } else {
                response.sendRedirect("/memories");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/memories");
        }
    }

    // Also support GET for simple delete links (with confirmation in JS)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
