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
            page = "login"; // default page
        }


        String contentPage,layoutPage;
        switch (page) {
            case "login":
                contentPage = "/fragments/loginContent.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "memories":
                contentPage = "/fragments/memories.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "journals":
                contentPage = "/fragments/journals.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "autographs":
                contentPage = "/fragments/autographcontent.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "viewautograph":
                contentPage = "/fragments/viewautograph.jsp";
                break;
            case "groups":
                contentPage = "/fragments/autographcontent.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "events":
                contentPage = "/fragments/autographcontent.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "feed":
                contentPage = "/fragments/autographcontent.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "settings":
                contentPage = "/fragments/autographcontent.jsp";
                layoutPage = "/layout2.jsp";
                break;
            default:
                layoutPage = "/layout.jsp";
                contentPage = "/fragments/404.jsp";
                break;
        }

        req.setAttribute("contentPage", contentPage);
        req.getRequestDispatcher(layoutPage).forward(req, resp);
    }
}