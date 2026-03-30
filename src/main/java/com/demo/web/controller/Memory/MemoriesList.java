package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoriesListRequest;
import com.demo.web.dto.Memory.MemoriesListResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemoriesList extends HttpServlet {

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
            MemoriesListRequest listRequest = new MemoriesListRequest();
            listRequest.setUserId((Integer) session.getAttribute("user_id"));

            MemoriesListResponse listResponse = memoryService.getMemoriesList(listRequest);

            if (!listResponse.isSuccess()) {
                request.setAttribute("errorMessage", listResponse.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Memory/memories.jsp").forward(request, response);
                return;
            }

            // Bind all the response items to the request for the JSP
            request.setAttribute("showStorageWarning", listResponse.isShowStorageWarning());
            request.setAttribute("storageFull", listResponse.isStorageFull());
            request.setAttribute("memories", listResponse.getMemories());

            // Build out the dynamic map of cover images for the JSP (request scope)
            if (listResponse.getCoverImages() != null) {
                listResponse.getCoverImages().forEach((memoryId, rawPath) -> {
                    request.setAttribute("cover_" + memoryId, request.getContextPath() + rawPath);
                });
            }

            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading memories: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/memories.jsp").forward(request, response);
        }
    }
}