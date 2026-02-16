package com.demo.web.controller.Settings;

import com.demo.web.dao.SubscriptionDAO;
import com.demo.web.model.Plan;
import com.demo.web.model.user;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ManageSubscriptionController extends HttpServlet {
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
        if (plan == null) {
            plan = subscriptionDAO.getPlanById(1); // Basic fallback
        }

        long usedBytes = subscriptionDAO.getUsedStorage(currentUser.getId());
        long totalBytes = plan.getStorageLimitBytes();

        request.setAttribute("currentPlan", plan);
        request.setAttribute("planName", plan.getName());
        request.setAttribute("planPrice",
                (plan.getPriceMonthly() == 0) ? "Free" : "$" + plan.getPriceMonthly() + "/mo");

        double usedGB = (double) usedBytes / (1024 * 1024 * 1024);
        double totalGB = (double) totalBytes / (1024 * 1024 * 1024);

        request.setAttribute("storageUsed", String.format("%.2f", usedGB));
        request.setAttribute("storageTotal", String.format("%.0f", totalGB));

        int pct = (totalBytes > 0) ? (int) (((double) usedBytes / totalBytes) * 100) : 0;
        request.setAttribute("storagePercentage", pct);

        request.setAttribute("billingCycle", (plan.getPriceMonthly() == 0) ? "—" : "Monthly");
        request.setAttribute("renewalDate", "—");

        request.getRequestDispatcher("/views/app/managesubscription.jsp").forward(request, response);
    }
}
