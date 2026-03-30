package com.demo.web.controller.Settings;

import com.demo.web.dao.Auth.userDAO;
import com.demo.web.model.Auth.user;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SettingsProfileView extends HttpServlet {

    private AuthService authService;
    private userDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        userDAO = new userDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        HttpSession session = authService.getSession(request);
        Integer userId = authService.getUserId(request);

        user currentUser = userDAO.findById(userId);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        session.setAttribute("user", currentUser);

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/settingsaccounteditprofile.jsp")
                .forward(request, response);
    }
}
