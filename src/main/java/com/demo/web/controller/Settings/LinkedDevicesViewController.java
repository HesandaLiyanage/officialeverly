package com.demo.web.controller.Settings;

import com.demo.web.model.UserSession;
import com.demo.web.service.AuthService;
import com.demo.web.service.LinkedDeviceService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * View controller for linked devices page.
 * Handles GET requests to display user's active sessions.
 */
public class LinkedDevicesViewController extends HttpServlet {

    private AuthService authService;
    private LinkedDeviceService linkedDeviceService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        linkedDeviceService = new LinkedDeviceService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String currentSessionId = authService.getSessionId(request);

        System.out.println("=== LinkedDevicesViewController DEBUG ===");

        // Get devices from service
        List<UserSession> devices = linkedDeviceService.getUserDevices(userId, currentSessionId);

        System.out.println("Found " + devices.size() + " active sessions for user ID: " + userId);

        // Set request attributes
        request.setAttribute("devices", devices);
        request.setAttribute("currentSessionId", currentSessionId);

        // Forward to JSP
        request.getRequestDispatcher("/views/app/linkeddevices.jsp").forward(request, response);
    }
}
