// File: com/demo/web/controller/CreateJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;
import com.demo.web.dao.JournalStreakDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

public class CreateJournalServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CreateJournalServlet.class.getName());
    private JournalDAO journalDAO;
    private JournalStreakDAO streakDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.journalDAO = new JournalDAO();
        this.streakDAO = new JournalStreakDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG CreateJournalServlet] Received POST request");

        // Set UTF-8 encoding for emoji/unicode support
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG CreateJournalServlet] User not logged in.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");
        System.out.println("[DEBUG CreateJournalServlet] User ID from session: " + userId);

        try {
            // Get form data
            String content = request.getParameter("content"); // This will be HTML with formatting
            String decorationsJson = request.getParameter("decorations"); // JSON string of decorations
            String backgroundTheme = request.getParameter("backgroundTheme"); // Background image path

            System.out.println(
                    "[DEBUG CreateJournalServlet] Content length: " + (content != null ? content.length() : 0));
            System.out.println("[DEBUG CreateJournalServlet] Decorations: " + decorationsJson);

            // Validate required fields
            if (content == null || content.trim().isEmpty() || content.equals("<br>")) {
                System.out.println("[DEBUG CreateJournalServlet] Content is empty");
                request.setAttribute("error", "Please write something in your journal!");
                request.getRequestDispatcher("/writejournal").forward(request, response);
                return;
            }

            // Generate title from current date (e.g., "24th October 2025")
            String journalTitle = generateDateTitle();

            // Create the complete journal content by combining HTML content, decorations,
            // and background
            String completeContent = buildCompleteJournalContent(content, decorationsJson, backgroundTheme);

            // Create Journal object
            Journal newJournal = new Journal();
            newJournal.setTitle(journalTitle);
            newJournal.setContent(completeContent);
            newJournal.setUserId(userId);
            newJournal.setJournalPic(null); // No image upload for now

            // IMPORTANT: Since DB doesn't have created_at/updated_at columns,
            // we DON'T set them here. The model still has them, but DAO won't use them.
            // We'll let the DB handle timestamps if needed later, or remove them from
            // model.

            System.out.println("[DEBUG CreateJournalServlet] Created journal object: " + newJournal);

            // Save to database
            boolean success = journalDAO.createJournal(newJournal);

            if (success) {
                System.out.println("[DEBUG CreateJournalServlet] Journal saved successfully with ID: "
                        + newJournal.getJournalId());

                // ✅ UPDATE STREAK - Use the correct method with date parameter
                try {
                    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                    boolean streakUpdated = streakDAO.updateStreakOnNewEntry(userId, today);

                    if (streakUpdated) {
                        System.out
                                .println("[DEBUG CreateJournalServlet] Streak updated successfully for user " + userId);
                    } else {
                        System.out.println(
                                "[WARNING CreateJournalServlet] Streak update returned false for user " + userId);
                    }
                } catch (Exception e) {
                    System.out.println("[ERROR CreateJournalServlet] Streak update failed: " + e.getMessage());
                    e.printStackTrace();
                    // Don't fail the journal creation if streak update fails
                }

                // Redirect to journals list page
                response.sendRedirect(request.getContextPath() + "/journals");
            } else {
                System.out.println("[ERROR CreateJournalServlet] Failed to save journal");
                request.setAttribute("error", "Failed to save journal entry. Please try again.");
                request.getRequestDispatcher("/writejournal").forward(request, response);
            }

        } catch (Exception e) {
            System.out.println("[ERROR CreateJournalServlet] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/writejournal").forward(request, response);
        }
    }

    /**
     * Build complete journal content by combining text content and decorations
     */
    private String buildCompleteJournalContent(String htmlContent, String decorationsJson, String backgroundTheme) {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"htmlContent\":").append(escapeJson(htmlContent)).append(",");
        jsonBuilder.append("\"decorations\":").append(decorationsJson != null ? decorationsJson : "[]").append(",");
        jsonBuilder.append("\"backgroundTheme\":").append(escapeJson(backgroundTheme != null ? backgroundTheme : ""));
        jsonBuilder.append("}");

        return jsonBuilder.toString();
    }

    /**
     * Escape JSON string properly
     */
    private String escapeJson(String text) {
        if (text == null)
            return "\"\"";

        return "\"" + text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                + "\"";
    }

    /**
     * Generate a formatted date title like "24th October 2025"
     */
    private String generateDateTitle() {
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("d");
        String day = sdf.format(now);

        // Add ordinal suffix (st, nd, rd, th)
        String suffix = "th";
        if (day.endsWith("1") && !day.endsWith("11")) {
            suffix = "st";
        } else if (day.endsWith("2") && !day.endsWith("12")) {
            suffix = "nd";
        } else if (day.endsWith("3") && !day.endsWith("13")) {
            suffix = "rd";
        }

        sdf = new SimpleDateFormat("MMMM yyyy");
        String monthYear = sdf.format(now);

        return day + suffix + " " + monthYear;
    }
}