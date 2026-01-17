package com.demo.web.controller.Autographs;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.demo.web.dao.autographDAO; // DAO import
import com.demo.web.model.autograph; // Model import

@WebServlet("/submitAutographEntry")
public class SubmitAutographEntryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String shareToken = req.getParameter("shareToken");
        String content = req.getParameter("content");
        String decorations = req.getParameter("decorations");

        if (shareToken == null || content == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        autographDAO dao = new autographDAO();

        try {
            autograph ag = dao.getAutographByShareToken(shareToken);

            if (ag == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // TODO: save entry using ag.getAutographId()
            // autographEntryDAO.save(ag.getAutographId(), content, decorations);

            resp.sendRedirect(req.getContextPath() + "/thank-you");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
