package com.demo.web.filter;

import com.demo.web.util.DatabaseUtil;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialize database connection
        DatabaseUtil.initialize(filterConfig.getServletContext());
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        //if the page we are trying to access is the login page, allow it

        String queryString = httpRequest.getQueryString();
        String uri = httpRequest.getRequestURI();

        if ((queryString != null && (queryString.contains("page=login")
                || queryString.contains("page=signup")
                || queryString.contains("page=signup2")))
                || uri.endsWith("/login.jsp")
                || uri.endsWith("/signup.jsp")
                || uri.endsWith("/signup2.jsp")) {
            // Allow login page to be accessed without authentication
            chain.doFilter(request, response);
            return;
        }

        // Check if user is authenticated
        if (isAuthenticated(httpRequest)) {
            // User is authenticated, continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not authenticated, redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/youcantaccessthis.jsp");
        }
    }

    private boolean isAuthenticated(HttpServletRequest request) {
        // First check session
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            return true;
        }

        // Check for remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("session_token".equals(cookie.getName())) {
                    return validateSessionToken(cookie.getValue(), request);
                }
            }
        }

        return false;
    }

    private boolean validateSessionToken(String sessionToken, HttpServletRequest request) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT us.user_id, us.expires_at, u.username " +
                    "FROM user_sessions us " +
                    "JOIN users u ON us.user_id = u.id " +
                    "WHERE us.session_id = ? AND us.is_active = true AND us.expires_at > ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sessionToken);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));

            rs = stmt.executeQuery();

            if (rs.next()) {
                // Valid session found, create HTTP session
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("username", rs.getString("username"));
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}