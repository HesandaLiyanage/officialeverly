package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;
import com.demo.web.model.Journal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/journal/recycle-bin")
public class RecycleBinServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        JournalDAO journalDAO = new JournalDAO();
        List<Journal> deletedJournals = journalDAO.findDeletedByUserId(userId);

        request.setAttribute("deletedJournals", deletedJournals);
        request.getRequestDispatcher("/WEB-INF/jsp/journal/recycle-bin.jsp").forward(request, response);
    }
}