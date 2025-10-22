package com.demo.web.controller;

import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.UserSession;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class LinkedDevicesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private userSessionDAO userSessionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userSessionDAO = new userSessionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");
        String currentSessionId = session.getId();

        // Get all active sessions for this user
        List<UserSession> devices = userSessionDAO.getUserSessions(userId);
        System.out.println("=== LinkedDevicesServlet DEBUG ===");
        System.out.println("Found " + devices.size() + " active sessions for user ID: " + userId);
        // Mark current device
        for (UserSession device : devices) {
            if (device.getSessionId().equals(currentSessionId)) {
                device.setDeviceName(device.getDeviceName() + " (This device)");
                System.out.println("Session ID: " + device.getSessionId() + ", Device Name: " + device.getDeviceName() + ", Active: " + device.isActive());

            }
        }

        // Pass devices to JSP
        request.setAttribute("devices", devices);
        request.setAttribute("currentSessionId", currentSessionId);

        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/settings/linkeddevices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        Integer userId = (Integer) session.getAttribute("user_id");
        String currentSessionId = session.getId();

        if ("removeDevice".equals(action)) {
            // Remove specific device
            String sessionIdToRemove = request.getParameter("sessionId");

            if (sessionIdToRemove != null && !sessionIdToRemove.equals(currentSessionId)) {
                boolean removed = SessionUtil.revokeSessionById(sessionIdToRemove);

                if (removed) {
                    request.setAttribute("success", "Device removed successfully");
                } else {
                    request.setAttribute("error", "Failed to remove device");
                }
            } else {
                request.setAttribute("error", "Cannot remove current device");
            }

        } else if ("logoutAll".equals(action)) {
            // Logout from all devices except current
            int removedCount = userSessionDAO.revokeAllSessionsExcept(userId, currentSessionId);
            request.setAttribute("success", "Logged out from " + removedCount + " device(s)");
        }

        // Redirect back to GET
        response.sendRedirect(request.getContextPath() + "/linkeddevices");
    }
}