package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.dao.memoryDAO;
import com.demo.web.model.Group;
import com.demo.web.model.MediaItem;
import com.demo.web.model.Memory;
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
    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;
    private memoryDAO memoryDao;
    private MediaDAO mediaDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        groupService = new GroupService();
        groupDAO = new GroupDAO();
        groupMemberDAO = new GroupMemberDAO();
        memoryDao = new memoryDAO();
        mediaDAO = new MediaDAO();
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
     * Only group members (admin + members) can access.
     */
    private void handleGroupMemories(HttpServletRequest request, HttpServletResponse response,
            int userId, String groupIdParam) throws ServletException, IOException {
        try {
            int groupId = Integer.parseInt(groupIdParam);
            Group groupDetail = groupDAO.findById(groupId);

            if (groupDetail == null) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            // Authorization: only admin or members can access group memories
            boolean isAdmin = (groupDetail.getUserId() == userId);
            boolean isMember = groupMemberDAO.isUserMember(groupId, userId);

            if (!isAdmin && !isMember) {
                System.out.println("[SECURITY] User " + userId + " attempted to access memories of group " + groupId
                        + " without permission");
                response.sendRedirect(request.getContextPath() + "/groups?error=Access denied");
                return;
            }

            // Get user's role in the group
            String userRole;
            if (isAdmin) {
                userRole = "admin";
            } else {
                userRole = groupMemberDAO.getMemberRole(groupId, userId);
            }

            // Fetch real memories for this group
            List<Memory> memories = memoryDao.getMemoriesByGroupId(groupId);

            // For each memory, get the first media item as cover image
            for (Memory memory : memories) {
                try {
                    List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());
                    if (!mediaItems.isEmpty()) {
                        MediaItem coverMedia = mediaItems.get(0);
                        request.setAttribute("cover_" + memory.getMemoryId(),
                                request.getContextPath() + "/viewMedia?mediaId=" + coverMedia.getMediaId());
                    }
                } catch (Exception e) {
                    System.err.println(
                            "Error getting media for group memory " + memory.getMemoryId() + ": " + e.getMessage());
                }
            }

            request.setAttribute("group", groupDetail);
            request.setAttribute("groupId", groupId);
            request.setAttribute("memories", memories);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("isMember", isMember);
            request.setAttribute("currentUserRole", userRole);
            request.setAttribute("currentUserId", userId);

            request.getRequestDispatcher("/views/app/groupmemories.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/groups?error=Error loading memories");
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
