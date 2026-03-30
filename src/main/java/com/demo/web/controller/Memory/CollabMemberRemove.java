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

public class CollabMemberRemove extends HttpServlet {

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
        String memberIdParam = request.getParameter("memberId");

        if (memoryIdParam == null || memberIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID and Member ID required\"}");
            return;
        }

        try {
            CollabActionRequest removeRequest = new CollabActionRequest();
            removeRequest.setAction("REMOVE");
            removeRequest.setRequesterId((Integer) session.getAttribute("user_id"));
            removeRequest.setMemoryId(Integer.parseInt(memoryIdParam));
            removeRequest.setTargetUserId(Integer.parseInt(memberIdParam));

            CollabActionResponse removeResponse = memoryService.processCollabAction(removeRequest);

            if (removeResponse.isSuccess()) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(removeResponse.getStatusCode());
                response.getWriter().write("{\"error\": \"" + removeResponse.getErrorMessage() + "\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
