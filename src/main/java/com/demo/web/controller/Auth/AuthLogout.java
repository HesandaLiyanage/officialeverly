package com.demo.web.controller.Auth;

import com.demo.web.util.SessionUtil;
import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.util.RememberMeUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AuthLogout extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final userSessionDAO userSessionDAO = new userSessionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUtil.revokeSession(request);
        RememberMeUtil.clearRememberMe(request, response, userSessionDAO);
        response.sendRedirect(request.getContextPath() + "/");
    }
}
