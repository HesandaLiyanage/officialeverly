package com.demo.web.controller.Settings;

import com.demo.web.dao.Settings.SubscriptionDAO;
import com.demo.web.dao.Auth.userDAO;
import com.demo.web.model.Settings.Plan;
import com.demo.web.model.Auth.user;
import com.demo.web.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * View controller for the Family Plan page.
 * Pre-computes the current plan name and isFamilyPlan flag
 * so the JSP can use JSTL/EL instead of scriptlets.
 */
@WebServlet("/familyplanview")
public class SettingsFamilyPlanView extends HttpServlet {

    private SubscriptionDAO subscriptionDAO;
    private AuthService authService;
    private userDAO userDAO;

    @Override
    public void init() throws ServletException {
        subscriptionDAO = new SubscriptionDAO();
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

        Integer userId = authService.getUserId(request);
        user currentUser = userDAO.findById(userId);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Plan plan = subscriptionDAO.getPlanByUserId(currentUser.getId());
        String currentPlan = (plan != null) ? plan.getName() : "Basic";

        request.setAttribute("currentPlan", currentPlan);
        request.setAttribute("isFamilyPlan", "Family".equals(currentPlan));

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/familyplan.jsp").forward(request, response);
    }
}
