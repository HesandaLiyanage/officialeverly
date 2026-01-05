// File: src/main/java/com/demo/web/controller/Journals/RestoreJournalServlet.java
package com.demo.web.controller.Journals;

import com.demo.web.dao.JournalDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/journal/restore")
public class RestoreJournalServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String recycleBinIdStr = request.getParameter("recycleBinId");
        if (recycleBinIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/trashmgt");
            return;
        }

        try {
            int recycleBinId = Integer.parseInt(recycleBinIdStr);
            JournalDAO dao = new JournalDAO();
            boolean success = dao.restoreJournalFromRecycleBin(recycleBinId, userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/trashmgt?msg=Journal restored");
            } else {
                response.sendRedirect(request.getContextPath() + "/trashmgt?error=Failed to restore");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/trashmgt?error=Invalid ID");
        }
    }
}