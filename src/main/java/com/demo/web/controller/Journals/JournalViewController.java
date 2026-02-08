package com.demo.web.controller.Journals;

import com.demo.web.model.Journal;
import com.demo.web.service.AuthService;
import com.demo.web.service.JournalService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * View controller for journal pages.
 * Handles GET requests for listing, viewing, and editing journals.
 */
public class JournalViewController extends HttpServlet {

    private AuthService authService;
    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        journalService = new JournalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        // Determine the action
        if ("view".equals(action) && idParam != null) {
            handleViewJournal(request, response, userId, idParam);
        } else if ("edit".equals(action) && idParam != null) {
            handleEditJournal(request, response, userId, idParam);
        } else {
            handleListJournals(request, response, userId);
        }
    }

    /**
     * Handles listing all journals for the user.
     */
    private void handleListJournals(HttpServletRequest request, HttpServletResponse response,
            int userId) throws ServletException, IOException {
        System.out.println("[DEBUG JournalViewController] Handling /journals request");

        try {
            // Get streak information
            int streakDays = journalService.getCurrentStreakDays(userId);
            int longestStreak = journalService.getLongestStreakDays(userId);

            System.out.println("[DEBUG JournalViewController] Current streak: " + streakDays + " days");
            System.out.println("[DEBUG JournalViewController] Longest streak: " + longestStreak + " days");

            // Get all journals
            List<Journal> journals = journalService.getJournalsByUserId(userId);
            int totalCount = journalService.getJournalCount(userId);

            System.out.println("[DEBUG JournalViewController] Found " + journals.size() + " journals");

            // Set attributes for JSP
            request.setAttribute("journals", journals);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("streakDays", streakDays);
            request.setAttribute("longestStreak", longestStreak);

            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("[DEBUG JournalViewController] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading journals: " + e.getMessage());
            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
        }
    }

    /**
     * Handles viewing a single journal.
     */
    private void handleViewJournal(HttpServletRequest request, HttpServletResponse response,
            int userId, String idParam) throws ServletException, IOException {
        System.out.println("[DEBUG JournalViewController] Handling /journalview request");

        try {
            int journalId = Integer.parseInt(idParam);
            Journal journal = journalService.getJournalById(journalId, userId);

            if (journal == null) {
                System.out.println("[DEBUG JournalViewController] Journal not found or access denied");
                request.setAttribute("error", "Journal entry not found or you don't have permission to view it.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG JournalViewController] Found journal: " + journal.getTitle());

            request.setAttribute("journal", journal);
            request.getRequestDispatcher("/views/app/journalview.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG JournalViewController] Invalid journal ID format");
            request.setAttribute("error", "Invalid Journal ID.");
            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG JournalViewController] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the journal entry: " + e.getMessage());
            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
        }
    }

    /**
     * Handles editing a journal (display the edit form).
     */
    private void handleEditJournal(HttpServletRequest request, HttpServletResponse response,
            int userId, String idParam) throws ServletException, IOException {
        System.out.println("[DEBUG JournalViewController] Handling /editjournal request");

        try {
            int journalId = Integer.parseInt(idParam);
            Journal journal = journalService.getJournalById(journalId, userId);

            if (journal == null) {
                System.out.println("[DEBUG JournalViewController] Journal not found or access denied");
                request.setAttribute("error", "Journal entry not found or you don't have permission to edit it.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                return;
            }

            System.out.println("[DEBUG JournalViewController] Found journal: " + journal.getTitle());

            request.setAttribute("journal", journal);
            request.getRequestDispatcher("/views/app/editjournal.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG JournalViewController] Invalid journal ID format");
            request.setAttribute("error", "Invalid Journal ID.");
            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG JournalViewController] Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading the journal entry: " + e.getMessage());
            request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
        }
    }
}
