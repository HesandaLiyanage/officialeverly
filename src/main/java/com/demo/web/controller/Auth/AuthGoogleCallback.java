package com.demo.web.controller.Auth;

import com.demo.web.dto.Auth.AuthGoogleCallbackRequest;
import com.demo.web.dto.Auth.AuthGoogleCallbackResponse;
import com.demo.web.service.AuthService;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthGoogleCallback extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID") != null ? System.getenv("GOOGLE_CLIENT_ID") : ""; 
    private static final String CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET") != null ? System.getenv("GOOGLE_CLIENT_SECRET") : ""; 
    private static final String REDIRECT_URI = "http://localhost:9090/googlecallback";

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        AuthGoogleCallbackRequest req = new AuthGoogleCallbackRequest(
            request.getParameter("code"),
            request.getParameter("state"),
            (String) session.getAttribute("oauth2_state")
        );

        AuthGoogleCallbackResponse res = authService.processGoogleCallback(req, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI);

        if (res.isSuccess()) {
            SessionUtil.createSession(request, res.getUser());
            response.sendRedirect(request.getContextPath() + "/memories");
        } else {
            response.sendError(res.getStatusCode() != 0 ? res.getStatusCode() : HttpServletResponse.SC_INTERNAL_SERVER_ERROR, res.getErrorMessage());
        }
    }
}