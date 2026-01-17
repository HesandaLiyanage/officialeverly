package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupDAO;
import com.demo.web.dao.GroupInviteDAO;
import com.demo.web.model.Group;
import com.demo.web.model.GroupInvite;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;

@WebServlet("/group/invite/generate")
public class GenerateInviteLinkServlet extends HttpServlet {

    private GroupDAO groupDAO;
    private GroupInviteDAO groupInviteDAO;

    @Override
    public void init() throws ServletException {
        groupDAO = new GroupDAO();
        groupInviteDAO = new GroupInviteDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String groupIdStr = request.getParameter("groupId");

        if (groupIdStr == null || groupIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Group ID required\"}");
            return;
        }

        try {
            int groupId = Integer.parseInt(groupIdStr);

            // Check if user is the admin of this group
            Group group = groupDAO.findById(groupId);
            if (group == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Group not found\"}");
                return;
            }

            if (group.getUserId() != userId) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"error\": \"Only group admin can generate invite links\"}");
                return;
            }

            // Generate invite token
            String token = groupInviteDAO.generateToken();

            // Create invite record
            GroupInvite invite = new GroupInvite();
            invite.setGroupId(groupId);
            invite.setInviteToken(token);
            invite.setCreatedBy(userId);
            invite.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            invite.setActive(true);

            boolean success = groupInviteDAO.createInvite(invite);

            if (success) {
                // Build the full invite URL
                String baseUrl = request.getScheme() + "://" + request.getServerName();
                if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                    baseUrl += ":" + request.getServerPort();
                }
                String inviteUrl = baseUrl + request.getContextPath() + "/invite/" + token;

                out.print("{\"success\": true, \"inviteUrl\": \"" + inviteUrl + "\", \"token\": \"" + token + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Failed to generate invite link\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid group ID\"}");
        }
    }
}
