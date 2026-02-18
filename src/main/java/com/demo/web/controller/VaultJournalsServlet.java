package com.demo.web.controller;

import com.demo.web.dao.VaultDAO;
import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet to display vault journals
 * Requires vault password verification via POST first
 */
@WebServlet("/vaultjournals")
public class VaultJournalsServlet extends HttpServlet {

    private VaultDAO vaultDAO;
    private JournalDAO journalDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
        journalDAO = new JournalDAO();
    }

    /**
     * GET - User must come from vault entry page with verified password
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if vault is set up
        if (!vaultDAO.hasVaultSetup(userId)) {
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        // Check if vault is unlocked in session
        Boolean vaultUnlocked = (Boolean) session.getAttribute("vault_unlocked");
        if (vaultUnlocked == null || !vaultUnlocked) {
            // Vault not unlocked, redirect to vault entry to verify password first
            response.sendRedirect(request.getContextPath() + "/vaultentries");
            return;
        }

        // Vault is unlocked in session, load vault journals
        List<Journal> vaultJournals = journalDAO.getVaultJournalsByUserId(userId);

        request.setAttribute("journals", vaultJournals);
        request.setAttribute("journalsCount", vaultJournals.size());
        request.getRequestDispatcher("/views/app/vaultjournals.jsp").forward(request, response);
    }

    /**
     * POST - Display vault journals after password verification
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String vaultPassword = request.getParameter("vaultPassword");

        // Verify vault password
        if (vaultPassword == null || !vaultDAO.verifyVaultPassword(userId, vaultPassword)) {
            request.setAttribute("errorMessage", "Invalid vault password");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
            return;
        }

        // Password verified, get vault journals
        List<Journal> vaultJournals = journalDAO.getVaultJournalsByUserId(userId);

        request.setAttribute("journals", vaultJournals);
        request.setAttribute("journalsCount", vaultJournals.size());
        request.getRequestDispatcher("/views/app/vaultjournals.jsp").forward(request, response);
    }
}
