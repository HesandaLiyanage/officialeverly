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
import java.io.IOException;
import java.util.List;

/**
 * Servlet for loading memory data into edit form
 */
public class EditMemoryServlet extends HttpServlet {

    private memoryDAO memoryDao;
    private MediaDAO mediaDao;

    @Override
    public void init() throws ServletException {
        memoryDao = new memoryDAO();
        mediaDao = new MediaDAO();
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
                response.sendRedirect("/memories");
                return;
            }

            // Check if user owns this memory
            if (memory.getUserId() != userId) {
                request.setAttribute("errorMessage", "You don't have permission to edit this memory");
                response.sendRedirect("/memories");
                return;
            }

            // Fetch associated media items
            List<MediaItem> mediaItems = mediaDao.getMediaByMemoryId(memoryId);

            // Set attributes for JSP
            request.setAttribute("memory", memory);
            request.setAttribute("mediaItems", mediaItems);

            // Forward to edit page
            request.getRequestDispatcher("/views/app/editmemory.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/memories");
        }
    }
}
