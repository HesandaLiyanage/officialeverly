package com.demo.web.controller.Autographs;

import com.demo.web.dao.autographDAO;
import com.demo.web.dao.AutographEntryDAO;
import com.demo.web.model.autograph;
import com.demo.web.model.AutographEntry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet to handle autograph entry submissions from shared links.
 * Uses token-only lookup for security (no autograph ID exposed).
 */
@WebServlet("/submitAutographEntry")
public class SubmitAutographEntryServlet extends HttpServlet {

    private autographDAO autographDAO;
    private AutographEntryDAO entryDAO;

    @Override
    public void init() throws ServletException {
        autographDAO = new autographDAO();
        entryDAO = new AutographEntryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG SubmitAutographEntryServlet] Processing entry submission");

        // Get form parameters
        String shareToken = request.getParameter("shareToken");
        String message = request.getParameter("message");
        String author = request.getParameter("author");
        String decorations = request.getParameter("decorations");

        // Validate share token
        if (shareToken == null || shareToken.trim().isEmpty()) {
            System.out.println("[DEBUG SubmitAutographEntryServlet] Invalid share token");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid share link");
            return;
        }

        // Validate message
        if (message == null || message.trim().isEmpty()) {
            System.out.println("[DEBUG SubmitAutographEntryServlet] Empty message");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Message is required");
            return;
        }

        try {
            // Look up autograph by token (secure - no ID exposed)
            autograph ag = autographDAO.getAutographByShareToken(shareToken);

            if (ag == null) {
                System.out.println("[DEBUG SubmitAutographEntryServlet] Autograph not found for token: " + shareToken);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph book not found");
                return;
            }

            System.out.println("[DEBUG SubmitAutographEntryServlet] Found autograph ID: " + ag.getAutographId()
                    + " for token: " + shareToken);

            // Get user ID - check if logged in, otherwise use a guest ID (0 or create guest
            // user logic)
            int userId = 0;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user_id") != null) {
                userId = (Integer) session.getAttribute("user_id");
            } else {
                // For guests, we could use the autograph owner's ID or a designated guest ID
                // Using the autograph owner's ID for simplicity
                userId = ag.getUserId();
            }

            // Create the entry
            AutographEntry entry = new AutographEntry();
            entry.setAutographId(ag.getAutographId());
            entry.setUserId(userId);

            // Combine author name with message for content field
            // Format: "Author: Message [Decorations JSON]"
            String fullContent = author + ": " + message;
            if (decorations != null && !decorations.isEmpty() && !decorations.equals("[]")) {
                fullContent += " |DECORATIONS|" + decorations;
            }

            // Truncate if needed (content column is VARCHAR(50) based on schema)
            // Note: You may want to increase this limit in the database
            if (fullContent.length() > 50) {
                System.out.println("[DEBUG SubmitAutographEntryServlet] Warning: Content truncated from "
                        + fullContent.length() + " to 50 chars");
                fullContent = fullContent.substring(0, 50);
            }

            entry.setContent(fullContent);

            // Save to database
            boolean success = entryDAO.createEntry(entry);

            if (success) {
                System.out.println("[DEBUG SubmitAutographEntryServlet] Entry created successfully with ID: "
                        + entry.getEntryId());

                // Redirect to shared view page with the token
                response.sendRedirect(request.getContextPath() + "/sharedview/" + shareToken);
            } else {
                System.out.println("[DEBUG SubmitAutographEntryServlet] Failed to create entry");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save autograph entry");
            }

        } catch (SQLException e) {
            System.out.println("[DEBUG SubmitAutographEntryServlet] Database error: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}
