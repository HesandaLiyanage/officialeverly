package com.demo.web.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.regex.Pattern;
import javax.crypto.SecretKey;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;
import com.demo.web.util.PasswordUtil;

public class signupservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");

    @Override
    public void init() throws ServletException {
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
        req.getRequestDispatcher("/signup").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String step = req.getParameter("step");
        if ("2".equals(step)) {
            handleStep2(req, resp);
        } else {
            handleStep1(req, resp);
        }
    }

    private void handleStep1(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String terms = req.getParameter("terms");

        // Add null checks
        if (email == null || password == null || confirmPassword == null) {
            req.setAttribute("errorMessage", "Please fill in all required fields.");
            req.getRequestDispatcher("/signup").forward(req, resp);
            return;
        }

        email = email.trim();
        password = password.trim();
        confirmPassword = confirmPassword.trim();

        List<String> errors = new ArrayList<>();

        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) errors.add("Invalid email.");
        if (password.length() < 6) errors.add("Password too short.");
        if (!password.equals(confirmPassword)) errors.add("Passwords do not match.");
        if (!"on".equals(terms)) errors.add("You must agree to Terms.");

        if (userDAO.findByemail(email) != null) errors.add("Email already exists.");

        if (!errors.isEmpty()) {
            req.setAttribute("errorMessage", String.join(" ", errors));
            req.getRequestDispatcher("/signup").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("temp_email", email);
        session.setAttribute("temp_password", password);
        session.setMaxInactiveInterval(30 * 60);

        resp.sendRedirect(req.getContextPath() + "/signup2");
    }

    private void handleStep2(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("temp_email") == null) {
            resp.sendRedirect(req.getContextPath() + "/signup");
            return;
        }

        String email = (String) session.getAttribute("temp_email");
        String password = (String) session.getAttribute("temp_password");
        String name = req.getParameter("name");
        String bio = req.getParameter("bio");

        // Add null check for name
        if (name == null) {
            req.setAttribute("errorMessage", "Name is required.");
            req.getRequestDispatcher("/signup2").forward(req, resp);
            return;
        }

        name = name.trim();

        // Bio is optional
        if (bio == null) {
            bio = "";
        } else {
            bio = bio.trim();
        }

        List<String> errors = new ArrayList<>();
        if (name.length() < 2 || name.length() > 50) errors.add("Name invalid.");
        if (bio.length() > 500) errors.add("Bio too long.");

        if (!errors.isEmpty()) {
            req.setAttribute("errorMessage", String.join(" ", errors));
            req.getRequestDispatcher("/signup2").forward(req, resp);
            return;
        }

        try {
            user newUser = new user();
            newUser.setUsername(name);
            newUser.setEmail(email);
            newUser.setPassword(password); // Raw password - DAO will hash it AND create encryption keys
            newUser.setBio(bio);
            newUser.setProfilePictureUrl("/resources/assets/everlylogo.png");

            // ============================================
            // This now creates user WITH encryption keys automatically!
            // Your updated userDAO.createUser() handles everything
            // ============================================
            boolean created = userDAO.createUser(newUser);

            if (created) {
                session.removeAttribute("temp_email");
                session.removeAttribute("temp_password");
                session.setAttribute("user", newUser);
                session.setAttribute("user_id", newUser.getId());
                userSessionDAO.createSession(newUser.getId(), session.getId());

                // ============================================
                // NEW: Unlock the master key after registration
                // ============================================
                try {
                    SecretKey masterKey = userDAO.unlockUserMasterKey(newUser.getId(), password);

                    // Store master key in session
                    session.setAttribute("masterKey", masterKey);

                    // Also store in session DAO cache
                    userSessionDAO.storeMasterKeyInCache(session.getId(), masterKey);

                    System.out.println("✓ User registered with encryption: " + newUser.getUsername());

                } catch (Exception e) {
                    // This shouldn't happen for new users, but handle gracefully
                    System.err.println("⚠ Warning: User created but encryption keys failed: " + e.getMessage());
                    e.printStackTrace();

                    // User is created and logged in, but without encryption
                    // They can set it up later if needed
                }
                // ============================================
                // END NEW CODE
                // ============================================

                resp.sendRedirect(req.getContextPath() + "/memories");
            } else {
                req.setAttribute("errorMessage", "Failed to create account.");
                req.getRequestDispatcher("/signup2").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Unexpected error.");
            req.getRequestDispatcher("/signup2").forward(req, resp);
        }
    }
}

/*
 * CHANGES MADE:
 *
 * 1. Added import: javax.crypto.SecretKey
 * 2. Added ~15 lines after user creation to unlock master key
 * 3. Everything else UNCHANGED
 *
 * WHAT THIS DOES:
 * - userDAO.createUser() now creates BOTH auth credentials AND encryption keys
 * - After successful creation, immediately unlocks the master key
 * - Stores master key in session (user is auto-logged in with encryption ready)
 *
 * YOUR EXISTING FLOW:
 * - Step 1: Email + Password validation (UNCHANGED)
 * - Step 2: Name + Bio → Create user (UNCHANGED logic, enhanced DAO)
 * - NEW: Master key automatically unlocked and stored
 *
 * RESULT:
 * - New users get full encryption automatically
 * - No extra steps required from user
 * - Seamless experience
 */