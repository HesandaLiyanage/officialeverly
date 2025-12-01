package com.demo.web.controller;

import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;
import com.demo.web.util.DatabaseUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

public class DeleteAutographServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(DeleteAutographServlet.class.getName());
    private autographDAO autographDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.autographDAO = new autographDAO(); // Initialize the DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("user_id");

        try {
            // Get the autograph ID to delete from the request parameter
            String autographIdStr = request.getParameter("autographId");
            if (autographIdStr == null || autographIdStr.trim().isEmpty()) {
                logger.warning("DeleteAutographServlet: Missing autographId parameter.");
                response.sendRedirect(request.getContextPath() + "/autographs"); // Redirect if ID missing
                return;
            }

            int autographId = Integer.parseInt(autographIdStr);

            // Optional: Verify the autograph belongs to the current user for security
            autograph existingAutograph = autographDAO.findById(autographId);
            if (existingAutograph == null || existingAutograph.getUserId() != userId) {
                logger.warning("DeleteAutographServlet: User " + userId + " attempted to delete autograph " + autographId + " which does not exist or does not belong to them.");
                response.sendRedirect(request.getContextPath() + "/autographs"); // Redirect if unauthorized
                return;
            }

            // Attempt to delete the autograph
            boolean success = autographDAO.deleteAutograph(autographId);

            if (success) {
                logger.info("Successfully deleted autograph ID: " + autographId + " by user ID: " + userId);
                // Redirect to the autographs list page on success
                response.sendRedirect(request.getContextPath() + "/autographs");
            } else {
                // This might happen if the delete failed for reasons other than the record not existing
                logger.warning("Failed to delete autograph ID: " + autographId + " by user ID: " + userId);
                // You could redirect back with an error, but often redirecting to the list is fine.
                response.sendRedirect(request.getContextPath() + "/autographs?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            logger.severe("DeleteAutographServlet: Invalid autograph ID format: " + request.getParameter("autographId"));
            response.sendRedirect(request.getContextPath() + "/autographs"); // Redirect on invalid ID format
        } catch (Exception e) {
            logger.severe("Database error while deleting autograph: " + e.getMessage());
            e.printStackTrace(); // Log the full stack trace for debugging
            response.sendRedirect(request.getContextPath() + "/autographs?error=database_error");
        }
    }
}