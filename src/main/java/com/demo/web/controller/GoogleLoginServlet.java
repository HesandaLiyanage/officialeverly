package com.demo.web.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;


public class GoogleLoginServlet extends HttpServlet {

    // Use the Client ID from your downloaded JSON file
    private static final String CLIENT_ID = "your_downloaded_client_id_from_json_file"; // Replace with actual ID
    private static final String REDIRECT_URI = "http://localhost:9090/memories/callback"; // Match your registered URI
    private static final String AUTHORIZATION_ENDPOINT = "https://accounts.google.com/o/oauth2/auth";
    private static final String SCOPE = "openid email profile";

    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Generate a random state string to prevent CSRF
        String state = generateSecureRandomString();
        HttpSession session = request.getSession();
        session.setAttribute("oauth2_state", state); // Store state in session

        // Build the authorization URL
        StringBuilder authUrl = new StringBuilder(AUTHORIZATION_ENDPOINT);
        authUrl.append("?response_type=code");
        authUrl.append("&client_id=").append(URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8));
        authUrl.append("&redirect_uri=").append(URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8));
        authUrl.append("&scope=").append(URLEncoder.encode(SCOPE, StandardCharsets.UTF_8));
        authUrl.append("&state=").append(URLEncoder.encode(state, StandardCharsets.UTF_8));

        // Redirect the user to Google's consent page
        response.sendRedirect(authUrl.toString());
    }

    private String generateSecureRandomString() {
        byte[] randomBytes = new byte[32]; // 256 bits
        secureRandom.nextBytes(randomBytes);
        return java.util.Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
}