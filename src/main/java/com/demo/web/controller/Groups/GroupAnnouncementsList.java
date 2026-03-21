package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupAnnouncementsListRequest;
import com.demo.web.dto.Groups.GroupAnnouncementsListResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupAnnouncementsList extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        groupService = new GroupService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        GroupAnnouncementsListRequest req = new GroupAnnouncementsListRequest(userId, groupIdStr);
        GroupAnnouncementsListResponse res = groupService.listGroupAnnouncements(req);

        if (!res.isSuccess()) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            return;
        }

        request.setAttribute("group", res.getGroup());
        request.setAttribute("groupId", res.getGroupId());
        request.setAttribute("groupName", res.getGroupName());
        request.setAttribute("groupDescription", res.getGroupDescription());
        request.setAttribute("announcements", res.getAnnouncements());
        request.setAttribute("announcementDisplayData", res.getAnnouncementDisplayData());

        request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupannouncement.jsp").forward(request, response);
    }
}

