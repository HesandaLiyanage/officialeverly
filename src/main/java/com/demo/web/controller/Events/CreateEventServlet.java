package com.demo.web.controller.Events;

import com.demo.web.dao.EventDAO;
import com.demo.web.dao.GroupAnnouncementDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Event;
import com.demo.web.model.Group;
import com.demo.web.model.GroupAnnouncement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class CreateEventServlet extends HttpServlet {

    private EventDAO eventDAO;
    private GroupDAO groupDAO;
    private GroupAnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        this.eventDAO = new EventDAO();
        this.groupDAO = new GroupDAO();
        this.announcementDAO = new GroupAnnouncementDAO();
    }

    /**
     * POST - Handle event creation (form submission)
     */

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG SaveEventServlet] Handling POST request");
        System.out.println("[DEBUG] Content Type: " + request.getContentType());

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG SaveEventServlet] No session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        System.out.println("[DEBUG SaveEventServlet] User ID: " + userId);

        try {
            // IMPORTANT: For multipart/form-data, use getPart() instead of getParameter()
            String title = getPartValue(request.getPart("e_title"));
            String description = getPartValue(request.getPart("e_description"));
            String dateStr = getPartValue(request.getPart("e_date"));
            String groupIdStr = getPartValue(request.getPart("group_id"));

            System.out.println("[DEBUG SaveEventServlet] Form data - Title: " + title +
                    ", Date: " + dateStr + ", Group ID: " + groupIdStr);

            // Validation
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required");
            }

            if (dateStr == null || dateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Event date is required");
            }

            if (groupIdStr == null || groupIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Please select a group");
            }

            int groupId = Integer.parseInt(groupIdStr);

            // Verify that the group belongs to this user (security check)
            Group selectedGroup = groupDAO.findById(groupId);
            if (selectedGroup == null || selectedGroup.getUserId() != userId) {
                System.out.println("[DEBUG SaveEventServlet] Security violation: User " + userId +
                        " attempted to create event for group " + groupId);
                throw new SecurityException("You can only create events for your own groups");
            }

            // Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(dateStr);
            Timestamp eventDate = new Timestamp(parsedDate.getTime());

            // Handle file upload
            String eventPicUrl = null;
            Part filePart = request.getPart("event_pic");

            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("[DEBUG SaveEventServlet] Processing file upload");
                String fileName = getSubmittedFileName(filePart);
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "event_" + UUID.randomUUID().toString() + fileExtension;

                // Define upload path - using media_uploads (persistent directory)
                String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                    System.out.println("[DEBUG SaveEventServlet] Created upload directory: " + uploadPath);
                }

                // Save file
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Store relative path in database
                eventPicUrl = "media_uploads/" + uniqueFileName;
                System.out.println("[DEBUG SaveEventServlet] File saved to: " + eventPicUrl);
            }

            // Create Event object
            Event newEvent = new Event();
            newEvent.setTitle(title.trim());
            newEvent.setDescription(description != null ? description.trim() : "");
            newEvent.setEventDate(eventDate);
            newEvent.setGroupId(groupId);
            newEvent.setEventPicUrl(eventPicUrl);
            newEvent.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            System.out.println("[DEBUG SaveEventServlet] Creating event: " + newEvent);

            // Save to database
            int eventId = eventDAO.createEvent(newEvent);

            if (eventId > 0) {
                // Auto-create announcement for the group
                try {
                    String announcementTitle = "New Event: " + newEvent.getTitle();
                    String announcementContent = "A new event '" + newEvent.getTitle() + "' has been scheduled for " + dateStr + ".\n\n" +
                            (newEvent.getDescription() != null && !newEvent.getDescription().isEmpty()
                                    ? "Details: " + newEvent.getDescription()
                                    : "");

                    System.out.println("[DEBUG SaveEventServlet] Creating auto-announcement - groupId: " + groupId + ", userId: " + userId + ", title: " + announcementTitle);
                    GroupAnnouncement announcement = new GroupAnnouncement(groupId, userId, announcementTitle, announcementContent);
                    announcement.setEventId(eventId);
                    boolean announcementCreated = announcementDAO.createAnnouncement(announcement);
                    System.out.println("[DEBUG SaveEventServlet] Auto-announcement created: " + announcementCreated + " for event: " + newEvent.getTitle());
                } catch (Exception e) {
                    System.err.println("[DEBUG SaveEventServlet] Failed to create auto-announcement: " + e.getMessage());
                    e.printStackTrace();
                    // We don't want to fail the event creation if announcement fails
                }

                System.out.println("[DEBUG SaveEventServlet] Event created successfully");
                session.setAttribute("successMessage", "Event created successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                System.out.println("[DEBUG SaveEventServlet] Failed to create event");
                throw new RuntimeException("Failed to create event");
            }

        } catch (ParseException e) {
            System.out.println("[DEBUG SaveEventServlet] Date parsing error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Invalid date format");
            session.setAttribute("formData_e_title", getPartValue(request.getPart("e_title")));
            session.setAttribute("formData_e_description", getPartValue(request.getPart("e_description")));
            session.setAttribute("formData_e_date", getPartValue(request.getPart("e_date")));
            session.setAttribute("formData_group_id", getPartValue(request.getPart("group_id")));
            response.sendRedirect(request.getContextPath() + "/createevent");

        } catch (IllegalArgumentException | SecurityException e) {
            System.out.println("[DEBUG SaveEventServlet] Validation error: " + e.getMessage());
            session.setAttribute("errorMessage", e.getMessage());
            try {
                session.setAttribute("formData_e_title", getPartValue(request.getPart("e_title")));
                session.setAttribute("formData_e_description", getPartValue(request.getPart("e_description")));
                session.setAttribute("formData_e_date", getPartValue(request.getPart("e_date")));
                session.setAttribute("formData_group_id", getPartValue(request.getPart("group_id")));
            } catch (Exception ex) {
                // Ignore if parts are not available
            }
            response.sendRedirect(request.getContextPath() + "/createevent");

        } catch (Exception e) {
            System.out.println("[DEBUG SaveEventServlet] Error in POST: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while creating the event: " + e.getMessage());
            try {
                session.setAttribute("formData_e_title", getPartValue(request.getPart("e_title")));
                session.setAttribute("formData_e_description", getPartValue(request.getPart("e_description")));
                session.setAttribute("formData_e_date", getPartValue(request.getPart("e_date")));
                session.setAttribute("formData_group_id", getPartValue(request.getPart("group_id")));
            } catch (Exception ex) {
                // Ignore if parts are not available
            }
            response.sendRedirect(request.getContextPath() + "/createevent");
        }
    }

    /**
     * Helper method to extract value from a Part (for text fields in multipart form)
     */
    private String getPartValue(Part part) throws IOException {
        if (part == null) {
            return null;
        }

        java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(part.getInputStream(), "UTF-8")
        );

        StringBuilder value = new StringBuilder();
        char[] buffer = new char[1024];
        int length;
        while ((length = reader.read(buffer)) > 0) {
            value.append(buffer, 0, length);
        }

        return value.toString();
    }


    /**
     * Helper method to extract filename from Part
     */
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}