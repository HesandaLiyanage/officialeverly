package com.demo.web.controller.Auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.demo.web.dao.Auth.userSessionDAO;
import com.demo.web.dto.Auth.*;
import com.demo.web.service.AuthService;
import com.demo.web.util.SessionUtil;

public class AuthSignup extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AuthService authService;
    private userSessionDAO userSessionDAO;

    @Override
    public void init() throws ServletException {
        try {
            authService = new AuthService();
            userSessionDAO = new userSessionDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize Service/DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/signup").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if ("2".equals(req.getParameter("step"))) {
            handleStep2(req, resp);
        } else {
            handleStep1(req, resp);
        }
    }

    private void handleStep1(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        AuthSignupStep1Request request = new AuthSignupStep1Request(
            req.getParameter("email"),
            req.getParameter("password"),
            req.getParameter("confirmPassword"),
            req.getParameter("terms")
        );

        AuthSignupStep1Response response = authService.signupStep1(request);

        if (!response.isSuccess()) {
            req.setAttribute("errorMessage", response.getErrorMessage());
            req.getRequestDispatcher("/signup").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("temp_email", response.getEmail());
        session.setMaxInactiveInterval(30 * 60);

        resp.sendRedirect(req.getContextPath() + "/signup2");
    }

    private void handleStep2(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("temp_email") == null) {
            resp.sendRedirect(req.getContextPath() + "/signup");
            return;
        }

        AuthSignupStep2Request request = new AuthSignupStep2Request(
            (String) session.getAttribute("temp_email"),
            req.getParameter("password"),
            req.getParameter("confirmPassword"),
            req.getParameter("name"),
            req.getParameter("bio")
        );

        AuthSignupStep2Response response = authService.signupStep2(request);

        if (!response.isSuccess()) {
            req.setAttribute("errorMessage", response.getErrorMessage());
            req.getRequestDispatcher("/signup2").forward(req, resp);
            return;
        }

        session.removeAttribute("temp_email");
        session = SessionUtil.createSession(req, response.getUser());
        session.setAttribute("user", response.getUser());

        if (response.getMasterKey() != null) {
            session.setAttribute("masterKey", response.getMasterKey());
            userSessionDAO.storeMasterKeyInCache(session.getId(), response.getMasterKey());
        }

        resp.sendRedirect(req.getContextPath() + "/memories");
    }
}
