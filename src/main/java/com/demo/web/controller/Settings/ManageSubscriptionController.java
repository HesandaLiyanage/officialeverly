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
            System.out.println(
                    "DEBUG: User " + currentUser.getId() + " has no plan (failed fetch?), using fallback Basic.");
            plan = subscriptionDAO.getPlanById(1); // Basic fallback
        }

        long usedBytes = subscriptionDAO.getUsedStorage(currentUser.getId());
        long totalBytes = plan.getStorageLimitBytes();

        System.out.println("DEBUG: User " + currentUser.getId() + " storage: used=" + usedBytes + " bytes, total="
                + totalBytes + " bytes");

        request.setAttribute("currentPlan", plan);
        request.setAttribute("planName", plan.getName());
        request.setAttribute("planPrice",
                (plan.getPriceMonthly() == 0) ? "Free" : "$" + plan.getPriceMonthly() + "/mo");

        // Format sizes dynamically
        request.setAttribute("storageUsedFormatted", formatSize(usedBytes));
        request.setAttribute("storageTotalFormatted", formatSize(totalBytes));

        // Keep raw GB logic for progress bar calculation / old references if any,
        // but rely on formatted attributes for display text.

        int pct = 0;
        if (totalBytes > 0) {
            pct = (int) (((double) usedBytes / totalBytes) * 100);
        }
        request.setAttribute("storagePercentage", pct);

        request.setAttribute("billingCycle", (plan.getPriceMonthly() == 0) ? "—" : "Monthly");
        request.setAttribute("renewalDate", "—");

        request.getRequestDispatcher("/views/app/managesubscription.jsp").forward(request, response);
    }

    private String formatSize(long bytes) {
        if (bytes <= 0)
            return "0 GB";
        if (bytes < 1024)
            return bytes + " B";
        if (bytes < 1024 * 1024)
            return String.format("%.2f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024)
            return String.format("%.2f MB", bytes / (1024.0 * 1024));
        return String.format("%.2f GB", bytes / (1024.0 * 1024 * 1024));
    }
}
