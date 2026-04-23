package com.demo.web.util;

import com.demo.web.dao.Auth.userSessionDAO;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public final class RememberMeUtil {

    public static final String COOKIE_NAME = "session_token";

    private RememberMeUtil() {
    }

    public static String getRememberMeToken(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }

        for (Cookie cookie : cookies) {
            if (COOKIE_NAME.equals(cookie.getName())) {
                return cookie.getValue();
            }
        }

        return null;
    }

    public static void clearRememberMe(HttpServletRequest request, HttpServletResponse response, userSessionDAO userSessionDAO) {
        String token = getRememberMeToken(request);
        if (token == null || token.isBlank()) {
            return;
        }

        userSessionDAO.deleteRememberMeToken(token);
        CookieUtil.clearCookie(request, response, COOKIE_NAME);
    }
}
