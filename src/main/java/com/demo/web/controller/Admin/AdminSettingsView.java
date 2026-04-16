package com.demo.web.controller.Admin;

import com.demo.web.dao.Admin.AdminSettingsDAO;
import com.demo.web.util.AdminAccessUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Real admin settings page for plan/storage cap management.
 */
public class AdminSettingsView extends HttpServlet {

    private AdminSettingsDAO adminSettingsDAO;

    @Override
    public void init() throws ServletException {
        adminSettingsDAO = new AdminSettingsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AdminAccessUtil.requireAdmin(request, response)) {
            return;
        }

        List<Map<String, Object>> planSummaries = adminSettingsDAO.getPlanSummaries();
        request.setAttribute("planSummaries", planSummaries);

        HttpSession session = request.getSession(false);
        if (session != null) {
            String flashMessage = (String) session.getAttribute("adminFlashMessage");
            String flashType = (String) session.getAttribute("adminFlashType");
            if (flashMessage != null) {
                request.setAttribute("flashMessage", flashMessage);
                request.setAttribute("flashType", flashType);
                session.removeAttribute("adminFlashMessage");
                session.removeAttribute("adminFlashType");
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Admin/adminsettings.jsp").forward(request, response);
    }
}
