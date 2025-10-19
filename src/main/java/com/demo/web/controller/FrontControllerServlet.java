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
        routeToJsp.put("/404", "/views/public/404.jsp");
        routeToJsp.put("/checkyourinbox", "/views/public/checkyourinbox.jsp");
        routeToJsp.put("/emailsentreset", "/views/public/emailsentreset.jsp");
        routeToJsp.put("/emailresetsuccess", "/views/public/emailresetsuccess.jsp");
        routeToJsp.put("/footer", "/views/public/footer.jsp");
        routeToJsp.put("/forgotpassword", "/views/public/forgotpassword.jsp");
        routeToJsp.put("/header", "/views/public/header.jsp");
        routeToJsp.put("/header2", "/views/public/header2.jsp");
        routeToJsp.put("/index", "/views/public/index.jsp");
        routeToJsp.put("/layout", "/views/public/layout.jsp");
        routeToJsp.put("/layout2", "/views/public/layout2.jsp");
        routeToJsp.put("/passwordreset", "/views/public/passwordreset.jsp");
        routeToJsp.put("/passwordresetenterpassword", "/views/public/passwordreset-enterpassword.jsp");
        routeToJsp.put("/plans", "/views/public/plans.jsp");
        routeToJsp.put("/signupthankyou", "/views/public/signupThankyou.jsp");
        routeToJsp.put("/whyeverly", "/views/public/whyeverly.jsp");
        routeToJsp.put("/youcantaccessthis", "/views/public/youcantaccessthis.jsp");
        routeToJsp.put("/privacy", "/views/public/privacy.jsp");
        routeToJsp.put("/aboutus", "/views/public/aboutus.jsp");
        routeToJsp.put("/resources/assets/landing.mp4", "/resources/assets/landing.mp4");



        // Protected pages
        routeToJsp.put("/memories", "/views/app/memories.jsp");
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/autographs", "/views/app/autographcontent.jsp");
        routeToJsp.put("/journals", "/views/app/journals.jsp");
        routeToJsp.put("/settingsaccount", "/views/app/settingsaccount.jsp");
        routeToJsp.put("/settingsappearance", "/views/app/settingsappearance.jsp");
        routeToJsp.put("/settingsnotifications", "/views/app/settingsnotifications.jsp");
        routeToJsp.put("/settingsprivacy", "/views/app/settingsprivacy.jsp");
        routeToJsp.put("/storagesense", "/views/app/storagesense.jsp");
        routeToJsp.put("/vaultForgotPassword", "/views/app/vaultForgotPassword.jsp");
        routeToJsp.put("/vaultmemories", "/views/app/vaultMemories.jsp");
        routeToJsp.put("/vaultPassword", "/views/app/vaultPassword.jsp");
        routeToJsp.put("/vaultSetup", "/views/app/vaultSetup.jsp");
        routeToJsp.put("/autographview", "/views/app/viewautograph.jsp");
        routeToJsp.put("/addautograph", "/views/app/addautograph.jsp");
        routeToJsp.put("/duplicatefinder", "/views/app/duplicatefinder.jsp");
        routeToJsp.put("/morethemes", "/views/app/morethemes.jsp");
        routeToJsp.put("/sharedlinks", "/views/app/sharedlinks.jsp");
        routeToJsp.put("/trashmgt", "/views/app/trashmgt.jsp");
        routeToJsp.put("/editprofile", "/views/app/settingsaccounteditprofile.jsp");
        routeToJsp.put("/linkeddevices", "/views/app/linkeddevices.jsp");
        routeToJsp.put("/memoryview", "/views/app/memoryview.jsp");
        routeToJsp.put("/creatememory", "/views/app/creatememory.jsp");
        routeToJsp.put("/notifications", "/views/app/notifications.jsp");
        routeToJsp.put("/groups", "/views/app/groupdashboard.jsp");
        routeToJsp.put("/groupprofile", "/views/app/groupprofile.jsp");
        routeToJsp.put("/groupmemories", "/views/app/groupmemories.jsp");
        routeToJsp.put("/groupmembers", "/views/app/groupmembers.jsp");
        routeToJsp.put("/groupannouncement", "/views/app/groupannouncement.jsp");
        routeToJsp.put("/events", "/views/app/eventinfo.jsp");
        routeToJsp.put("/writeautograph", "/views/app/writeautograph.jsp");










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
