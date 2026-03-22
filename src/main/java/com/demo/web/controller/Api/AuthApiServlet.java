package com.demo.web.controller.Api;

import com.demo.web.dto.Auth.AuthLoginRequest;
import com.demo.web.dto.Auth.AuthLoginResponse;
import com.demo.web.service.AuthService;
import com.demo.web.util.SessionUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/api/login")
public class AuthApiServlet extends HttpServlet {
    private AuthService authService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            // Parse JSON body
            BufferedReader reader = request.getReader();
            AuthLoginRequest loginRequest = gson.fromJson(reader, AuthLoginRequest.class);

            if (loginRequest == null || loginRequest.getUsername() == null || loginRequest.getPassword() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("errorMessage", "Username and password are required");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Authenticate
            AuthLoginResponse authResponse = authService.login(loginRequest);

            if (authResponse.isSuccess()) {
                // Set JSESSIONID internally via standard Tomcat session
                SessionUtil.createSession(request, authResponse.getUser());

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Login successful");
                // Don't leak passwords or sensitive data to API
                response.getWriter().write(gson.toJson(jsonResponse));
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("errorMessage", authResponse.getErrorMessage());
                response.getWriter().write(gson.toJson(jsonResponse));
            }

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("errorMessage", "Invalid JSON format");
            response.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("errorMessage", "Internal server error: " + e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
