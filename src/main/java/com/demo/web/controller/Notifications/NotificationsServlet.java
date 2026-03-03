package com.demo.web.controller.Notifications;

import com.demo.web.dao.NotificationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/notificationsapi")
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    /**
     * GET: Load notification list page with real data.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> notifications = notificationDAO.getNotifications(userId, 50);
        int unreadCount = notificationDAO.getUnreadCount(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/views/app/notifications.jsp").forward(request, response);
    }

    /**
     * POST: Handle mark-as-read or mark-all-as-read actions (AJAX).
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

        String action = request.getParameter("action");

        if ("markAllRead".equals(action)) {
            boolean success = notificationDAO.markAllAsRead(userId);
            out.write("{\"success\": " + success + "}");
        } else if ("markRead".equals(action)) {
            String notifIdStr = request.getParameter("notificationId");
            if (notifIdStr != null) {
                int notifId = Integer.parseInt(notifIdStr);
                boolean success = notificationDAO.markAsRead(notifId, userId);
                out.write("{\"success\": " + success + "}");
            } else {
                response.setStatus(400);
                out.write("{\"success\": false, \"error\": \"Missing notificationId\"}");
            }
        } else if ("delete".equals(action)) {
            String notifIdStr = request.getParameter("notificationId");
            if (notifIdStr != null) {
                int notifId = Integer.parseInt(notifIdStr);
                boolean success = notificationDAO.deleteNotification(notifId, userId);
                out.write("{\"success\": " + success + "}");
            } else {
                response.setStatus(400);
                out.write("{\"success\": false, \"error\": \"Missing notificationId\"}");
            }
        } else {
            response.setStatus(400);
            out.write("{\"success\": false, \"error\": \"Unknown action\"}");
        }
    }
}
