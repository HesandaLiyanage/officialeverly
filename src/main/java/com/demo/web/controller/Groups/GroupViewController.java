package com.demo.web.controller.Groups;

import com.demo.web.model.Group;
import com.demo.web.service.AuthService;
import com.demo.web.service.GroupService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * View controller for group pages.
 * Handles GET requests for listing, viewing, and editing groups.
 */
public class GroupViewController extends HttpServlet {

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

        // Validate session
        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String action = request.getParameter("action");
        String groupIdParam = request.getParameter("groupId");

        // Determine the action
        if ("memories".equals(action) && groupIdParam != null) {
            handleGroupMemories(request, response, userId, groupIdParam);
        } else if ("edit".equals(action) && groupIdParam != null) {
            handleEditGroup(request, response, userId, groupIdParam);
        } else {
            handleListGroups(request, response, userId);
        }
    }

    /**
     * Handles listing all groups for the user.
     */
    private void handleListGroups(HttpServletRequest request, HttpServletResponse response,
            int userId) throws ServletException, IOException {
        List<Group> groups = groupService.getGroupsByUserId(userId);

        request.setAttribute("groups", groups);
        // Pass DAO for legacy JSP compatibility (member count queries)
        request.setAttribute("groupDAO", groupService.getGroupDAO());

        request.getRequestDispatcher("/views/app/groupdashboard.jsp").forward(request, response);
    }

    /**
     * Handles viewing a group's memories.
     */
    private void handleGroupMemories(HttpServletRequest request, HttpServletResponse response,
            int userId, String groupIdParam) throws ServletException, IOException {
        try {
            int groupId = Integer.parseInt(groupIdParam);
            Group groupDetail = groupService.getGroupById(groupId, userId);

            if (groupDetail == null) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            request.setAttribute("group", groupDetail);
            request.setAttribute("groupId", groupId);
            request.getRequestDispatcher("/views/app/groupmemories.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups");
        }
    }

    /**
     * Handles editing a group (display the edit form).
     */
    private void handleEditGroup(HttpServletRequest request, HttpServletResponse response,
            int userId, String groupIdParam) throws ServletException, IOException {
        try {
            int groupId = Integer.parseInt(groupIdParam);
            Group groupToEdit = groupService.getGroupById(groupId, userId);

            if (groupToEdit == null) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            request.setAttribute("group", groupToEdit);
            request.getRequestDispatcher("/views/app/editgroup.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups");
        }
    }
}
