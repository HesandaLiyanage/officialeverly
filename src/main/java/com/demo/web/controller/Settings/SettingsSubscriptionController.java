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

public class SettingsSubscriptionController extends HttpServlet {
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
            // Fallback if not set (should not happen due to migration)
            plan = subscriptionDAO.getPlanById(1); // Basic
        }

        long usedBytes = subscriptionDAO.getUsedStorage(currentUser.getId());
        long totalBytes = plan.getStorageLimitBytes();

        int memoryCount = subscriptionDAO.getMemoryCount(currentUser.getId());
        int memoryLimit = plan.getMemoryLimit();

        request.setAttribute("currentPlan", plan);
        request.setAttribute("usedStorageBytes", usedBytes);
        request.setAttribute("totalStorageBytes", totalBytes);

        request.setAttribute("memoryCount", memoryCount);
        request.setAttribute("memoryLimit", (memoryLimit == -1) ? "Unlimited" : String.valueOf(memoryLimit));

        double memPercent = 0;
        if (memoryLimit > 0) {
            memPercent = (double) memoryCount / memoryLimit * 100;
        }
        request.setAttribute("memoryPercentage", String.format("%.1f", memPercent));

        // Calculate percentage
        double percent = (totalBytes > 0) ? ((double) usedBytes / totalBytes * 100) : 0;
        request.setAttribute("storagePercentage", String.format("%.1f", percent));

        // Helper for display
        request.setAttribute("usedStorageFormatted", formatSize(usedBytes));
        request.setAttribute("totalStorageFormatted", formatSize(totalBytes));

        // Forward to JSP
        request.getRequestDispatcher("/views/app/settingssubscription.jsp").forward(request, response);
    }

    private String formatSize(long size) {
        String[] units = new String[] { "B", "KB", "MB", "GB", "TB" };
        int unitIndex = 0;
        double sizeDouble = size;
        while (sizeDouble >= 1024 && unitIndex < units.length - 1) {
            sizeDouble /= 1024;
            unitIndex++;
        }
        return String.format("%.2f %s", sizeDouble, units[unitIndex]);
    }
}
