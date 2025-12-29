// File: src/main/java/com/demo/web/controller/DeleteJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/delete")
public class DeleteJournalServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String journalIdStr = request.getParameter("journalId");
        if (journalIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/journals");
            return;
        }

        try {
            int journalId = Integer.parseInt(journalIdStr);
            JournalDAO dao = new JournalDAO();
            boolean success = dao.deleteJournalToRecycleBin(journalId, userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/journals?msg=Journal moved to Recycle Bin");
            } else {
                response.sendRedirect(request.getContextPath() + "/journals?error=Failed to delete journal");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/journals?error=Invalid journal ID");
        }
    }
}