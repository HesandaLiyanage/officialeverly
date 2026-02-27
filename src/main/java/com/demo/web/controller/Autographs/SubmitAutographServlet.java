package com.demo.web.controller.Autographs;

import com.demo.web.dao.AutographEntryDAO;
import com.demo.web.dao.autographDAO;
import com.demo.web.model.AutographEntry;
import com.demo.web.model.autograph;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Handles submission of autograph entries from shared links.
 * Mapped to /submit-autograph in web.xml.
 * Accepts POST with: token, content, author, contentPlain
 * Returns JSON: { "success": true/false, "message": "..." }
 */
public class SubmitAutographServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Validate session
        if (!authService.isValidSession(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\": false, \"message\": \"You must be logged in to submit an autograph.\"}");
            return;
        }

        String token = request.getParameter("token");
        String content = request.getParameter("content");
        String author = request.getParameter("author");
        String contentPlain = request.getParameter("contentPlain");

        // Validate required fields
        if (token == null || token.isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Invalid share token.\"}");
            return;
        }
        if (content == null || content.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Please write a message.\"}");
            return;
        }
        if (author == null || author.trim().isEmpty()) {
            out.write("{\"success\": false, \"message\": \"Please enter your name.\"}");
            return;
        }

        try {
            int userId = authService.getUserId(request);

            // Look up the autograph by share token
            autographDAO agDao = new autographDAO();
            autograph ag = agDao.getAutographByShareToken(token);

            if (ag == null) {
                out.write("{\"success\": false, \"message\": \"Autograph book not found or link has expired.\"}");
                return;
            }

            // Create the entry
            AutographEntry entry = new AutographEntry();
            entry.setAutographId(ag.getAutographId());
            entry.setUserId(userId);
            entry.setContent(content);
            entry.setContentPlain(contentPlain != null ? contentPlain : "");
            entry.setLink(token);

            AutographEntryDAO entryDao = new AutographEntryDAO();
            boolean saved = entryDao.createEntry(entry);

            if (saved) {
                out.write("{\"success\": true, \"message\": \"Autograph submitted successfully!\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to save your autograph. Please try again.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"Server error: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
