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
import java.net.URLEncoder;

public class CollabMemoryJoin extends HttpServlet {

    private MemoryService memoryService;

    @Override
    public void init() throws ServletException {
        memoryService = new MemoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String shareKey = request.getParameter("key");

        if (shareKey == null || shareKey.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invite link");
            return;
        }

        HttpSession session = request.getSession(false);

        // If not logged in, redirect to login with return URL
        if (session == null || session.getAttribute("user_id") == null) {
            String returnUrl = request.getRequestURI() + "?key=" + URLEncoder.encode(shareKey, "UTF-8");
            response.sendRedirect(
                    request.getContextPath() + "/login?redirect=" + URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            CollabActionRequest joinRequest = new CollabActionRequest();
            joinRequest.setAction("JOIN");
            joinRequest.setRequesterId(userId);
            joinRequest.setShareKey(shareKey);

            CollabActionResponse joinResponse = memoryService.processCollabAction(joinRequest);

            if (!joinResponse.isSuccess()) {
                request.setAttribute("errorMessage", joinResponse.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);
                return;
            }

            // Redirect to the collab memory view using targetMemoryId
            response.sendRedirect(request.getContextPath() + "/collabmemoryview?id=" + joinResponse.getTargetMemoryId());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error joining memory: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Memory/collabmemories.jsp").forward(request, response);
        }
    }
}
