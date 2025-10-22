package com.demo.web.util;

import com.demo.web.dao.userSessionDAO;
import com.demo.web.model.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionUtil {

    private static userSessionDAO userSessionDAO = new userSessionDAO();

    /**
     * Create HTTP session and store in database
     */
    public static void createSession(HttpServletRequest request, user user) {
        System.out.println("=== SessionUtil.createSession START ===");

        // Create HTTP session
        HttpSession session = request.getSession();
        session.setAttribute("user_id", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("email", user.getEmail());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        System.out.println("HTTP Session created - ID: " + session.getId());
        System.out.println("User ID: " + user.getId());

        // Store in database
        String sessionId = session.getId();
        String deviceName = getDeviceName(request);
        String deviceType = getDeviceType(request.getHeader("User-Agent"));
        String ipAddress = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");

        System.out.println("Device Name: " + deviceName);
        System.out.println("Device Type: " + deviceType);
        System.out.println("IP Address: " + ipAddress);

        boolean dbResult = userSessionDAO.createSession(
                user.getId(),
                sessionId,
                deviceName,
                deviceType,
                ipAddress,
                userAgent != null ? userAgent : "Unknown Browser"
        );

        System.out.println("Database session created: " + dbResult);
        System.out.println("=== SessionUtil.createSession END ===");
    }

    /**
     * Validate session against database
     */
    public static boolean isValidSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        System.out.println("=== SessionUtil.isValidSession START ===");
        System.out.println("Session exists: " + (session != null));

        if (session == null) {
            System.out.println("Session is null - returning false");
            return false;
        }

        Object userId = session.getAttribute("user_id");
        System.out.println("user_id in session: " + userId);

        if (userId == null) {
            System.out.println("user_id is null - returning false");
            return false;
        }

        // Check database
        String sessionId = session.getId();
        System.out.println("Checking session ID in DB: " + sessionId);

        boolean isValid = userSessionDAO.isValidSession(sessionId);
        System.out.println("Database validation result: " + isValid);

        if (isValid) {
            System.out.println("Session is valid - returning true");
            return true;
        } else {
            System.out.println("Session invalid in DB - invalidating HTTP session");
            session.invalidate();
            return false;
        }
    }

    /**
     * Revoke session (logout)
     */
    public static void revokeSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            String sessionId = session.getId();

            // Revoke in database
            userSessionDAO.revokeSession(sessionId);

            // Invalidate HTTP session
            session.invalidate();
        }
    }

    /**
     * Revoke specific session by ID (for linked devices feature)
     */
    public static boolean revokeSessionById(String sessionId) {
        return userSessionDAO.revokeSession(sessionId);
    }

    /**
     * Get device name from request
     */
    private static String getDeviceName(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return "Unknown Device";
        }

        if (userAgent.contains("Windows")) {
            return "Windows PC";
        } else if (userAgent.contains("Mac")) {
            return "Mac";
        } else if (userAgent.contains("Linux")) {
            return "Linux PC";
        } else if (userAgent.contains("Android")) {
            return "Android Device";
        } else if (userAgent.contains("iPhone") || userAgent.contains("iPad")) {
            return "iOS Device";
        } else {
            return "Unknown Device";
        }
    }

    /**
     * Get device type from user agent
     */
    private static String getDeviceType(String userAgent) {
        if (userAgent == null) {
            return "Unknown";
        }

        if (userAgent.contains("Mobile") || userAgent.contains("Android") ||
                userAgent.contains("iPhone") || userAgent.contains("Windows Phone")) {
            return "Mobile";
        } else if (userAgent.contains("iPad") || userAgent.contains("Tablet")) {
            return "Tablet";
        } else {
            return "Desktop";
        }
    }

    /**
     * Get client IP address
     */
    private static String getClientIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("X-Real-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}