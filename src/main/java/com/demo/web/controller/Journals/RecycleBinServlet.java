// File: src/main/java/com/demo/web/controller/Journals/RecycleBinServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.RecycleBinDAO;
import com.demo.web.model.RecycleBinItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/trashmgt")
public class RecycleBinServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RecycleBinDAO rbDao = new RecycleBinDAO();
        List<RecycleBinItem> journalItems = rbDao.findByUserId(userId);
        List<RecycleBinItem> autographItems = rbDao.findAutographsByUserId(userId);
        
        // Combine both lists
        List<RecycleBinItem> trashItems = new java.util.ArrayList<>();
        trashItems.addAll(journalItems);
        trashItems.addAll(autographItems);
        
        // Sort by deleted date descending
        trashItems.sort((a, b) -> {
            if (a.getDeletedAt() == null && b.getDeletedAt() == null) return 0;
            if (a.getDeletedAt() == null) return 1;
            if (b.getDeletedAt() == null) return -1;
            return b.getDeletedAt().compareTo(a.getDeletedAt());
        });
        
        request.setAttribute("trashItems", trashItems);
        request.getRequestDispatcher("/views/app/trashmgt.jsp").forward(request, response);
    }

    // ✅ ADD THIS doPost METHOD FOR PERMANENT DELETE
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String recycleBinIdStr = request.getParameter("recycleBinId");

        if (recycleBinIdStr == null || recycleBinIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid item");
            return;
        }

        try {
            int recycleBinId = Integer.parseInt(recycleBinIdStr);

            if ("permanentDelete".equals(action)) {
                // Delete from recycle_bin table
                RecycleBinDAO rbDao = new RecycleBinDAO();
                boolean success = rbDao.deleteFromRecycleBin(recycleBinId);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Item permanently deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to delete item");
                }
            } else if ("restore".equals(action)) {
                // Restore via JournalDAO
                com.demo.web.dao.JournalDAO journalDAO = new com.demo.web.dao.JournalDAO();
                boolean success = journalDAO.restoreJournalFromRecycleBin(recycleBinId, userId);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Item restored");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to restore item");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/trashmgt?error=Unknown action");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid ID");
        }
    }
}