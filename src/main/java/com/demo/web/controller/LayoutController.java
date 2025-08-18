package com.demo.web.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LayoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();               // e.g., /myApp/dashboard
        String contextPath = req.getContextPath();      // e.g., /myApp
        String path = uri.substring(contextPath.length()); // e.g., /dashboard

        // Skip static files (like .css, .js, etc.)
        if (path.matches("^/(resources|css|js|images)/.*") || path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg)$")) {
            req.getRequestDispatcher(path).forward(req, resp);
            return;
        }

        // Extract the page name
        String page = path;
        if (page.startsWith("/")) {
            page = page.substring(1); // Remove the leading '/'
        }
        if (page.isEmpty()) {
            page = "landing"; // Default page
        }

        String contentPage;
        String layoutType;

        switch (page) {
            // Public pages
            case "landing":
            case "about":
            case "contact":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "public";
                break;

            // Auth pages
            case "login":
            case "signup":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "auth";
                break;

            // Dashboard pages
            case "dashboard":
            case "settings":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "dashboard";
                break;

            // Feed
            case "feed":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "feed";
                break;
            case "memories":
                contentPage = "/fragments/memories.jsp";
                break;
            case "journals":
                contentPage = "/fragments/journals.jsp";
                break;
            case "memories":
                contentPage = "/fragments/memories.jsp";
                break;
            case "journals":
                contentPage = "/fragments/journals.jsp";
                break;
            case "autographs":
                contentPage = "/fragments/autographcontent.jsp";
                break;
            case "groups":
                contentPage = "/fragments/autographcontent.jsp";
                break;
            case "events":
                contentPage = "/fragments/autographcontent.jsp";
                break;
            case "feed":
                contentPage = "/fragments/autographcontent.jsp";
                break;
            case "settings":
                contentPage = "/fragments/autographcontent.jsp";
                break;
            default:
                contentPage = "/fragments/404.jsp";
                layoutType = "public";
                break;
        }

        req.setAttribute("contentPage", contentPage);
        req.setAttribute("layoutType", layoutType);
        req.getRequestDispatcher("/layout.jsp").forward(req, resp);
    }
}
