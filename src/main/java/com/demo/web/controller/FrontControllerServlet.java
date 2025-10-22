// File: com/demo/web/controller/FrontControllerServlet.java (Complete, Final Version with Group Handlers)
package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.autographDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.model.UserSession;
import com.demo.web.model.autograph;
import com.demo.web.model.user;
import com.demo.web.model.Group;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.Date;
import java.text.SimpleDateFormat;

// Interface for logic handlers
interface LogicHandler {
    void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}

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

        // Protected pages (some need specific logic, others are static JSPs)
        routeToJsp.put("/memories", "/views/app/memories.jsp");
        routeToJsp.put("/dashboard", "/views/app/dashboard.jsp");
        routeToJsp.put("/profile", "/views/app/profile.jsp");
        routeToJsp.put("/autographs", "/views/app/Autographs/autographcontent.jsp");
        routeToJsp.put("/journals", "/views/app/journals.jsp");
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
        routeToJsp.put("/addautograph", "/views/app/Autographs/addautograph.jsp");
        routeToJsp.put("/duplicatefinder", "/views/app/duplicatefinder.jsp");
        routeToJsp.put("/morethemes", "/views/app/morethemes.jsp");
        routeToJsp.put("/sharedlinks", "/views/app/sharedlinks.jsp");
        routeToJsp.put("/trashmgt", "/views/app/trashmgt.jsp");
        routeToJsp.put("/notifications", "/views/app/notifications.jsp");
        routeToJsp.put("/groupprofile", "/views/app/groupprofile.jsp");
        routeToJsp.put("/groupmemories", "/views/app/groupmemories.jsp");
        routeToJsp.put("/groupmembers", "/views/app/groupmembers.jsp");
        routeToJsp.put("/groupannouncement", "/views/app/groupannouncement.jsp");
        routeToJsp.put("/events", "/views/app/eventdashboard.jsp");
        routeToJsp.put("/writeautograph", "/views/app/writeautograph.jsp");
        routeToJsp.put("/eventinfo", "/views/app/eventinfo.jsp");
        routeToJsp.put("/creatememory", "/views/app/creatememory.jsp");

        // Pages that require business logic before showing the JSP
        routeToLogic.put("/linkeddevices", new LinkedDevicesLogicHandler());
        routeToLogic.put("/editprofile", new EditProfileLogicHandler());
        routeToLogic.put("/autographs", new AutographListLogicHandler());
        routeToLogic.put("/autographview", new AutographViewLogicHandler());
        routeToLogic.put("/editautograph", new EditAutographLogicHandler());
        routeToLogic.put("/groups", new GroupListLogicHandler());
        routeToLogic.put("/groupmemories", new GroupViewLogicHandler());
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
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                    System.out.println("Session ID: " + device.getSessionId() + ", Device Name: " + device.getDeviceName() + ", Active: " + device.isActive());
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
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Integer userId = (Integer) session.getAttribute("user_id");

            user currentUser = userDAO.findById(userId);
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            session.setAttribute("user", currentUser);

            request.getRequestDispatcher("/views/app/settingsaccounteditprofile.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /autographs
    private static class AutographListLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public AutographListLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        public AutographViewLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

            request.setAttribute("autograph", autographDetail);

            request.getRequestDispatcher("/views/app/Autographs/viewautograph.jsp").forward(request, response);
        }
    }

    // Inner class implementing the logic for /editautograph
    private static class EditAutographLogicHandler implements LogicHandler {
        private autographDAO autographDAO;

        public EditAutographLogicHandler() {
            this.autographDAO = new autographDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

    // Inner class implementing the logic for /groupmemories (viewing a specific group)
    private static class GroupViewLogicHandler implements LogicHandler {
        private GroupDAO groupDAO;

        public GroupViewLogicHandler() {
            this.groupDAO = new GroupDAO();
        }

        @Override
        public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
}