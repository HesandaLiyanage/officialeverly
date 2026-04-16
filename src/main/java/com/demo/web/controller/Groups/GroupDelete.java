package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupDeleteRequest;
import com.demo.web.dto.Groups.GroupDeleteResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class GroupDelete extends HttpServlet {

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

        try {
            GroupDeleteRequest apiRequest = new GroupDeleteRequest();
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));
            apiRequest.setGroupIdStr(request.getParameter("groupId"));

            if (apiRequest.getGroupIdStr() == null || apiRequest.getGroupIdStr().trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            GroupDeleteResponse apiResponse = groupService.deleteGroup(apiRequest);

            response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/groups?error=delete_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/groups");
    }
}
