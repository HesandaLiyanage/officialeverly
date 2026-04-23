package com.demo.web.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public final class CookieUtil {

    private CookieUtil() {
    }

    public static void addHttpOnlyCookie(HttpServletRequest request, HttpServletResponse response,
                                         String name, String value, int maxAgeSeconds) {
        StringBuilder header = new StringBuilder();
        header.append(name).append("=").append(value == null ? "" : value);
        header.append("; Max-Age=").append(maxAgeSeconds);
        header.append("; Path=/");
        header.append("; HttpOnly");
        header.append("; SameSite=Lax");
        if (request.isSecure()) {
            header.append("; Secure");
        }
        response.addHeader("Set-Cookie", header.toString());
    }

    public static void clearCookie(HttpServletRequest request, HttpServletResponse response, String name) {
        addHttpOnlyCookie(request, response, name, "", 0);
    }
}
