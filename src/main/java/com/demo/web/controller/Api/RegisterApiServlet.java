package com.demo.web.controller.Api;

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

@WebServlet("/api/register")
public class RegisterApiServlet extends HttpServlet {
    private Gson gson;

    @Override
    public void init() throws ServletException {
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {
            BufferedReader reader = request.getReader();
            // Just a stub for now
            response.setStatus(HttpServletResponse.SC_NOT_IMPLEMENTED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Native Registration API requires specific Request DTO to be matched with AuthSignup logic");
            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", "Invalid JSON format");
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}
