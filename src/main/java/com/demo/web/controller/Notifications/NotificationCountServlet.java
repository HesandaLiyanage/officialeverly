package com.demo.web.controller.Notifications;

import com.demo.web.dao.NotificationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/notifications/unreadcount")
public class NotificationCountServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            out.write("{\"count\": 0}");
            return;
        }

        int count = notificationDAO.getUnreadCount(userId);
        out.write("{\"count\": " + count + "}");
    }
}
