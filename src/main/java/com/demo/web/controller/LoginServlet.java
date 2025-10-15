package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;

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
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        // Check for remember me cookie
        user rememberedUser = checkRememberMeToken(request);
        if (rememberedUser != null) {
            // Auto-login with remember me
            createUserSession(request, rememberedUser);
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
        String rememberMe = request.getParameter("remember_me");

        // Input validation
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login").forward(request, response);
            return;
        }

        try {
            // Authenticate user using DAO
            user user = userDAO.authenticateUser(username, password);

            if (user != null) {
                // Create session
                createUserSession(request, user);

                // Handle remember me functionality
                if ("on".equals(rememberMe)) {
                    handleRememberMe(user.getId(), response);
                }

                // Update last login
                userDAO.updateLastLogin(user.getId());

                // Store session in database with device information
                HttpSession httpSession = request.getSession();
                String deviceName = getDeviceName(request);
                String deviceType = getDeviceType(request.getHeader("User-Agent"));
                String ipAddress = getClientIpAddress(request);
                String userAgent = request.getHeader("User-Agent");

                userSessionDAO.createSession(user.getId(), httpSession.getId(),
                        deviceName, deviceType, ipAddress, userAgent);

                // Redirect to memories page
                response.sendRedirect(request.getContextPath() + "/memories");

            } else {
                // Authentication failed
                request.setAttribute("error", "Invalid username or password");
                request.setAttribute("username", username); // Preserve username
                request.getRequestDispatcher("/login").forward(request, response);
            }

        } catch (Exception e) {
            // Log the exception (use proper logging framework)
            e.printStackTrace();

            request.setAttribute("error", "An error occurred during login. Please try again.");
            request.getRequestDispatcher("/login").forward(request, response);
        }
    }

    /**
     * Create user session
     */
    private void createUserSession(HttpServletRequest request, user user) {
        HttpSession session = request.getSession();
        session.setAttribute("user_id", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("email", user.getEmail());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
    }

    /**
     * Handle remember me functionality
     */
    private void handleRememberMe(int userId, HttpServletResponse response) {
        try {
            String sessionToken = userSessionDAO.createRememberMeToken(userId);

            if (sessionToken != null) {
                // Create cookie
                Cookie cookie = new Cookie("session_token", sessionToken);
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

        } catch (Exception e) {
            // Log error but don't fail login
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

    /**
     * Get device name from request
     */
    private String getDeviceName(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return "Unknown Device";
        }

        // Simple device detection
        if (userAgent.contains("Windows")) {
            return "Windows PC";
        } else if (userAgent.contains("Mac")) {
            return "Mac";
        } else if (userAgent.contains("Linux")) {
            return "Linux PC";
        } else if (userAgent.contains("Android")) {
            return "Android Device";
        } else if (userAgent.contains("iPhone") || userAgent.contains("iPad")) {
            return "iOS Device";
        } else {
            return "Unknown Device";
        }
    }

    /**
     * Get device type from user agent
     */
    private String getDeviceType(String userAgent) {
        if (userAgent == null) {
            return "Unknown";
        }

        if (userAgent.contains("Mobile") || userAgent.contains("Android") ||
                userAgent.contains("iPhone") || userAgent.contains("Windows Phone")) {
            return "Mobile";
        } else if (userAgent.contains("iPad") || userAgent.contains("Tablet")) {
            return "Tablet";
        } else {
            return "Desktop";
        }
    }

    /**
     * Get client IP address
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("X-Real-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("X-Forwarded-For");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}