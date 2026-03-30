package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupInviteJoinRequest;
import com.demo.web.dto.Groups.GroupInviteJoinResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupInviteJoin extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        groupService = new GroupService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("user_id");

        GroupInviteJoinRequest req = new GroupInviteJoinRequest(request.getPathInfo(), userId);
        GroupInviteJoinResponse res = groupService.joinGroupInvite(req);

        if (res.getPendingInviteToken() != null) {
            session.setAttribute("pendingInviteToken", res.getPendingInviteToken());
        }

        if (res.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
        }
    }
}
