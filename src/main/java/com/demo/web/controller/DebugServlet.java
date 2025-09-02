package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.model.user;
import com.demo.web.util.DatabaseUtil;
import com.demo.web.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DebugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body>");
        out.println("<h2>Database Debug Information</h2>");

        // Test 1: Database connection
        out.println("<h3>1. Database Connection Test</h3>");
        try {
            boolean connected = DatabaseUtil.testConnection();
            out.println("<p>Database Connection: " + (connected ? "✅ SUCCESS" : "❌ FAILED") + "</p>");
            out.println("<p>Database URL: " + DatabaseUtil.getDatabaseUrl() + "</p>");
        } catch (Exception e) {
            out.println("<p>❌ Connection Error: " + e.getMessage() + "</p>");
        }

        // Test 2: Check users in database
        out.println("<h3>2. Users in Database</h3>");
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT id, username, email, is_active FROM users LIMIT 5";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Username</th><th>Email</th><th>Active</th></tr>");

            boolean hasUsers = false;
            while (rs.next()) {
                hasUsers = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getBoolean("is_active") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            if (!hasUsers) {
                out.println("<p>❌ No users found in database!</p>");
            }

        } catch (Exception e) {
            out.println("<p>❌ Database Query Error: " + e.getMessage() + "</p>");
        }

        // Test 3: Password hashing test
        out.println("<h3>3. Password Hashing Test</h3>");
        String testPassword = "password123";
        String testSalt = PasswordUtil.generateSalt();
        String testHash = PasswordUtil.hashPassword(testPassword, testSalt);
        boolean verified = PasswordUtil.verifyPassword(testPassword, testSalt, testHash);

        out.println("<p>Test Password: " + testPassword + "</p>");
        out.println("<p>Generated Salt: " + testSalt + "</p>");
        out.println("<p>Generated Hash: " + testHash + "</p>");
        out.println("<p>Verification: " + (verified ? "✅ SUCCESS" : "❌ FAILED") + "</p>");

        // Test 4: Test authentication with existing user
        out.println("<h3>4. Authentication Test Form</h3>");
        out.println("<form method='post'>");
        out.println("Username: <input name='testUsername' type='text' value='admin'><br><br>");
        out.println("Password: <input name='testPassword' type='text' value='password123'><br><br>");
        out.println("<input type='submit' value='Test Authentication'>");
        out.println("</form>");

        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String testUsername = request.getParameter("testUsername");
        String testPassword = request.getParameter("testPassword");

        out.println("<html><body>");
        out.println("<h2>Authentication Test Results</h2>");

        out.println("<p>Testing with:</p>");
        out.println("<p>Username: " + testUsername + "</p>");
        out.println("<p>Password: " + testPassword + "</p>");

        try {
            userDAO userDAO = new userDAO();
            user user = userDAO.authenticateUser(testUsername, testPassword);

            if (user != null) {
                out.println("<h3>✅ Authentication SUCCESS!</h3>");
                out.println("<p>User ID: " + user.getId() + "</p>");
                out.println("<p>Username: " + user.getUsername() + "</p>");
                out.println("<p>Email: " + user.getEmail() + "</p>");
                out.println("<p>Active: " + user.isActive() + "</p>");
            } else {
                out.println("<h3>❌ Authentication FAILED!</h3>");

                // Let's check what's in the database for this user
                out.println("<h4>Debug Info:</h4>");
                try (Connection conn = DatabaseUtil.getConnection()) {
                    String sql = "SELECT username, password_hash, salt, is_active FROM users WHERE username = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, testUsername);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String storedHash = rs.getString("password_hash");
                        String storedSalt = rs.getString("salt");
                        boolean active = rs.getBoolean("is_active");

                        out.println("<p>User found in database</p>");
                        out.println("<p>Stored Salt: " + storedSalt + "</p>");
                        out.println("<p>Stored Hash: " + storedHash + "</p>");
                        out.println("<p>Is Active: " + active + "</p>");

                        // Test password verification manually
                        boolean passwordMatch = PasswordUtil.verifyPassword(testPassword, storedSalt, storedHash);
                        out.println("<p>Password Match: " + (passwordMatch ? "✅ YES" : "❌ NO") + "</p>");

                        // Show what hash would be generated with input password
                        String newHash = PasswordUtil.hashPassword(testPassword, storedSalt);
                        out.println("<p>Expected Hash: " + newHash + "</p>");

                    } else {
                        out.println("<p>❌ User '" + testUsername + "' not found in database!</p>");
                    }
                }
            }

        } catch (Exception e) {
            out.println("<h3>❌ Error during authentication:</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace();
        }

        out.println("<br><a href='/debug'>← Back to Debug Page</a>");
        out.println("</body></html>");
    }
}