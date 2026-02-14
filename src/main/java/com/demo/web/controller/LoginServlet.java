package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;
import com.demo.web.util.PasswordUtil;
import com.demo.web.util.SessionUtil;

import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new userDAO();
        userSessionDAO = new userSessionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if already logged in
        if (SessionUtil.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        // Check for remember me cookie
        user rememberedUser = checkRememberMeToken(request);
        if (rememberedUser != null) {
            // Auto-login with remember me
            SessionUtil.createSession(request, rememberedUser);
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        // Check if user was redirected after deactivating their account
        String deactivated = request.getParameter("deactivated");
        if ("true".equals(deactivated)) {
            request.setAttribute("infoMessage",
                    "Your account has been deactivated. You can reactivate it by logging in again.");
        }

        // Show login form
        request.getRequestDispatcher("/login").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMeToken = request.getParameter("rememberme");

        // Validate input
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/login").forward(request, response);
            return;
        }

        // Authenticate user (YOUR EXISTING CODE - UNCHANGED)
        user user = userDAO.findByemail(username);
        if (user != null && PasswordUtil.verifyPassword(password, user.getSalt(), user.getPassword())) {

            // Check if account was deactivated — if so, reactivate it
            if (!user.is_active()) {
                System.out.println("Reactivating deactivated account for user: " + user.getUsername());
                userDAO.reactivateAccount(user.getId());
                user.set_active(true);
            }

            // Login success: create session (HTTP + Database)
            SessionUtil.createSession(request, user);

            // ============================================
            // NEW: Unlock encryption master key
            // ============================================
            try {
                SecretKey masterKey = userDAO.unlockUserMasterKey(user.getId(), password);

                // Store master key in session
                HttpSession session = request.getSession();
                session.setAttribute("masterKey", masterKey);

                // Also store in session DAO cache (for load balancing)
                String sessionId = (String) session.getAttribute("sessionId");
                if (sessionId != null) {
                    userSessionDAO.storeMasterKeyInCache(sessionId, masterKey);
                }

                System.out.println("✓ Encryption keys unlocked for user: " + user.getUsername());

            } catch (Exception e) {
                // User authenticated but encryption keys unavailable (old account or error)
                System.err.println("⚠ Warning: Could not unlock encryption keys for user: " + user.getUsername());
                System.err.println("  Reason: " + e.getMessage());

                // Don't fail login - user can still access app
                // But they won't be able to encrypt/decrypt files
                // You might want to redirect them to setup encryption later
            }
            // ============================================
            // END NEW CODE
            // ============================================

            // Handle "Remember Me" if checkbox is checked
            String rememberMe = rememberMeToken;
            if ("true".equals(rememberMe) || "on".equals(rememberMe)) {
                handleRememberMe(user.getId(), response);
            }

            // Check if admin user and redirect to admin page
            if ("admin".equals(user.getUsername())) {
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }

            // Check for pending invite token (from group invite link)
            HttpSession session = request.getSession();
            String pendingInviteToken = (String) session.getAttribute("pendingInviteToken");
            if (pendingInviteToken != null) {
                session.removeAttribute("pendingInviteToken");
                response.sendRedirect(request.getContextPath() + "/invite/" + pendingInviteToken);
                return;
            }

            // Redirect to original page or /memories
            String returnUrl = request.getParameter("redirect");
            if (returnUrl == null || returnUrl.isEmpty()) {
                returnUrl = request.getParameter("return");
            }
            if (returnUrl != null && !returnUrl.isEmpty()) {
                // Validate redirect URL to prevent open redirect vulnerabilities
                if (returnUrl.startsWith("/") || returnUrl.startsWith(request.getContextPath())) {
                    response.sendRedirect(returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/memories");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/memories");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/login").forward(request, response);
        }
    }

    /**
     * Handle remember me functionality - UNCHANGED
     */
    private void handleRememberMe(int userId, HttpServletResponse response) {
        try {
            String sessionToken = userSessionDAO.createRememberMeToken(userId);

            if (sessionToken != null) {
                Cookie cookie = new Cookie("session_token", sessionToken);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                response.addCookie(cookie);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Check for remember me token and auto-login - UNCHANGED
     */
    private user checkRememberMeToken(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("session_token".equals(cookie.getName())) {
                    try {
                        Integer userId = userSessionDAO.getUserIdByToken(cookie.getValue());
                        if (userId != null) {
                            return userDAO.findById(userId);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                }
            }
        }
        return null;
    }
}

/*
 * CHANGES MADE:
 *
 * 1. Added import: javax.crypto.SecretKey
 * 2. Added ~15 lines after successful authentication to unlock master key
 * 3. Everything else UNCHANGED
 *
 * WHAT THIS DOES:
 * - After user successfully logs in (your existing auth)
 * - Tries to unlock their encryption master key
 * - If successful: stores in session
 * - If fails: logs warning but login still succeeds
 *
 * BACKWARD COMPATIBLE:
 * - Old accounts without encryption: login still works (just can't encrypt
 * files)
 * - New accounts with encryption: login works + can encrypt files
 */