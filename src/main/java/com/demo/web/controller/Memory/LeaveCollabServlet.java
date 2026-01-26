package com.demo.web.controller.Memory;

import com.demo.web.dao.MemoryMemberDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for leaving a collaborative memory (for members, not owners)
 */
public class LeaveCollabServlet extends HttpServlet {

    private MemoryMemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        memberDAO = new MemoryMemberDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Not logged in\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String memoryIdParam = request.getParameter("memoryId");

        if (memoryIdParam == null || memoryIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID required\"}");
            return;
        }

        try {
            int memoryId = Integer.parseInt(memoryIdParam);

            // Check if user is owner (owners cannot leave, they must delete)
            if (memberDAO.isOwner(memoryId, userId)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Owner cannot leave. Delete the memory instead.\"}");
                return;
            }

            // Check if user is a member
            if (!memberDAO.isMember(memoryId, userId)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"You are not a member of this memory\"}");
                return;
            }

            // Leave the memory
            boolean left = memberDAO.leaveMembership(memoryId, userId);

            if (left) {
                System.out.println("User " + userId + " left memory " + memoryId);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to leave memory\"}");
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
