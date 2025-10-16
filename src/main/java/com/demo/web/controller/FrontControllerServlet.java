package com.demo.web.controller;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


public class FrontControllerServlet extends HttpServlet {

    private Map<String, String> routeToJsp;

    @Override
    public void init() {
        routeToJsp = new HashMap<>();

        // Public pages
        routeToJsp.put("/", "/views/public/landing.jsp");
        routeToJsp.put("/login", "/views/public/loginContent.jsp");
        routeToJsp.put("/register", "/views/public/register.jsp");
        routeToJsp.put("/aboutus", "/views/public/about.jsp");
        routeToJsp.put("/contact", "/views/public/contact.jsp");
        routeToJsp.put("/signup", "/views/public/signup.jsp");
        routeToJsp.put("/signup2", "/views/public/signup2.jsp");

        // Protected pages
        routeToJsp.put("/memories", "/views/app/memories.jsp");
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/settings", "/views/app/settings.jsp");
        // add other protected pages here
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

        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Remove trailing slash
        if (path.endsWith("/") && path.length() > 1) {
            path = path.substring(0, path.length() - 1);
        }

        String jsp = routeToJsp.get(path);
        if (jsp != null) {
            request.getRequestDispatcher(jsp).forward(request, response);
        } else {
            // 404
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/views/public/404.jsp").forward(request, response);
        }
    }
}
