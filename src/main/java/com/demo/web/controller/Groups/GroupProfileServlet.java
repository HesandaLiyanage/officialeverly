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

public class GroupProfileServlet extends HttpServlet {

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

        Integer currentUserId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");
        String memberIdStr = request.getParameter("memberId");

        if (groupIdStr == null || groupIdStr.isEmpty() || memberIdStr == null || memberIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
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

            // Get specific member info from the group
            GroupMember targetMember = null;
            for (GroupMember gm : groupMemberDAO.getMembersByGroupId(groupId)) {
                if (gm.getUser().getId() == memberId) {
                    targetMember = gm;
                    break;
                }
            }

            if (targetMember == null) {
                response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&error=Member not found");
                return;
            }

            // Check if current user is admin of this group
            boolean isAdmin = (group.getUserId() == currentUserId);

            request.setAttribute("group", group);
            request.setAttribute("member", targetMember);
            request.setAttribute("isAdmin", isAdmin);
            request.setAttribute("currentUserId", currentUserId);

            request.getRequestDispatcher("/views/app/groupprofile.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid parameters");
        }
    }
}
