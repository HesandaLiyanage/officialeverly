package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/trashmgt")
public class TrashManagementServlet extends HttpServlet {

    // GET → Show trash
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        JournalDAO journalDAO = new JournalDAO();
        List<Journal> deletedJournals = journalDAO.findDeletedByUserId(userId);

        request.setAttribute("deletedJournals", deletedJournals);
        request.getRequestDispatcher("/views/app/trashmgt.jsp").forward(request, response);    }

    // POST → Handle Restore or Permanent Delete
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String journalIdStr = request.getParameter("journalId");

        if (journalIdStr == null || journalIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid journal");
            return;
        }

        try {
            int journalId = Integer.parseInt(journalIdStr);

            // 🔒 Security: Verify ownership (optional but recommended)
            JournalDAO dao = new JournalDAO();
            Journal journal = dao.findById(journalId);
            if (journal == null || journal.getUserId() != userId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            if ("restore".equals(action)) {
                boolean success = dao.restoreJournal(journalId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Journal restored");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to restore");
                }
            }
            else if ("permanentDelete".equals(action)) {
                boolean success = dao.deleteJournal(journalId); // Actual DELETE
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Journal permanently deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to delete");
                }
            }
            else {
                response.sendRedirect(request.getContextPath() + "/trashmgt?error=Unknown action");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid journal ID");
        }
    }
}