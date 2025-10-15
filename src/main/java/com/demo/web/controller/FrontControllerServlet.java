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

public class FrontControllerServlet extends HttpServlet {

    private Set<String> publicRoutes;
    private Set<String> protectedRoutes;

    @Override
    public void init() throws ServletException {
        // Initialize public routes (no login required)
        publicRoutes = new HashSet<>(Arrays.asList(
                "/",
                "/login",
                "/signup",
                "/about",
                "/contact",
                "/register",
                "/whyeverly",
                "/plans"
        ));

        // Initialize protected routes (require login)
        protectedRoutes = new HashSet<>(Arrays.asList(
                "/dashboard",
                "/memories",
                "/profile",
                "/settings",
                "/admin",
                "/photos",
                "/upload",
                "/albums"
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

        // Remove context path from the URL
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        // Handle trailing slash
        if (path.endsWith("/") && path.length() > 1) {
            path = path.substring(0, path.length() - 1);
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

    private String getJspFileForRoute(String path) {
        // First check if it's a specific mapped route
        switch (path) {
            case "/":
                return "/views/public/landing.jsp";
            case "/login":
                return "/views/public/loginContent.jsp";
            case "/signup":
                return "/views/public/signup.jsp";
            case "/about":
                return "/views/public/about.jsp";
            case "/contact":
                return "/views/public/contact.jsp";
            case "/register":
                return "/views/public/register.jsp";
            case "/whyeverly":
                return "/views/public/whyeverly.jsp";
            case "/plans":
                return "/views/public/plans.jsp";
            case "/dashboard":
                return "/views/app/dashboard.jsp";
            case "/memories":
                return "/views/app/memories.jsp";
            case "/profile":
                return "/views/app/profile.jsp";
            case "/settings":
                return "/views/app/settings.jsp";
            case "/admin":
                return "/views/app/admin.jsp";
            case "/photos":
                return "/views/app/photos.jsp";
            case "/upload":
                return "/views/app/upload.jsp";
            case "/albums":
                return "/views/app/albums.jsp";
        }

        // For routes not in the switch statement, try to find corresponding JSP
        if (path.startsWith("/")) {
            // Try public folder first
            String publicJsp = "/views/public" + path + ".jsp";
            // Try app folder second
            String appJsp = "/views/app" + path + ".jsp";

            // You might want to implement file existence checking here
            // For now, just return one of them
            return publicJsp; // Default to public
        }

        return null; // Route not found
    }
}