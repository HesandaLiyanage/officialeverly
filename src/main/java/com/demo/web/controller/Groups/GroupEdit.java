package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupEditRequest;
import com.demo.web.dto.Groups.GroupEditResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class GroupEdit extends HttpServlet {

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
            GroupEditRequest apiRequest = new GroupEditRequest();
            apiRequest.setUserId((Integer) session.getAttribute("user_id"));
            apiRequest.setGroupIdStr(request.getParameter("groupId"));
            apiRequest.setGroupName(request.getParameter("g_name"));
            apiRequest.setGroupDescription(request.getParameter("g_description"));
            apiRequest.setCustomLink(request.getParameter("customLink"));
            apiRequest.setFilePart(request.getPart("group_pic"));
            apiRequest.setContextPath(request.getContextPath());
            apiRequest.setApplicationPath(request.getServletContext().getRealPath(""));

            GroupEditResponse apiResponse = groupService.editGroup(apiRequest);

            if (apiResponse.isSuccess()) {
                response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
            } else if (apiResponse.getGroup() != null) {
                request.setAttribute("error", apiResponse.getErrorMessage());
                request.setAttribute("group", apiResponse.getGroup());
                request.getRequestDispatcher("/WEB-INF/views/app/Groups/editgroup.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + apiResponse.getRedirectUrl());
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating the group");
            response.sendRedirect(request.getContextPath() + "/groups");
        }
    }
}