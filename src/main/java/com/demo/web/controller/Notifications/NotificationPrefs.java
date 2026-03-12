package com.demo.web.controller.Notifications;

import com.demo.web.dao.Notifications.NotificationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/notificationprefsapi")
public class NotificationPrefs extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * GET: Return the notification preferences page with current settings.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Boolean> prefs = notificationDAO.getPreferences(userId);
        request.setAttribute("notifPrefs", prefs);
        request.getRequestDispatcher("/WEB-INF/views/app/Settings/settingsnotifications.jsp").forward(request, response);
    }

    /**
     * POST: Toggle a specific notification preference on/off (AJAX).
     * Expects: notifType (string), enabled (boolean)
     * Returns: JSON response.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.setStatus(401);
            out.write("{\"success\": false, \"error\": \"Not authenticated\"}");
            return;
        }

        String notifType = request.getParameter("notifType");
        String enabledStr = request.getParameter("enabled");

        if (notifType == null || enabledStr == null) {
            response.setStatus(400);
            out.write("{\"success\": false, \"error\": \"Missing parameters\"}");
            return;
        }

        boolean enabled = Boolean.parseBoolean(enabledStr);
        boolean success = notificationDAO.updatePreference(userId, notifType, enabled);

        out.write("{\"success\": " + success + "}");
    }
}
