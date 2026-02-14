package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.model.Group;
import com.demo.web.model.GroupMember;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class GroupMembersServlet extends HttpServlet {

    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
        groupMemberDAO = new GroupMemberDAO();
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
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        try {
            int groupId = Integer.parseInt(groupIdStr);

            Group group = groupDAO.findById(groupId);
            if (group == null) {
                response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
                return;
            }

            List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);
            boolean isAdmin = (group.getUserId() == userId);
            boolean isMember = groupMemberDAO.isUserMember(groupId, userId);
            String currentUserRole = isAdmin ? "admin" : groupMemberDAO.getMemberRole(groupId, userId);

            if (!isAdmin && !isMember) {
                System.out.println("[SECURITY] User " + userId + " attempted to access members of group " + groupId
                        + " without permission");
                response.sendRedirect(request.getContextPath() + "/groups?error=Access denied");
                return;
            }

            request.setAttribute("group", group);
            request.setAttribute("members", members);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("isMember", isMember);
            request.setAttribute("currentUserId", userId);
            request.setAttribute("currentUserRole", currentUserRole);

            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) {
                request.setAttribute("successMessage", msg);
            }
            if (error != null) {
                request.setAttribute("errorMessage", error);
            }

            request.getRequestDispatcher("/views/app/groupmembers.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid group ID");
        }
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
        String action = request.getParameter("action");
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        int groupId;
        try {
            groupId = Integer.parseInt(groupIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid group ID");
            return;
        }

        Group group = groupDAO.findById(groupId);
        if (group == null) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
            return;
        }

        boolean isAdmin = (group.getUserId() == userId);

        // Handle leaveGroup before admin check — any member can leave
        if ("leaveGroup".equals(action)) {
            if (isAdmin) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Admin cannot leave the group. Delete the group instead.");
                return;
            }
            boolean isMember = groupMemberDAO.isUserMember(groupId, userId);
            if (!isMember) {
                response.sendRedirect(request.getContextPath() + "/groups?error=You are not a member of this group");
                return;
            }
            boolean removed = groupMemberDAO.deleteGroupMember(groupId, userId);
            if (removed) {
                response.sendRedirect(request.getContextPath() + "/groups?msg=You have left the group");
            } else {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Failed to leave group");
            }
            return;
        }

        // All other actions require admin
        if (!isAdmin) {
            response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                    + "&error=Only admin can manage roles");
            return;
        }

        if ("updateRole".equals(action)) {
            handleUpdateRole(request, response, groupId, userId);
        } else if ("removeMember".equals(action)) {
            handleRemoveMember(request, response, groupId, userId);
        } else {
            response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId);
        }
    }

    private void handleUpdateRole(HttpServletRequest request, HttpServletResponse response,
            int groupId, int adminUserId) throws IOException {
        String memberIdStr = request.getParameter("memberId");
        String newRole = request.getParameter("role");

        if (memberIdStr == null || newRole == null) {
            response.sendRedirect(
                    request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Missing parameters");
            return;
        }

        if (!"editor".equals(newRole) && !"viewer".equals(newRole)) {
            response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                    + "&error=Invalid role. Must be editor or viewer");
            return;
        }

        try {
            int memberId = Integer.parseInt(memberIdStr);

            if (memberId == adminUserId) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Cannot change your own role");
                return;
            }

            String currentRole = groupMemberDAO.getMemberRole(groupId, memberId);
            if ("admin".equals(currentRole)) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Cannot change admin role");
                return;
            }

            boolean updated = groupMemberDAO.updateMemberRole(groupId, memberId, newRole);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&msg=Role updated successfully");
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Failed to update role");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Invalid member ID");
        }
    }

    private void handleRemoveMember(HttpServletRequest request, HttpServletResponse response,
            int groupId, int adminUserId) throws IOException {
        String memberIdStr = request.getParameter("memberId");
        if (memberIdStr == null) {
            response.sendRedirect(
                    request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Missing member ID");
            return;
        }

        try {
            int memberId = Integer.parseInt(memberIdStr);
            if (memberId == adminUserId) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Cannot remove yourself");
                return;
            }

            boolean removed = groupMemberDAO.deleteGroupMember(groupId, memberId);
            if (removed) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&msg=Member removed successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId
                        + "&error=Failed to remove member");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Invalid member ID");
        }
    }
}
