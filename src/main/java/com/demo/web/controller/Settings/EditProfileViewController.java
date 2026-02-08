package com.demo.web.controller.Settings;

import com.demo.web.model.user;
import com.demo.web.service.AuthService;
import com.demo.web.service.ProfileService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * View controller for edit profile page.
 * Handles GET requests to display edit profile form.
 */
public class EditProfileViewController extends HttpServlet {

    private AuthService authService;
    private ProfileService profileService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        profileService = new ProfileService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== EditProfileViewController START ===");

        // Validate session
        if (!authService.isValidSession(request)) {
            System.out.println("Session validation failed, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = authService.getSession(request);
        Integer userId = authService.getUserId(request);

        System.out.println("User ID from session: " + userId);

        // Fetch fresh user data from database
        user currentUser = profileService.getUserForEdit(userId);
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

        System.out.println("=== EditProfileViewController END ===");
    }
}
