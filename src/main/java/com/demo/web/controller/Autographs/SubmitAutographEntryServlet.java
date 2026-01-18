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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String token = request.getParameter("token");
        String contentPlain = request.getParameter("content");
        String author = request.getParameter("author");
        String decorationsJson = request.getParameter("decorations");

        try {
            autograph ag = autoDAO.getAutographByShareToken(token);
            if (ag == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Autograph book not found");
                return;
            }

            // Construct Rich HTML
            StringBuilder richHtml = new StringBuilder();
            richHtml.append("<div class='rich-autograph-entry'>");
            richHtml.append("<div class='message-text'>").append(contentPlain).append("</div>");
            richHtml.append(
                    "<div class='decorations-layer' style='position:absolute; top:0; left:0; width:100%; height:100%; pointer-events:none;'>");

            if (decorationsJson != null && !decorationsJson.isEmpty() && !decorationsJson.equals("[]")) {
                com.google.gson.JsonArray decorations = com.google.gson.JsonParser.parseString(decorationsJson)
                        .getAsJsonArray();
                for (int i = 0; i < decorations.size(); i++) {
                    com.google.gson.JsonObject dec = decorations.get(i).getAsJsonObject();
                    richHtml.append("<span class='").append(dec.get("className").getAsString()).append("' ")
                            .append("style='position:absolute; top:").append(dec.get("top").getAsString())
                            .append("; left:").append(dec.get("left").getAsString()).append(";'>")
                            .append(dec.get("content").getAsString()).append("</span>");
                }
            }
            richHtml.append("</div>");
            richHtml.append("<div class='author-signature'>- ").append(author).append("</div>");
            richHtml.append("</div>");

            AutographEntry entry = new AutographEntry();
            entry.setAutographId(ag.getAutographId());
            entry.setUserId(userId);
            entry.setContent(richHtml.toString());
            entry.setContentPlain(contentPlain);
            entry.setLink(java.util.UUID.randomUUID().toString().substring(0, 8)); // Short unique link for entry

            boolean success = entryDAO.createEntry(entry);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/sharedview/" + token);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save entry");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
