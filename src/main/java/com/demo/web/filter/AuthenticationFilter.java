package com.demo.web.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class AuthenticationFilter implements Filter {

    private Set<String> publicPaths;

    @Override
    public void init(FilterConfig filterConfig) {
        // Pages that don't require login
        publicPaths = new HashSet<>(Arrays.asList(
                "/",
                "/login",
                "/register",
                "/aboutus",
                "/contact",
                "/loginservlet",
                "/signup",
                "/signup2",
                "/signupservlet",
                "/debug"
        ));
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Skip static resources
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("user_id") != null);

        // If path is public, continue
        if (publicPaths.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Protected path: if logged in, continue
        if (loggedIn) {
            chain.doFilter(request, response);
            return;
        }

        // Not logged in: redirect to login with return URL
        String returnUrl = req.getRequestURI().substring(req.getContextPath().length());
        String loginUrl = req.getContextPath() + "/login?return=" + java.net.URLEncoder.encode(returnUrl, "UTF-8");
        res.sendRedirect(loginUrl);
    }

    private boolean isStaticResource(String path) {
        return path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".jpg") || path.endsWith(".png") ||
                path.endsWith(".gif") || path.endsWith(".ico") ||
                path.endsWith(".svg") || path.endsWith(".woff") ||
                path.endsWith(".woff2") || path.endsWith(".ttf") ||
                path.endsWith(".eot");
    }

    @Override
    public void destroy() {}
}
