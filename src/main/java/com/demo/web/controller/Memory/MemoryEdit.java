package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryEditRequest;
import com.demo.web.dto.Memory.MemoryEditResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class MemoryEdit extends HttpServlet {

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
            MemoryEditRequest apiRequest = new MemoryEditRequest();
            apiRequest.setMemoryId(Integer.parseInt(idParam));
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));

            MemoryEditResponse apiResponse = memoryService.getMemoryForEdit(apiRequest);

            if (apiResponse.getErrorMessage() != null) {
                request.setAttribute("errorMessage", apiResponse.getErrorMessage());
                if (apiResponse.getRedirectGroupId() != null) {
                    response.sendRedirect("/groupmemories?groupId=" + apiResponse.getRedirectGroupId());
                } else {
                    response.sendRedirect("/memories");
                }
                return;
            }

            if (apiResponse.isGroupMemory()) {
                request.setAttribute("group", apiResponse.getGroup());
                request.setAttribute("isGroupMemory", true);
            }

            request.setAttribute("memory", apiResponse.getMemory());
            request.setAttribute("mediaItems", apiResponse.getMediaItems());

            request.getRequestDispatcher("/WEB-INF/views/app/Memory/editmemory.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("/memories");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/memories");
        }
    }
}
