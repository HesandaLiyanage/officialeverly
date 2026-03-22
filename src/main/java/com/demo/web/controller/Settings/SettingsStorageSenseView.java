package com.demo.web.controller.Settings;

import com.demo.web.dto.Settings.SettingsStorageSenseRequest;
import com.demo.web.dto.Settings.SettingsStorageSenseResponse;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/storagesenseview")
public class SettingsStorageSenseView extends HttpServlet {

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

        SettingsStorageSenseRequest req = new SettingsStorageSenseRequest(authService.getUserId(request));
        SettingsStorageSenseResponse res = settingsService.getStorageSense(req);

        request.setAttribute("plan", res.getPlan());
        request.setAttribute("usedStorageBytes", res.getUsedStorageBytes());
        request.setAttribute("storageLimitBytes", res.getStorageLimitBytes());
        request.setAttribute("usedPercent", res.getUsedPercent());
        request.setAttribute("usedFormatted", res.getUsedFormatted());
        request.setAttribute("totalFormatted", res.getTotalFormatted());
        request.setAttribute("progressBarColor", res.getProgressBarColor());
        request.setAttribute("contentTypeDisplay", res.getContentTypeDisplay());
        request.setAttribute("topMemoryDisplay", res.getTopMemoryDisplay());
        request.setAttribute("topGroupDisplay", res.getTopGroupDisplay());
        request.setAttribute("duplicateCount", res.getDuplicateCount());
        request.setAttribute("duplicateSize", res.getDuplicateSize());
        request.setAttribute("duplicateSizeFormatted", res.getDuplicateSizeFormatted());
        request.setAttribute("trashCount", res.getTrashCount());
        request.setAttribute("memoryCount", res.getMemoryCount());

        request.getRequestDispatcher(res.getRedirectUrl()).forward(request, response);
    }
}
