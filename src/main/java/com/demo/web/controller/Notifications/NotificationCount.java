package com.demo.web.controller.Notifications;

import com.demo.web.dto.Notifications.NotificationCountRequest;
import com.demo.web.dto.Notifications.NotificationCountResponse;
import com.demo.web.service.NotificationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/notifications/unreadcount")
public class NotificationCount extends HttpServlet {

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        super.init();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        
        NotificationCountRequest req = new NotificationCountRequest(userId);
        NotificationCountResponse res = notificationService.getUnreadCount(req);

        out.write("{\"count\": " + res.getCount() + "}");
    }
}
