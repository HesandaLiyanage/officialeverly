package com.demo.web.controller.Memory;

import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;

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

            // Check if user owns this memory
            if (memory.getUserId() != userId) {
                response.sendRedirect("/memories");
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

            // Redirect to memories list
            response.sendRedirect("/memories");

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
