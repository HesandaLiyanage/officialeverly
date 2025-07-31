package com.demo.web.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LayoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String page = req.getParameter("page");
        if (page == null || page.isEmpty()) {
            page = "landing"; // Default page
        }

        String contentPage;
        String layoutType;

        switch (page) {
            // Public pages (landing, about, etc.)
            case "landing":
            case "about":
            case "contact":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "public";
                break;

            // Auth pages (login, signup)
            case "login":
            case "signup":
                contentPage = "/fragments/" + page + "Content.jsp";
                layoutType = "auth";
                break;

            // App pages (dashboard etc.)
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
