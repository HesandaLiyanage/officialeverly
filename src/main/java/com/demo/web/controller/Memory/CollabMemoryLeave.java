package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.CollabActionRequest;
import com.demo.web.dto.Memory.CollabActionResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CollabMemoryLeave extends HttpServlet {

    private MemoryService memoryService;

    @Override
    public void init() throws ServletException {
        memoryService = new MemoryService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        String memoryIdParam = request.getParameter("memoryId");

        if (memoryIdParam == null || memoryIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID required\"}");
            return;
        }

        try {
            CollabActionRequest leaveRequest = new CollabActionRequest();
            leaveRequest.setAction("LEAVE");
            leaveRequest.setRequesterId((Integer) session.getAttribute("user_id"));
            leaveRequest.setMemoryId(Integer.parseInt(memoryIdParam));

            CollabActionResponse leaveResponse = memoryService.processCollabAction(leaveRequest);

            if (leaveResponse.isSuccess()) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(leaveResponse.getStatusCode());
                response.getWriter().write("{\"error\": \"" + leaveResponse.getErrorMessage() + "\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid memory ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
