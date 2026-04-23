// File: com/demo/web/middleware/FrontControllerServlet.java
// Refactored version - pure routing, no business logic
package com.demo.web.middleware;

import com.demo.web.util.RequestPathUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.LinkedHashMap;
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
    private Map<String, String> routeToInternalForward;
    private Map<String, String> routeToPostForward;
    private static final Logger logger = Logger.getLogger(FrontControllerServlet.class.getName());

    @Override
    public void init() throws ServletException {
        Map<String, String> jspRoutes = new LinkedHashMap<>();
        Map<String, String> controllerRoutes = new LinkedHashMap<>();
        Map<String, String> internalRoutes = new LinkedHashMap<>();
        Map<String, String> postRoutes = new LinkedHashMap<>();

        // ========================================
        // PUBLIC PAGES (no authentication needed)
        // ========================================
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/", "/WEB-INF/views/public/landing.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/login", "/WEB-INF/views/public/loginContent.jsp");
        // /register and /contact removed - JSPs don't exist
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/aboutus", "/WEB-INF/views/public/aboutus.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/signup", "/WEB-INF/views/public/signup.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/signup2", "/WEB-INF/views/public/signup2.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/404", "/WEB-INF/views/public/404.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/checkyourinbox", "/WEB-INF/views/public/checkyourinbox.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/emailsentreset", "/WEB-INF/views/public/emailsentreset.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/emailresetsuccess", "/WEB-INF/views/public/emailresetsuccess.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/footer", "/WEB-INF/views/public/footer.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/forgotpassword", "/WEB-INF/views/public/forgotpassword.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/header", "/WEB-INF/views/public/header.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/header2", "/WEB-INF/views/public/header2.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/index", "/WEB-INF/views/public/index.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/layout", "/WEB-INF/views/public/layout.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/layout2", "/WEB-INF/views/public/layout2.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/passwordreset", "/WEB-INF/views/public/passwordreset.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/passwordresetenterpassword", "/WEB-INF/views/public/passwordreset-enterpassword.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/plans", "/WEB-INF/views/public/plans.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/signupthankyou", "/WEB-INF/views/public/signupThankyou.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/whyeverly", "/WEB-INF/views/public/whyeverly.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/youcantaccessthis", "/WEB-INF/views/public/youcantaccessthis.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/privacy", "/WEB-INF/views/public/privacy.jsp");

        // ========================================
        // PROTECTED PAGES (static JSPs - no data fetching)
        // ========================================
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/dashboard", "/WEB-INF/views/app/dashboard.jsp");
        // /profile removed - profile.jsp doesn't exist; use /publicprofile instead
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/collabmemories", "/collabmemoriesview");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/settingsaccount", "/WEB-INF/views/app/Settings/settingsaccount.jsp");
        // /managesubscription handled by web.xml ManageSubscriptionController
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/changeplan", "/changeplanview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/familyplan", "/familyplanview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/settingsnotifications", "/notificationprefsapi");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/settingsprivacy", "/WEB-INF/views/app/Settings/settingsprivacy.jsp");
        // /settingssubscription handled by web.xml SettingsSubscriptionController
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/storagesense", "/storagesenseview");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultForgotPassword", "/WEB-INF/views/app/Vault/vaultForgotPassword.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultmemories", "/WEB-INF/views/app/Vault/vaultMemories.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultPassword", "/WEB-INF/views/app/Vault/vaultPassword.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultSetup", "/WEB-INF/views/app/Vault/vaultSetup.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/addautograph", "/WEB-INF/views/app/Autographs/addautograph.jsp");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/duplicatefinder", "/duplicatefinderview");
        // /morethemes removed - Appearance feature removed
        // /sharedlinks handled by web.xml SharedLinksController
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/trashmgt", "/trashmgtview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/notifications", "/notificationsapi");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/groupprofile", "/WEB-INF/views/app/Groups/groupprofile.jsp");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/groupmembers", "/groupmembersservlet");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/groupannouncement", "/groupannouncementservlet");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/createannouncement", "/createannouncementservlet");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/viewannouncement", "/viewannouncementservlet");
        // /writeautograph removed - actual feature uses /write-autograph via
        // @WebServlet
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/creatememory", "/WEB-INF/views/app/Memory/creatememory.jsp");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/memoryrecap", "/memoryrecapview");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/writejournal", "/WEB-INF/views/app/Journals/writejournal.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultjournals", "/WEB-INF/views/app/Vault/vaultjournals.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/feedWelcome", "/WEB-INF/views/app/Feed/feedWelcome.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/feedProfileSetup", "/WEB-INF/views/app/Feed/feedProfileSetup.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/userprofile", "/WEB-INF/views/app/Feed/userprofile.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/followerprofile", "/WEB-INF/views/app/Feed/followerprofile.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/followingprofile", "/WEB-INF/views/app/Feed/followingprofile.jsp");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultpassword", "/WEB-INF/views/app/Vault/vaultpassword.jsp");

        // --- Groups ---
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/creategroup", "/WEB-INF/views/app/Groups/creategroup.jsp");

        // Comment routes - use controller for data loading
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/feedcomment", "/viewComments");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/comments", "/viewComments");
        // /feededitprofile JSP route removed - controller route on line 162 handles it
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/blockedusers", "/blockedusersview");
        registerJspRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/vaultentries", "/WEB-INF/views/app/Vault/vaultentries.jsp");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/collabmemoryview", "/collabmemoryviewservlet");

        // Admin pages - routed through controllers for dynamic data
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/admin", "/adminoverviewview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/adminuser", "/adminuserview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/adminsettings", "/adminsettingsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/adminanalytics", "/adminanalyticsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/admincontent", "/admincontentview");

        // ========================================
        // ROUTES TO VIEW CONTROLLERS (need data fetching)
        // Business logic is in Service layer, view prep in Controllers
        // ========================================

        // Settings controllers
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/linkeddevices", "/linkeddevicesview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editprofile", "/editprofileview");

        // Autograph routes (all handled by AutographViewController)
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/autographs", "/autographsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/autographview", "/autographsview?action=view");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editautograph", "/autographsview?action=edit");

        // Group routes (all handled by GroupViewController)
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/groups", "/groupsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/groupmemories", "/groupsview?action=memories");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editgroup", "/groupsview?action=edit");

        // Event routes (all handled by EventViewController)
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/events", "/eventsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/eventinfo", "/eventsview?action=info");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/createevent", "/eventsview?action=create");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editevent", "/eventsview?action=edit");

        // Journal routes (all handled by JournalViewController)
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/journals", "/journalsview");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/journalview", "/journalsview?action=view");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editjournal", "/journalsview?action=edit");

        // Feed route (checks for feed profile before showing)
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/feed", "/feedview");

        // Feed profile view route
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/publicprofile", "/feedprofileview");

        // Edit feed profile route
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/feededitprofile", "/feededitprofileview");

        // Followers/Following routes
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/followers", "/followersview?type=followers");
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/following", "/followersview?type=following");

        // Create post route
        registerControllerRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/createPost", "/createPostServlet");

        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/memories", "/memoriesview");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/memoryview", "/memoryViewServlet");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/editmemory", "/editMemoryServlet");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/updatememory", "/updateMemoryServlet");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/deletememory", "/deleteMemoryServlet");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/viewMedia", "/viewmedia");
        registerInternalRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/viewmedia", "/viewmedia");
        registerPostRoute(jspRoutes, controllerRoutes, internalRoutes, postRoutes, "/createMemory", "/createMemoryServlet");

        routeToJsp = Collections.unmodifiableMap(jspRoutes);
        routeToController = Collections.unmodifiableMap(controllerRoutes);
        routeToInternalForward = Collections.unmodifiableMap(internalRoutes);
        routeToPostForward = Collections.unmodifiableMap(postRoutes);
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

        String path = RequestPathUtil.normalizePath(request);

        logger.info("FrontController: Handling request for path: " + path);

        // ========================================
        // SPECIAL SERVLET ROUTES
        // These forward to specific servlets (not JSPs or view controllers)
        // ========================================

        String internalTarget = routeToInternalForward.get(path);
        if (internalTarget != null) {
            request.getRequestDispatcher(internalTarget).forward(request, response);
            return;
        }

        // POST-specific routes
        if ("POST".equals(request.getMethod())) {
            String postTarget = routeToPostForward.get(path);
            if (postTarget != null) {
                request.getRequestDispatcher(postTarget).forward(request, response);
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
            controllerPath = RequestPathUtil.appendQuery(controllerPath, request.getQueryString());

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

    private void registerJspRoute(Map<String, String> jspRoutes, Map<String, String> controllerRoutes,
                                  Map<String, String> internalRoutes, Map<String, String> postRoutes,
                                  String path, String target) {
        registerRoute("JSP", jspRoutes, controllerRoutes, internalRoutes, postRoutes, path, target);
    }

    private void registerControllerRoute(Map<String, String> jspRoutes, Map<String, String> controllerRoutes,
                                         Map<String, String> internalRoutes, Map<String, String> postRoutes,
                                         String path, String target) {
        registerRoute("controller", controllerRoutes, jspRoutes, internalRoutes, postRoutes, path, target);
    }

    private void registerInternalRoute(Map<String, String> jspRoutes, Map<String, String> controllerRoutes,
                                       Map<String, String> internalRoutes, Map<String, String> postRoutes,
                                       String path, String target) {
        registerRoute("internal", internalRoutes, jspRoutes, controllerRoutes, postRoutes, path, target);
    }

    private void registerPostRoute(Map<String, String> jspRoutes, Map<String, String> controllerRoutes,
                                   Map<String, String> internalRoutes, Map<String, String> postRoutes,
                                   String path, String target) {
        registerRoute("post", postRoutes, jspRoutes, controllerRoutes, internalRoutes, path, target);
    }

    private void registerRoute(String routeType, Map<String, String> destination, Map<String, String> otherA,
                               Map<String, String> otherB, Map<String, String> otherC, String path, String target) {
        if (destination.containsKey(path) || otherA.containsKey(path) || otherB.containsKey(path) || otherC.containsKey(path)) {
            throw new IllegalStateException("Duplicate " + routeType + " route registered for path " + path);
        }
        destination.put(path, target);
    }
}
