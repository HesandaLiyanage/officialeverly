package com.demo.web.controller.Memory;

import com.demo.web.dao.memoryDAO;
import com.demo.web.dao.MemoryMemberDAO;
import com.demo.web.model.Memory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

/**
 * Servlet for joining a collaborative memory via invite link
 * URL: /memoryinvite?key=XXXXXX
 */
public class JoinCollabServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MemoryMemberDAO memberDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
        memberDAO = new MemoryMemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String shareKey = request.getParameter("key");

        if (shareKey == null || shareKey.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invite link");
            return;
        }

        HttpSession session = request.getSession(false);

        // If not logged in, redirect to login with return URL
        if (session == null || session.getAttribute("user_id") == null) {
            String returnUrl = request.getRequestURI() + "?key=" + URLEncoder.encode(shareKey, "UTF-8");
            response.sendRedirect(
                    request.getContextPath() + "/login?redirect=" + URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Find memory by share key
            Memory memory = memoryDAO.getMemoryByShareKey(shareKey);

            if (memory == null) {
                request.setAttribute("errorMessage", "Invalid or expired invite link");
                request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
                return;
            }

            if (!memory.isCollaborative()) {
                request.setAttribute("errorMessage", "This memory is not collaborative");
                request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
                return;
            }

            // Check if user is already a member
            if (memberDAO.isMember(memory.getMemoryId(), userId)) {
                System.out.println("User " + userId + " is already a member of memory " + memory.getMemoryId());
            } else {
                // Add user as member
                memberDAO.addMember(memory.getMemoryId(), userId, "member");
                System.out.println("User " + userId + " joined memory " + memory.getMemoryId() + " via invite link");
            }

            // Redirect to the collab memory view
            response.sendRedirect(request.getContextPath() + "/collabmemoryview?id=" + memory.getMemoryId());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error joining memory: " + e.getMessage());
            request.getRequestDispatcher("/views/app/collabmemories.jsp").forward(request, response);
        }
    }
}
