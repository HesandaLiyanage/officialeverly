package com.demo.web.controller.Journals;

import com.demo.web.dto.Journals.JournalDashboardRequest;
import com.demo.web.dto.Journals.JournalDashboardResponse;
import com.demo.web.dto.Journals.JournalEditFormRequest;
import com.demo.web.dto.Journals.JournalEditFormResponse;
import com.demo.web.dto.Journals.JournalViewRequest;
import com.demo.web.dto.Journals.JournalViewResponse;
import com.demo.web.model.Journals.Journal;
import com.demo.web.service.JournalService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class JournalView extends HttpServlet {

    private JournalService journalService;

    @Override
    public void init() throws ServletException {
        super.init();
        journalService = new JournalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        String journalIdParam = request.getParameter("id");

        if ("view".equals(action)) {
            JournalViewRequest req = new JournalViewRequest(userId, journalIdParam);
            JournalViewResponse res = journalService.getJournalViewData(req);

            if (!res.isSuccess()) {
                request.setAttribute("error", res.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Journals/journals.jsp").forward(request, response);
                return;
            }

            request.setAttribute("journal", res.getJournal());
            request.setAttribute("isInVault", res.getJournal().isInVault());
            preComputeJournalAttributes(request, res.getJournal());
            request.getRequestDispatcher("/WEB-INF/views/app/Journals/journalview.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            JournalEditFormRequest req = new JournalEditFormRequest(userId, journalIdParam);
            JournalEditFormResponse res = journalService.getJournalEditFormData(req);

            if (!res.isSuccess()) {
                request.setAttribute("error", res.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Journals/journals.jsp").forward(request, response);
                return;
            }

            request.setAttribute("journal", res.getJournal());
            request.setAttribute("isInVault", res.getJournal().isInVault());
            preComputeJournalAttributes(request, res.getJournal());
            request.getRequestDispatcher("/WEB-INF/views/app/Journals/editjournal.jsp").forward(request, response);
            return;
        }
        //dashboard
        JournalDashboardRequest req = new JournalDashboardRequest(userId);
        JournalDashboardResponse res = journalService.getDashboard(req);

        if (res.getError() != null) {
            request.setAttribute("error", res.getError());
        }

        request.setAttribute("journals", res.getJournals());
        request.setAttribute("totalCount", res.getTotalCount());
        request.setAttribute("streakDays", res.getStreakDays());
        request.setAttribute("longestStreak", res.getLongestStreak());
        request.setAttribute("wordCounts", res.getWordCounts());
        request.getRequestDispatcher("/WEB-INF/views/app/Journals/journals.jsp").forward(request, response);
    }


    private void preComputeJournalAttributes(HttpServletRequest request, Journal journal) {
        String journalTitle = journal.getTitle() != null ? journal.getTitle() : "";
        String htmlContent = "";
        String backgroundTheme = "";
        String decorationsJson = "[]";
        String rawContentForJs = "";

        String rawContent = journal.getContent();
        if (rawContent != null && !rawContent.isEmpty()) {
            rawContentForJs = rawContent.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
            try {
                com.google.gson.Gson gson = new com.google.gson.Gson();
                com.google.gson.JsonObject contentObj = gson.fromJson(rawContent, com.google.gson.JsonObject.class);

                com.google.gson.JsonElement htmlEl = contentObj.get("htmlContent");
                if (htmlEl != null && !htmlEl.isJsonNull()) {
                    htmlContent = htmlEl.getAsString();
                }

                com.google.gson.JsonElement decEl = contentObj.get("decorations");
                if (decEl != null && !decEl.isJsonNull() && decEl.isJsonArray()) {
                    decorationsJson = decEl.getAsJsonArray().toString();
                }

                com.google.gson.JsonElement bgEl = contentObj.get("backgroundTheme");
                if (bgEl != null && !bgEl.isJsonNull()) {
                    backgroundTheme = bgEl.getAsString();
                }
            } catch (Exception e) {}
        }

        request.setAttribute("journalTitle", journalTitle);
        request.setAttribute("journalId", journal.getJournalId());
        request.setAttribute("htmlContent", htmlContent);
        request.setAttribute("backgroundTheme", backgroundTheme);
        request.setAttribute("decorationsJson", decorationsJson);
        request.setAttribute("rawContentForJs", rawContentForJs);

        com.google.gson.Gson gson = new com.google.gson.Gson();
        request.setAttribute("htmlContentJson", gson.toJson(htmlContent));
        request.setAttribute("decorationsJsonEscaped", gson.toJson(decorationsJson));
        request.setAttribute("backgroundThemeJson", gson.toJson(backgroundTheme));
    }
}
