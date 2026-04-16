package com.demo.web.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Shared controller helper for authenticated feature modules.
 */
public final class ControllerSessionUtil {

    private ControllerSessionUtil() {
    }

    public static Integer requireUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return (Integer) session.getAttribute("user_id");
    }
}
