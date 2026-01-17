package com.demo.web.controller.Memory;

import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.MemoryMember;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for managing collaborative memory members.
 * GET: List members of a memory
 * DELETE: Remove a member (owner only)
 */
@WebServlet("/memory/members")
public class CollabMembersServlet extends HttpServlet {

    private MemoryMemberDAO memberDao;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        memberDao = new MemoryMemberDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String memoryIdStr = request.getParameter("memoryId");

        if (memoryIdStr == null || memoryIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID is required\"}");
            return;
        }

        try {
            int memoryId = Integer.parseInt(memoryIdStr);

            // Check if user is a member of this memory
            MemoryMember currentMember = memberDao.getMember(memoryId, userId);
            if (currentMember == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\": \"You are not a member of this memory\"}");
                return;
            }

            // Get all members
            List<MemoryMember> members = memberDao.getMembersOfMemory(memoryId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("members", members);
            result.put("isOwner", "owner".equals(currentMember.getRole()));
            result.put("currentUserRole", currentMember.getRole());

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid memory ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String memoryIdStr = request.getParameter("memoryId");
        String targetUserIdStr = request.getParameter("userId");

        if (memoryIdStr == null || targetUserIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID and user ID are required\"}");
            return;
        }

        try {
            int memoryId = Integer.parseInt(memoryIdStr);
            int targetUserId = Integer.parseInt(targetUserIdStr);

            // Check if current user is owner
            MemoryMember currentMember = memberDao.getMember(memoryId, userId);
            if (currentMember == null || !"owner".equals(currentMember.getRole())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\": \"Only the owner can remove members\"}");
                return;
            }

            // Cannot remove self (owner)
            if (targetUserId == userId) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Owner cannot remove themselves\"}");
                return;
            }

            // Remove the member
            boolean removed = memberDao.removeMember(memoryId, targetUserId);

            if (removed) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true, \"message\": \"Member removed\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Member not found\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
