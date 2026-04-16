package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupAnnouncementCreateRequest;
import com.demo.web.dto.Groups.GroupAnnouncementCreateResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupAnnouncementCreate extends HttpServlet {

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

        String groupIdStr = request.getParameter("groupId");
        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        request.setAttribute("groupId", groupIdStr);
        request.getRequestDispatcher("/WEB-INF/views/app/Groups/createannouncement.jsp").forward(request, response);
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


        GroupAnnouncementCreateRequest req = new GroupAnnouncementCreateRequest(userId, groupIdStr, title, content);
        GroupAnnouncementCreateResponse res = groupService.createGroupAnnouncement(req);

        if (res.isSuccess()) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
        } else if (res.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
        } else {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.setAttribute("groupId", res.getGroupId());
            request.getRequestDispatcher("/WEB-INF/views/app/Groups/createannouncement.jsp").forward(request, response);
        }
    }
}
