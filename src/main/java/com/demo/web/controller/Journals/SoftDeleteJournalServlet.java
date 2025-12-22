// File: com/demo/web/servlet/journal/SoftDeleteJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/soft-delete")
public class SoftDeleteJournalServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current user ID from session (adjust key if yours is different)
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get journal ID from request
        String journalIdStr = request.getParameter("journalId");
        if (journalIdStr == null || journalIdStr.isEmpty()) {
            response.sendRedirect("journal/list?error=Invalid journal ID");
            return;
        }

        int journalId;
        try {
            journalId = Integer.parseInt(journalIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("journal/list?error=Invalid journal ID");
            return;
        }

        JournalDAO journalDAO = new JournalDAO();

        // 🔒 Security: Verify this journal belongs to the user
        Journal journal = journalDAO.findById(journalId);
        if (journal == null || journal.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't own this journal.");
            return;
        }

        // Perform soft delete
        boolean success = journalDAO.softDeleteJournal(journalId);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/journals?msg=Journal moved to Recycle Bin");
        } else {
            response.sendRedirect(request.getContextPath() + "/journals?error=Failed to delete journal");
        }
    }
}