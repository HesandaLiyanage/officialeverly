package com.demo.web.controller.Journals;

import com.demo.web.dao.Journals.RecycleBinDAO;
import com.demo.web.model.Journals.RecycleBinItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/trashmgtview")
public class TrashManagementView extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RecycleBinDAO rbDao = new RecycleBinDAO();

        // Get both journal and autograph trash items
        List<RecycleBinItem> journalItems = rbDao.findByUserId(userId);
        List<RecycleBinItem> autographItems = rbDao.findAutographsByUserId(userId);

        // Combine both lists
        List<RecycleBinItem> allItems = new ArrayList<>();
        allItems.addAll(journalItems);
        allItems.addAll(autographItems);

        // Sort by deleted_at DESC
        allItems.sort((a, b) -> {
            if (a.getDeletedAt() == null && b.getDeletedAt() == null)
                return 0;
            if (a.getDeletedAt() == null)
                return 1;
            if (b.getDeletedAt() == null)
                return -1;
            return b.getDeletedAt().compareTo(a.getDeletedAt());
        });

        request.setAttribute("trashItems", allItems);
        request.getRequestDispatcher("/views/app/Journals/trashmgt.jsp").forward(request, response);
    }

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
            RecycleBinDAO rbDao = new RecycleBinDAO();

            // Get the item to determine its type
            RecycleBinItem item = rbDao.findById(recycleBinId);
            if (item == null || item.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/trashmgt?error=Item not found");
                return;
            }

            if ("restore".equals(action)) {
                boolean success = false;
                if ("journal".equals(item.getItemType())) {
                    com.demo.web.dao.Journals.JournalDAO journalDAO = new com.demo.web.dao.Journals.JournalDAO();
                    success = journalDAO.restoreJournalFromRecycleBin(recycleBinId, userId);
                } else if ("autograph".equals(item.getItemType())) {
                    // For autographs, restore by re-inserting into autograph table and removing
                    // from recycle bin
                    com.demo.web.dao.Autographs.autographDAO autographDAO = new com.demo.web.dao.Autographs.autographDAO();
                    success = autographDAO.restoreAutographFromRecycleBin(recycleBinId, userId);
                }

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=" +
                            item.getItemType().substring(0, 1).toUpperCase() + item.getItemType().substring(1)
                            + " restored successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to restore");
                }
            } else if ("permanentDelete".equals(action)) {
                boolean success = rbDao.deleteFromRecycleBin(recycleBinId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Item permanently deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to delete");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/trashmgt?error=Unknown action");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid ID");
        }
    }
}