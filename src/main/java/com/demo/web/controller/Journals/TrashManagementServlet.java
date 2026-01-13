/*
/ File: src/main/java/com/demo/web/controller/Journals/TrashManagementServlet.java


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
public class TrashManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ✅ Use RecycleBinDAO (not JournalDAO)
        RecycleBinDAO rbDao = new RecycleBinDAO();
        List<RecycleBinItem> trashItems = rbDao.findByUserId(userId);

        request.setAttribute("trashItems", trashItems);
        request.getRequestDispatcher("/views/app/trashmgt.jsp").forward(request, response);
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
        String recycleBinIdStr = request.getParameter("recycleBinId"); // ← Key change!

        if (recycleBinIdStr == null || recycleBinIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid item");
            return;
        }

        try {
            int recycleBinId = Integer.parseInt(recycleBinIdStr);

            if ("restore".equals(action)) {
                // ✅ Restore via JournalDAO (it handles re-insert + cleanup)
                com.demo.web.dao.JournalDAO journalDAO = new com.demo.web.dao.JournalDAO();
                boolean success = journalDAO.restoreJournalFromRecycleBin(recycleBinId, userId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Journal restored");
                } else {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to restore");
                }
            } else if ("permanentDelete".equals(action)) {
                // ✅ Delete directly from recycle_bin
                RecycleBinDAO rbDao = new RecycleBinDAO();
                boolean success = rbDao.deleteFromRecycleBin(recycleBinId);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Journal permanently deleted");
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
*/