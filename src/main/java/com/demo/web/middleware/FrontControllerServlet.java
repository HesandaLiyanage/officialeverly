// File: com/demo/web/controller/FrontControllerServlet.java (Complete, Final Version with Group Handlers)
package com.demo.web.middleware;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.autographDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.model.*;
import com.demo.web.util.SessionUtil;
import com.demo.web.dao.EventDAO;
import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Event;
import com.demo.web.model.UserSession;
import com.demo.web.model.autograph;
import com.demo.web.dao.JournalStreakDAO;
import com.demo.web.dao.AutographEntryDAO;
import com.demo.web.model.JournalStreak;
import com.demo.web.model.AutographEntry;

import java.security.SecureRandom;
import java.util.Base64;
import java.sql.SQLException;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

// Interface for logic handlers
interface LogicHandler {
    void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB per file
        maxRequestSize = 1024 * 1024 * 100 // 100MB total request
)
public class FrontControllerServlet extends HttpServlet {

    private Map<String, String> routeToJsp;
    private Map<String, LogicHandler> routeToLogic;
    private static final Logger logger = Logger.getLogger(FrontControllerServlet.class.getName());

    @Override
    public void init() throws ServletException {
        routeToJsp = new HashMap<>();
        routeToLogic = new HashMap<>();

        // Public pages (no specific logic, just JSP)
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
        routeToJsp.put("/resources/assets/landing.mp4", "/resources/assets/landing.mp4");

        // Protected pages (some need specific logic, others are static JSPs)
        // routeToJsp.put("/memories", "/views/app/memories.jsp");
        // routeToJsp.put("/memories", "/memoriesServlet"); routes to servlet, not JSP
        // directly
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/autographs", "/views/app/Autographs/autographcontent.jsp");
        routeToJsp.put("/journals", "/views/app/journals.jsp");

        routeToJsp.put("/collabmemories", "/views/app/collabmemories.jsp");
        routeToJsp.put("/settingsaccount", "/views/app/settingsaccount.jsp"); // No specific logic needed here, just the
                                                                              // static page

        routeToJsp.put("/settingsaccount", "/views/app/settingsaccount.jsp");

        routeToJsp.put("/settingsnotifications", "/views/app/settingsnotifications.jsp");
        routeToJsp.put("/settingsprivacy", "/views/app/settingsprivacy.jsp");
        routeToJsp.put("/storagesense", "/views/app/storagesense.jsp");
        routeToJsp.put("/settingsappearance", "/views/app/settingsappearance.jsp");
        routeToJsp.put("/vaultForgotPassword", "/views/app/vaultForgotPassword.jsp");
        routeToJsp.put("/vaultmemories", "/views/app/vaultMemories.jsp");
        routeToJsp.put("/vaultPassword", "/views/app/vaultPassword.jsp");
        routeToJsp.put("/vaultSetup", "/views/app/vaultSetup.jsp");
        routeToJsp.put("/autographview", "/views/app/Autographs/viewautograph.jsp");
        routeToJsp.put("/journalview", "/views/app/journalview.jsp");
        routeToJsp.put("/memoryview", "/views/app/memoryview.jsp");
        routeToJsp.put("/collabmemoryview", "/views/app/collabmemoryview.jsp");
        routeToJsp.put("/editautograph", "/views/app/Autographs/editautograph.jsp");
        routeToJsp.put("/addautograph", "/views/app/Autographs/addautograph.jsp");
        routeToJsp.put("/duplicatefinder", "/views/app/duplicatefinder.jsp");
        routeToJsp.put("/morethemes", "/views/app/morethemes.jsp");
        routeToJsp.put("/sharedlinks", "/views/app/sharedlinks.jsp");
        routeToJsp.put("/trashmgt", "/views/app/trashmgt.jsp");
        routeToJsp.put("/notifications", "/views/app/notifications.jsp");
        routeToJsp.put("/groups", "/views/app/groupdashboard.jsp");
        routeToJsp.put("/editgroup", "/views/app/editgroup.jsp");
        routeToJsp.put("/groupprofile", "/views/app/groupprofile.jsp");
        routeToJsp.put("/groupmemories", "/views/app/groupmemories.jsp");
        routeToJsp.put("/groupmembers", "/views/app/groupmembers.jsp");
        routeToJsp.put("/groupannouncement", "/views/app/groupannouncement.jsp");
        routeToJsp.put("/writeautograph", "/views/app/Autographs/writeautograph.jsp");
        routeToJsp.put("/eventinfo", "/views/app/eventinfo.jsp");
        routeToJsp.put("/creatememory", "/views/app/creatememory.jsp");
        routeToJsp.put("/creategroup", "/views/app/creategroup.jsp");
        routeToJsp.put("/editgroup", "/views/app/editgroup.jsp");
        routeToJsp.put("/editevent", "/views/app/editevent.jsp");
        routeToJsp.put("/memoryview", "/views/app/memoryview.jsp");
        routeToJsp.put("/memoryrecap", "/views/app/memoryrecap.jsp");
        routeToJsp.put("/writejournal", "/views/app/writejournal.jsp");
        routeToJsp.put("/vaultjournals", "/views/app/vaultjournals.jsp");
        routeToJsp.put("/feed", "/views/app/publicfeed.jsp");
        routeToJsp.put("/userprofile", "/views/app/userprofile.jsp");
        routeToJsp.put("/followers", "/views/app/followers.jsp");
        routeToJsp.put("/following", "/views/app/following.jsp");
        routeToJsp.put("/followerprofile", "/views/app/followerprofile.jsp");
        routeToJsp.put("/followingprofile", "/views/app/followingprofile.jsp");
        routeToJsp.put("/feedcomment", "/views/app/feedcomment.jsp");
        routeToJsp.put("/vaultpassword", "/views/app/vaultpassword.jsp");
        routeToJsp.put("/comments", "/views/app/feedcomment.jsp");
        routeToJsp.put("/publicprofile", "/views/app/userprofile.jsp");
        routeToJsp.put("/feededitprofile", "/views/app/editpublicprofile.jsp");
        routeToJsp.put("/blockedusers", "/views/app/blockedusers.jsp");
        routeToJsp.put("/editmemory", "/views/app/editmemory.jsp");
        routeToJsp.put("/vaultentries", "/views/app/vaultentries.jsp");
        routeToJsp.put("/admin", "/views/app/Admin/admindahboard.jsp");
        routeToJsp.put("/adminuser", "/views/app/Admin/adminuser.jsp");
        routeToJsp.put("/adminsettings", "/views/app/Admin/adminsettings.jsp");
        routeToJsp.put("/adminanalytics", "/views/app/Admin/adminanalytics.jsp");
        routeToJsp.put("/comments", "/views/app/feedcomment.jsp");
        routeToJsp.put("/admincontent", "/views/app/Admin/admincontent.jsp");

        // Pages that require business logic before showing the JSP
        routeToLogic.put("/linkeddevices", new LinkedDevicesLogicHandler());
        routeToLogic.put("/editprofile", new EditProfileLogicHandler());
        routeToLogic.put("/autographs", new AutographListLogicHandler());
        routeToLogic.put("/autographview", new AutographViewLogicHandler());
        routeToLogic.put("/editautograph", new EditAutographLogicHandler());
        routeToLogic.put("/groups", new GroupListLogicHandler());
        routeToLogic.put("/groupmemories", new GroupViewLogicHandler());
        routeToLogic.put("/editgroup", new EditGroupLogicHandler());
        routeToLogic.put("/events", new EventListLogicHandler());
        routeToLogic.put("/createevent", new CreateEventLogicHandler());
        routeToLogic.put("/editevent", new EditEventLogicHandler()); // ADD THIS LINE
        routeToLogic.put("/journals", new JournalListLogicHandler()); // ADD THIS LINE
        routeToLogic.put("/journalview", new JournalViewLogicHandler()); // ADD THIS LINE
        routeToLogic.put("/editjournal", new EditJournalLogicHandler());
        routeToLogic.put("/memories", new MemoryViewLogicHandler());
        routeToLogic.put("/generateShareLink", new GenerateShareLinkLogicHandler());
        routeToLogic.put("/submit-autograph", new SubmitAutographEntryLogicHandler());

        // Remove this if using servlet
    }

    /**
     * Generates a unique random token for share links
     */
    private String generateShareToken() {
        SecureRandom random = new SecureRandom();
        byte[] randomBytes = new byte[16];
        random.nextBytes(randomBytes);
        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(randomBytes);
    }

    private static class MemoryViewLogicHandler implements LogicHandler {

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

        }
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

        if ("/memories".equals(path)) {
            logger.info("Routing /memories to MemoriesServlet");
            request.getRequestDispatcher("/memoriesview").forward(request, response);
            return;
        }

        // Route /memoryview to MemoryViewServlet
        if ("/memoryview".equals(path)) {
            logger.info("Routing /memoryview to MemoryViewServlet");
            request.getRequestDispatcher("/memoryViewServlet").forward(request, response);
            return;
        }

        // Route /editmemory to EditMemoryServlet
        if ("/editmemory".equals(path)) {
            logger.info("Routing /editmemory to EditMemoryServlet");
            request.getRequestDispatcher("/editMemoryServlet").forward(request, response);
            return;
        }

        // Route /updatememory to UpdateMemoryServlet (POST)
        if ("/updatememory".equals(path)) {
            logger.info("Routing /updatememory to UpdateMemoryServlet");
            request.getRequestDispatcher("/updateMemoryServlet").forward(request, response);
            return;
        }

        // Route /deletememory to DeleteMemoryServlet
        if ("/deletememory".equals(path)) {
            logger.info("Routing /deletememory to DeleteMemoryServlet");
            request.getRequestDispatcher("/deleteMemoryServlet").forward(request, response);
            return;
        }

        // Route /share/* to handle share links
        if (path.startsWith("/share/")) {
            logger.info("Routing share link to ShareLinkViewLogicHandler");
            String shareToken = path.substring("/share/".length());
            request.setAttribute("shareToken", shareToken);
            new ShareLinkViewLogicHandler().execute(request, response);
            return;
        }

        // Route /sharedview/* to handle viewing autograph entries (token-only access)
        if (path.startsWith("/sharedview/")) {
            logger.info("Routing shared view to SharedAutographViewLogicHandler");
            String shareToken = path.substring("/sharedview/".length());
            request.setAttribute("shareToken", shareToken);
            new SharedAutographViewLogicHandler().execute(request, response);
            return;
        }

        // Route /viewMedia to ViewMediaServlet (GET requests) - support both cases
        if ("/viewMedia".equals(path) || "/viewmedia".equals(path)) {
            logger.info("Routing " + path + " to ViewMediaServlet");
            request.getRequestDispatcher("/viewmedia").forward(request, response);
            return;
        }

        logger.info("FrontController: Handling GET/POST request for path: " + path);

        if ("POST".equals(request.getMethod())) {
            switch (path) {
                case "/createMemory":
                    routeToCreateMemoryServlet(request, response);
                    return;

                // You can add more later:
                // case "/uploadAvatar": routeToAvatarServlet(request, response); return;
            }
        }

        // Check if the path has specific business logic associated with it
        LogicHandler logicHandler = routeToLogic.get(path);
        if (logicHandler != null) {
            logger.info("Executing business logic for path: " + path);
            logicHandler.execute(request, response);
            return;
        }

        // If no specific logic handler, check if it's just a static JSP mapping
        String jsp = routeToJsp.get(path);
        if (jsp != null) {
            logger.info("Forwarding directly to JSP: " + jsp);
            request.getRequestDispatcher(jsp).forward(request, response);
        } else {
            // Handle 404 - path not found in either map
            logger.warning("Path not found: " + path);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/views/public/404.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /linkeddevices
    private static class LinkedDevicesLogicHandler implements LogicHandler {
        private userSessionDAO userSessionDAO;

        public LinkedDevicesLogicHandler() {
            this.userSessionDAO = new userSessionDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");
            String currentSessionId = session.getId();

            List<UserSession> devices = userSessionDAO.getUserSessions(userId);
            System.out.println("=== LinkedDevicesLogicHandler DEBUG ===");
            System.out.println("Found " + devices.size() + " active sessions for user ID: " + userId);
            for (UserSession device : devices) {
                if (device.getSessionId().equals(currentSessionId)) {
                    device.setDeviceName(device.getDeviceName() + " (This device)");
                    System.out.println("Session ID: " + device.getSessionId() + ", Device Name: "
                            + device.getDeviceName() + ", Active: " + device.isActive());
                }
            }

            request.setAttribute("devices", devices);
            request.setAttribute("currentSessionId", currentSessionId);

            request.getRequestDispatcher("/views/app/linkeddevices.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /editprofile
    private static class EditProfileLogicHandler implements LogicHandler {
        private userDAO userDAO;

        public EditProfileLogicHandler() {
            this.userDAO = new userDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            System.out.println("=== EditProfileLogicHandler START ===");

            // Use SessionUtil to validate session
            if (!SessionUtil.isValidSession(request)) {
                System.out.println("Session validation failed, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get the session (should exist and be valid now)
            HttpSession session = request.getSession(false);
            if (session == null) {
                // Should not happen if SessionUtil.isValidSession returned true, but good
                // safety check
                System.out.println("Session is unexpectedly null, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Retrieve the user ID using the correct attribute name ("user_id")
            Integer userId = (Integer) session.getAttribute("user_id");
            System.out.println("User ID from session: " + userId);

            // Fetch fresh user data from database
            user currentUser = userDAO.findById(userId);
            if (currentUser == null) {
                System.out.println("User not found in database for ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            System.out.println("Fetched user from DB: " + currentUser.getUsername());
            System.out.println("User email: " + currentUser.getEmail());
            System.out.println("User bio: " + currentUser.getBio());

            // Update the user object in session with fresh data from DB
            session.setAttribute("user", currentUser);
            System.out.println("Updated session with fresh user data");

            // Forward to the edit profile JSP
            System.out.println("Forwarding to settingsaccounteditprofile.jsp");
            request.getRequestDispatcher("/views/app/settingsaccounteditprofile.jsp")
                    .forward(request, response);

            System.out.println("=== EditProfileLogicHandler END ===");
        }
    }

    // Inner class implementing the logic for /autographs
    private static class AutographListLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public AutographListLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            List<autograph> autographs = autographDAO.findByUserId(userId);

            request.setAttribute("autographs", autographs);

            request.getRequestDispatcher("/views/app/Autographs/autographcontent.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /autographview
    private static class AutographViewLogicHandler implements LogicHandler {
        private autographDAO autographDAO;
        private AutographEntryDAO entryDAO;

        public AutographViewLogicHandler() {
            this.autographDAO = new autographDAO();
            this.entryDAO = new AutographEntryDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            String autographIdParam = request.getParameter("id");
            if (autographIdParam == null || autographIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            int autographId;
            try {
                autographId = Integer.parseInt(autographIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            autograph autographDetail = autographDAO.findById(autographId);

            if (autographDetail == null || autographDetail.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            try {
                List<AutographEntry> entries = entryDAO.findByAutographId(autographId);
                request.setAttribute("autograph", autographDetail);
                request.setAttribute("entries", entries);
            } catch (SQLException e) {
                e.printStackTrace();
            }

            request.getRequestDispatcher("/views/app/Autographs/viewautograph.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for viewing shared autographs
    private static class ShareLinkViewLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public ShareLinkViewLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                // Not logged in - redirect to login
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String shareToken = (String) request.getAttribute("shareToken");

            if (shareToken == null || shareToken.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid share link");
                return;
            }

            try {
                autograph ag = autographDAO.getAutographByShareToken(shareToken);

                if (ag == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph not found");
                    return;
                }

                // Forward to the write autograph page
                request.setAttribute("autograph", ag);
                request.setAttribute("shareToken", shareToken);
                request.getRequestDispatcher("/views/app/Autographs/writeautograph.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error loading autograph");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error loading autograph");
            }
        }
    }

    // Inner class implementing the logic for generating share links
    private static class GenerateShareLinkLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public GenerateShareLinkLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Not authenticated\"}");
                return;
            }

            try {
                String autographIdStr = request.getParameter("autographId");

                if (autographIdStr == null || autographIdStr.isEmpty()) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Autograph ID is required\"}");
                    return;
                }

                int autographId = Integer.parseInt(autographIdStr);

                // Get or create share token
                String shareToken = autographDAO.getOrCreateShareToken(autographId);

                // Generate full share URL
                String baseUrl = request.getScheme() + "://" +
                        request.getServerName() +
                        (request.getServerPort() != 80 && request.getServerPort() != 443
                                ? ":" + request.getServerPort()
                                : "")
                        +
                        request.getContextPath();

                String shareUrl = baseUrl + "/share/" + shareToken;

                // Return JSON response
                response.getWriter().write("{\"success\": true, \"shareUrl\": \"" + shareUrl + "\"}");

            } catch (NumberFormatException e) {
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid autograph ID\"}");
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\": false, \"message\": \"Database error occurred\"}");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\": false, \"message\": \"Error generating share link\"}");
            }
        }
    }

    // Inner class implementing the logic for /editautograph
    private static class EditAutographLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public EditAutographLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            String autographIdParam = request.getParameter("id");
            if (autographIdParam == null || autographIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            int autographId;
            try {
                autographId = Integer.parseInt(autographIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            autograph autographToEdit = autographDAO.findById(autographId);

            if (autographToEdit == null || autographToEdit.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            request.setAttribute("autograph", autographToEdit);

            request.getRequestDispatcher("/views/app/Autographs/editautograph.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /groups
    private static class GroupListLogicHandler implements LogicHandler {
        private GroupDAO groupDAO;

        public GroupListLogicHandler() {
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            List<Group> groups = groupDAO.findByUserId(userId);

            // Get member counts for each group
            for (Group group : groups) {
                int memberCount = groupDAO.getMemberCount(group.getGroupId());
                // We'll pass this via request attribute map
            }

            request.setAttribute("groups", groups);
            request.setAttribute("groupDAO", groupDAO); // Pass DAO to JSP for member count queries

            request.getRequestDispatcher("/views/app/groupdashboard.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /groupmemories (viewing a specific
    // group)
    // Inner class implementing the logic for /groupmemories (viewing a specific
    // group)
    private static class GroupViewLogicHandler implements LogicHandler {
        private GroupDAO groupDAO;

        public GroupViewLogicHandler() {
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            String groupIdParam = request.getParameter("groupId");
            if (groupIdParam == null || groupIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            int groupId;
            try {
                groupId = Integer.parseInt(groupIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            Group groupDetail = groupDAO.findById(groupId);

            if (groupDetail == null || groupDetail.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            request.setAttribute("group", groupDetail);
            request.setAttribute("groupId", groupId);

            request.getRequestDispatcher("/views/app/groupmemories.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /editgroup
    private static class EditGroupLogicHandler implements LogicHandler {
        private GroupDAO groupDAO;

        public EditGroupLogicHandler() {
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            String groupIdParam = request.getParameter("groupId");
            if (groupIdParam == null || groupIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            int groupId;
            try {
                groupId = Integer.parseInt(groupIdParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            Group groupToEdit = groupDAO.findById(groupId);

            if (groupToEdit == null || groupToEdit.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/groups");
                return;
            }

            request.setAttribute("group", groupToEdit);

            request.getRequestDispatcher("/views/app/editgroup.jsp").forward(request, response);
        }
    }

    private static class EventListLogicHandler implements LogicHandler {
        private EventDAO eventDAO;

        public EventListLogicHandler() {
            this.eventDAO = new EventDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            System.out.println("[DEBUG EventListLogicHandler] Starting to handle /events request");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG EventListLogicHandler] No session or user_id, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");
            System.out.println("[DEBUG EventListLogicHandler] Fetching events for user ID: " + userId);

            try {
                // Check if user is a group admin (has created at least one group)
                boolean isGroupAdmin = eventDAO.isUserGroupAdmin(userId);
                System.out.println("[DEBUG EventListLogicHandler] User is group admin: " + isGroupAdmin);

                request.setAttribute("isGroupAdmin", isGroupAdmin);

                // Get all events for the user (only from groups they created)
                List<Event> allEvents = eventDAO.findByUserId(userId);
                System.out.println("[DEBUG EventListLogicHandler] Total events found: " + allEvents.size());

                // Get upcoming events
                List<Event> upcomingEvents = eventDAO.findUpcomingEventsByUserId(userId);
                System.out.println("[DEBUG EventListLogicHandler] Upcoming events: " + upcomingEvents.size());

                // Get past events
                List<Event> pastEvents = eventDAO.findPastEventsByUserId(userId);
                System.out.println("[DEBUG EventListLogicHandler] Past events: " + pastEvents.size());

                // Set attributes for JSP
                request.setAttribute("allEvents", allEvents);
                request.setAttribute("upcomingEvents", upcomingEvents);
                request.setAttribute("pastEvents", pastEvents);
                request.setAttribute("upcomingCount", upcomingEvents.size());
                request.setAttribute("pastCount", pastEvents.size());
                request.setAttribute("totalCount", allEvents.size());

                System.out.println("[DEBUG EventListLogicHandler] Forwarding to eventdashboard.jsp");
                request.getRequestDispatcher("/views/app/eventdashboard.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("[DEBUG EventListLogicHandler] Error occurred: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while fetching events: " + e.getMessage());
                request.getRequestDispatcher("/views/app/eventdashboard.jsp").forward(request, response);
            }
        }
    }

    private static class CreateEventLogicHandler implements LogicHandler {
        private GroupDAO groupDAO;

        public CreateEventLogicHandler() {
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            System.out.println("[DEBUG CreateEventLogicHandler] Handling /createevent request");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG CreateEventLogicHandler] No session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");
            System.out.println("[DEBUG CreateEventLogicHandler] User ID: " + userId);

            try {
                // Get all groups created by this user (only creators can create events)
                List<Group> userGroups = groupDAO.findByUserId(userId);
                System.out.println("[DEBUG CreateEventLogicHandler] Found " + userGroups.size() + " groups for user");

                // Check if user has at least one group
                if (userGroups.isEmpty()) {
                    System.out.println("[DEBUG CreateEventLogicHandler] User has no groups");
                    request.setAttribute("error", "You need to create a group first before creating events.");
                    request.setAttribute("noGroups", true);
                }

                // Set groups as request attribute
                request.setAttribute("userGroups", userGroups);

                // Forward to create event JSP
                request.getRequestDispatcher("/views/app/createevent.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("[DEBUG CreateEventLogicHandler] Error: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while loading groups: " + e.getMessage());
                request.getRequestDispatcher("/views/app/createevent.jsp").forward(request, response);
            }
        }
    }

    private static class EditEventLogicHandler implements LogicHandler {
        private EventDAO eventDAO;
        private GroupDAO groupDAO;

        public EditEventLogicHandler() {
            this.eventDAO = new EventDAO();
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            System.out.println("[DEBUG EditEventLogicHandler] Handling /editevent request");

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG EditEventLogicHandler] No session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");
            String eventIdStr = request.getParameter("event_id");

            System.out.println("[DEBUG EditEventLogicHandler] User ID: " + userId + ", Event ID: " + eventIdStr);

            try {
                // Validation
                if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                    System.out.println("[DEBUG EditEventLogicHandler] Event ID is missing");
                    session.setAttribute("errorMessage", "Event ID is required");
                    response.sendRedirect(request.getContextPath() + "/events");
                    return;
                }

                int eventId = Integer.parseInt(eventIdStr);

                // Get the event
                Event event = eventDAO.findById(eventId);

                if (event == null) {
                    System.out.println("[DEBUG EditEventLogicHandler] Event not found: " + eventId);
                    session.setAttribute("errorMessage", "Event not found");
                    response.sendRedirect(request.getContextPath() + "/events");
                    return;
                }

                System.out.println("[DEBUG EditEventLogicHandler] Event found: " + event.getTitle());

                // Get the group information
                Group eventGroup = groupDAO.findById(event.getGroupId());

                if (eventGroup == null) {
                    System.out.println("[DEBUG EditEventLogicHandler] Group not found for event: " + eventId);
                    session.setAttribute("errorMessage", "Group not found for this event");
                    response.sendRedirect(request.getContextPath() + "/events");
                    return;
                }

                // Security check: Verify the group belongs to this user
                if (eventGroup.getUserId() != userId) {
                    System.out.println("[DEBUG EditEventLogicHandler] Security violation: User " + userId +
                            " attempted to edit event " + eventId + " from group " + eventGroup.getGroupId());
                    session.setAttribute("errorMessage", "You don't have permission to edit this event");
                    response.sendRedirect(request.getContextPath() + "/events");
                    return;
                }

                // Get all user's groups for the dropdown
                List<Group> userGroups = groupDAO.findByUserId(userId);
                System.out.println("[DEBUG EditEventLogicHandler] Found " + userGroups.size() + " groups for user");

                // Set attributes for JSP
                request.setAttribute("event", event);
                request.setAttribute("userGroups", userGroups);

                System.out.println("[DEBUG EditEventLogicHandler] Forwarding to editevent.jsp");

                // Forward to edit event JSP
                request.getRequestDispatcher("/views/app/editevent.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                System.out.println("[DEBUG EditEventLogicHandler] Invalid event ID format: " + e.getMessage());
                session.setAttribute("errorMessage", "Invalid event ID");
                response.sendRedirect(request.getContextPath() + "/events");

            } catch (Exception e) {
                System.out.println("[DEBUG EditEventLogicHandler] Error loading event for edit: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "An error occurred while loading the event");
                response.sendRedirect(request.getContextPath() + "/events");
            }
        }
    }

    // Inner class implementing the logic for /journals
    private static class JournalListLogicHandler implements LogicHandler {
        private JournalDAO journalDAO;
        private JournalStreakDAO streakDAO;

        public JournalListLogicHandler() {
            this.journalDAO = new JournalDAO();
            this.streakDAO = new JournalStreakDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            System.out.println("[DEBUG JournalListLogicHandler] Handling /journals request");
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG JournalListLogicHandler] No session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Integer userId = (Integer) session.getAttribute("user_id");
            System.out.println("[DEBUG JournalListLogicHandler] User ID: " + userId);

            try {
                // Check and update streak status (in case user missed a day)
                streakDAO.checkAndUpdateStreakStatus(userId);

                // Get streak information
                JournalStreak streak = streakDAO.getStreakByUserId(userId);
                int streakDays = (streak != null) ? streak.getCurrentStreak() : 0;
                int longestStreak = (streak != null) ? streak.getLongestStreak() : 0;

                System.out.println("[DEBUG JournalListLogicHandler] Current streak: " + streakDays + " days");
                System.out.println("[DEBUG JournalListLogicHandler] Longest streak: " + longestStreak + " days");

                // Get all journals for this user
                List<Journal> journals = journalDAO.findByUserId(userId);
                System.out.println("[DEBUG JournalListLogicHandler] Found " + journals.size() + " journals");

                // Get total count
                int totalCount = journalDAO.getJournalCount(userId);
                System.out.println("[DEBUG JournalListLogicHandler] Total journal count: " + totalCount);

                // Set attributes for JSP
                request.setAttribute("journals", journals);
                request.setAttribute("totalCount", totalCount);
                request.setAttribute("streakDays", streakDays);
                request.setAttribute("longestStreak", longestStreak);

                System.out.println("[DEBUG JournalListLogicHandler] Forwarding to journals.jsp");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("[DEBUG JournalListLogicHandler] Error: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while loading journals: " + e.getMessage());
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
            }
        }
    }

    // Inner class implementing the logic for /journalview
    // Inner class implementing the logic for /journalview
    private static class JournalViewLogicHandler implements LogicHandler {
        private JournalDAO journalDAO;

        public JournalViewLogicHandler() {
            this.journalDAO = new JournalDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            System.out.println("[DEBUG JournalViewLogicHandler] Handling /journalview request");
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG JournalViewLogicHandler] No session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Integer userId = (Integer) session.getAttribute("user_id");

            // Get journal ID from request parameter
            String journalIdParam = request.getParameter("id");
            if (journalIdParam == null || journalIdParam.trim().isEmpty()) {
                System.out.println("[DEBUG JournalViewLogicHandler] Journal ID parameter is missing");
                request.setAttribute("error", "Journal ID is required.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response); // Or redirect to
                                                                                                    // journals list
                return;
            }

            int journalId;
            try {
                journalId = Integer.parseInt(journalIdParam);
            } catch (NumberFormatException e) {
                System.out.println("[DEBUG JournalViewLogicHandler] Invalid journal ID format: " + journalIdParam);
                request.setAttribute("error", "Invalid Journal ID.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response); // Or redirect to
                                                                                                    // journals list
                return;
            }

            System.out.println(
                    "[DEBUG JournalViewLogicHandler] User ID: " + userId + ", Requested Journal ID: " + journalId);

            try {
                // Fetch the specific journal
                Journal journal = journalDAO.findById(journalId);

                if (journal == null) {
                    System.out.println("[DEBUG JournalViewLogicHandler] Journal not found with ID: " + journalId);
                    request.setAttribute("error", "Journal entry not found.");
                    request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response); // Or redirect
                                                                                                        // to journals
                                                                                                        // list
                    return;
                }

                // Security check: Ensure the journal belongs to the current user
                if (journal.getUserId() != userId) {
                    System.out.println("[DEBUG JournalViewLogicHandler] User " + userId + " tried to access journal "
                            + journalId + " which belongs to user " + journal.getUserId());
                    request.setAttribute("error", "You do not have permission to view this journal entry.");
                    request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response); // Or redirect
                                                                                                        // to journals
                                                                                                        // list
                    return;
                }

                System.out.println("[DEBUG JournalViewLogicHandler] Found journal: " + journal.getTitle());

                // Set the journal object as a request attribute for the JSP
                request.setAttribute("journal", journal);

                // Forward to the view JSP
                System.out.println("[DEBUG JournalViewLogicHandler] Forwarding to journalview.jsp");
                request.getRequestDispatcher("/views/app/journalview.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("[DEBUG JournalViewLogicHandler] Error fetching journal: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while loading the journal entry: " + e.getMessage());
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response); // Or show a
                                                                                                    // specific error
                                                                                                    // page
            }
        }
    }

    // Inner class implementing the logic for /editjournal
    // Inner class implementing the logic for /editjournal
    private static class EditJournalLogicHandler implements LogicHandler {
        private JournalDAO journalDAO;

        public EditJournalLogicHandler() {
            this.journalDAO = new JournalDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            System.out.println("[DEBUG EditJournalLogicHandler] Handling /editjournal request");
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                System.out.println("[DEBUG EditJournalLogicHandler] No session, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Integer userId = (Integer) session.getAttribute("user_id");

            // Get journal ID from request parameter
            String journalIdParam = request.getParameter("id"); // Use 'id' as the parameter name for consistency
            if (journalIdParam == null || journalIdParam.trim().isEmpty()) {
                System.out.println("[DEBUG EditJournalLogicHandler] Journal ID parameter is missing");
                request.setAttribute("error", "Journal ID is required.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                return;
            }

            int journalId;
            try {
                journalId = Integer.parseInt(journalIdParam);
            } catch (NumberFormatException e) {
                System.out.println("[DEBUG EditJournalLogicHandler] Invalid journal ID format: " + journalIdParam);
                request.setAttribute("error", "Invalid Journal ID.");
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                return;
            }

            System.out.println(
                    "[DEBUG EditJournalLogicHandler] User ID: " + userId + ", Requested Journal ID: " + journalId);

            try {
                // Fetch the specific journal
                Journal journal = journalDAO.findById(journalId);

                if (journal == null) {
                    System.out.println("[DEBUG EditJournalLogicHandler] Journal not found with ID: " + journalId);
                    request.setAttribute("error", "Journal entry not found.");
                    request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                    return;
                }

                // Security check: Ensure the journal belongs to the current user
                if (journal.getUserId() != userId) {
                    System.out.println("[DEBUG EditJournalLogicHandler] User " + userId + " tried to access journal "
                            + journalId + " which belongs to user " + journal.getUserId());
                    request.setAttribute("error", "You do not have permission to edit this journal entry.");
                    request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
                    return;
                }

                System.out.println("[DEBUG EditJournalLogicHandler] Found journal: " + journal.getTitle());

                // Set the journal object as a request attribute for the JSP
                request.setAttribute("journal", journal);

                // Forward to the edit JSP
                System.out.println("[DEBUG EditJournalLogicHandler] Forwarding to editjournal.jsp");
                request.getRequestDispatcher("/views/app/editjournal.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("[DEBUG EditJournalLogicHandler] Error fetching journal: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while loading the journal entry: " + e.getMessage());
                request.getRequestDispatcher("/views/app/journals.jsp").forward(request, response);
            }
        }
    }

    private static class SharedAutographViewLogicHandler implements LogicHandler {
        private autographDAO autographDAO;
        private AutographEntryDAO entryDAO;

        public SharedAutographViewLogicHandler() {
            this.autographDAO = new autographDAO();
            this.entryDAO = new AutographEntryDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String shareToken = (String) request.getAttribute("shareToken");

            if (shareToken == null || shareToken.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid share link");
                return;
            }

            try {
                autograph ag = autographDAO.getAutographByShareToken(shareToken);

                if (ag == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph not found");
                    return;
                }

                // Load entries for this autograph
                List<AutographEntry> entries = entryDAO.findByAutographId(ag.getAutographId());

                request.setAttribute("autograph", ag);
                request.setAttribute("entries", entries);
                request.setAttribute("shareToken", shareToken);

                request.getRequestDispatcher("/views/app/Autographs/sharedautographview.jsp").forward(request,
                        response);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error loading autograph entries");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error loading autograph entries");
            }
        }
    }

    private void routeToCreateMemoryServlet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This forwards the EXACT SAME request (with files, parts, everything) to your
        // servlet
        RequestDispatcher dispatcher = request.getRequestDispatcher("/createMemoryServlet");
        dispatcher.forward(request, response);
    }

    class SubmitAutographEntryLogicHandler implements LogicHandler {
        private autographDAO autoDAO;
        private AutographEntryDAO entryDAO;

        public SubmitAutographEntryLogicHandler() {
            this.autoDAO = new autographDAO();
            this.entryDAO = new AutographEntryDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int userId = (Integer) session.getAttribute("user_id");
            String token = request.getParameter("token");
            String contentPlain = request.getParameter("content");
            String author = request.getParameter("author");
            String decorationsJson = request.getParameter("decorations");

            if (token == null || token.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing token");
                return;
            }

            try {
                autograph ag = autoDAO.getAutographByShareToken(token);
                if (ag == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph book not found");
                    return;
                }

                // Construct Rich HTML
                StringBuilder richHtml = new StringBuilder();
                richHtml.append("<div class='rich-autograph-entry'>");
                richHtml.append("<div class='message-text'>").append(contentPlain).append("</div>");
                richHtml.append(
                        "<div class='decorations-layer' style='position:absolute; top:0; left:0; width:100%; height:100%; pointer-events:none;'>");

                if (decorationsJson != null && !decorationsJson.isEmpty() && !decorationsJson.equals("[]")) {
                    JsonArray decorations = JsonParser.parseString(decorationsJson).getAsJsonArray();
                    for (int i = 0; i < decorations.size(); i++) {
                        JsonObject dec = decorations.get(i).getAsJsonObject();
                        richHtml.append("<span class='").append(dec.get("className").getAsString()).append("' ")
                                .append("style='position:absolute; top:").append(dec.get("top").getAsString())
                                .append("; left:").append(dec.get("left").getAsString()).append(";'>")
                                .append(dec.get("content").getAsString()).append("</span>");
                    }
                }
                richHtml.append("</div>");
                richHtml.append("<div class='author-signature'>- ").append(author).append("</div>");
                richHtml.append("</div>");

                AutographEntry entry = new AutographEntry();
                entry.setAutographId(ag.getAutographId());
                entry.setUserId(userId);
                entry.setContent(richHtml.toString());
                entry.setContentPlain(contentPlain);
                entry.setLink(java.util.UUID.randomUUID().toString().substring(0, 8)); // Short unique link for entry

                boolean success = entryDAO.createEntry(entry);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/sharedview/" + token);
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save entry");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Database error during autograph submission", e);
            }
        }
    }
}
