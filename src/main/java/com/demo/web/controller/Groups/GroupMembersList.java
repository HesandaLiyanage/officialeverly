package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupMembersListRequest;
import com.demo.web.dto.Groups.GroupMembersListResponse;
import com.demo.web.dto.Groups.GroupMemberActionRequest;
import com.demo.web.dto.Groups.GroupMemberActionResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupMembersList extends HttpServlet {

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

        Integer userId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        String msg = request.getParameter("msg");
        String error = request.getParameter("error");

        GroupMembersListRequest req = new GroupMembersListRequest(userId, groupIdStr, msg, error);
        GroupMembersListResponse res = groupService.listGroupMembers(req);

        if (res.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            return;
        }

        request.setAttribute("group", res.getGroup());
        request.setAttribute("members", res.getMembers());
        request.setAttribute("isAdmin", res.isAdmin());
        request.setAttribute("isMember", res.isMember());
        request.setAttribute("currentUserId", res.getCurrentUserId());
        request.setAttribute("currentUserRole", res.getCurrentUserRole());

        request.setAttribute("groupName", res.getGroupName());
        request.setAttribute("groupId", res.getGroupId());
        request.setAttribute("memberDisplayData", res.getMemberDisplayData());

        if (res.getSuccessMessage() != null) {
            request.setAttribute("successMessage", res.getSuccessMessage());
        }
        if (res.getErrorMessage() != null) {
            request.setAttribute("errorMessage", res.getErrorMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupmembers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        String groupIdStr = request.getParameter("groupId");
        String memberIdStr = request.getParameter("memberId");
        String newRole = request.getParameter("role");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        GroupMemberActionRequest req = new GroupMemberActionRequest(userId, action, groupIdStr, memberIdStr, newRole);
        GroupMemberActionResponse res = groupService.executeGroupMemberAction(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
