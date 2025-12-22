// File: com/demo/web/controller/DeleteJournalServlet.java
package com.demo.web.controller;

import com.demo.web.dao.JournalDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

public class DeleteJournalServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(DeleteJournalServlet.class.getName());
    private JournalDAO journalDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalDAO = new JournalDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG DeleteJournalServlet] Received POST request for delete");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG DeleteJournalServlet] User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Get journal ID from request parameter
            String journalIdParam = request.getParameter("journalId");
            if (journalIdParam == null || journalIdParam.trim().isEmpty()) {
                System.out.println("[DEBUG DeleteJournalServlet] Journal ID parameter is missing");
                request.setAttribute("error", "Journal ID is required.");
                response.sendRedirect(request.getContextPath() + "/journals");
                return;
            }

            int journalId = Integer.parseInt(journalIdParam);

            System.out.println("[DEBUG DeleteJournalServlet] Attempting to delete journal ID: " + journalId + " for user ID: " + userId);

            // Fetch the journal to check ownership
            com.demo.web.model.Journal journal = journalDAO.findById(journalId);
            if (journal == null) {
                System.out.println("[DEBUG DeleteJournalServlet] Journal not found with ID: " + journalId);
                request.setAttribute("error", "Journal entry not found.");
                response.sendRedirect(request.getContextPath() + "/journals");
                return;
            }

            // Security check: Ensure the journal belongs to the current user
            if (journal.getUserId() != userId) {
                System.out.println("[DEBUG DeleteJournalServlet] User " + userId + " tried to delete journal " + journalId + " which belongs to user " + journal.getUserId());
                request.setAttribute("error", "You do not have permission to delete this journal entry.");
                response.sendRedirect(request.getContextPath() + "/journals");
                return;
            }

            // Perform the deletion
            boolean success = journalDAO.deleteJournal(journalId);

            if (success) {
                System.out.println("[DEBUG DeleteJournalServlet] Journal deleted successfully: " + journalId);
                // Redirect back to the journals list page
                response.sendRedirect(request.getContextPath() + "/journals");
            } else {
                System.out.println("[ERROR DeleteJournalServlet] Failed to delete journal: " + journalId);
                request.setAttribute("error", "Failed to delete journal entry. Please try again.");
                response.sendRedirect(request.getContextPath() + "/journals"); // Or redirect back to the view page
            }

        } catch (NumberFormatException e) {
            System.out.println("[ERROR DeleteJournalServlet] Invalid journal ID format: " + e.getMessage());
            request.setAttribute("error", "Invalid Journal ID.");
            response.sendRedirect(request.getContextPath() + "/journals");
        } catch (Exception e) {
            System.out.println("[ERROR DeleteJournalServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/journals");
        }
    }
}