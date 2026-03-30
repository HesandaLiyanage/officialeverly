package com.demo.web.controller.Settings;

import com.demo.web.model.Auth.UserSession;
import com.demo.web.service.AuthService;
import com.demo.web.service.SettingsService;
import com.demo.web.dto.Settings.SettingsLinkedDevicesRequest;
import com.demo.web.dto.Settings.SettingsLinkedDevicesResponse;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SettingsLinkedDevicesView extends HttpServlet {

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

        Integer userId = authService.getUserId(request);
        String currentSessionId = authService.getSessionId(request);

        SettingsLinkedDevicesRequest req = new SettingsLinkedDevicesRequest(userId, null, currentSessionId, null);
        SettingsLinkedDevicesResponse res = settingsService.getLinkedDevices(req);

        List<UserSession> devices = res.getDevices();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        List<Map<String, Object>> deviceDisplayData = new ArrayList<>();
        
        for (UserSession device : devices) {
            Map<String, Object> displayData = new HashMap<>();
            displayData.put("deviceName", device.getDeviceName());
            displayData.put("deviceType", device.getDeviceType());
            displayData.put("sessionId", device.getSessionId());
            displayData.put("lastLogin", device.getCreatedAt() != null ? dateFormat.format(device.getCreatedAt()) : "Unknown");
            displayData.put("isCurrentDevice", device.getSessionId().equals(currentSessionId));
            deviceDisplayData.add(displayData);
        }

        request.setAttribute("deviceDisplayData", deviceDisplayData);

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/linkeddevices.jsp").forward(request, response);
    }
}
