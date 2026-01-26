package com.demo.web.service;

import com.demo.web.util.SessionUtil;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Service for authentication and session-related operations.
 * Centralizes session validation logic used across controllers.
 */
public class AuthService {

    /**
     * Validates if the current request has a valid session with a logged-in user.
     * 
     * @param request The HTTP request
     * @return true if session is valid and user is logged in
     */
    public boolean isValidSession(HttpServletRequest request) {
        return SessionUtil.isValidSession(request);
    }

    /**
     * Gets the user ID from the session.
     * 
     * @param request The HTTP request
     * @return The user ID, or null if not logged in
     */
    public Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Integer) session.getAttribute("user_id");
    }

    /**
     * Gets the current session ID.
     * 
     * @param request The HTTP request
     * @return The session ID, or null if no session
     */
    public String getSessionId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null ? session.getId() : null;
    }

    /**
     * Gets the HttpSession object.
     * 
     * @param request The HTTP request
     * @return The session, or null if none exists
     */
    public HttpSession getSession(HttpServletRequest request) {
        return request.getSession(false);
    }
}
