package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupAnnouncementDAO;
import com.demo.web.model.Group;
import com.demo.web.model.GroupAnnouncement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class GroupAnnouncementServlet extends HttpServlet {

    private GroupDAO groupDAO;
    private GroupAnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
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

        try {
            int groupId = Integer.parseInt(groupIdStr);
            Group group = groupDAO.findById(groupId);
            
            if (group == null) {
                response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
                return;
            }

            List<GroupAnnouncement> announcements = announcementDAO.findByGroupId(groupId);

            request.setAttribute("group", group);
            request.setAttribute("announcements", announcements);
            
            request.getRequestDispatcher("/views/app/groupannouncement.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid group ID");
        }
    }
}
