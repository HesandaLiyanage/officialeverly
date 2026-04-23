package com.demo.web.util;

import javax.servlet.http.HttpServletRequest;

public final class RequestPathUtil {

    private RequestPathUtil() {
    }

    public static String normalizePath(HttpServletRequest request) {
        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
        String requestUri = request.getRequestURI() == null ? "" : request.getRequestURI();
        String path = requestUri.startsWith(contextPath) ? requestUri.substring(contextPath.length()) : requestUri;

        if (path.isEmpty()) {
            path = "/";
        }

        if (path.endsWith("/") && path.length() > 1) {
            return path.substring(0, path.length() - 1);
        }

        return path;
    }

    public static boolean isStaticResource(String path) {
        String normalizedPath = path == null ? "" : path.toLowerCase();
        return normalizedPath.endsWith(".css") ||
                normalizedPath.endsWith(".js") ||
                normalizedPath.endsWith(".jpg") ||
                normalizedPath.endsWith(".jpeg") ||
                normalizedPath.endsWith(".png") ||
                normalizedPath.endsWith(".gif") ||
                normalizedPath.endsWith(".ico") ||
                normalizedPath.endsWith(".svg") ||
                normalizedPath.endsWith(".woff") ||
                normalizedPath.endsWith(".woff2") ||
                normalizedPath.endsWith(".ttf") ||
                normalizedPath.endsWith(".eot") ||
                normalizedPath.endsWith(".webp") ||
                normalizedPath.endsWith(".mp4");
    }

    public static String appendQuery(String path, String queryString) {
        if (queryString == null || queryString.isBlank()) {
            return path;
        }
        return path + (path.contains("?") ? "&" : "?") + queryString;
    }

    public static boolean isSafeRedirectTarget(HttpServletRequest request, String target) {
        if (target == null || target.isBlank()) {
            return false;
        }

        if (target.startsWith("//") || target.contains("://")) {
            return false;
        }

        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
        return target.startsWith("/") || (!contextPath.isEmpty() && target.startsWith(contextPath + "/"));
    }

    public static String toApplicationRedirect(HttpServletRequest request, String target) {
        if (!isSafeRedirectTarget(request, target)) {
            return null;
        }

        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
        if (!contextPath.isEmpty() && target.startsWith(contextPath + "/")) {
            return target;
        }

        if (contextPath.isEmpty()) {
            return target;
        }

        return target.startsWith("/") ? contextPath + target : contextPath + "/" + target;
    }
}
