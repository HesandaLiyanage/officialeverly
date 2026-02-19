package com.demo.web.controller.Events;

import com.demo.web.dao.EventDAO;
import com.demo.web.dao.EventGroupDAO;
import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Event;
import com.demo.web.model.Group;

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

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class UpdateEventServlet extends HttpServlet {

    private EventDAO eventDAO;
    private EventGroupDAO eventGroupDAO;
    private GroupDAO groupDAO;

    @Override
    public void init() throws ServletException {
        this.eventDAO = new EventDAO();
        this.eventGroupDAO = new EventGroupDAO();
        this.groupDAO = new GroupDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG UpdateEventServlet] Handling POST request");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("[DEBUG UpdateEventServlet] No session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        System.out.println("[DEBUG UpdateEventServlet] User ID: " + userId);

        try {
            // Get form parameters (use getPart for multipart data)
            String eventIdStr = getPartValue(request.getPart("event_id"));
            String title = getPartValue(request.getPart("e_title"));
            String description = getPartValue(request.getPart("e_description"));
            String dateStr = getPartValue(request.getPart("e_date"));

            // Collect ALL group_id parts (multiple checkboxes with name="group_id")
            Collection<Part> allParts = request.getParts();
            List<Integer> groupIds = new ArrayList<>();
            for (Part part : allParts) {
                if ("group_id".equals(part.getName())) {
                    String val = getPartValue(part);
                    if (val != null && !val.trim().isEmpty()) {
                        groupIds.add(Integer.parseInt(val.trim()));
                    }
                }
            }

            System.out.println("[DEBUG UpdateEventServlet] Form data - Event ID: " + eventIdStr +
                    ", Title: " + title + ", Date: " + dateStr + ", Group IDs: " + groupIds);

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

            if (groupIds.isEmpty()) {
                throw new IllegalArgumentException("Please select at least one group");
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get existing event
            Event existingEvent = eventDAO.findById(eventId);
            if (existingEvent == null) {
                throw new IllegalArgumentException("Event not found");
            }

            // Verify that ALL selected groups belong to this user (security check)
            for (int groupId : groupIds) {
                Group selectedGroup = groupDAO.findById(groupId);
                if (selectedGroup == null || selectedGroup.getUserId() != userId) {
                    System.out.println("[DEBUG UpdateEventServlet] Security violation: User " + userId +
                            " attempted to update event " + eventId + " to group " + groupId);
                    throw new SecurityException("You can only update events for your own groups");
                }
            }

            // Parse the date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(dateStr);
            Timestamp eventDate = new Timestamp(parsedDate.getTime());

            // Handle file upload (optional - only if new file is uploaded)
            String eventPicUrl = existingEvent.getEventPicUrl(); // Keep existing image by default
            Part filePart = request.getPart("event_pic");

            if (filePart != null && filePart.getSize() > 0) {
                System.out.println("[DEBUG UpdateEventServlet] Processing new file upload");

                // Delete old image if exists
                if (existingEvent.getEventPicUrl() != null && !existingEvent.getEventPicUrl().isEmpty()) {
                    deleteEventImage(existingEvent.getEventPicUrl());
                }

                String fileName = getSubmittedFileName(filePart);
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "event_" + UUID.randomUUID().toString() + fileExtension;

                // Define upload path - using media_uploads (persistent directory)
                String uploadPath = getServletContext().getRealPath("") + File.separator + "media_uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Save file
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Store relative path
                eventPicUrl = "media_uploads/" + uniqueFileName;
                System.out.println("[DEBUG UpdateEventServlet] New file saved to: " + eventPicUrl);
            }

            // Update Event object
            existingEvent.setTitle(title.trim());
            existingEvent.setDescription(description != null ? description.trim() : "");
            existingEvent.setEventDate(eventDate);
            existingEvent.setGroupId(groupIds.get(0)); // legacy column
            existingEvent.setEventPicUrl(eventPicUrl);

            System.out.println("[DEBUG UpdateEventServlet] Updating event: " + existingEvent);

            // Update in database
            boolean success = eventDAO.updateEvent(existingEvent);

            if (success) {
                // Update group associations: delete old, insert new
                eventGroupDAO.deleteGroupsByEventId(eventId);
                eventGroupDAO.addGroupsToEvent(eventId, groupIds);
                System.out.println("[DEBUG UpdateEventServlet] Updated groups for event " + eventId + ": " + groupIds);

                System.out.println("[DEBUG UpdateEventServlet] Event updated successfully");
                session.setAttribute("successMessage", "Event updated successfully!");
                response.sendRedirect(request.getContextPath() + "/events");
            } else {
                System.out.println("[DEBUG UpdateEventServlet] Failed to update event");
                throw new RuntimeException("Failed to update event");
            }

        } catch (ParseException e) {
            System.out.println("[DEBUG UpdateEventServlet] Date parsing error: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Invalid date format");
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + request.getParameter("event_id"));

        } catch (IllegalArgumentException | SecurityException e) {
            System.out.println("[DEBUG UpdateEventServlet] Validation error: " + e.getMessage());
            session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + request.getParameter("event_id"));

        } catch (Exception e) {
            System.out.println("[DEBUG UpdateEventServlet] Error in POST: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while updating the event: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/editevent?event_id=" + request.getParameter("event_id"));
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
                    System.out.println("[DEBUG UpdateEventServlet] Old image deleted: " + realPath);
                } else {
                    System.out.println("[DEBUG UpdateEventServlet] Failed to delete old image: " + realPath);
                }
            }
        } catch (Exception e) {
            System.out.println("[DEBUG UpdateEventServlet] Error deleting old image: " + e.getMessage());
        }
    }
}