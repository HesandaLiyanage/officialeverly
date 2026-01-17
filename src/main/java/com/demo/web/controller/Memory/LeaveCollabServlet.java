package com.demo.web.controller.Memory;

import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.MemoryMember;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet to allow members to leave a collaborative memory.
 * Owners cannot leave - they would need to delete the memory.
 */
@WebServlet("/memory/leave")
public class LeaveCollabServlet extends HttpServlet {

    private MemoryMemberDAO memberDao;

    @Override
    public void init() throws ServletException {
        memberDao = new MemoryMemberDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String memoryIdStr = request.getParameter("memoryId");

        if (memoryIdStr == null || memoryIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID is required\"}");
            return;
        }

        try {
            int memoryId = Integer.parseInt(memoryIdStr);

            // Check if user is a member
            MemoryMember member = memberDao.getMember(memoryId, userId);
            if (member == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"You are not a member of this memory\"}");
                return;
            }

            // Owners cannot leave
            if ("owner".equals(member.getRole())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\": \"Owners cannot leave. Delete the memory instead.\"}");
                return;
            }

            // Remove self from memory
            boolean removed = memberDao.removeMember(memoryId, userId);

            if (removed) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"success\": true, \"message\": \"You have left the collab memory\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to leave the memory\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid memory ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
