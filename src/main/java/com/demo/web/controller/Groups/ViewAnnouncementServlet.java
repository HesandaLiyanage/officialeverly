package com.demo.web.controller.Groups;

import com.demo.web.dao.GroupAnnouncementDAO;
import com.demo.web.model.GroupAnnouncement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ViewAnnouncementServlet extends HttpServlet {

    private GroupAnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        announcementDAO = new GroupAnnouncementDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/groups");
            return;
        }

        try {
            int announcementId = Integer.parseInt(idStr);
            GroupAnnouncement announcement = announcementDAO.findById(announcementId);
            
            if (announcement == null) {
                response.sendRedirect(request.getContextPath() + "/groups?error=Announcement not found");
                return;
            }

            request.setAttribute("announcement", announcement);
            request.getRequestDispatcher("/views/app/viewannouncement.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/groups?error=Invalid announcement ID");
        }
    }
}
