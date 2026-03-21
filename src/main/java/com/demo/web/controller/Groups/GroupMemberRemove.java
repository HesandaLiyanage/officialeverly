package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupMemberRemoveRequest;
import com.demo.web.dto.Groups.GroupMemberRemoveResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupMemberRemove extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        groupService = new GroupService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer currentUserId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");
        String memberIdStr = request.getParameter("memberId");

        if (groupIdStr == null || groupIdStr.isEmpty() || memberIdStr == null || memberIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Missing parameters");
            return;
        }

        GroupMemberRemoveRequest req = new GroupMemberRemoveRequest(currentUserId, groupIdStr, memberIdStr);
        GroupMemberRemoveResponse res = groupService.removeGroupMember(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
