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
 * Servlet to handle vault password setup
 * Handles the form submission from vaultSetup.jsp
 */
@WebServlet("/vaultSetup")
public class VaultSetupServlet extends HttpServlet {

    private VaultDAO vaultDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
    }

    /**
     * GET - Check if vault is set up and show appropriate page
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

        // Check if vault is already set up
        if (vaultDAO.hasVaultSetup(userId)) {
            // Vault already set up, redirect to vault entry
            response.sendRedirect(request.getContextPath() + "/vaultentries");
            return;
        }

        // Show vault setup page
        request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
    }

    /**
     * POST - Handle vault password setup
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

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        // Validate passwords
        if (password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Password is required");
            request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
            return;
        }

        // Setup vault password
        try {
            boolean success = vaultDAO.setupVaultPassword(userId, password);

            if (success) {
                // Redirect to vault entry page
                response.sendRedirect(request.getContextPath() + "/vaultentries");
            } else {
                request.setAttribute("errorMessage", "Failed to set up vault. Please try again.");
                request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/views/app/vaultSetup.jsp").forward(request, response);
        }
    }
}
