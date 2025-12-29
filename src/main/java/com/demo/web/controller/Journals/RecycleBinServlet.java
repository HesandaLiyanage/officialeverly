
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
        List<RecycleBinItem> trashItems = rbDao.findByUserId(userId);
        request.setAttribute("trashItems", trashItems);
        request.getRequestDispatcher("/views/app/trashmgt.jsp").forward(request, response);
    }
}

