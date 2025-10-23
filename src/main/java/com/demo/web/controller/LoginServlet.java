package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;
import com.demo.web.util.PasswordUtil;
import com.demo.web.util.SessionUtil;

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

        // Show login form
        request.getRequestDispatcher("/login").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/login").forward(request, response);
            return;
        }

        // Authenticate user
        user user = userDAO.findByUsername(username);
        if (user != null && PasswordUtil.verifyPassword(password, user.getSalt(), user.getPassword())) {
            // Login success: create session (HTTP + Database)
            SessionUtil.createSession(request, user);

            // Handle "Remember Me" if checkbox is checked
            String rememberMe = request.getParameter("remember_me");
            if ("true".equals(rememberMe) || "on".equals(rememberMe)) {
                handleRememberMe(user.getId(), response);
            }

            // Redirect to original page or /memories
            String returnUrl = request.getParameter("return");
            if (returnUrl != null && !returnUrl.isEmpty()) {
                response.sendRedirect(request.getContextPath() + returnUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/memories");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/login").forward(request, response);
        }
    }

    /**
     * Handle remember me functionality
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
     * Check for remember me token and auto-login
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