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
 * Servlet to handle vault password changes
 * Handles the form submission from vaultpassword.jsp
 */
@WebServlet("/changevaultpassword")
public class ChangeVaultPasswordServlet extends HttpServlet {

    private VaultDAO vaultDAO;

    @Override
    public void init() throws ServletException {
        vaultDAO = new VaultDAO();
    }

    /**
     * GET - Show change password page
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

        // Show vault password change page
        request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
    }

    /**
     * POST - Handle vault password change
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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || currentPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Current password is required");
            request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            request.setAttribute("errorMessage", "New password is required");
            request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("errorMessage", "New password must be at least 8 characters long");
            request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New passwords do not match");
            request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            return;
        }

        // Change vault password
        try {
            boolean success = vaultDAO.changeVaultPassword(userId, currentPassword, newPassword);

            if (success) {
                request.setAttribute("successMessage", "Vault password changed successfully!");
                request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/views/app/vaultpassword.jsp").forward(request, response);
        }
    }
}
