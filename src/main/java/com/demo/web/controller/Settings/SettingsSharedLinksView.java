package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsSharedLinksRequest;
import com.demo.web.dto.Settings.SettingsSharedLinksResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SettingsSharedLinksView extends HttpServlet {

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

        SettingsSharedLinksRequest req = new SettingsSharedLinksRequest(authService.getUserId(request), null, null);
        SettingsSharedLinksResponse res = settingsService.getSharedLinks(req);

        request.setAttribute("sharedAutographs", res.getSharedAutographs());
        request.setAttribute("sharedMemories", res.getSharedMemories());
        request.setAttribute("sharedInvites", res.getSharedInvites());

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SettingsSharedLinksRequest req = new SettingsSharedLinksRequest(
            authService.getUserId(request),
            request.getParameter("action"),
            request.getParameter("id")
        );

        SettingsSharedLinksResponse res = settingsService.revokeSharedLink(req);

        response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
    }
}
