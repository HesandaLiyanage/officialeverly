package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryRecapRequest;
import com.demo.web.dto.Memory.MemoryRecapResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemoryRecap extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            MemoryRecapRequest apiRequest = new MemoryRecapRequest();
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));
            apiRequest.setContextPath(request.getContextPath());

            MemoryRecapResponse apiResponse = memoryService.getMemoryRecaps(apiRequest);

            request.setAttribute("allRecaps", apiResponse.getAllRecaps());
            request.setAttribute("timeRecaps", apiResponse.getTimeRecaps());
            request.setAttribute("eventRecaps", apiResponse.getEventRecaps());
            request.setAttribute("groupRecaps", apiResponse.getGroupRecaps());
            
            request.setAttribute("totalMemories", apiResponse.getTotalMemories());
            request.setAttribute("totalEvents", apiResponse.getTotalEvents());
            request.setAttribute("totalGroups", apiResponse.getTotalGroups());
            
            request.setAttribute("recapDataJson", apiResponse.getRecapDataJson());

            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memoryrecap.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memory recaps: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memoryrecap.jsp").forward(request, response);
        }
    }
}
