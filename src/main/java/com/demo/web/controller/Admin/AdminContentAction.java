package com.demo.web.controller.Admin;

import com.demo.web.dao.Feed.PostReportDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * AdminContentAction - Handles admin actions on reported content.
 * POST-only servlet that performs the action then redirects back to /admincontent.
 * Actions: dismiss, warn, delete_post
 */
public class AdminContentAction extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminContentAction.class.getName());
    private PostReportDAO postReportDAO;

    @Override
    public void init() throws ServletException {
        postReportDAO = new PostReportDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int adminUserId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        String reportIdStr = request.getParameter("reportId");
        String postIdStr = request.getParameter("postId");
        String adminNotes = request.getParameter("adminNotes");

        if (action == null) {
            session.setAttribute("adminFlashMessage", "Invalid action.");
            session.setAttribute("adminFlashType", "error");
            response.sendRedirect(request.getContextPath() + "/admincontent");
            return;
        }

        try {
            switch (action) {
                case "dismiss":
                    if (reportIdStr != null) {
                        int reportId = Integer.parseInt(reportIdStr);
                        boolean dismissed = postReportDAO.updateReportStatus(reportId, "dismissed",
                            adminNotes != null ? adminNotes : "Dismissed by admin.", adminUserId);
                        if (dismissed) {
                            session.setAttribute("adminFlashMessage", "Report dismissed successfully.");
                            session.setAttribute("adminFlashType", "success");
                        } else {
                            session.setAttribute("adminFlashMessage", "Failed to dismiss report.");
                            session.setAttribute("adminFlashType", "error");
                        }
                    }
                    break;

                case "reviewed":
                    if (reportIdStr != null) {
                        int reportId = Integer.parseInt(reportIdStr);
                        boolean reviewed = postReportDAO.updateReportStatus(reportId, "reviewed",
                            adminNotes != null ? adminNotes : "Reviewed by admin.", adminUserId);
                        if (reviewed) {
                            session.setAttribute("adminFlashMessage", "Report marked as reviewed.");
                            session.setAttribute("adminFlashType", "success");
                        } else {
                            session.setAttribute("adminFlashMessage", "Failed to update report.");
                            session.setAttribute("adminFlashType", "error");
                        }
                    }
                    break;

                case "delete_post":
                    if (postIdStr != null) {
                        int postId = Integer.parseInt(postIdStr);
                        boolean deleted = postReportDAO.deleteReportedPost(postId, adminUserId);
                        if (deleted) {
                            session.setAttribute("adminFlashMessage", "Post deleted successfully.");
                            session.setAttribute("adminFlashType", "success");
                        } else {
                            session.setAttribute("adminFlashMessage", "Failed to delete post.");
                            session.setAttribute("adminFlashType", "error");
                        }
                    }
                    break;

                default:
                    session.setAttribute("adminFlashMessage", "Unknown action: " + action);
                    session.setAttribute("adminFlashType", "error");
                    break;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("adminFlashMessage", "Invalid ID parameter.");
            session.setAttribute("adminFlashType", "error");
        }

        logger.info("[AdminContentAction] Action '" + action + "' performed by admin " + adminUserId);
        response.sendRedirect(request.getContextPath() + "/admincontent");
    }
}
