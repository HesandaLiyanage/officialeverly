package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupAnnouncementDAO;
import com.demo.web.model.GroupAnnouncement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CreateAnnouncementServlet extends HttpServlet {

    private GroupAnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        announcementDAO = new GroupAnnouncementDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        request.setAttribute("groupId", groupIdStr);
        request.getRequestDispatcher("/views/app/createannouncement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (groupIdStr == null || title == null || content == null || title.isEmpty() || content.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.setAttribute("groupId", groupIdStr);
            request.getRequestDispatcher("/views/app/createannouncement.jsp").forward(request, response);
            return;
        }

        try {
            int groupId = Integer.parseInt(groupIdStr);
            GroupAnnouncement announcement = new GroupAnnouncement(groupId, userId, title, content);
            
            boolean success = announcementDAO.createAnnouncement(announcement);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/groupannouncementservlet?groupId=" + groupId);
            } else {
                request.setAttribute("errorMessage", "Failed to create announcement. Please try again.");
                request.setAttribute("groupId", groupIdStr);
                request.getRequestDispatcher("/views/app/createannouncement.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid group ID");
        }
    }
}
