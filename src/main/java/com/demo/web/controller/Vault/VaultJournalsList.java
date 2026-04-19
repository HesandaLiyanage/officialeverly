package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;
import com.demo.web.util.ControllerSessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/vaultjournals")
public class VaultJournalsList extends HttpServlet {

    private VaultService vaultService;

    @Override
    public void init() throws ServletException {
        vaultService = new VaultService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        VaultJournalsRequest req = new VaultJournalsRequest(
            userId,
            null,
            (Boolean) request.getSession().getAttribute("vault_unlocked")
        );

        showVaultJournals(request, response, req, true);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = ControllerSessionUtil.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        VaultJournalsRequest req = new VaultJournalsRequest(
            userId,
            request.getParameter("vaultPassword"),
            null
        );

        showVaultJournals(request, response, req, false);
    }

    private void showVaultJournals(HttpServletRequest request, HttpServletResponse response, VaultJournalsRequest req,
                                   boolean redirectWhenLocked)
            throws ServletException, IOException {
        VaultJournalsResponse res = vaultService.getVaultJournals(req);

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            if (redirectWhenLocked) {
                response.sendRedirect(request.getContextPath() + "/vaultentries");
            } else {
                request.setAttribute("errorMessage", res.getErrorMessage());
                request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            }
            return;
        }

        request.setAttribute("journals", res.getJournals());
        Map<Integer, String> journalExcerpts = new LinkedHashMap<>();
        if (res.getJournals() != null) {
            for (com.demo.web.model.Journals.Journal journal : res.getJournals()) {
                journalExcerpts.put(journal.getJournalId(), buildExcerpt(journal.getContent()));
            }
        }
        request.setAttribute("journalExcerpts", journalExcerpts);
        request.setAttribute("journalsCount", res.getJournalsCount());
        request.setAttribute("storagePercentage", res.getStoragePercentage());
        request.setAttribute("storageUsedFormatted", res.getStorageUsedFormatted());
        request.setAttribute("storageTotalFormatted", res.getStorageTotalFormatted());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultjournals.jsp").forward(request, response);
    }

    private String buildExcerpt(String rawContent) {
        if (rawContent == null || rawContent.trim().isEmpty()) {
            return "Private journal";
        }
        String plain = extractPlainText(rawContent);
        if (plain.length() > 110) {
            return plain.substring(0, 110) + "...";
        }
        return plain.isEmpty() ? "Private journal" : plain;
    }

    private String extractPlainText(String rawContent) {
        try {
            com.google.gson.JsonObject json = new com.google.gson.Gson().fromJson(rawContent, com.google.gson.JsonObject.class);
            com.google.gson.JsonElement htmlEl = json.get("htmlContent");
            if (htmlEl != null && !htmlEl.isJsonNull()) {
                return htmlEl.getAsString()
                        .replaceAll("<br\\s*/?>", " ")
                        .replaceAll("</p>", " ")
                        .replaceAll("<[^>]*>", " ")
                        .replace("&nbsp;", " ")
                        .replaceAll("\\s+", " ")
                        .trim();
            }
        } catch (Exception ignored) {
        }
        return "";
    }
}
