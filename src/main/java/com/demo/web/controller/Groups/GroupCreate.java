package com.demo.web.controller.Groups;

import com.demo.web.dto.Groups.GroupCreateRequest;
import com.demo.web.dto.Groups.GroupCreateResponse;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class GroupCreate extends HttpServlet {

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
        request.getRequestDispatcher("/creategroup").forward(request, response);
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

        try {
            GroupCreateRequest apiRequest = new GroupCreateRequest();
            apiRequest.setUserId(userId);
            apiRequest.setGroupName(request.getParameter("g_name"));
            apiRequest.setGroupDescription(request.getParameter("g_description"));
            apiRequest.setCustomLink(request.getParameter("customLink"));
            apiRequest.setFilePart(request.getPart("group_pic"));
            apiRequest.setApplicationPath(request.getServletContext().getRealPath(""));
            apiRequest.setContextPath(request.getContextPath());

            GroupCreateResponse apiResponse = groupService.createGroup(apiRequest);

            if (apiResponse.isSuccess()) {
                session.setAttribute("successMessage", apiResponse.getSuccessMessage());
                response.sendRedirect(request.getContextPath() + "/groups");
            } else {
                request.setAttribute("error", apiResponse.getErrorMessage());
                request.setAttribute("g_name", apiRequest.getGroupName());
                request.setAttribute("g_description", apiRequest.getGroupDescription());
                request.setAttribute("customLink", apiRequest.getCustomLink());
                request.getRequestDispatcher("/creategroup").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while creating the group: " + e.getMessage());
            request.getRequestDispatcher("/creategroup").forward(request, response);
        }
    }
}