package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsDeactivateRequest;
import com.demo.web.dto.Settings.SettingsDeactivateResponse;
import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;
import com.demo.web.util.RememberMeUtil;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SettingsDeactivateAccount extends HttpServlet {

    private AuthService authService;
    private SettingsService settingsService;
    private userSessionDAO userSessionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        settingsService = new SettingsService();
        userSessionDAO = new userSessionDAO();
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
            RememberMeUtil.clearRememberMe(request, response, userSessionDAO);
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
        } else {
            request.setAttribute("error", res.getErrorMessage());
            request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
        }
    }
}
