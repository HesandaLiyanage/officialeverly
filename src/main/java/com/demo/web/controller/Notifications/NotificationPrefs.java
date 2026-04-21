package com.demo.web.controller.Notifications;

import com.demo.web.dto.Notifications.NotificationPrefsPostRequest;
import com.demo.web.dto.Notifications.NotificationPrefsPostResponse;
import com.demo.web.service.NotificationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/notificationprefsapi")
public class NotificationPrefs extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        super.init();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/settingsaccount");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        String notifType = request.getParameter("notifType");
        String enabledStr = request.getParameter("enabled");

        NotificationPrefsPostRequest req = new NotificationPrefsPostRequest(userId, notifType, enabledStr);
        NotificationPrefsPostResponse res = notificationService.updatePreference(req);

        if (!res.isSuccess() && res.getStatusCode() != 0) {
            response.setStatus(res.getStatusCode());
            if (res.getErrorMessage() != null) {
                out.write("{\"success\": false, \"error\": \"" + res.getErrorMessage() + "\"}");
                return;
            }
        }

        out.write("{\"success\": " + res.isSuccess() + "}");
    }
}
