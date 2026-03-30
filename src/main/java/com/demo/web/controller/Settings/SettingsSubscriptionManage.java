package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsSubscriptionRequest;
import com.demo.web.dto.Settings.SettingsSubscriptionResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SettingsSubscriptionManage extends HttpServlet {
    
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

        SettingsSubscriptionRequest req = new SettingsSubscriptionRequest(authService.getUserId(request));
        SettingsSubscriptionResponse res = settingsService.getSubscriptionDetails(req);

        request.setAttribute("currentPlan", res.getCurrentPlan());
        request.setAttribute("planName", res.getPlanName());
        request.setAttribute("planPrice", res.getPlanPrice());
        request.setAttribute("storageUsedFormatted", res.getStorageUsedFormatted());
        request.setAttribute("storageTotalFormatted", res.getStorageTotalFormatted());
        request.setAttribute("storagePercentage", res.getStoragePercentage());
        request.setAttribute("billingCycle", res.getBillingCycle());
        request.setAttribute("renewalDate", res.getRenewalDate());
        request.setAttribute("isBasicPlan", res.isBasicPlan());
        request.setAttribute("needsMoreSpace", res.isNeedsMoreSpace());

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }
}
