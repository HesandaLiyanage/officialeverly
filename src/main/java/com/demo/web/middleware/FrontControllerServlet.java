// File: com/demo/web/middleware/FrontControllerServlet.java
// Refactored version - pure routing, no business logic
package com.demo.web.middleware;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

/**
 * FrontController Servlet - Handles URL routing for the application.
 * 
 * This servlet is responsible ONLY for:
 * 1. Mapping public URLs to JSP views
 * 2. Forwarding requests to appropriate view controllers
 * 
 * Business logic has been moved to the Service layer.
 * View preparation has been moved to ViewController classes.
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB per file
        maxRequestSize = 1024 * 1024 * 100 // 100MB total request
)
public class FrontControllerServlet extends HttpServlet {

    private Map<String, String> routeToJsp;
    private Map<String, String> routeToController;
    private static final Logger logger = Logger.getLogger(FrontControllerServlet.class.getName());

    @Override
    public void init() throws ServletException {
        routeToJsp = new HashMap<>();
        routeToController = new HashMap<>();

        // ========================================
        // PUBLIC PAGES (no authentication needed)
        // ========================================
        routeToJsp.put("/", "/views/public/landing.jsp");
        routeToJsp.put("/login", "/views/public/loginContent.jsp");
        routeToJsp.put("/register", "/views/public/register.jsp");
        routeToJsp.put("/aboutus", "/views/public/aboutus.jsp");
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

        // ========================================
        // PROTECTED PAGES (static JSPs - no data fetching)
        // ========================================
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/collabmemories", "/views/app/collabmemories.jsp");
        routeToJsp.put("/settingsaccount", "/views/app/settingsaccount.jsp");
        routeToJsp.put("/settingsnotifications", "/views/app/settingsnotifications.jsp");
        routeToJsp.put("/settingsprivacy", "/views/app/settingsprivacy.jsp");
        routeToJsp.put("/storagesense", "/views/app/storagesense.jsp");
        routeToJsp.put("/settingsappearance", "/views/app/settingsappearance.jsp");
        routeToJsp.put("/vaultForgotPassword", "/views/app/vaultForgotPassword.jsp");
        routeToJsp.put("/vaultmemories", "/views/app/vaultMemories.jsp");
        routeToJsp.put("/vaultPassword", "/views/app/vaultPassword.jsp");
        routeToJsp.put("/vaultSetup", "/views/app/vaultSetup.jsp");
        routeToJsp.put("/addautograph", "/views/app/Autographs/addautograph.jsp");
        routeToJsp.put("/duplicatefinder", "/views/app/duplicatefinder.jsp");
        routeToJsp.put("/morethemes", "/views/app/morethemes.jsp");
        routeToJsp.put("/sharedlinks", "/views/app/sharedlinks.jsp");
        routeToJsp.put("/trashmgt", "/views/app/trashmgt.jsp");
        routeToJsp.put("/notifications", "/views/app/notifications.jsp");
        routeToJsp.put("/groupprofile", "/views/app/groupprofile.jsp");
        routeToJsp.put("/groupmembers", "/views/app/groupmembers.jsp");
        routeToJsp.put("/groupannouncement", "/views/app/groupannouncement.jsp");
        routeToJsp.put("/writeautograph", "/views/app/writeautograph.jsp");
        routeToJsp.put("/eventinfo", "/views/app/eventinfo.jsp");
        routeToJsp.put("/creatememory", "/views/app/creatememory.jsp");
        routeToJsp.put("/creategroup", "/views/app/creategroup.jsp");
        routeToJsp.put("/memoryrecap", "/views/app/memoryrecap.jsp");
        routeToJsp.put("/writejournal", "/views/app/writejournal.jsp");
        routeToJsp.put("/vaultjournals", "/views/app/vaultjournals.jsp");
        routeToJsp.put("/feedWelcome", "/views/app/feedWelcome.jsp");
        routeToJsp.put("/feedProfileSetup", "/views/app/feedProfileSetup.jsp");
        routeToJsp.put("/userprofile", "/views/app/userprofile.jsp");
        routeToJsp.put("/followerprofile", "/views/app/followerprofile.jsp");
        routeToJsp.put("/followingprofile", "/views/app/followingprofile.jsp");
        routeToJsp.put("/vaultpassword", "/views/app/vaultpassword.jsp");

        // Comment routes - use controller for data loading
        routeToController.put("/feedcomment", "/viewComments");
        routeToController.put("/comments", "/viewComments");
        routeToJsp.put("/feededitprofile", "/views/app/editpublicprofile.jsp");
        routeToJsp.put("/blockedusers", "/views/app/blockedusers.jsp");
        routeToJsp.put("/vaultentries", "/views/app/vaultentries.jsp");
        routeToJsp.put("/collabmemoryview", "/views/app/collabmemoryview.jsp");

        // Admin pages
        routeToJsp.put("/admin", "/views/app/Admin/admindahboard.jsp");
        routeToJsp.put("/adminuser", "/views/app/Admin/adminuser.jsp");
        routeToJsp.put("/adminsettings", "/views/app/Admin/adminsettings.jsp");
        routeToJsp.put("/adminanalytics", "/views/app/Admin/adminanalytics.jsp");
        routeToJsp.put("/admincontent", "/views/app/Admin/admincontent.jsp");

        // ========================================
        // ROUTES TO VIEW CONTROLLERS (need data fetching)
        // Business logic is in Service layer, view prep in Controllers
        // ========================================

        // Settings controllers
        routeToController.put("/linkeddevices", "/linkeddevicesview");
        routeToController.put("/editprofile", "/editprofileview");

        // Autograph routes (all handled by AutographViewController)
        routeToController.put("/autographs", "/autographsview");
        routeToController.put("/autographview", "/autographsview?action=view");
        routeToController.put("/editautograph", "/autographsview?action=edit");

        // Group routes (all handled by GroupViewController)
        routeToController.put("/groups", "/groupsview");
        routeToController.put("/groupmemories", "/groupsview?action=memories");
        routeToController.put("/editgroup", "/groupsview?action=edit");

        // Event routes (all handled by EventViewController)
        routeToController.put("/events", "/eventsview");
        routeToController.put("/createevent", "/eventsview?action=create");
        routeToController.put("/editevent", "/eventsview?action=edit");

        // Journal routes (all handled by JournalViewController)
        routeToController.put("/journals", "/journalsview");
        routeToController.put("/journalview", "/journalsview?action=view");
        routeToController.put("/editjournal", "/journalsview?action=edit");

        // Feed route (checks for feed profile before showing)
        routeToController.put("/feed", "/feedview");

        // Feed profile view route
        routeToController.put("/publicprofile", "/feedprofileview");

        // Edit feed profile route
        routeToController.put("/feededitprofile", "/feededitprofileview");

        // Followers/Following routes
        routeToController.put("/followers", "/followersview?type=followers");
        routeToController.put("/following", "/followersview?type=following");

        // Create post route
        routeToController.put("/createPost", "/createPostServlet");
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

        logger.info("FrontController: Handling request for path: " + path);

        // ========================================
        // SPECIAL SERVLET ROUTES
        // These forward to specific servlets (not JSPs or view controllers)
        // ========================================

        // Memory routes -> Memory servlets
        if ("/memories".equals(path)) {
            request.getRequestDispatcher("/memoriesview").forward(request, response);
            return;
        }
        if ("/memoryview".equals(path)) {
            request.getRequestDispatcher("/memoryViewServlet").forward(request, response);
            return;
        }
        if ("/editmemory".equals(path)) {
            request.getRequestDispatcher("/editMemoryServlet").forward(request, response);
            return;
        }
        if ("/updatememory".equals(path)) {
            request.getRequestDispatcher("/updateMemoryServlet").forward(request, response);
            return;
        }
        if ("/deletememory".equals(path)) {
            request.getRequestDispatcher("/deleteMemoryServlet").forward(request, response);
            return;
        }
        if ("/viewMedia".equals(path) || "/viewmedia".equals(path)) {
            request.getRequestDispatcher("/viewmedia").forward(request, response);
            return;
        }

        // POST-specific routes
        if ("POST".equals(request.getMethod())) {
            if ("/createMemory".equals(path)) {
                request.getRequestDispatcher("/createMemoryServlet").forward(request, response);
                return;
            }
        }

        // ========================================
        // VIEW CONTROLLER ROUTES
        // Forward to view controllers that handle data fetching
        // ========================================
        String controllerPath = routeToController.get(path);
        if (controllerPath != null) {
            logger.info("Forwarding to view controller: " + controllerPath);

            // Preserve original query parameters
            String queryString = request.getQueryString();
            if (queryString != null && !controllerPath.contains("?")) {
                controllerPath += "?" + queryString;
            } else if (queryString != null) {
                controllerPath += "&" + queryString;
            }

            request.getRequestDispatcher(controllerPath).forward(request, response);
            return;
        }

        // ========================================
        // STATIC JSP ROUTES
        // Direct JSP mappings (no data fetching needed)
        // ========================================
        String jsp = routeToJsp.get(path);
        if (jsp != null) {
            logger.info("Forwarding to JSP: " + jsp);
            request.getRequestDispatcher(jsp).forward(request, response);
            return;
        }

        // ========================================
        // 404 - NOT FOUND
        // ========================================
        logger.warning("Path not found: " + path);
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        request.getRequestDispatcher("/views/public/404.jsp").forward(request, response);
    }
}