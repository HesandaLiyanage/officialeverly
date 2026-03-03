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

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EventUpdate extends HttpServlet {

    private EventDAO eventDAO;
    private GroupDAO groupDAO;
    private GroupAnnouncementDAO announcementDAO;

    @Override
    public void init() throws ServletException {
        this.eventDAO = new EventDAO();
        this.groupDAO = new GroupDAO();
        this.announcementDAO = new GroupAnnouncementDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG UpdateEventServlet] Handling POST request");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        String eventIdRedirect = null;

        try {
            String eventIdStr = getPartValue(request.getPart("event_id"));
            String title = getPartValue(request.getPart("e_title"));
            String description = getPartValue(request.getPart("e_description"));
            String dateStr = getPartValue(request.getPart("e_date"));

            // Validation
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Event ID is required");
            }
            if (title == null || title.trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required");
            }
            if (dateStr == null || dateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Event date is required");
            }

            int eventId = Integer.parseInt(eventIdStr);
            eventIdRedirect = eventIdStr;

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

            // Get existing event
            Event existingEvent = eventDAO.findById(eventId);
            if (existingEvent == null) {
                throw new IllegalArgumentException("Event not found");
            }

            // Security: verify all selected groups belong to this user
            for (int gid : selectedGroupIds) {
                Group g = groupDAO.findById(gid);
                if (g == null || g.getUserId() != userId) {
                    throw new SecurityException("You can only assign events to your own groups");
                }
            }

            // Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(dateStr);
            Timestamp eventDate = new Timestamp(parsedDate.getTime());

            // Handle file upload (optional)
            String eventPicUrl = existingEvent.getEventPicUrl();
            Part filePart = request.getPart("event_pic");
            if (filePart != null && filePart.getSize() > 0) {
                // Delete old image
                if (existingEvent.getEventPicUrl() != null && !existingEvent.getEventPicUrl().isEmpty()) {
                    deleteEventImage(existingEvent.getEventPicUrl());
                }

                String fileName = getSubmittedFileName(filePart);
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "event_" + UUID.randomUUID().toString() + fileExtension;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists())
                    uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                eventPicUrl = "media_uploads/" + uniqueFileName;
            }

            // Detect which groups are NEW (added in this update)
            List<Integer> oldGroupIds = eventDAO.getGroupIdsForEvent(eventId);
            List<Integer> newlyAddedGroups = new ArrayList<>();
            for (int gid : selectedGroupIds) {
                if (!oldGroupIds.contains(gid)) {
                    newlyAddedGroups.add(gid);
                }
            }

            // Update Event object
            existingEvent.setTitle(title.trim());
            existingEvent.setDescription(description != null ? description.trim() : "");
            existingEvent.setEventDate(eventDate);
            existingEvent.setGroupId(selectedGroupIds.get(0)); // backward compat
            existingEvent.setEventPicUrl(eventPicUrl);

            boolean success = eventDAO.updateEvent(existingEvent);

            if (success) {
                // Sync groups in junction table
                eventDAO.setEventGroups(eventId, selectedGroupIds);

                // Create announcements for NEWLY added groups only
                for (int groupId : newlyAddedGroups) {
                    try {
                        String announcementTitle = "New Event: " + existingEvent.getTitle();
                        String announcementContent = "A new event '" + existingEvent.getTitle() +
                                "' has been scheduled for " + dateStr + ".";

                        GroupAnnouncement announcement = new GroupAnnouncement(groupId, userId, announcementTitle,
                                announcementContent);
                        announcement.setEventId(eventId);
                        announcementDAO.createAnnouncement(announcement);
                        System.out.println("[DEBUG UpdateEventServlet] Created announcement for new group: " + groupId);
                    } catch (Exception e) {
                        System.err.println(
                                "[DEBUG UpdateEventServlet] Failed to create announcement for group " + groupId);
                    }
                }

                session.setAttribute("successMessage", "Event updated successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                throw new RuntimeException("Failed to update event");
            }

        } catch (ParseException e) {
            session.setAttribute("errorMessage", "Invalid date format");
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + eventIdRedirect);
        } catch (IllegalArgumentException | SecurityException e) {
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + eventIdRedirect);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while updating the event: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + eventIdRedirect);
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

    private void deleteEventImage(String imageUrl) {
        try {
            String realPath = getServletContext().getRealPath("") + File.separator + imageUrl;
            File imageFile = new File(realPath);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        } catch (Exception e) {
            System.err.println("[DEBUG UpdateEventServlet] Error deleting old image: " + e.getMessage());
        }
    }
}