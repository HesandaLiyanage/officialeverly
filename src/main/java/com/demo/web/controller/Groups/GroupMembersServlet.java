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

        // Check if user is logged in
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

            // Get group info
            Group group = groupDAO.findById(groupId);
            if (group == null) {
                response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
                return;
            }

            // Get group members
            List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);

            // Check if current user is admin
            boolean isAdmin = (group.getUserId() == userId);

            // Check if current user is a member
            boolean isMember = groupMemberDAO.isUserMember(groupId, userId);

            // Authorization check
            if (!isAdmin && !isMember) {
                System.out.println("[SECURITY] User " + userId + " attempted to access members of group " + groupId + " without permission");
                response.sendRedirect(request.getContextPath() + "/groups?error=Access denied");
                return;
            }

            // Set attributes for JSP
            request.setAttribute("group", group);
            request.setAttribute("members", members);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("isMember", isMember);
            request.setAttribute("currentUserId", userId);
            
            // Pass any success/error messages
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
}
