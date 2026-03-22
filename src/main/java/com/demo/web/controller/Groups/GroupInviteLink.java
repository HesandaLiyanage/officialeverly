package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupInviteLinkRequest;
import com.demo.web.dto.Groups.GroupInviteLinkResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class GroupInviteLink extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        groupService = new GroupService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Group ID required\"}");
            return;
        }

        String baseUrl = request.getScheme() + "://" + request.getServerName();
        if (request.getServerPort() != 80 && request.getServerPort() != 443) {
            baseUrl += ":" + request.getServerPort();
        }
        baseUrl += request.getContextPath();

        GroupInviteLinkRequest req = new GroupInviteLinkRequest(userId, groupIdStr, baseUrl);
        GroupInviteLinkResponse res = groupService.generateGroupInviteLink(req);

        response.setStatus(res.getStatusCode());
        out.print(res.getJsonResponse());
    }
}
