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
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
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
     * Now supports multiple groups via checkboxes (group_ids[])
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
            // Get form fields
            String title = getPartValue(request.getPart("e_title"));
            String description = getPartValue(request.getPart("e_description"));
            String dateStr = getPartValue(request.getPart("e_date"));

            System.out.println("[DEBUG SaveEventServlet] Form data - Title: " + title + ", Date: " + dateStr);

            // Validation
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required");
            }
            if (dateStr == null || dateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Event date is required");
            }

            // Collect selected group IDs from checkboxes
            List<Integer> selectedGroupIds = new ArrayList<>();
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if ("group_ids".equals(part.getName())) {
                    String val = getPartValue(part);
                    if (val != null && !val.trim().isEmpty()) {
                        selectedGroupIds.add(Integer.parseInt(val.trim()));
                    }
                }
            }

            if (selectedGroupIds.isEmpty()) {
                throw new IllegalArgumentException("Please select at least one group");
            }

            System.out.println("[DEBUG SaveEventServlet] Selected groups: " + selectedGroupIds);

            // Security: verify all groups belong to this user
            for (int gid : selectedGroupIds) {
                Group g = groupDAO.findById(gid);
                if (g == null || g.getUserId() != userId) {
                    throw new SecurityException("You can only create events for your own groups (group " + gid + ")");
                }
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

                String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                eventPicUrl = "media_uploads/" + uniqueFileName;
                System.out.println("[DEBUG SaveEventServlet] File saved to: " + eventPicUrl);
            }

            // Create Event object (use first group for backward compat group_id)
            Event newEvent = new Event();
            newEvent.setTitle(title.trim());
            newEvent.setDescription(description != null ? description.trim() : "");
            newEvent.setEventDate(eventDate);
            newEvent.setGroupId(selectedGroupIds.get(0)); // primary group for backward compat
            newEvent.setEventPicUrl(eventPicUrl);
            newEvent.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            System.out.println("[DEBUG SaveEventServlet] Creating event: " + newEvent);

            // Save to database
            int eventId = eventDAO.createEvent(newEvent);

            if (eventId > 0) {
                // Save all groups to event_group junction table
                eventDAO.setEventGroups(eventId, selectedGroupIds);

                // Auto-create announcement for EACH selected group
                for (int groupId : selectedGroupIds) {
                    try {
                        String announcementTitle = "New Event: " + newEvent.getTitle();
                        String announcementContent = "A new event '" + newEvent.getTitle() +
                                "' has been scheduled for " + dateStr + ".\n\n" +
                                (newEvent.getDescription() != null && !newEvent.getDescription().isEmpty()
                                        ? "Details: " + newEvent.getDescription()
                                        : "");

                        GroupAnnouncement announcement = new GroupAnnouncement(groupId, userId, announcementTitle,
                                announcementContent);
                        announcement.setEventId(eventId);
                        boolean announcementCreated = announcementDAO.createAnnouncement(announcement);
                        System.out.println("[DEBUG SaveEventServlet] Auto-announcement created: " +
                                announcementCreated + " for group: " + groupId);
                    } catch (Exception e) {
                        System.err.println("[DEBUG SaveEventServlet] Failed to create auto-announcement for group "
                                + groupId + ": " + e.getMessage());
                    }
                }

                System.out.println("[DEBUG SaveEventServlet] Event created successfully with " + selectedGroupIds.size()
                        + " groups");
                session.setAttribute("successMessage", "Event created successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                throw new RuntimeException("Failed to create event");
            }

        } catch (ParseException e) {
            System.out.println("[DEBUG SaveEventServlet] Date parsing error: " + e.getMessage());
            session.setAttribute("errorMessage", "Invalid date format");
            response.sendRedirect(request.getContextPath() + "/createevent");
        } catch (IllegalArgumentException | SecurityException e) {
            System.out.println("[DEBUG SaveEventServlet] Validation error: " + e.getMessage());
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/createevent");
        } catch (Exception e) {
            System.out.println("[DEBUG SaveEventServlet] Error in POST: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while creating the event: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/createevent");
        }
    }

    private String getPartValue(Part part) throws IOException {
        if (part == null)
            return null;
        java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(part.getInputStream(), "UTF-8"));
        StringBuilder value = new StringBuilder();
        char[] buffer = new char[1024];
        int length;
        while ((length = reader.read(buffer)) > 0) {
            value.append(buffer, 0, length);
        }
        return value.toString();
    }

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