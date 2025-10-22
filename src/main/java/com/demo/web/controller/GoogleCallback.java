package com.demo.web.controller;

import com.demo.web.dao.userDAO;
import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;
import com.demo.web.util.SessionUtil;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

// This must match your registered redirect URI
public class GoogleCallback extends HttpServlet {

    // Use the Client ID and Secret from your downloaded JSON file
    private static final String CLIENT_ID = "417018345621-nn7l4i95mi5u0pu9vlipd5op6cfvmc72.apps.googleusercontent.com "; // Replace
    private static final String CLIENT_SECRET = "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"; // Replace
    private static final String REDIRECT_URI = "http://localhost:9090/googlecallback"; // Match registered URI
    private static final String TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";

    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new userDAO();
        userSessionDAO = new userSessionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        String receivedState = request.getParameter("state");

        HttpSession session = request.getSession();
        String storedState = (String) session.getAttribute("oauth2_state");

        // CSRF Check
        if (receivedState == null || !receivedState.equals(storedState)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid state parameter.");
            return;
        }

        if (code == null || code.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Authorization code not found.");
            return;
        }

        try {
            // Exchange the code for tokens
            String accessToken = exchangeCodeForToken(code);
            if (accessToken != null) {
                // Successfully got the token, now get user info
                JsonObject userInfo = getUserInfo(accessToken);
                if (userInfo != null) {
                    String email = userInfo.get("email").getAsString();
                    String name = userInfo.get("name").getAsString();
                    String googleId = userInfo.get("id").getAsString(); // Google's unique ID for the user

                    // --- Core Logic: Find or Create User based on Google Email ---
                    user googleUser = userDAO.findByUsername(email); // Assuming email is used as username

                    if (googleUser == null) {
                        // User doesn't exist, create a new one
                        googleUser = new user();
                        googleUser.setUsername(email); // Use email as username
                        // Set other fields as needed, maybe name, maybe a placeholder password, etc.
                        // You might want a flag to indicate this user was created via Google
                        // googleUser.setGoogleId(googleId); // If you have a field for this
                        // Call your DAO's insert method
                        // userDAO.insert(googleUser); // Implement this if needed
                    }

                    // --- End Core Logic ---

                    // Login the user using your existing SessionUtil
                    SessionUtil.createSession(request, googleUser);

                    // Redirect to the main page after successful login
                    response.sendRedirect(request.getContextPath() + "/memories");
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve user information.");
                }
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to exchange code for access token.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred during authentication.");
        }
    }

    private String exchangeCodeForToken(String code) throws IOException {
        URL url = new URL(TOKEN_ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        // Prepare POST data
        String postData = String.format(
                "code=%s&client_id=%s&client_secret=%s&redirect_uri=%s&grant_type=authorization_code",
                URLEncoder.encode(code, StandardCharsets.UTF_8),
                URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8),
                URLEncoder.encode(CLIENT_SECRET, StandardCharsets.UTF_8),
                URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
        );

        // Send POST data
        try (DataOutputStream wr = new DataOutputStream(conn.getOutputStream())) {
            wr.writeBytes(postData);
            wr.flush();
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            // Parse the JSON response to get the access token
            JsonObject tokenResponse = JsonParser.parseString(content.toString()).getAsJsonObject();
            if (tokenResponse.has("access_token")) {
                return tokenResponse.get("access_token").getAsString();
            }
        } else {
            System.err.println("Token Exchange failed. Response Code: " + responseCode);
            // Read error stream if needed for debugging
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String inputLine;
            StringBuilder errorContent = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                errorContent.append(inputLine);
            }
            in.close();
            System.err.println("Error Response: " + errorContent.toString());
        }
        return null; // Indicate failure
    }

    // Method to fetch user info using the access token
    private JsonObject getUserInfo(String accessToken) throws IOException {
        String userInfoUrl = "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken;
        URL url = new URL(userInfoUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            // Parse the JSON response containing user info
            return JsonParser.parseString(content.toString()).getAsJsonObject();
        } else {
            System.err.println("User Info Request failed. Response Code: " + responseCode);
        }
        return null; // Indicate failure
    }
}