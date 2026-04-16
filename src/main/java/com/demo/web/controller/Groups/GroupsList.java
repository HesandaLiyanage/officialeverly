package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.*;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class GroupsList extends HttpServlet {

    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        super.init();
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
        String action = request.getParameter("action");
        String groupIdParam = request.getParameter("groupId");

        if ("memories".equals(action) && groupIdParam != null) {
            GroupsListMemoriesRequest apiRequest = new GroupsListMemoriesRequest(userId, groupIdParam);
            GroupsListMemoriesResponse apiResponse = groupService.getGroupMemories(apiRequest);

            if (apiResponse.getRedirectUrl() != null) {
                response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
                return;
            }

            if (apiResponse.getCoverImageUrls() != null) {
                apiResponse.getCoverImageUrls().forEach((memId, rawPath) ->
                        request.setAttribute("cover_" + memId, request.getContextPath() + rawPath));
            }

            request.setAttribute("group", apiResponse.getGroup());
            request.setAttribute("groupId", apiResponse.getGroupId());
            request.setAttribute("groupName", apiResponse.getGroupName());
            request.setAttribute("memories", apiResponse.getMemories());
            request.setAttribute("isAdmin", apiResponse.isAdmin());
            request.setAttribute("isMember", apiResponse.isMember());
            request.setAttribute("currentUserRole", apiResponse.getCurrentUserRole());
            request.setAttribute("currentUserId", apiResponse.getCurrentUserId());
            request.setAttribute("canCreate", apiResponse.isCanCreate());

            request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupmemories.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action) && groupIdParam != null) {
            GroupsListEditRequest apiRequest = new GroupsListEditRequest(userId, groupIdParam);
            GroupsListEditResponse apiResponse = groupService.getGroupForEditDisplay(apiRequest);

            if (apiResponse.getRedirectUrl() != null) {
                response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
                return;
            }

            request.setAttribute("group", apiResponse.getGroup());
            request.getRequestDispatcher("/WEB-INF/views/app/Groups/editgroup.jsp").forward(request, response);
            return;
        }

        GroupsListRequest apiRequest = new GroupsListRequest(userId);
        GroupsListResponse apiResponse = groupService.listGroups(apiRequest);

        if (apiResponse.getErrorMessage() != null) {
            request.setAttribute("error", apiResponse.getErrorMessage());
        }

        request.setAttribute("groups", apiResponse.getGroups());
        request.setAttribute("groupDisplayData", apiResponse.getGroupDisplayData());
        request.setAttribute("announcementDisplayData", apiResponse.getAnnouncementDisplayData());
        request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupdashboard.jsp").forward(request, response);
    }
}
