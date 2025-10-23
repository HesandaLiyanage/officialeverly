package com.demo.web.controller;

import com.demo.web.dao.EventDAO;
import com.demo.web.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

public class DeleteEventServlet extends HttpServlet {

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        this.eventDAO = new EventDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG DeleteEventServlet] Handling POST request");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG DeleteEventServlet] No session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String eventIdStr = request.getParameter("event_id");

        System.out.println("[DEBUG DeleteEventServlet] User ID: " + userId + ", Event ID: " + eventIdStr);

        try {
            // Validation
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Event ID is required");
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get the event first to verify ownership and get image path
            Event event = eventDAO.findById(eventId);

            if (event == null) {
                System.out.println("[DEBUG DeleteEventServlet] Event not found: " + eventId);
                session.setAttribute("errorMessage", "Event not found");
                response.sendRedirect(request.getContextPath() + "/events");
                return;
            }

            // Security check: Verify the event belongs to a group owned by this user
            // You'll need to add a method to check this, or get group info from event
            // For now, assuming you have a way to verify ownership through GroupDAO
            // This is a simplified version - adjust based on your actual security model

            System.out.println("[DEBUG DeleteEventServlet] Deleting event: " + event.getTitle());

            // Delete the event from database
            boolean deleted = eventDAO.deleteEvent(eventId);

            if (deleted) {
                System.out.println("[DEBUG DeleteEventServlet] Event deleted successfully");

                // Delete the event image file if it exists
                if (event.getEventPicUrl() != null && !event.getEventPicUrl().isEmpty()) {
                    deleteEventImage(event.getEventPicUrl());
                }

                session.setAttribute("successMessage", "Event deleted successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                System.out.println("[DEBUG DeleteEventServlet] Failed to delete event");
                session.setAttribute("errorMessage", "Failed to delete event");
                response.sendRedirect(request.getContextPath() + "/events");
            }

        } catch (NumberFormatException e) {
            System.out.println("[DEBUG DeleteEventServlet] Invalid event ID format: " + e.getMessage());
            session.setAttribute("errorMessage", "Invalid event ID");
            response.sendRedirect(request.getContextPath() + "/events");

        } catch (IllegalArgumentException e) {
            System.out.println("[DEBUG DeleteEventServlet] Validation error: " + e.getMessage());
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/events");

        } catch (Exception e) {
            System.out.println("[DEBUG DeleteEventServlet] Error deleting event: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while deleting the event");
            response.sendRedirect(request.getContextPath() + "/events");
        }
    }

    /**
     * Helper method to delete event image from file system
     */
    private void deleteEventImage(String imageUrl) {
        try {
            String realPath = getServletContext().getRealPath("") + File.separator + imageUrl;
            File imageFile = new File(realPath);

            if (imageFile.exists()) {
                boolean fileDeleted = imageFile.delete();
                if (fileDeleted) {
                    System.out.println("[DEBUG DeleteEventServlet] Image file deleted: " + realPath);
                } else {
                    System.out.println("[DEBUG DeleteEventServlet] Failed to delete image file: " + realPath);
                }
            } else {
                System.out.println("[DEBUG DeleteEventServlet] Image file not found: " + realPath);
            }
        } catch (Exception e) {
            System.out.println("[DEBUG DeleteEventServlet] Error deleting image file: " + e.getMessage());
            // Don't throw exception, just log it - image deletion is not critical
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST or show error
        response.sendRedirect(request.getContextPath() + "/events");
    }
}