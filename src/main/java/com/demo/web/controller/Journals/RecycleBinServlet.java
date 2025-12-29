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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Fetch from recycle_bin table
        RecycleBinDAO rbDao = new RecycleBinDAO();
        List<RecycleBinItem> trashItems = rbDao.findByUserId(userId);

        request.setAttribute("trashItems", trashItems); // ← Key change: "trashItems", not "deletedJournals"
        request.getRequestDispatcher("/views/app/trashmgt.jsp").forward(request, response);
    }
}