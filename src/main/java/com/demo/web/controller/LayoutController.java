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


        String contentPage;
        String layoutPage;
        switch (page) {
            case "login":
                contentPage = "/loginContent.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "signup":
                contentPage = "/fragments/signup.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "signup2":
                contentPage = "/signup2.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "forgotpassword":
                contentPage = "/passwordreset.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "profile":
                contentPage = "/signup2.jsp";
                layoutPage = "/layout.jsp";
                break;
            case "signupThankyou":
                contentPage = "/signupThankyou.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "vaultSetup":
                contentPage = "/fragments/vaultSetup.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "vaultPassword":
                contentPage = "/fragments/vaultPassword.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "vaultForgotPassword":
                contentPage = "/fragments/vaultForgotPassword.jsp";
                layoutPage = "/layout2.jsp";
                break;
            case "vaultMemories":
                contentPage = "/fragments/vaultMemories.jsp";
                layoutPage = "/layout2.jsp";
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
                layoutPage = "/layout2.jsp";
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
                contentPage = "/404.jsp";
                break;
        }

        req.setAttribute("contentPage", contentPage);
        req.getRequestDispatcher(layoutPage).forward(req, resp);
    }
}