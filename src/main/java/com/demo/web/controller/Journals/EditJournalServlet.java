// File: com/demo/web/controller/EditJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

public class EditJournalServlet extends HttpServlet { // Only handles POST

    private static final Logger logger = Logger.getLogger(EditJournalServlet.class.getName());
    private JournalDAO journalDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalDAO = new JournalDAO();
    }

    // doPost remains the same, handles the form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG EditJournalServlet] Received POST request for edit");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG EditJournalServlet] User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Get journal ID from request parameter
            String journalIdParam = request.getParameter("journalId");
            if (journalIdParam == null || journalIdParam.trim().isEmpty()) {
                System.out.println("[DEBUG EditJournalServlet] Journal ID parameter is missing");
                request.setAttribute("error", "Journal ID is required.");
                response.sendRedirect(request.getContextPath() + "/journals"); // Redirect back to list
                return;
            }

            int journalId = Integer.parseInt(journalIdParam);

            System.out.println("[DEBUG EditJournalServlet] Attempting to edit journal ID: " + journalId + " for user ID: " + userId);

            // Fetch the journal to check ownership and get current data
            Journal journal = journalDAO.findById(journalId);
            if (journal == null) {
                System.out.println("[DEBUG EditJournalServlet] Journal not found with ID: " + journalId);
                request.setAttribute("error", "Journal entry not found.");
                response.sendRedirect(request.getContextPath() + "/journals");
                return;
            }

            // Security check: Ensure the journal belongs to the current user
            if (journal.getUserId() != userId) {
                System.out.println("[DEBUG EditJournalServlet] User " + userId + " tried to edit journal " + journalId + " which belongs to user " + journal.getUserId());
                request.setAttribute("error", "You do not have permission to edit this journal entry.");
                response.sendRedirect(request.getContextPath() + "/journals");
                return;
            }

            // Get form data (title, content, decorations)
            String title = request.getParameter("title"); // Get title if provided in edit form
            String content = request.getParameter("content"); // This will be HTML with formatting
            String decorationsJson = request.getParameter("decorations"); // JSON string of decorations

            System.out.println("[DEBUG EditJournalServlet] Title: " + title);
            System.out.println("[DEBUG EditJournalServlet] Content length: " + (content != null ? content.length() : 0));
            System.out.println("[DEBUG EditJournalServlet] Decorations: " + decorationsJson);

            // Validate required fields
            if (content == null || content.trim().isEmpty() || content.equals("<br>")) {
                System.out.println("[DEBUG EditJournalServlet] Content is empty");
                request.setAttribute("error", "Please write something in your journal!");
                // Re-populate the journal object for the form
                request.setAttribute("journal", journal); // Pass the original journal back
                request.getRequestDispatcher("/views/app/editjournal.jsp").forward(request, response);
                return;
            }

            // Since no image upload is handled here, picUrl remains unchanged
            String picUrl = journal.getJournalPic(); // Keep existing image

            // Create the updated journal content by combining HTML content and decorations
            String updatedContent = buildCompleteJournalContent(content, decorationsJson);

            // Use provided title or keep the original if null/empty
            String journalTitle = (title != null && !title.trim().isEmpty())
                    ? title
                    : journal.getTitle(); // Keep original title if not provided

            // Update the journal object with new data
            journal.setTitle(journalTitle);
            journal.setContent(updatedContent);
            // journal.setUserId(userId); // UserId should not change
            // journal.setJournalPic(picUrl); // PicUrl might change if image upload is added later

            // Perform the update in the database
            boolean success = journalDAO.updateJournal(journal);

            if (success) {
                System.out.println("[DEBUG EditJournalServlet] Journal updated successfully: " + journalId);
                // Redirect back to the journal view page for the edited entry
                response.sendRedirect(request.getContextPath() + "/journalview?id=" + journalId);
            } else {
                System.out.println("[ERROR EditJournalServlet] Failed to update journal: " + journalId);
                request.setAttribute("error", "Failed to update journal entry. Please try again.");
                // Pass the journal object back in case of error to re-populate the form
                request.setAttribute("journal", journal);
                request.getRequestDispatcher("/views/app/editjournal.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            System.out.println("[ERROR EditJournalServlet] Invalid journal ID format: " + e.getMessage());
            request.setAttribute("error", "Invalid Journal ID.");
            response.sendRedirect(request.getContextPath() + "/journals");
        } catch (Exception e) {
            System.out.println("[ERROR EditJournalServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            // Pass the journal object back in case of error to re-populate the form
            // We need to fetch it again in case of an error during processing
            try {
                Journal journal = journalDAO.findById(Integer.parseInt(request.getParameter("journalId")));
                if (journal != null && journal.getUserId() == userId) {
                    request.setAttribute("journal", journal);
                }
            } catch (Exception ex) { /* Ignore error fetching journal on error page */ }
            request.getRequestDispatcher("/views/app/editjournal.jsp").forward(request, response);
        }
    }

    /**
     * Build complete journal content by combining text content and decorations
     */
    private String buildCompleteJournalContent(String htmlContent, String decorationsJson) {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"htmlContent\":").append(escapeJson(htmlContent)).append(",");
        jsonBuilder.append("\"decorations\":").append(decorationsJson != null ? decorationsJson : "[]");
        jsonBuilder.append("}");

        return jsonBuilder.toString();
    }

    /**
     * Escape JSON string properly
     */
    private String escapeJson(String text) {
        if (text == null) return "\"\"";

        return "\"" + text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                + "\"";
    }
}