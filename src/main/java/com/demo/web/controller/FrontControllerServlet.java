package com.demo.web.controller;

import com.demo.web.dao.userDAO; // Import your userDAO
import com.demo.web.dao.userSessionDAO; // Import your userSessionDAO if needed elsewhere
import com.demo.web.model.UserSession; // Import your UserSession model
import com.demo.web.model.user; // Import your user model

import javax.servlet.ServletException;
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

public class FrontControllerServlet extends HttpServlet {

    private Map<String, String> routeToJsp; // Path -> JSP
    private Map<String, LogicHandler> routeToLogic; // Path -> Business Logic Handler

    private static final Logger logger = Logger.getLogger(FrontControllerServlet.class.getName());

    @Override
    public void init() throws ServletException {
        routeToJsp = new HashMap<>();
        routeToLogic = new HashMap<>();

        // Public pages (no specific logic, just JSP)
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
        routeToJsp.put("/resources/assets/landing.mp4", "/resources/assets/landing.mp4");

        // Protected pages (some need specific logic)
        routeToJsp.put("/memories", "/views/app/memories.jsp");
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/autographs", "/views/app/Autographs/autographcontent.jsp");
        routeToJsp.put("/journals", "/views/app/journals.jsp");
        routeToJsp.put("/settingsaccount", "/views/app/settingsaccount.jsp"); // No specific logic needed here, just the static page
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
        routeToJsp.put("/addautograph", "/views/app/Autographs/addautograph.jsp");
        routeToJsp.put("/duplicatefinder", "/views/app/duplicatefinder.jsp");
        routeToJsp.put("/morethemes", "/views/app/morethemes.jsp");
        routeToJsp.put("/sharedlinks", "/views/app/sharedlinks.jsp");
        routeToJsp.put("/trashmgt", "/views/app/trashmgt.jsp");
        routeToJsp.put("/notifications", "/views/app/notifications.jsp");
        routeToJsp.put("/groups", "/views/app/groupdashboard.jsp");
        routeToJsp.put("/groupprofile", "/views/app/groupprofile.jsp");
        routeToJsp.put("/groupmemories", "/views/app/groupmemories.jsp");
        routeToJsp.put("/groupmembers", "/views/app/groupmembers.jsp");
        routeToJsp.put("/groupannouncement", "/views/app/groupannouncement.jsp");
        routeToJsp.put("/events", "/views/app/eventdashboard.jsp");
        routeToJsp.put("/writeautograph", "/views/app/writeautograph.jsp");
        routeToJsp.put("/writejournal", "/views/app/writejournal.jsp");
        routeToJsp.put("/eventinfo", "/views/app/eventinfo.jsp");
        routeToJsp.put("/creatememory", "/views/app/creatememory.jsp");
        routeToJsp.put("/creategroup", "/views/app/creategroup.jsp");
        routeToJsp.put("/createevent", "/views/app/createevent.jsp");
        // Pages that require business logic before showing the JSP
        routeToLogic.put("/linkeddevices", new LinkedDevicesLogicHandler());
        routeToLogic.put("/editprofile", new EditProfileLogicHandler()); // Add this line

        // Add other protected pages that don't need specific logic here if not already in routeToJsp
        // e.g., routeToJsp.put("/someotherpage", "/views/app/someotherpage.jsp");
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

        logger.info("FrontController: Handling GET/POST request for path: " + path);

        // Check if the path has specific business logic associated with it
        LogicHandler logicHandler = routeToLogic.get(path);
        if (logicHandler != null) {
            logger.info("Executing business logic for path: " + path);
            // Execute the associated logic. This logic class should handle the forwarding to the JSP.
            logicHandler.execute(request, response);
            return; // Important: Exit here after logic executes and forwards
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
        private userSessionDAO userSessionDAO; // Assuming this DAO is available or can be instantiated

        public LinkedDevicesLogicHandler() {
            // Initialize the DAO here if needed, or inject it somehow
            // For simplicity, just instantiate it here if no DI framework is used
            this.userSessionDAO = new userSessionDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Check if user is logged in (you might want to centralize this check too)
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                // Should ideally not happen if AuthenticationFilter works correctly, but good to check
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get user ID and current session ID from the request session
            Integer userId = (Integer) session.getAttribute("user_id");
            String currentSessionId = session.getId();

            // Fetch data using the DAO (Replicating logic from LinkedDevicesServlet doGet)
            List<UserSession> devices = userSessionDAO.getUserSessions(userId);
            System.out.println("=== LinkedDevicesLogicHandler DEBUG ===");
            System.out.println("Found " + devices.size() + " active sessions for user ID: " + userId);
            for (UserSession device : devices) {
                if (device.getSessionId().equals(currentSessionId)) {
                    device.setDeviceName(device.getDeviceName() + " (This device)");
                    System.out.println("Session ID: " + device.getSessionId() + ", Device Name: " + device.getDeviceName() + ", Active: " + device.isActive());
                }
            }

            // Set attributes required by the JSP
            request.setAttribute("devices", devices);
            request.setAttribute("currentSessionId", currentSessionId);

            // Forward to the JSP
            request.getRequestDispatcher("/views/app/linkeddevices.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /editprofile
    private static class EditProfileLogicHandler implements LogicHandler {
        private userDAO userDAO; // Assuming this DAO is available or can be instantiated

        public EditProfileLogicHandler() {
            // Initialize the DAO here if needed, or inject it somehow
            // For simplicity, just instantiate it here if no DI framework is used
            this.userDAO = new userDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Check if user is logged in (you might want to centralize this check too)
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                // Should ideally not happen if AuthenticationFilter works correctly, but good to check
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get user ID from the request session
            Integer userId = (Integer) session.getAttribute("user_id");

            // Fetch the current user object from the database using the validated user_id
            user currentUser = userDAO.findById(userId);
            if (currentUser == null) {
                // User ID in session doesn't correspond to a valid user in DB
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Set the user object as a request attribute (or update session if needed)
            // The JSP expects it in the session, so we ensure it's there.
            session.setAttribute("user", currentUser);

            // Forward to the JSP
            request.getRequestDispatcher("/views/app/settingsaccounteditprofile.jsp").forward(request, response);
        }
    }

    // Example for adding another logic handler as an inner class later:
    /*
    private static class ProfileLogicHandler implements LogicHandler {
        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Fetch user profile data using a UserDAO or similar
            // UserDAO userDAO = new UserDAO();
            // User user = userDAO.getUserById(userIdFromSession);
            // request.setAttribute("user", user);
            request.getRequestDispatcher("/views/app/profile.jsp").forward(request, response);
        }
    }
    */
}
