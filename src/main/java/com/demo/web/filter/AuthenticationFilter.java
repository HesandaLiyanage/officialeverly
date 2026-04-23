package com.demo.web.filter;

import com.demo.web.util.SessionUtil;
import com.demo.web.util.RequestPathUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class AuthenticationFilter implements Filter {

    private Set<String> publicPaths;

    @Override
    public void init(FilterConfig filterConfig) {
        publicPaths = Collections.unmodifiableSet(new HashSet<>(Arrays.asList(
                "/",
                "/login",
                "/register",
                "/aboutus",
                "/contact",
                "/api/login",
                "/loginservlet",
                "/saveEvent",
                "/signup",
                "/signup2",
                "/signupservlet",
                "/debug",
                "/404",
                "/checkyourinbox",
                "/emailresetsuccess",
                "/footer",
                "/forgotpassword",
                "/header",
                "/googlelogin",
                "/googlecallback",
                "/index",
                "/layout",
                "/layout2",
                "/passwordreset",
                "/passwordresetenterpassword",
                "/plans",
                "/signupthankyou",
                "/write-autograph",
                "/whyeverly",
                "/youcantaccessthis",
                "/emailsentreset",
                "/privacy",
                "/resources/assets/landing.mp4",
                "/viewMedia",
                "/viewmedia"
        )));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = RequestPathUtil.normalizePath(req);

        // Skip static resources
        if ("OPTIONS".equalsIgnoreCase(req.getMethod()) || RequestPathUtil.isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // If path is public, continue
        if (publicPaths.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in (validates against database)
        if (SessionUtil.isValidSession(req)) {
            chain.doFilter(request, response);
            return;
        }

        // Not logged in: redirect to login with return URL
        String returnUrl = path;
        if (req.getQueryString() != null && !req.getQueryString().isBlank()) {
            returnUrl = returnUrl + "?" + req.getQueryString();
        }
        String loginUrl = req.getContextPath() + "/login?return=" +
                URLEncoder.encode(returnUrl, StandardCharsets.UTF_8);
        res.sendRedirect(loginUrl);
    }

    @Override
    public void destroy() {}
}
