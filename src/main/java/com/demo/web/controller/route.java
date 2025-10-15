package com.demo.web.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class route extends HttpServlet {

    // Routes that don't require authentication
    private Set<String> publicRoutes;

    // Routes that require authentication
    private Set<String> protectedRoutes;

    @Override
    public void init() throws ServletException {
        // Initialize public routes (no login required)
        publicRoutes = new HashSet<>(Arrays.asList(
                "/",
                "/signup",
                "/login",
                "/about",
                "/signup2",
                "/logincontent"
        ));

        // Initialize protected routes (require login)
        protectedRoutes = new HashSet<>(Arrays.asList(
                "/dashboard",
                "/memories",
                "/profile",
                "/settings",
                "/admin"
        ));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        String contextPath = request.getContextPath();

        // CRITICAL FIX: Ignore JSP files and static resources to prevent infinite loops
        if (path.endsWith(".jsp") || path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".jpg") || path.endsWith(".png") || path.endsWith(".gif") ||
                path.endsWith(".ico") || path.endsWith(".svg")) {
            // Let the default servlet handle these
            request.getRequestDispatcher(path).forward(request, response);
            return;
        }

        // Remove context path from the URL
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        // Handle trailing slash
        if (path.endsWith("/") && path.length() > 1) {
            path = path.substring(0, path.length() - 1);
        }

        if (path.equals("/login") && !isUserAuthenticated(request)) {
            // We're already trying to access login page
            request.getRequestDispatcher("/views/public/loginContent.jsp").forward(request, response);
            return;
        }

        // Check if route requires authentication
        if (isProtectedRoute(path)) {
            if (!isUserAuthenticated(request)) {
                // Redirect to login page
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        // Get the JSP file for the route
        String jspFile = getJspFileForRoute(path);

        if (jspFile != null) {
            // Forward to the appropriate JSP file
            request.getRequestDispatcher(jspFile).forward(request, response);
        } else {
            // Handle 404 - route not found
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/views/public/404.jsp").forward(request, response);
        }
    }

    private boolean isProtectedRoute(String path) {

        // If it's in public routes, it's not protected
        if (publicRoutes.contains(path)) {
            return false;
        }

        // Check if it's explicitly in protected routes
        if (protectedRoutes.contains(path)) {
            return true;
        }


        // Default: if not explicitly defined, assume it's protected
        // This is a security-first approach
        return true;
    }

    private boolean isUserAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
        // Adjust this based on what you store in session for authentication
        // Examples: "user", "userId", "username", "isLoggedIn", etc.
    }

    private String getJspFileForRoute(String path) {
        // First check if it's a specific mapped route
        switch (path) {
            case "/":
                return "/landing.jsp";
            case "/signup":
                return "/views/public/signup.jsp";
            case "/memories":
                return "/memories.jsp";
            case "/about":
                return "/about.jsp";
            case "/signup2":
                return "/views/public/signup2.jsp";
            case "/login":
                return "/views/public/loginContent.jsp";
            case "/dashboard":
                return "/dashboard.jsp";
            case "/profile":
                return "/profile.jsp";
            case "/settings":
                return "/settings.jsp";
            case "/admin":
                return "/admin.jsp";
            // Add other specific mappings as needed
        }



        // For routes not in the switch statement, use automatic mapping
        // Convert /abc to /abc.jsp
        if (path.startsWith("/")) {
            String jspFileName = path.substring(1) + ".jsp"; // Remove leading slash and add .jsp
            return "/" + jspFileName;
        }

        return null; // Route not found
    }
}