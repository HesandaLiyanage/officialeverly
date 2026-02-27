package com.demo.web.controller.Autographs;

import com.demo.web.dao.AutographEntryDAO;
import com.demo.web.model.AutographEntry;
import com.demo.web.model.autograph;
import com.demo.web.service.AuthService;
import com.demo.web.service.AutographService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * View controller for autograph pages.
 * Handles GET requests for listing, viewing, and editing autographs.
 */
public class AutographViewController extends HttpServlet {

    private AuthService authService;
    private AutographService autographService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
        autographService = new AutographService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Validate session
        if (!authService.isValidSession(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = authService.getUserId(request);
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        // Determine the action based on parameter or default to list
        if ("view".equals(action) && idParam != null) {
            handleViewAutograph(request, response, userId, idParam);
        } else if ("edit".equals(action) && idParam != null) {
            handleEditAutograph(request, response, userId, idParam);
        } else {
            handleListAutographs(request, response, userId);
        }
    }

    /**
     * Handles listing all autographs for the user.
     */
    private void handleListAutographs(HttpServletRequest request, HttpServletResponse response,
            int userId) throws ServletException, IOException {
        List<autograph> autographs = autographService.getAutographsByUserId(userId);
        request.setAttribute("autographs", autographs);
        request.getRequestDispatcher("/views/app/Autographs/autographcontent.jsp").forward(request, response);
    }

    /**
     * Handles viewing a single autograph.
     */
    private void handleViewAutograph(HttpServletRequest request, HttpServletResponse response,
            int userId, String idParam) throws ServletException, IOException {
        try {
            int autographId = Integer.parseInt(idParam);
            autograph autographDetail = autographService.getAutographById(autographId, userId);

            if (autographDetail == null) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            request.setAttribute("autograph", autographDetail);

            // Load autograph entries
            try {
                AutographEntryDAO entryDao = new AutographEntryDAO();
                List<AutographEntry> entries = entryDao.findByAutographId(autographId);
                request.setAttribute("entries", entries);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("entries", java.util.Collections.emptyList());
            }

            request.getRequestDispatcher("/views/app/Autographs/viewautograph.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/autographs");
        }
    }

    /**
     * Handles editing an autograph (display the edit form).
     */
    private void handleEditAutograph(HttpServletRequest request, HttpServletResponse response,
            int userId, String idParam) throws ServletException, IOException {
        try {
            int autographId = Integer.parseInt(idParam);
            autograph autographToEdit = autographService.getAutographById(autographId, userId);

            if (autographToEdit == null) {
                response.sendRedirect(request.getContextPath() + "/autographs");
                return;
            }

            request.setAttribute("autograph", autographToEdit);
            request.getRequestDispatcher("/views/app/Autographs/editautograph.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/autographs");
        }
    }
}
