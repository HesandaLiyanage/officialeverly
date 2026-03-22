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
        routeToJsp.put("/", "/WEB-INF/views/public/landing.jsp");
        routeToJsp.put("/login", "/WEB-INF/views/public/loginContent.jsp");
        // /register and /contact removed - JSPs don't exist
        routeToJsp.put("/aboutus", "/WEB-INF/views/public/aboutus.jsp");
        routeToJsp.put("/signup", "/WEB-INF/views/public/signup.jsp");
        routeToJsp.put("/signup2", "/WEB-INF/views/public/signup2.jsp");
        routeToJsp.put("/404", "/WEB-INF/views/public/404.jsp");
        routeToJsp.put("/checkyourinbox", "/WEB-INF/views/public/checkyourinbox.jsp");
        routeToJsp.put("/emailsentreset", "/WEB-INF/views/public/emailsentreset.jsp");
        routeToJsp.put("/emailresetsuccess", "/WEB-INF/views/public/emailresetsuccess.jsp");
        routeToJsp.put("/footer", "/WEB-INF/views/public/footer.jsp");
        routeToJsp.put("/forgotpassword", "/WEB-INF/views/public/forgotpassword.jsp");
        routeToJsp.put("/header", "/WEB-INF/views/public/header.jsp");
        routeToJsp.put("/header2", "/WEB-INF/views/public/header2.jsp");
        routeToJsp.put("/index", "/WEB-INF/views/public/index.jsp");
        routeToJsp.put("/layout", "/WEB-INF/views/public/layout.jsp");
        routeToJsp.put("/layout2", "/WEB-INF/views/public/layout2.jsp");
        routeToJsp.put("/passwordreset", "/WEB-INF/views/public/passwordreset.jsp");
        routeToJsp.put("/passwordresetenterpassword", "/WEB-INF/views/public/passwordreset-enterpassword.jsp");
        routeToJsp.put("/plans", "/WEB-INF/views/public/plans.jsp");
        routeToJsp.put("/signupthankyou", "/WEB-INF/views/public/signupThankyou.jsp");
        routeToJsp.put("/whyeverly", "/WEB-INF/views/public/whyeverly.jsp");
        routeToJsp.put("/youcantaccessthis", "/WEB-INF/views/public/youcantaccessthis.jsp");
        routeToJsp.put("/privacy", "/WEB-INF/views/public/privacy.jsp");

        // ========================================
        // PROTECTED PAGES (static JSPs - no data fetching)
        // ========================================
        routeToJsp.put("/dashboard", "/WEB-INF/views/app/dashboard.jsp");
        // /profile removed - profile.jsp doesn't exist; use /publicprofile instead
        routeToController.put("/collabmemories", "/collabmemoriesview");
        routeToJsp.put("/settingsaccount", "/WEB-INF/views/app/Settings/settingsaccount.jsp");
        // /managesubscription handled by web.xml ManageSubscriptionController
        routeToController.put("/changeplan", "/changeplanview");
        routeToController.put("/familyplan", "/familyplanview");
        routeToController.put("/settingsnotifications", "/notificationprefsapi");
        routeToJsp.put("/settingsprivacy", "/WEB-INF/views/app/Settings/settingsprivacy.jsp");
        // /settingssubscription handled by web.xml SettingsSubscriptionController
        routeToController.put("/storagesense", "/storagesenseview");
        routeToJsp.put("/vaultForgotPassword", "/WEB-INF/views/app/Vault/vaultForgotPassword.jsp");
        routeToJsp.put("/vaultmemories", "/WEB-INF/views/app/Vault/vaultMemories.jsp");
        routeToJsp.put("/vaultPassword", "/WEB-INF/views/app/Vault/vaultPassword.jsp");
        routeToJsp.put("/vaultSetup", "/WEB-INF/views/app/Vault/vaultSetup.jsp");
        routeToJsp.put("/addautograph", "/WEB-INF/views/app/Autographs/addautograph.jsp");
        routeToController.put("/duplicatefinder", "/duplicatefinderview");
        // /morethemes removed - Appearance feature removed
        // /sharedlinks handled by web.xml SharedLinksController
        routeToController.put("/trashmgt", "/trashmgtview");
        routeToController.put("/notifications", "/notificationsapi");
        routeToJsp.put("/groupprofile", "/WEB-INF/views/app/Groups/groupprofile.jsp");
        routeToController.put("/groupmembers", "/groupmembersservlet");
        routeToController.put("/groupannouncement", "/groupannouncementservlet");
        routeToController.put("/createannouncement", "/createannouncementservlet");
        routeToController.put("/viewannouncement", "/viewannouncementservlet");
        // /writeautograph removed - actual feature uses /write-autograph via
        // @WebServlet
        routeToJsp.put("/creatememory", "/WEB-INF/views/app/Memory/creatememory.jsp");
        routeToController.put("/memoryrecap", "/memoryrecapview");
        routeToJsp.put("/writejournal", "/WEB-INF/views/app/Journals/writejournal.jsp");
        routeToJsp.put("/vaultjournals", "/WEB-INF/views/app/Vault/vaultjournals.jsp");
        routeToJsp.put("/feedWelcome", "/WEB-INF/views/app/Feed/feedWelcome.jsp");
        routeToJsp.put("/feedProfileSetup", "/WEB-INF/views/app/Feed/feedProfileSetup.jsp");
        routeToJsp.put("/userprofile", "/WEB-INF/views/app/Feed/userprofile.jsp");
        routeToJsp.put("/followerprofile", "/WEB-INF/views/app/Feed/followerprofile.jsp");
        routeToJsp.put("/followingprofile", "/WEB-INF/views/app/Feed/followingprofile.jsp");
        routeToJsp.put("/vaultpassword", "/WEB-INF/views/app/Vault/vaultpassword.jsp");
        routeToJsp.put("/notifications", "/WEB-INF/views/app/Notifications/notifications.jsp");

        // --- Groups ---
        routeToJsp.put("/groups", "/groupdashboard"); // Let Groups servlet handle this
        routeToJsp.put("/creategroup", "/WEB-INF/views/app/Groups/creategroup.jsp");

        // Comment routes - use controller for data loading
        routeToController.put("/feedcomment", "/viewComments");
        routeToController.put("/comments", "/viewComments");
        // /feededitprofile JSP route removed - controller route on line 162 handles it
        routeToController.put("/blockedusers", "/blockedusersview");
        routeToJsp.put("/vaultentries", "/WEB-INF/views/app/Vault/vaultentries.jsp");
        routeToController.put("/collabmemoryview", "/collabmemoryviewservlet");

        // Admin pages - routed through controllers for dynamic data
        routeToController.put("/admin", "/adminoverviewview");
        routeToController.put("/adminuser", "/adminuserview");
        routeToJsp.put("/adminsettings", "/WEB-INF/views/app/Admin/adminsettings.jsp");
        routeToController.put("/adminanalytics", "/adminanalyticsview");
        routeToController.put("/admincontent", "/admincontentview");

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
        routeToController.put("/eventinfo", "/eventsview?action=info");
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
        request.getRequestDispatcher("/WEB-INF/views/public/404.jsp").forward(request, response);
    }
}