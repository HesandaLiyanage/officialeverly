package com.demo.web.controller;

import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        System.out.println("=== LogoutServlet: Processing logout ===");

        // Revoke session (both HTTP session and database session)
        SessionUtil.revokeSession(request);
        System.out.println("Session revoked");

        // Clear the "Remember Me" cookie if it exists
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("session_token".equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setMaxAge(0); // Delete the cookie
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    System.out.println("Remember Me cookie cleared");
                    break;
                }
            }
        }

        System.out.println("Redirecting to landing page");

        // Redirect to landing page
        response.sendRedirect(request.getContextPath() + "/");
    }
}