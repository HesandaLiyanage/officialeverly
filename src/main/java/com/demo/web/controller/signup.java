package com.demo.web.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;

public class signup extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    // Email validation pattern
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to signup JSP page
        request.getRequestDispatcher("/signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String bio = request.getParameter("bio");

        // Trim whitespace
        username = (username != null) ? username.trim() : "";
        email = (email != null) ? email.trim() : "";
        password = (password != null) ? password.trim() : "";
        bio = (bio != null) ? bio.trim() : "";

        try {
            // Validate input
            String validationError = validateInput(username, email, password);
            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
                return;
            }

            // Check if user already exists
            if (userDAO.findByemail(email)) {
                request.setAttribute("errorMessage", "An account with this email already exists.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
                return;
            }

            // Create new user object
            user newUser = new user();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(hashPassword(password)); // Hash the password
            newUser.setBio(bio);

            // Save user to database
            boolean userCreated = userDAO.createUser(newUser);

            if (userCreated) {
                // Get the created user (with generated ID)
                user createdUser = userDAO.findByemail(email);

                if (createdUser != null) {
                    // Create user session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", createdUser);
                    session.setAttribute("userId", createdUser.getId());

                    // Optional: Store session in database
                    userSessionDAO.createSession(createdUser.getId(), session.getId());

                    // Success - redirect to dashboard or home page
                    request.setAttribute("successMessage", "Account created successfully! Welcome, " + username + "!");
                    request.setAttribute("messageType", "success");

                    // Option 1: Redirect to dashboard
                    // response.sendRedirect("dashboard");

                    // Option 2: Forward to success page
                    request.getRequestDispatcher("/signup.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Account created but login failed. Please try logging in.");
                    request.setAttribute("messageType", "error");
                    request.getRequestDispatcher("/signup.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Failed to create account. Please try again.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // Log the error
            System.err.println("Database error during signup: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);

        } catch (Exception e) {
            // Log unexpected errors
            System.err.println("Unexpected error during signup: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    /**
     * Validates user input
     */
    private String validateInput(String username, String email, String password) {
        // Check required fields
        if (username == null || username.isEmpty()) {
            return "Username is required.";
        }

        if (email == null || email.isEmpty()) {
            return "Email is required.";
        }

        if (password == null || password.isEmpty()) {
            return "Password is required.";
        }

        // Validate username length and characters
        if (username.length() < 2) {
            return "Username must be at least 2 characters long.";
        }

        if (username.length() > 50) {
            return "Username must be less than 50 characters.";
        }

        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Please enter a valid email address.";
        }

        if (email.length() > 100) {
            return "Email must be less than 100 characters.";
        }

        // Validate password strength
        if (password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }

        if (password.length() > 128) {
            return "Password must be less than 128 characters.";
        }

        // Optional: Add more password strength requirements
        // if (!password.matches(".*[A-Z].*")) {
        //     return "Password must contain at least one uppercase letter.";
        // }

        return null; // No validation errors
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
        return password;
    }

    @Override
    public void destroy() {
        // Clean up resources if needed
        super.destroy();
    }
}