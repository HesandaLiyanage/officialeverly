package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.CollabMemoryViewRequest;
import com.demo.web.dto.Memory.CollabMemoryViewResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CollabMemoryView extends HttpServlet {

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
            response.sendRedirect("/collabmemories");
            return;
        }

        try {
            CollabMemoryViewRequest apiRequest = new CollabMemoryViewRequest();
            apiRequest.setMemoryId(Integer.parseInt(idParam));
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));

            CollabMemoryViewResponse apiResponse = memoryService.viewCollabMemory(apiRequest);

            if (apiResponse.getErrorMessage() != null) {
                request.setAttribute("errorMessage", apiResponse.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);
                return;
            }

            if (!apiResponse.isCollaborative()) {
                response.sendRedirect("/memoryview?id=" + apiRequest.getMemoryId());
                return;
            }

            request.setAttribute("memory", apiResponse.getMemory());
            request.setAttribute("mediaItems", apiResponse.getMediaItems());
            request.setAttribute("members", apiResponse.getMembers());
            request.setAttribute("isOwner", apiResponse.isOwner());
            request.setAttribute("currentUserId", apiRequest.getUserId());

            request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemoryview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/collabmemories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);
        }
    }
}
