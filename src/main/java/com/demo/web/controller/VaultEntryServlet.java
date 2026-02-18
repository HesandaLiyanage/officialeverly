package com.demo.web.controller;

import com.demo.web.dao.VaultDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet to handle vault entry (password verification)
 * This is the main vault access gate
 */
@WebServlet("/vaultentries")
public class VaultEntryServlet extends HttpServlet {

    private VaultDAO vaultDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
    }

    /**
     * GET - Show vault entry page or redirect to setup
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
            // Vault not set up, redirect to setup page
            response.sendRedirect(request.getContextPath() + "/vaultSetup");
            return;
        }

        // Show vault entry page (password prompt)
        request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
    }

    /**
     * POST - Verify vault password
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
        String password = request.getParameter("vaultPassword");

        // Validate password
        if (password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Password is required");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
            return;
        }

        // Verify vault password
        try {
            boolean isValid = vaultDAO.verifyVaultPassword(userId, password);

            if (isValid) {
                // Password correct - store vault unlocked state in session
                session.setAttribute("vault_unlocked", true);
                request.setAttribute("vaultUnlocked", true);
                request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
            } else {
                // Wrong password
                request.setAttribute("errorMessage", "Incorrect password. Please try again.");
                request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/views/app/vaultentries.jsp").forward(request, response);
        }
    }
}
