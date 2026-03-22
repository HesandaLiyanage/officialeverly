package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.*;
import com.demo.web.service.AuthService;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class GroupsList extends HttpServlet {

    private AuthService authService;
    private GroupService groupService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        groupService = new GroupService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String action = request.getParameter("action");
        String groupIdParam = request.getParameter("groupId");

        if ("memories".equals(action) && groupIdParam != null) {
            handleGroupMemories(request, response, userId, groupIdParam);
        } else if ("edit".equals(action) && groupIdParam != null) {
            handleEditGroup(request, response, userId, groupIdParam);
        } else {
            handleListGroups(request, response, userId);
        }
    }

    private void handleListGroups(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        GroupsListRequest apiRequest = new GroupsListRequest();
        apiRequest.setUserId(userId);
        
        GroupsListResponse apiResponse = groupService.listGroups(apiRequest);

        if (apiResponse.getErrorMessage() != null) {
            request.setAttribute("error", apiResponse.getErrorMessage());
        }

        request.setAttribute("groups", apiResponse.getGroups());
        request.setAttribute("groupDisplayData", apiResponse.getGroupDisplayData());
        request.setAttribute("announcementDisplayData", apiResponse.getAnnouncementDisplayData());

        request.getRequestDispatcher("/WEB-INF/views/app/Groups/groupdashboard.jsp").forward(request, response);
    }

    private void handleGroupMemories(HttpServletRequest request, HttpServletResponse response, int userId, String groupIdParam) throws ServletException, IOException {
        GroupsListMemoriesRequest apiRequest = new GroupsListMemoriesRequest();
        apiRequest.setUserId(userId);
        apiRequest.setGroupIdParam(groupIdParam);

        GroupsListMemoriesResponse apiResponse = groupService.getGroupMemories(apiRequest);

        if (apiResponse.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
            return;
        }

        if (apiResponse.getCoverImageUrls() != null) {
            apiResponse.getCoverImageUrls().forEach((memId, rawPath) -> {
                request.setAttribute("cover_" + memId, request.getContextPath() + rawPath);
            });
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
    }

    private void handleEditGroup(HttpServletRequest request, HttpServletResponse response, int userId, String groupIdParam) throws ServletException, IOException {
        GroupsListEditRequest apiRequest = new GroupsListEditRequest();
        apiRequest.setUserId(userId);
        apiRequest.setGroupIdParam(groupIdParam);

        GroupsListEditResponse apiResponse = groupService.getGroupForEditDisplay(apiRequest);

        if (apiResponse.getRedirectUrl() != null) {
            response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
            return;
        }

        request.setAttribute("group", apiResponse.getGroup());
        request.getRequestDispatcher("/WEB-INF/views/app/Groups/editgroup.jsp").forward(request, response);
    }
}
