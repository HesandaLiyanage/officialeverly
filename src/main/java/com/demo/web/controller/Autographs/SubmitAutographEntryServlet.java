package com.demo.web.controller.autographs;

import com.demo.web.dao.autographDAO;
import com.demo.web.dao.AutographEntryDAO;
import com.demo.web.model.autograph;
import com.demo.web.model.AutographEntry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/submit-autograph")
public class SubmitAutographEntryServlet extends HttpServlet {

    private AutographEntryDAO entryDAO = new AutographEntryDAO();
    private autographDAO autoDAO = new autographDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String content = request.getParameter("content");
        String author = request.getParameter("author");
        String decorations = request.getParameter("decorations");

        try {
            autograph ag = autoDAO.getAutographByShareToken(token);
            if (ag == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph book not found");
                return;
            }

            int userId = 0;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user_id") != null) {
                userId = (Integer) session.getAttribute("user_id");
            }

            AutographEntry entry = new AutographEntry();
            entry.setAutographId(ag.getAutographId());
            entry.setUserId(userId);
            entry.setContent(author + ": " + content);
            entry.setDecorations(decorations);

            boolean success = entryDAO.createEntry(entry);

            if (success) {
                // Return users to the writing space or a thank you page
                // The user wanted: "updating the autograph book"
                // Usually redirecting to a shared view or thank you is good
                response.sendRedirect(request.getContextPath() + "/sharedview/" + token);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save entry");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
