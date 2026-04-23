package com.demo.web.service;

import com.demo.web.dao.Auth.userDAO;
import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.model.Auth.user;
import com.demo.web.dto.Auth.*;
import com.demo.web.util.AppLogger;
import com.demo.web.util.AdminAccessUtil;
import com.demo.web.util.PasswordUtil;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import javax.crypto.SecretKey;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.logging.Logger;

public class AuthService {

    private static final Logger logger = AppLogger.getLogger(AuthService.class);

    private userDAO userDAO;
    private userSessionDAO userSessionDAO;

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final String TOKEN_ENDPOINT = "https://oauth2.googleapis.com/token";

    public AuthService() {
        this.userDAO = new userDAO();
        this.userSessionDAO = new userSessionDAO();
    }

    public AuthLoginResponse login(AuthLoginRequest request) {
        AuthLoginResponse response = new AuthLoginResponse();
        
        if (request.getUsername() == null || request.getPassword() == null ||
            request.getUsername().isEmpty() || request.getPassword().isEmpty()) {
            response.setErrorMessage("Username and password are required");
            return response;
        }

        String usernameOrEmail = request.getUsername().trim();
        user user = userDAO.findByemail(usernameOrEmail);
        
        if (user != null && PasswordUtil.verifyPassword(request.getPassword(), user.getSalt(), user.getPassword())) {
            if (PasswordUtil.needsRehash(user.getPassword())) {
                String upgradedSalt = PasswordUtil.generateSalt();
                String upgradedHash = PasswordUtil.hashPassword(request.getPassword(), upgradedSalt);
                if (userDAO.upgradePasswordHash(user.getId(), upgradedHash, upgradedSalt)) {
                    user.setSalt(upgradedSalt);
                    user.setPassword(upgradedHash);
                }
            }
            
            if (!user.is_active()) {
                userDAO.reactivateAccount(user.getId());
                user.set_active(true);
            }

            response.setUser(user);

            try {
                SecretKey masterKey = userDAO.unlockUserMasterKey(user.getId(), request.getPassword());
                response.setMasterKey(masterKey);
            } catch (Exception e) {
                AppLogger.warn(logger, "Unable to unlock master key during login for user " + user.getId(), e);
            }

            if ("true".equals(request.getRememberMe()) || "on".equals(request.getRememberMe())) {
                try {
                    String token = userSessionDAO.createRememberMeToken(user.getId());
                    response.setRememberMeToken(token);
                } catch (Exception e) {
                    AppLogger.warn(logger, "Unable to create remember-me token for user " + user.getId(), e);
                }
            }

            response.setSuccess(true);
            
            if (AdminAccessUtil.isAdminUser(user)) {
                response.setRedirectUrl("/adminanalytics");
            }

        } else {
            response.setErrorMessage("Invalid username or password");
        }
        
        return response;
    }

    public AuthSignupStep1Response signupStep1(AuthSignupStep1Request request) {
        AuthSignupStep1Response response = new AuthSignupStep1Response();
        
        if (request.getEmail() == null || request.getPassword() == null || request.getConfirmPassword() == null) {
            response.setErrorMessage("Please fill in all required fields.");
            return response;
        }

        String email = request.getEmail().trim();
        String password = request.getPassword().trim();
        String confirmPassword = request.getConfirmPassword().trim();

        List<String> errors = new ArrayList<>();

        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) errors.add("Invalid email.");
        if (!PasswordUtil.isPasswordStrong(password)) errors.add(PasswordUtil.getPasswordRequirements());
        if (!password.equals(confirmPassword)) errors.add("Passwords do not match.");
        if (!"on".equals(request.getTerms())) errors.add("You must agree to Terms.");

        if (userDAO.findByemail(email) != null) errors.add("Email already exists.");

        if (!errors.isEmpty()) {
            response.setErrorMessage(String.join(" ", errors));
            return response;
        }

        response.setSuccess(true);
        response.setEmail(email);
        return response;
    }

    public AuthSignupStep2Response signupStep2(AuthSignupStep2Request request) {
        AuthSignupStep2Response response = new AuthSignupStep2Response();

        if (request.getName() == null || request.getPassword() == null || request.getConfirmPassword() == null) {
            response.setErrorMessage("Name and password confirmation are required.");
            return response;
        }

        if (!request.getPassword().equals(request.getConfirmPassword())) {
            response.setErrorMessage("Passwords do not match.");
            return response;
        }

        if (!PasswordUtil.isPasswordStrong(request.getPassword())) {
            response.setErrorMessage(PasswordUtil.getPasswordRequirements());
            return response;
        }

        if (request.getEmail() == null || request.getEmail().isBlank()) {
            response.setErrorMessage("Signup session expired. Please start again.");
            return response;
        }

        String name = request.getName().trim();
        String bio = request.getBio() == null ? "" : request.getBio().trim();

        List<String> errors = new ArrayList<>();
        if (name.length() < 2 || name.length() > 50) errors.add("Name invalid.");
        if (bio.length() > 500) errors.add("Bio too long.");

        if (!errors.isEmpty()) {
            response.setErrorMessage(String.join(" ", errors));
            return response;
        }

        try {
            user newUser = new user();
            newUser.setUsername(name);
            newUser.setEmail(request.getEmail());
            newUser.setPassword(request.getPassword());
            newUser.setBio(bio);
            newUser.setProfilePictureUrl("/resources/assets/everlylogo.png");

            boolean created = userDAO.createUser(newUser);

            if (created) {
                response.setSuccess(true);
                response.setUser(newUser);
                
                try {
                    SecretKey masterKey = userDAO.unlockUserMasterKey(newUser.getId(), request.getPassword());
                    response.setMasterKey(masterKey);
                } catch (Exception e) {
                    AppLogger.warn(logger, "Unable to unlock master key after signup for user " + newUser.getId(), e);
                }
            } else {
                response.setErrorMessage("Failed to create account.");
            }

        } catch (Exception e) {
            AppLogger.error(logger, "Unexpected signup error", e);
            response.setErrorMessage("Unexpected error.");
        }
        
        return response;
    }

    public AuthGoogleCallbackResponse processGoogleCallback(AuthGoogleCallbackRequest request, String clientId, String clientSecret, String redirectUri) {
        AuthGoogleCallbackResponse response = new AuthGoogleCallbackResponse();

        if (request.getReceivedState() == null || !request.getReceivedState().equals(request.getStoredState())) {
            response.setStatusCode(400);
            response.setErrorMessage("Invalid state parameter.");
            return response;
        }

        if (request.getCode() == null || request.getCode().isEmpty()) {
            response.setStatusCode(400);
            response.setErrorMessage("Authorization code not found.");
            return response;
        }

        try {
            String accessToken = exchangeCodeForToken(request.getCode(), clientId, clientSecret, redirectUri);
            if (accessToken != null) {
                JsonObject userInfo = getUserInfo(accessToken);
                if (userInfo != null) {
                    String email = userInfo.get("email").getAsString();
                    
                    user googleUser = userDAO.findByUsername(email);

                    if (googleUser == null) {
                        googleUser = new user();
                        googleUser.setUsername(email);
                    }

                    response.setSuccess(true);
                    response.setUser(googleUser);
                } else {
                    response.setStatusCode(500);
                    response.setErrorMessage("Failed to retrieve user information.");
                }
            } else {
                response.setStatusCode(500);
                response.setErrorMessage("Failed to exchange code for access token.");
            }
        } catch (Exception e) {
            AppLogger.warn(logger, "Google authentication callback failed", e);
            response.setStatusCode(500);
            response.setErrorMessage("An error occurred during authentication.");
        }
        return response;
    }

    private String exchangeCodeForToken(String code, String clientId, String clientSecret, String redirectUri) throws IOException {
        URL url = new URL(TOKEN_ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        String postData = String.format(
                "code=%s&client_id=%s&client_secret=%s&redirect_uri=%s&grant_type=authorization_code",
                URLEncoder.encode(code, StandardCharsets.UTF_8),
                URLEncoder.encode(clientId, StandardCharsets.UTF_8),
                URLEncoder.encode(clientSecret, StandardCharsets.UTF_8),
                URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
        );

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

            JsonObject tokenResponse = JsonParser.parseString(content.toString()).getAsJsonObject();
            if (tokenResponse.has("access_token")) {
                return tokenResponse.get("access_token").getAsString();
            }
        }
        return null;
    }

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

            return JsonParser.parseString(content.toString()).getAsJsonObject();
        }
        return null; 
    }

    // --- Session Helper Methods for Controllers ---

    public boolean isValidSession(javax.servlet.http.HttpServletRequest request) {
        return com.demo.web.util.SessionUtil.isValidSession(request);
    }

    public int getUserId(javax.servlet.http.HttpServletRequest request) {
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user_id") != null) {
            return (Integer) session.getAttribute("user_id");
        }
        return -1;
    }

    public javax.servlet.http.HttpSession getSession(javax.servlet.http.HttpServletRequest request) {
        return request.getSession(false);
    }

    public String getSessionId(javax.servlet.http.HttpServletRequest request) {
        javax.servlet.http.HttpSession session = request.getSession(false);
        if (session != null) {
            return session.getId();
        }
        return null;
    }
}
