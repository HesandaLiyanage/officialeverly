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
import java.io.PrintWriter;
import java.security.SecureRandom;

/**
 * Servlet for generating or retrieving share link for collaborative memories
 */
public class GenerateShareLinkServlet extends HttpServlet {

    private memoryDAO memoryDAO;
    private MemoryMemberDAO memberDAO;

    // Characters for generating share key
    private static final String CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    public void init() throws ServletException {
        super.init();
        memoryDAO = new memoryDAO();
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

            // Check if user is owner or member
            if (!memberDAO.isMember(memoryId, userId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"error\": \"Not authorized\"}");
                return;
            }

            // Get memory
            Memory memory = memoryDAO.getMemoryById(memoryId);
            if (memory == null || !memory.isCollaborative()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Collaborative memory not found\"}");
                return;
            }

            String shareKey = memory.getCollabShareKey();

            // If no share key exists, generate one
            if (shareKey == null || shareKey.isEmpty()) {
                shareKey = generateShareKey(14);
                memoryDAO.setCollabShareKey(memoryId, shareKey);
                System.out.println("Generated new share key for memory " + memoryId + ": " + shareKey);
            }

            // Build share URL
            String baseUrl = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80 && request.getServerPort() != 443) {
                baseUrl += ":" + request.getServerPort();
            }
            String shareUrl = baseUrl + request.getContextPath() + "/memoryinvite?key=" + shareKey;

            try (PrintWriter out = response.getWriter()) {
                out.write(String.format(
                        "{\"success\": true, \"shareKey\": \"%s\", \"shareUrl\": \"%s\"}",
                        shareKey, shareUrl));
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

    /**
     * Generate random share key
     */
    private String generateShareKey(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
}
