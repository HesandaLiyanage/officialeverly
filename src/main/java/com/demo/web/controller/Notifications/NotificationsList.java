package com.demo.web.controller.Notifications;

import com.demo.web.dto.Notifications.NotificationsListGetRequest;
import com.demo.web.dto.Notifications.NotificationsListGetResponse;
import com.demo.web.dto.Notifications.NotificationsListPostRequest;
import com.demo.web.dto.Notifications.NotificationsListPostResponse;
import com.demo.web.service.NotificationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/notificationsapi")
public class NotificationsList extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        super.init();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        NotificationsListGetRequest req = new NotificationsListGetRequest(userId);
        NotificationsListGetResponse res = notificationService.getNotifications(req);

        if (res.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            return;
        }

        request.setAttribute("notifications", res.getNotifications());
        request.setAttribute("unreadCount", res.getUnreadCount());
        request.getRequestDispatcher("/WEB-INF/views/app/Notifications/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"error\": \"Not authenticated\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        String notificationIdStr = request.getParameter("notificationId");

        NotificationsListPostRequest req = new NotificationsListPostRequest(userId, action, notificationIdStr);
        NotificationsListPostResponse res = notificationService.handleAction(req);

        if (!res.isSuccess() && res.getStatusCode() != 200) {
            response.setStatus(res.getStatusCode());
            if (res.getErrorMessage() != null) {
                out.write("{\"success\": false, \"error\": \"" + res.getErrorMessage() + "\"}");
                return;
            }
        }

        out.write("{\"success\": " + res.isSuccess() + "}");
    }
}
