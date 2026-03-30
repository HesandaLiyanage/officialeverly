package com.demo.web.controller.Auth;

import com.demo.web.dao.Auth.userDAO;
import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.model.Auth.user;
import com.demo.web.dto.Auth.AuthLoginRequest;
import com.demo.web.dto.Auth.AuthLoginResponse;
import com.demo.web.service.AuthService;
import com.demo.web.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Cookie;
import java.io.IOException;

public class AuthLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AuthService authService;
    private userSessionDAO userSessionDAO;
    private userDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        userSessionDAO = new userSessionDAO();
        userDAO = new userDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (SessionUtil.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        user rememberedUser = checkRememberMeToken(request);
        if (rememberedUser != null) {
            SessionUtil.createSession(request, rememberedUser);
            response.sendRedirect(request.getContextPath() + "/memories");
            return;
        }

        if ("true".equals(request.getParameter("deactivated"))) {
            request.setAttribute("infoMessage",
                    "Your account has been deactivated. You can reactivate it by logging in again.");
        }

        request.getRequestDispatcher("/login").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthLoginRequest req = new AuthLoginRequest(
            request.getParameter("username"),
            request.getParameter("password"),
            request.getParameter("rememberme"),
            request.getParameter("deactivated")
        );

        AuthLoginResponse res = authService.login(req);

        if (res.isSuccess()) {
            SessionUtil.createSession(request, res.getUser());

            HttpSession session = request.getSession();
            if (res.getMasterKey() != null) {
                session.setAttribute("masterKey", res.getMasterKey());
                String sessionId = (String) session.getAttribute("sessionId");
                if (sessionId != null) {
                    userSessionDAO.storeMasterKeyInCache(sessionId, res.getMasterKey());
                }
            }

            if (res.getRememberMeToken() != null) {
                Cookie cookie = new Cookie("session_token", res.getRememberMeToken());
                cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            if (res.getRedirectUrl() != null) {
                response.sendRedirect(request.getContextPath() + res.getRedirectUrl());
                return;
            }

            String pendingInviteToken = (String) session.getAttribute("pendingInviteToken");
            if (pendingInviteToken != null) {
                session.removeAttribute("pendingInviteToken");
                response.sendRedirect(request.getContextPath() + "/invite/" + pendingInviteToken);
                return;
            }

            String returnUrl = request.getParameter("redirect");
            if (returnUrl == null || returnUrl.isEmpty()) {
                returnUrl = request.getParameter("return");
            }
            if (returnUrl != null && !returnUrl.isEmpty() && (returnUrl.startsWith("/") || returnUrl.startsWith(request.getContextPath()))) {
                response.sendRedirect(returnUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/memories");
            }
        } else {
            request.setAttribute("errorMessage", res.getErrorMessage());
            request.getRequestDispatcher("/login").forward(request, response);
        }
    }

    private user checkRememberMeToken(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("session_token".equals(cookie.getName())) {
                    try {
                        Integer userId = userSessionDAO.getUserIdByToken(cookie.getValue());
                        if (userId != null) {
                            return userDAO.findById(userId);
                        }
                    } catch (Exception e) {}
                    break;
                }
            }
        }
        return null;
    }
}