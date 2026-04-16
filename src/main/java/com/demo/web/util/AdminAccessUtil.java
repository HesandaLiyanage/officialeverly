package com.demo.web.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Minimal admin access helper.
 * This project does not currently have a dedicated role table/column,
 * so the admin panel uses the existing session username as the guard.
 */
public final class AdminAccessUtil {

    private AdminAccessUtil() {
    }

    public static boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Object usernameObj = session.getAttribute("username");
        String username = usernameObj != null ? String.valueOf(usernameObj) : "";
        if (!"admin".equalsIgnoreCase(username)) {
            response.sendRedirect(request.getContextPath() + "/youcantaccessthis");
            return false;
        }

        return true;
    }
}
