package com.demo.web.controller;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class MainServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Redirect to the layout controller with login page
        resp.sendRedirect("view?page=login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Handle form submissions or other POST requests
        doGet(req, resp);
    }
}