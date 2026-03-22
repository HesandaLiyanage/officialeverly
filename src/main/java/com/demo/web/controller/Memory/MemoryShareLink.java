package com.demo.web.controller.Memory;

import com.demo.web.dto.Memory.MemoryShareLinkRequest;
import com.demo.web.dto.Memory.MemoryShareLinkResponse;
import com.demo.web.service.MemoryService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class MemoryShareLink extends HttpServlet {

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
            MemoryShareLinkRequest shareRequest = new MemoryShareLinkRequest();
            shareRequest.setMemoryId(Integer.parseInt(memoryIdParam));
            shareRequest.setUserId((Integer) session.getAttribute("user_id"));

            MemoryShareLinkResponse shareResponse = memoryService.handleShareLink(shareRequest);

            if (!shareResponse.isSuccess()) {
                response.setStatus(shareResponse.getStatusCode());
                response.getWriter().write("{\"error\": \"" + shareResponse.getErrorMessage() + "\"}");
                return;
            }

            // Build share URL
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            String shareUrl = baseUrl + request.getContextPath() + "/memoryinvite?key=" + shareResponse.getShareLink();

            try (PrintWriter out = response.getWriter()) {
                out.write(String.format(
                        "{\"success\": true, \"shareKey\": \"%s\", \"shareUrl\": \"%s\"}",
                        shareResponse.getShareLink(), shareUrl));
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
