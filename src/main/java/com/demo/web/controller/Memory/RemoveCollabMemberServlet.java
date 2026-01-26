package com.demo.web.controller.Memory;

import com.demo.web.dao.MemoryMemberDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for owner to remove a member from collaborative memory
 */
public class RemoveCollabMemberServlet extends HttpServlet {

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
        String memberIdParam = request.getParameter("memberId");

        if (memoryIdParam == null || memberIdParam == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Memory ID and Member ID required\"}");
            return;
        }

        try {
            int memoryId = Integer.parseInt(memoryIdParam);
            int memberIdToRemove = Integer.parseInt(memberIdParam);

            // Only owner can remove members
            if (!memberDAO.isOwner(memoryId, userId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\": \"Only the owner can remove members\"}");
                return;
            }

            // Cannot remove the owner
            if (memberDAO.isOwner(memoryId, memberIdToRemove)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Cannot remove the owner\"}");
                return;
            }

            // Remove the member
            boolean removed = memberDAO.removeMember(memoryId, memberIdToRemove);

            if (removed) {
                System.out.println(
                        "Owner " + userId + " removed member " + memberIdToRemove + " from memory " + memoryId);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Failed to remove member\"}");
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
