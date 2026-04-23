package com.demo.web.util;

import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.model.Auth.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class SessionUtil {

    private static final userSessionDAO userSessionDAO = new userSessionDAO();
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static HttpSession createSession(HttpServletRequest request, user user) {
        HttpSession existingSession = request.getSession(false);
        String previousSessionId = existingSession != null ? existingSession.getId() : null;

        HttpSession session = request.getSession(true);
        request.changeSessionId();
        session = request.getSession(false);

        if (previousSessionId != null && !previousSessionId.equals(session.getId())) {
            userSessionDAO.revokeSession(previousSessionId);
        }

        session.setAttribute("user_id", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("email", user.getEmail());
        session.setAttribute("is_admin", AdminAccessUtil.isAdminUser(user));
        session.setAttribute("csrf_token", generateCsrfToken());
        session.setMaxInactiveInterval(30 * 60);

        boolean dbResult = userSessionDAO.createSession(
                user.getId(),
                session.getId(),
                getDeviceName(request),
                getDeviceType(request.getHeader("User-Agent")),
                getClientIpAddress(request),
                request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "Unknown Browser"
        );

        if (!dbResult) {
            session.invalidate();
            throw new IllegalStateException("Failed to persist session");
        }

        return session;
    }

    public static boolean isValidSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object userId = session.getAttribute("user_id");
        if (userId == null) {
            return false;
        }

        boolean isValid = userSessionDAO.isValidSession(session.getId());
        if (!isValid) {
            session.invalidate();
        }
        return isValid;
    }

    public static void revokeSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            userSessionDAO.revokeSession(session.getId());
            session.invalidate();
        }
    }

    public static boolean revokeSessionById(String sessionId) {
        return userSessionDAO.revokeSession(sessionId);
    }

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

    private static String generateCsrfToken() {
        byte[] token = new byte[32];
        SECURE_RANDOM.nextBytes(token);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(token);
    }
}
