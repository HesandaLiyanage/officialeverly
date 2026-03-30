package com.demo.web.controller.Autographs;

import com.demo.web.dto.Autographs.AutographDashboardRequest;
import com.demo.web.dto.Autographs.AutographDashboardResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.AutographService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AutographView extends HttpServlet {

    private AuthService authService;
    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        autographService = new AutographService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        AutographDashboardRequest req = new AutographDashboardRequest(
            userId,
            request.getParameter("action"),
            request.getParameter("id")
        );

        AutographDashboardResponse res = autographService.getDashboard(req);

        if (res.getRedirectUrl() != null && !res.getRedirectUrl().contains("WEB-INF")) {
            response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
            return;
        }

        if (res.isView() || res.isEdit()) {
            request.setAttribute("autograph", res.getAutograph());
            if (res.isView()) {
                request.setAttribute("entries", res.getEntries());
                request.setAttribute("entriesJson", res.getEntriesJson());
                request.setAttribute("entryCount", res.getEntryCount());
            }
        }

        if (res.isList()) {
            request.setAttribute("autographs", res.getAutographs());
            request.setAttribute("recentActivities", res.getRecentActivities());
        }

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }
}
