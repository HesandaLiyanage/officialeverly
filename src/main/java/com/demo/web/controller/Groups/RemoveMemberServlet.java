package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.model.Group;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class RemoveMemberServlet extends HttpServlet {

    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
        groupMemberDAO = new GroupMemberDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer currentUserId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");
        String memberIdStr = request.getParameter("memberId");

        if (groupIdStr == null || groupIdStr.isEmpty() || memberIdStr == null || memberIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Missing parameters");
            return;
        }

        try {
            int groupId = Integer.parseInt(groupIdStr);
            int memberId = Integer.parseInt(memberIdStr);

            Group group = groupDAO.findById(groupId);
            if (group == null) {
                response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
                return;
            }

            // Security Check: Only group creator can remove members
            if (group.getUserId() != currentUserId) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=You do not have permission to remove members");
                return;
            }

            // Prevent admin from removing themselves (optional, but usually desired for groups)
            if (memberId == currentUserId) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=You cannot remove yourself");
                return;
            }

            boolean success = groupMemberDAO.deleteGroupMember(groupId, memberId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&msg=Member removed successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Failed to remove member");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid parameters");
        }
    }
}
