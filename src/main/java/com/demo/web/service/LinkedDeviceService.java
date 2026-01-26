package com.demo.web.service;

import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.UserSession;

import java.util.List;

/**
 * Service for managing linked devices / user sessions.
 * Extracted from FrontControllerServlet.LinkedDevicesLogicHandler
 */
public class LinkedDeviceService {

    private userSessionDAO userSessionDAO;

    public LinkedDeviceService() {
        this.userSessionDAO = new userSessionDAO();
    }

    /**
     * Gets all active sessions/devices for a user.
     * Marks the current device in the list.
     * 
     * @param userId           The user ID
     * @param currentSessionId The current session ID to mark as "This device"
     * @return List of user sessions
     */
    public List<UserSession> getUserDevices(int userId, String currentSessionId) {
        List<UserSession> devices = userSessionDAO.getUserSessions(userId);

        // Mark the current device
        for (UserSession device : devices) {
            if (device.getSessionId().equals(currentSessionId)) {
                device.setDeviceName(device.getDeviceName() + " (This device)");
            }
        }

        return devices;
    }

    /**
     * Terminates a specific session.
     * 
     * @param sessionId The session ID to terminate
     * @return true if successful
     */
    public boolean terminateSession(String sessionId) {
        return userSessionDAO.deleteSession(sessionId);
    }
}
