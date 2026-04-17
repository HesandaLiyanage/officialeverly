package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryDeleteRequest;
import com.demo.web.dto.Memory.MemoryDeleteResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for deleting a memory and its associated media
 */
public class MemoryDelete extends HttpServlet {

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

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("/memories");
            return;
        }

        try {
            int memoryId = Integer.parseInt(idParam);
            int userId = (int) session.getAttribute("user_id");

            MemoryDeleteRequest deleteRequest = new MemoryDeleteRequest();
            deleteRequest.setMemoryId(memoryId);
            deleteRequest.setUserId(userId);
            deleteRequest.setApplicationPath(request.getServletContext().getRealPath(""));

            MemoryDeleteResponse deleteResponse = memoryService.deleteMemory(deleteRequest);

            if (!deleteResponse.isSuccess()) {
                response.sendRedirect("/memories");
                return;
            }

            // Redirect back exactly to where it came from
            if (deleteResponse.getGroupId() != null) {
                response.sendRedirect("/groupmemories?groupId=" + deleteResponse.getGroupId());
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
