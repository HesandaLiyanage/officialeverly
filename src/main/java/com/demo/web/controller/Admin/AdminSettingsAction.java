package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminSettingsDAO;
import com.demo.web.util.AdminAccessUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles actionable admin settings updates.
 */
public class AdminSettingsAction extends HttpServlet {

    private static final long ONE_GB = 1024L * 1024L * 1024L;
    private AdminSettingsDAO adminSettingsDAO;

    @Override
    public void init() throws ServletException {
        adminSettingsDAO = new AdminSettingsDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AdminAccessUtil.requireAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);

        try {
            int planId = Integer.parseInt(request.getParameter("planId"));
            long storageLimitGb = Long.parseLong(request.getParameter("storageLimitGb"));
            int memoryLimit = Integer.parseInt(request.getParameter("memoryLimit"));

            if (storageLimitGb <= 0) {
                throw new IllegalArgumentException("Storage cap must be greater than 0 GB.");
            }
            if (memoryLimit == 0 || memoryLimit < -1) {
                throw new IllegalArgumentException("Memory cap must be a positive number or -1 for unlimited.");
            }

            long storageLimitBytes = storageLimitGb * ONE_GB;
            boolean updated = adminSettingsDAO.updatePlanLimits(planId, storageLimitBytes, memoryLimit);

            if (session != null) {
                session.setAttribute("adminFlashMessage",
                        updated ? "Plan limits updated successfully." : "Failed to update plan limits.");
                session.setAttribute("adminFlashType", updated ? "success" : "error");
            }
        } catch (IllegalArgumentException e) {
            if (session != null) {
                session.setAttribute("adminFlashMessage", e.getMessage());
                session.setAttribute("adminFlashType", "error");
            }
        } catch (Exception e) {
            if (session != null) {
                session.setAttribute("adminFlashMessage", "Invalid settings input.");
                session.setAttribute("adminFlashType", "error");
            }
        }

        response.sendRedirect(request.getContextPath() + "/adminsettings");
    }
}
