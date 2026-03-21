package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryUpdateRequest;
import com.demo.web.dto.Memory.MemoryUpdateResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet for updating memory details including adding/removing media
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB per file
        maxRequestSize = 1024 * 1024 * 100 // 100MB total request
)
public class MemoryUpdate extends HttpServlet {

    private MemoryService memoryService;

    @Override
    public void init() throws ServletException {
        memoryService = new MemoryService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");

        try {
            String memoryIdParam = request.getParameter("memoryId");
            if (memoryIdParam == null || memoryIdParam.isEmpty()) {
                response.sendRedirect("/memories");
                return;
            }

            MemoryUpdateRequest updateRequest = new MemoryUpdateRequest();
            updateRequest.setMemoryId(Integer.parseInt(memoryIdParam));
            updateRequest.setUserId(userId);
            updateRequest.setTitle(request.getParameter("memoryName"));
            updateRequest.setDescription(request.getParameter("memoryDescription"));
            updateRequest.setRemovedMediaIds(request.getParameterValues("removedFileIds[]"));
            updateRequest.setNewMediaFiles(request.getParts());

            MemoryUpdateResponse updateResponse = memoryService.updateMemory(updateRequest);

            if (!updateResponse.isSuccess()) {
                request.setAttribute("errorMessage", updateResponse.getErrorMessage());
                response.sendRedirect("/memories");
                return;
            }

            // Redirect back to the view
            response.sendRedirect("/memoryview?id=" + updateRequest.getMemoryId());

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating memory: " + e.getMessage());
            response.sendRedirect("/memories");
        }
    }
}
