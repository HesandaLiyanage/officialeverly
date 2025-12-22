// File: com/demo/web/servlet/journal/RestoreJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/restore")
public class RestoreJournalServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String journalIdStr = request.getParameter("journalId");
        if (journalIdStr == null || journalIdStr.isEmpty()) {
            response.sendRedirect("journal/recycle-bin?error=Invalid journal ID");
            return;
        }

        int journalId;
        try {
            journalId = Integer.parseInt(journalIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("journal/recycle-bin?error=Invalid journal ID");
            return;
        }

        JournalDAO journalDAO = new JournalDAO();

        // 🔒 Security: Verify ownership
        Journal journal = journalDAO.findById(journalId);
        if (journal == null || journal.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't own this journal.");
            return;
        }

        // Restore the journal
        boolean success = journalDAO.restoreJournal(journalId);
        if (success) {
            response.sendRedirect("journal/recycle-bin?msg=Journal restored successfully");
        } else {
            response.sendRedirect("journal/recycle-bin?error=Failed to restore journal");
        }
    }
}