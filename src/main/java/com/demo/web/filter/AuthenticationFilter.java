package com.demo.web.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Clean Subdomain-Based Authentication Filter
 *
 * Two domains, completely separate:
 *
 * PUBLIC DOMAIN (no authentication):
 *   - everly.local:8080/
 *   - everly.local:8080/contact
 *   - everly.local:8080/login
 *   - everly.local:8080/register
 *
 * APP DOMAIN (requires authentication for EVERYTHING):
 *   - app.everly.local:8080/
 *   - app.everly.local:8080/photos
 *   - app.everly.local:8080/upload
 *   - app.everly.local:8080/albums
 *
 * Production will be:
 *   - everly.com (public)
 *   - app.everly.com (authenticated)
 */

public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✓ Everly AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String serverName = req.getServerName();
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Debug log
        System.out.println("→ " + serverName + path);

        // Skip static resources - let them through without authentication
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ========================================
        // 2. Check if this is APP subdomain
        // ========================================
        if (isAppSubdomain(serverName)) {

            // Allow login/register pages on app subdomain
            if (path.equals("/login") || path.equals("/register") || path.equals("/logout")) {
                chain.doFilter(request, response);
                return;
            }

            // EVERYTHING ELSE on app.everly requires authentication
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                // Not logged in - redirect to main domain login
                redirectToLogin(req, res, serverName);
                return;
            }

            // User is authenticated - allow access
            chain.doFilter(request, response);
            return;
        }

        // ========================================
        // 3. Main domain (everly.local) - all public
        // ========================================
        // Everything on main domain is public, no auth needed
        chain.doFilter(request, response);
    }



    // Add this method to your AuthenticationFilter class
    private boolean isStaticResource(String path) {
        return path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".jpg") || path.endsWith(".png") ||
                path.endsWith(".gif") || path.endsWith(".ico") ||
                path.endsWith(".svg") || path.endsWith(".jpeg") ||
                path.endsWith(".woff") || path.endsWith(".woff2") ||
                path.endsWith(".ttf") || path.endsWith(".eot");
    }


    /**
     * Check if this is the app subdomain
     */
    private boolean isAppSubdomain(String serverName) {
        // Development
        if (serverName.equals("app.everly.local")) {
            return true;
        }

        // Production
        if (serverName.equals("app.everly.com")) {
            return true;
        }

        // Generic check for any "app." subdomain
        if (serverName.startsWith("app.")) {
            return true;
        }

        return false;
    }

    /**
     * Redirect unauthenticated user to login on main domain
     */
    private void redirectToLogin(HttpServletRequest req, HttpServletResponse res,
                                 String currentDomain) throws IOException {

        // For AJAX requests, return 401 instead of redirect
        if ("XMLHttpRequest".equals(req.getHeader("X-Requested-With"))) {
            res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Build login URL on main domain
        String protocol = req.isSecure() ? "https" : "http";
        int port = req.getServerPort();
        String portStr = (port == 80 || port == 443) ? "" : ":" + port;

        // Determine main domain
        String mainDomain;
        if (currentDomain.contains("everly.local")) {
            mainDomain = "everly.local";
        } else if (currentDomain.contains("everly.com")) {
            mainDomain = "everly.com";
        } else {
            mainDomain = currentDomain.replace("app.", "");
        }

        // Build login URL with return parameter
        String loginUrl = protocol + "://" + mainDomain + portStr +
                req.getContextPath() + "/login";

        // Add return URL (where they were trying to go)
        String returnUrl = req.getRequestURL().toString();
        if (req.getQueryString() != null) {
            returnUrl += "?" + req.getQueryString();
        }

        try {
            loginUrl += "?return=" + java.net.URLEncoder.encode(returnUrl, "UTF-8");
        } catch (Exception e) {
            // If encoding fails, just redirect without return URL
        }

        System.out.println("→ Redirecting to login: " + loginUrl);
        res.sendRedirect(loginUrl);
    }

}