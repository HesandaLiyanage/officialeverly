package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupInviteDAO;
import com.demo.web.dao.GroupMemberDAO;
import com.demo.web.model.Group;
import com.demo.web.model.GroupInvite;
import com.demo.web.model.GroupMember;
import com.demo.web.model.user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/invite/*")
public class InviteServlet extends HttpServlet {

    private GroupInviteDAO groupInviteDAO;
    private GroupMemberDAO groupMemberDAO;
    private GroupDAO groupDAO;

    @Override
    public void init() throws ServletException {
        groupInviteDAO = new GroupInviteDAO();
        groupMemberDAO = new GroupMemberDAO();
        groupDAO = new GroupDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Extract token from URL path: /invite/{token}
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid invite link");
            return;
        }

        String token = pathInfo.substring(1); // Remove leading "/"
        System.out.println("[DEBUG InviteServlet] Processing invite token: " + token);

        // Look up the invite
        GroupInvite invite = groupInviteDAO.findByToken(token);
        if (invite == null) {
            System.out.println("[DEBUG InviteServlet] Invite not found or expired for token: " + token);
            response.sendRedirect(request.getContextPath() + "/groups?error=Invite link is invalid or expired");
            return;
        }

        // Check if user is logged in
        HttpSession session = request.getSession(true);
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            // User not logged in - store token and redirect to login
            session.setAttribute("pendingInviteToken", token);
            System.out.println("[DEBUG InviteServlet] User not logged in, storing pending token and redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login?redirect=invite");
            return;
        }

        // User is logged in - process the join
        processJoinGroup(request, response, invite, userId);
    }

    private void processJoinGroup(HttpServletRequest request, HttpServletResponse response, 
                                   GroupInvite invite, int userId) throws IOException {
        
        int groupId = invite.getGroupId();

        // Check if user is already a member
        if (groupMemberDAO.isUserMember(groupId, userId)) {
            System.out.println("[DEBUG InviteServlet] User " + userId + " is already a member of group " + groupId);
            response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&msg=You are already a member of this group");
            return;
        }

        // Get group info
        Group group = groupDAO.findById(groupId);
        if (group == null) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Group not found");
            return;
        }

        // Add user to the group
        GroupMember newMember = new GroupMember();
        newMember.setGroupId(groupId);
        
        user memberUser = new user();
        memberUser.setId(userId);
        newMember.setUser(memberUser);
        
        newMember.setRole("member"); // New members join as regular members
        newMember.setJoinedAt(new Timestamp(System.currentTimeMillis()));
        newMember.setStatus("active");

        boolean success = groupMemberDAO.addGroupMember(newMember);

        if (success) {
            System.out.println("[DEBUG InviteServlet] Successfully added user " + userId + " to group " + groupId);
            response.sendRedirect(request.getContextPath() + "/groupmembers?groupId=" + groupId + "&msg=Successfully joined " + group.getName());
        } else {
            System.out.println("[DEBUG InviteServlet] Failed to add user " + userId + " to group " + groupId);
            response.sendRedirect(request.getContextPath() + "/groups?error=Failed to join group");
        }
    }
}
