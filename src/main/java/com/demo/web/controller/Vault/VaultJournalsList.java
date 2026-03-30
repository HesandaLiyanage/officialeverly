package com.demo.web.controller.Vault;

import com.demo.web.service.VaultService;
import com.demo.web.dto.Vault.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        VaultJournalsRequest req = new VaultJournalsRequest(
            (Integer) session.getAttribute("user_id"),
            null, // No password via GET
            (Boolean) session.getAttribute("vault_unlocked")
        );

        VaultJournalsResponse res = vaultService.getVaultJournals(req);

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            response.sendRedirect(request.getContextPath() + "/vaultentries");
            return;
        }

        request.setAttribute("journals", res.getJournals());
        request.setAttribute("journalsCount", res.getJournalsCount());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultjournals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        VaultJournalsRequest req = new VaultJournalsRequest(
            (Integer) session.getAttribute("user_id"),
            request.getParameter("vaultPassword"),
            null
        );

        VaultJournalsResponse res = vaultService.getVaultJournals(req);

        if (!res.isHasSetup()) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        if (!res.isAccessGranted()) {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultentries.jsp").forward(request, response);
            return;
        }

        request.setAttribute("journals", res.getJournals());
        request.setAttribute("journalsCount", res.getJournalsCount());
        request.getRequestDispatcher("/WEB-INF/views/app/Vault/vaultjournals.jsp").forward(request, response);
    }
}
