package com.demo.web.controller.Settings;

import com.demo.web.dao.Settings.SubscriptionDAO;
import com.demo.web.model.Settings.Plan;
import com.demo.web.model.Auth.user;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * View controller for the Change Plan page.
 * Pre-computes the current plan name and boolean flags for each plan tier
 * so the JSP can use JSTL/EL instead of scriptlets.
 */
@WebServlet("/changeplanview")
public class SettingsChangePlanView extends HttpServlet {

    private SubscriptionDAO subscriptionDAO;

    @Override
    public void init() throws ServletException {
        subscriptionDAO = new SubscriptionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        user currentUser = (session != null) ? (user) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Plan plan = subscriptionDAO.getPlanByUserId(currentUser.getId());
        String currentPlan = (plan != null) ? plan.getName() : "Basic";

        // Set the current plan name
        request.setAttribute("currentPlan", currentPlan);

        // Pre-compute boolean flags for each plan tier
        request.setAttribute("isBasic", "Basic".equals(currentPlan));
        request.setAttribute("isPremium", "Premium".equals(currentPlan));
        request.setAttribute("isPro", "Pro".equals(currentPlan));
        request.setAttribute("isFamily", "Family".equals(currentPlan));

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/changeplan.jsp").forward(request, response);
    }
}
