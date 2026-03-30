package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.CollabMemoriesListRequest;
import com.demo.web.dto.Memory.CollabMemoriesListResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CollabMemoriesList extends HttpServlet {

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
            CollabMemoriesListRequest apiRequest = new CollabMemoriesListRequest();
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));
            apiRequest.setContextPath(request.getContextPath());

            CollabMemoriesListResponse apiResponse = memoryService.getCollabMemoriesList(apiRequest);

            request.setAttribute("memories", apiResponse.getMemories());
            
            // set individually attributes according to map
            if(apiResponse.getCoverImageUrls() != null) {
               for(java.util.Map.Entry<Integer, String> entry : apiResponse.getCoverImageUrls().entrySet()) {
                   request.setAttribute("cover_" + entry.getKey(), entry.getValue());
               }
            }
            if(apiResponse.getMemberCounts() != null) {
               for(java.util.Map.Entry<Integer, Integer> entry : apiResponse.getMemberCounts().entrySet()) {
                   request.setAttribute("memberCount_" + entry.getKey(), entry.getValue());
               }
            }
            if(apiResponse.getIsOwnerMap() != null) {
               for(java.util.Map.Entry<Integer, Boolean> entry : apiResponse.getIsOwnerMap().entrySet()) {
                   request.setAttribute("isOwner_" + entry.getKey(), entry.getValue());
               }
            }

            request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading collab memories: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);
        }
    }
}
