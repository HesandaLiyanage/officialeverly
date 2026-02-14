package com.demo.web.controller.Settings;

import com.demo.web.dao.userDAO;
import com.demo.web.service.AuthService;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import java.io.IOException;

/**
 * Handles account deactivation.
 * Sets is_active = false in the database (does NOT delete data).
 * After deactivation, the user is logged out and redirected to the landing
 * page.
 * The user can reactivate their account by logging in again.
 */
public class DeactivateAccountServlet extends HttpServlet {

    private AuthService authService;
    private userDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        userDAO = new userDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DeactivateAccountServlet START ===");

        // Validate session
        if (!authService.isValidSession(request)) {
            System.out.println("No valid session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        if (userId == null) {
            System.out.println("No user ID in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("Deactivating account for user ID: " + userId);

        try {
            // Deactivate the account in the database
            boolean deactivated = userDAO.deactivateAccount(userId);

            if (deactivated) {
                System.out.println("Account deactivated successfully for user ID: " + userId);

                // Revoke the current session (logs the user out)
                SessionUtil.revokeSession(request);

                // Clear remember-me cookie if it exists
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if ("session_token".equals(cookie.getName())) {
                            cookie.setValue("");
                            cookie.setMaxAge(0);
                            cookie.setPath("/");
                            response.addCookie(cookie);
                            break;
                        }
                    }
                }

                // Redirect to login page with deactivation message
                response.sendRedirect(request.getContextPath() + "/login?deactivated=true");
            } else {
                System.out.println("Failed to deactivate account for user ID: " + userId);
                request.setAttribute("error", "Failed to deactivate account. Please try again.");
                request.getRequestDispatcher("/views/app/settingsaccount.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error deactivating account: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while deactivating your account.");
            request.getRequestDispatcher("/views/app/settingsaccount.jsp").forward(request, response);
        }

        System.out.println("=== DeactivateAccountServlet END ===");
    }
}
