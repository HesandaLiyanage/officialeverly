package com.demo.web.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;

public class signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    // Email validation pattern (from your original code)
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            userDAO = new userDAO();
            userSessionDAO = new userSessionDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Show the first signup page
        req.getRequestDispatcher("/fragments/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String referer = req.getHeader("Referer");

        // Determine which step we're on based on the referer
        if (referer != null && referer.contains("page=profile")) {
            // We're on step 2 (profile page)
            handleProfileSetup(req, resp);
        } else {
            // We're on step 1 (signup page)
            handleStep1(req, resp);
        }
    }

    private void handleStep1(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String terms = req.getParameter("terms");

        // Trim whitespace
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password.trim() : "";
        confirmPassword = (confirmPassword != null) ? confirmPassword.trim() : "";

        // Validate input
        List<String> errors = new ArrayList<>();

        if (email == null || email.isEmpty()) {
            errors.add("Email is required.");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            errors.add("Please enter a valid email address.");
        } else if (email.length() > 100) {
            errors.add("Email must be less than 100 characters.");
        }

        if (password == null || password.isEmpty()) {
            errors.add("Password is required.");
        } else if (password.length() < 6) {
            errors.add("Password must be at least 6 characters long.");
        } else if (password.length() > 128) {
            errors.add("Password must be less than 128 characters.");
        }

        if (!password.equals(confirmPassword)) {
            errors.add("Passwords do not match.");
        }

        if (terms == null || !terms.equals("on")) {
            errors.add("You must agree to the Terms of Service and Privacy Policy.");
        }

        if (!errors.isEmpty()) {
            // Store errors and return to signup page
            req.setAttribute("errorMessage", String.join(" ", errors));
            req.setAttribute("messageType", "error");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/fragments/signup.jsp").forward(req, resp);
            return;
        }

        // Check if email already exists
        user existingUser = userDAO.findByemail(email);
        if (existingUser != null) {
            req.setAttribute("errorMessage", "An account with this email already exists.");
            req.setAttribute("messageType", "error");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/fragments/signup.jsp").forward(req, resp);
            return;
        }

        // Store basic info in session temporarily
        HttpSession session = req.getSession();
        session.setAttribute("temp_signup_email", email);
        session.setAttribute("temp_signup_password", password);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout

        // Redirect to profile setup page
        resp.sendRedirect(req.getContextPath() + "/view?page=profile");
    }

    private void handleProfileSetup(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Check if user has completed step 1
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("temp_signup_email") == null) {
            resp.sendRedirect(req.getContextPath() + "/view?page=signup");
            return;
        }

        // Get data from step 1
        String email = (String) session.getAttribute("temp_signup_email");
        String password = (String) session.getAttribute("temp_signup_password");

        // Get data from profile page
        String name = req.getParameter("name");
        String bio = req.getParameter("bio");

        // Trim whitespace
        name = (name != null) ? name.trim() : "";
        bio = (bio != null) ? bio.trim() : "";

        // Validate profile data
        List<String> errors = validateProfileData(name, bio);
        if (!errors.isEmpty()) {
            req.setAttribute("errorMessage", String.join(" ", errors));
            req.setAttribute("messageType", "error");
            req.getRequestDispatcher("/fragments/signup2.jsp").forward(req, resp);
            return;
        }

        try {
            // Handle profile picture upload
            String profilePicturePath = null;
            try {
                profilePicturePath = handleProfilePictureUpload(req);
            } catch (Exception e) {
                req.setAttribute("errorMessage", "Failed to upload profile picture: " + e.getMessage());
                req.setAttribute("messageType", "error");
                req.getRequestDispatcher("/fragments/signup2.jsp").forward(req, resp);
                return;
            }

            // Create new user object
            user newUser = new user();
            newUser.setUsername(name);  // Using name as username
            newUser.setEmail(email);
            newUser.setPassword(hashPassword(password)); // Hash the password
            newUser.setBio(bio);

            // If you have a separate username field, you might want to set it differently
            // For now, using the name as username, or you could generate a unique one

            // Save user to database
            boolean userCreated = userDAO.createUser(newUser);

            if (userCreated) {
                // Get the created user (with generated ID)
                user createdUser = userDAO.findByemail(email);

                if (createdUser != null) {
                    // Clear temporary session data
                    session.removeAttribute("temp_signup_email");
                    session.removeAttribute("temp_signup_password");

                    // Create user session
                    session.setAttribute("user", createdUser);
                    session.setAttribute("userId", createdUser.getId());

                    // Optional: Store session in database
                    userSessionDAO.createSession(createdUser.getId(), session.getId());

                    // Success - redirect to landing page
                    resp.sendRedirect(req.getContextPath() + "/view?page=landingContent");
                } else {
                    req.setAttribute("errorMessage", "Account created but login failed. Please try logging in.");
                    req.setAttribute("messageType", "error");
                    req.getRequestDispatcher("/fragments/signup2.jsp").forward(req, resp);
                }
            } else {
                req.setAttribute("errorMessage", "Failed to create account. Please try again.");
                req.setAttribute("messageType", "error");
                req.getRequestDispatcher("/fragments/signup2.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            // Log unexpected errors
            System.err.println("Unexpected error during signup: " + e.getMessage());
            e.printStackTrace();

            req.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            req.setAttribute("messageType", "error");
            req.getRequestDispatcher("/fragments/signup2.jsp").forward(req, resp);
        }
    }

    private List<String> validateProfileData(String name, String bio) {
        List<String> errors = new ArrayList<>();

        if (name == null || name.isEmpty()) {
            errors.add("Name is required.");
        } else if (name.length() < 2) {
            errors.add("Name must be at least 2 characters long.");
        } else if (name.length() > 50) {
            errors.add("Name must be less than 50 characters.");
        }

        if (bio != null && bio.length() > 500) {
            errors.add("Bio must be less than 500 characters.");
        }

        return errors;
    }

    /**
     * Hash password (replace with proper hashing algorithm)
     * This is a placeholder - use BCrypt, SCrypt, or Argon2 in production
     */
    private String hashPassword(String password) {
        // TODO: Replace with proper password hashing
        // Example using BCrypt:
        // return BCrypt.hashpw(password, BCrypt.gensalt());

        // For now, returning as-is (NOT SECURE - only for development)
        // You should implement proper password hashing here
        return password;
    }

    /**
     * Handle profile picture upload
     * You'll need to implement this based on your ProfilePictureService
     */
    private String handleProfilePictureUpload(HttpServletRequest req) throws Exception {
        // This is a placeholder - implement based on your actual upload logic
        // You might want to use Apache Commons FileUpload or similar

        Part filePart = req.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            // Implement your file upload logic here
            // Return the path where the file was saved
            return "/path/to/saved/image.jpg"; // Replace with actual path
        }
        return null; // No picture uploaded
    }

    @Override
    public void destroy() {
        // Clean up resources if needed
        super.destroy();
    }
}