package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsLinkedDevicesRequest;
import com.demo.web.dto.Settings.SettingsLinkedDevicesResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SettingsLinkedDevicesAction extends HttpServlet {
    
    private AuthService authService;
    private SettingsService settingsService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        settingsService = new SettingsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SettingsLinkedDevicesRequest req = new SettingsLinkedDevicesRequest(
            authService.getUserId(request),
            null,
            request.getSession(false).getId(),
            null
        );

        SettingsLinkedDevicesResponse res = settingsService.getLinkedDevices(req);

        request.setAttribute("devices", res.getDevices());
        request.setAttribute("currentSessionId", req.getCurrentSessionId());

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SettingsLinkedDevicesRequest req = new SettingsLinkedDevicesRequest(
            authService.getUserId(request),
            request.getParameter("action"),
            request.getSession(false).getId(),
            request.getParameter("sessionId")
        );

        SettingsLinkedDevicesResponse res = settingsService.handleLinkedDevicesAction(req);

        if (res.isSuccess()) {
            request.setAttribute("success", res.getSuccessMessage());
        } else {
            request.setAttribute("error", res.getErrorMessage());
        }

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}