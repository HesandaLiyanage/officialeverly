package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryViewRequest;
import com.demo.web.dto.Memory.MemoryViewResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for viewing a single memory with its associated media.
 * Supports personal memories and group memories with role-based access.
 */
public class MemoryView extends HttpServlet {

    private MemoryService memoryService;

    @Override
    public void init() throws ServletException {
        memoryService = new MemoryService();
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

            MemoryViewRequest viewRequest = new MemoryViewRequest();
            viewRequest.setMemoryId(memoryId);
            viewRequest.setUserId(userId);

            MemoryViewResponse viewResponse = memoryService.viewMemory(viewRequest);

            if (!viewResponse.isSuccess()) {
                request.setAttribute("errorMessage", viewResponse.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Memory/memories.jsp").forward(request, response);
                return;
            }

            // Set attributes for JSP exactly as before
            request.setAttribute("memory", viewResponse.getMemory());
            request.setAttribute("mediaItems", viewResponse.getMediaItems());
            request.setAttribute("isGroupMemory", viewResponse.isGroupMemory());
            request.setAttribute("canEdit", viewResponse.isCanEdit());
            request.setAttribute("userRole", viewResponse.getUserRole());
            request.setAttribute("isAdmin", viewResponse.isAdmin());
            if (viewResponse.getGroup() != null) {
                request.setAttribute("group", viewResponse.getGroup());
            }

            // Forward to view page
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memoryview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memories.jsp").forward(request, response);
        }
    }
}
