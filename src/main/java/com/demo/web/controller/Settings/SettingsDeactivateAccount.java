package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsDeactivateRequest;
import com.demo.web.dto.Settings.SettingsDeactivateResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import java.io.IOException;

public class SettingsDeactivateAccount extends HttpServlet {

    private AuthService authService;
    private SettingsService settingsService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        settingsService = new SettingsService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        SettingsDeactivateRequest req = new SettingsDeactivateRequest(userId);
        SettingsDeactivateResponse res = settingsService.deactivateAccount(req);

        if (res.isSuccess()) {
            SessionUtil.revokeSession(request);
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("session_token".equals(cookie.getName())) {
                        cookie.setValue("");
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                        break;
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
        } else {
            request.setAttribute("error", res.getErrorMessage());
            request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
        }
    }
}
