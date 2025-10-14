package com.demo.web.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Clean Subdomain-Based Authentication Filter
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

        // ========================================
        // 1. ALWAYS allow static resources
        // ========================================
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // ========================================
        // 2. Check if this is APP subdomain
        // ========================================
        if (isAppSubdomain(serverName)) {

            // Allow login/register pages on app subdomain
            if (path.equals("/login") || path.equals("/signup") || path.equals("/logout")) {
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
        // If user tries to access an app-only route from the main domain, redirect to app subdomain
        if (isAppOnlyPath(path)) {
            String protocol = req.isSecure() ? "https" : "http";
            int port = req.getServerPort();
            String portStr = (port == 80 || port == 443) ? "" : ":" + port;

            // redirect to app subdomain (handles both local and prod)
            String appDomain = serverName.contains("everly.local") ? "app.everly.local" : "app.everly.com";

            String redirectUrl = protocol + "://" + appDomain + portStr + path;
            if (req.getQueryString() != null) {
                redirectUrl += "?" + req.getQueryString();
            }

            System.out.println("→ Redirecting to app subdomain: " + redirectUrl);
            res.sendRedirect(redirectUrl);
            return;
        }

        // Everything on main domain is public, no auth needed
        chain.doFilter(request, response);
    }

    /**
     * Check if this is the app subdomain
     */
    private boolean isAppSubdomain(String serverName) {
        // Development
        if (serverName.equals("app.everly.local")) return true;

        // Production
        if (serverName.equals("app.everly.com")) return true;

        // Generic check for any "app." subdomain
        return serverName.startsWith("app.");
    }

    /**
     * Check if path is a static resource
     */
    private boolean isStaticResource(String path) {
        String lower = path.toLowerCase();

        // Check file extensions
        if (lower.endsWith(".css") || lower.endsWith(".js") ||
                lower.endsWith(".png") || lower.endsWith(".jpg") ||
                lower.endsWith(".jpeg") || lower.endsWith(".gif") ||
                lower.endsWith(".ico") || lower.endsWith(".svg") ||
                lower.endsWith(".woff") || lower.endsWith(".woff2") ||
                lower.endsWith(".ttf") || lower.endsWith(".map") ||
                lower.endsWith(".webp")) {
            return true;
        }

        // Check directories
        if (lower.startsWith("/css/") || lower.startsWith("/js/") ||
                lower.startsWith("/images/") || lower.startsWith("/img/") ||
                lower.startsWith("/fonts/") || lower.startsWith("/assets/") ||
                lower.startsWith("/static/")) {
            return true;
        }

        return false;
    }

    /**
     * Check if path belongs to the app (authenticated) area
     */
    private boolean isAppOnlyPath(String path) {
        return path.startsWith("/dashboard") ||
                path.startsWith("/photos") ||
                path.startsWith("/upload") ||
                path.startsWith("/albums") ||
                path.startsWith("/settings") ||
                path.startsWith("/profile");
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
            // ignore
        }

        System.out.println("→ Redirecting to login: " + loginUrl);
        res.sendRedirect(loginUrl);
    }

    @Override
    public void destroy() {
        System.out.println("✗ Everly AuthFilter destroyed");
    }
}
