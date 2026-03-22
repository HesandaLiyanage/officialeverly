package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupProfileViewRequest;
import com.demo.web.dto.Groups.GroupProfileViewResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupProfileView extends HttpServlet {

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

        try {
            GroupProfileViewRequest apiRequest = new GroupProfileViewRequest();
            apiRequest.setCurrentUserId((Integer) session.getAttribute("user_id"));
            apiRequest.setGroupIdStr(request.getParameter("groupId"));
            apiRequest.setMemberIdStr(request.getParameter("memberId"));

            if (apiRequest.getGroupIdStr() == null || apiRequest.getGroupIdStr().isEmpty() ||
                apiRequest.getMemberIdStr() == null || apiRequest.getMemberIdStr().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            GroupProfileViewResponse apiResponse = groupService.viewGroupProfile(apiRequest);

            if (!apiResponse.isSuccess()) {
                response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
                return;
            }

            request.setAttribute("group", apiResponse.getGroup());
            request.setAttribute("member", apiResponse.getMember());
            request.setAttribute("isAdmin", apiResponse.isAdmin());
            request.setAttribute("currentUserId", apiResponse.getCurrentUserId());
            request.setAttribute("groupId", apiResponse.getGroupId());
            request.setAttribute("groupName", apiResponse.getGroupName());
            request.setAttribute("creatorText", apiResponse.getCreatorText());
            request.setAttribute("memberName", apiResponse.getMemberName());
            request.setAttribute("memberEmail", apiResponse.getMemberEmail());
            request.setAttribute("memberRole", apiResponse.getMemberRole());
            request.setAttribute("initials", apiResponse.getInitials());
            request.setAttribute("joinedDate", apiResponse.getJoinedDate());
            request.setAttribute("canRemove", apiResponse.isCanRemove());
            request.setAttribute("memberId", apiResponse.getMemberId());
            request.setAttribute("isRoleViewer", apiResponse.isRoleViewer());
            request.setAttribute("isRoleMember", apiResponse.isRoleMember());
            request.setAttribute("isRoleAdmin", apiResponse.isRoleAdmin());

            request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupprofile.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid parameters");
        }
    }
}

