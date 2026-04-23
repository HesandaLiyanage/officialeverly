package com.demo.web.filter;

import com.demo.web.util.RequestPathUtil;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class CsrfProtectionFilter implements Filter {

    private Set<String> exemptPaths;

    @Override
    public void init(FilterConfig filterConfig) {
        exemptPaths = Collections.unmodifiableSet(new HashSet<>(Arrays.asList(
                "/loginservlet",
                "/signupservlet",
                "/googlelogin",
                "/googlecallback",
                "/logoutservlet"
        )));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        String path = RequestPathUtil.normalizePath(req);

        if (session != null) {
            req.setAttribute("csrfToken", session.getAttribute("csrf_token"));
        }

        if (isSafeMethod(req.getMethod()) || RequestPathUtil.isStaticResource(path) || isExemptPath(path) || path.startsWith("/api/")) {
            chain.doFilter(request, response);
            return;
        }

        if (session == null || session.getAttribute("user_id") == null) {
            chain.doFilter(request, response);
            return;
        }

        if (hasValidToken(req, session) || passesSameOriginChecks(req)) {
            chain.doFilter(request, response);
            return;
        }

        res.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF validation failed");
    }

    private boolean isSafeMethod(String method) {
        return "GET".equalsIgnoreCase(method) ||
                "HEAD".equalsIgnoreCase(method) ||
                "OPTIONS".equalsIgnoreCase(method) ||
                "TRACE".equalsIgnoreCase(method);
    }

    private boolean isExemptPath(String path) {
        return exemptPaths.contains(path);
    }

    private boolean hasValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("csrf_token");
        if (sessionToken == null || sessionToken.isBlank()) {
            return false;
        }

        String requestToken = request.getHeader("X-CSRF-Token");
        if (requestToken == null || requestToken.isBlank()) {
            requestToken = request.getParameter("csrfToken");
        }

        if (requestToken == null || requestToken.isBlank()) {
            return false;
        }

        return MessageDigest.isEqual(
                sessionToken.getBytes(StandardCharsets.UTF_8),
                requestToken.getBytes(StandardCharsets.UTF_8)
        );
    }

    private boolean passesSameOriginChecks(HttpServletRequest request) {
        String fetchSite = request.getHeader("Sec-Fetch-Site");
        if ("cross-site".equalsIgnoreCase(fetchSite)) {
            return false;
        }
        if ("same-origin".equalsIgnoreCase(fetchSite) ||
                "same-site".equalsIgnoreCase(fetchSite) ||
                "none".equalsIgnoreCase(fetchSite)) {
            return true;
        }

        String origin = request.getHeader("Origin");
        if (origin != null && !origin.isBlank()) {
            return isSameOrigin(request, origin);
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank()) {
            return isSameOrigin(request, referer);
        }

        return false;
    }

    private boolean isSameOrigin(HttpServletRequest request, String url) {
        try {
            URI uri = new URI(url);
            String requestScheme = request.getScheme();
            String requestHost = request.getServerName();
            int requestPort = normalizePort(request.getScheme(), request.getServerPort());
            int uriPort = normalizePort(uri.getScheme(), uri.getPort());

            return requestScheme.equalsIgnoreCase(uri.getScheme()) &&
                    requestHost.equalsIgnoreCase(uri.getHost()) &&
                    requestPort == uriPort;
        } catch (URISyntaxException e) {
            return false;
        }
    }

    private int normalizePort(String scheme, int port) {
        if (port > 0) {
            return port;
        }
        return "https".equalsIgnoreCase(scheme) ? 443 : 80;
    }

    @Override
    public void destroy() {
    }
}
