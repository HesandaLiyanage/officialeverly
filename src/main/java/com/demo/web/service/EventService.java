package com.demo.web.service;

import com.demo.web.dao.Events.EventDAO;
import com.demo.web.dao.Events.EventVoteDAO;
import com.demo.web.dao.Groups.GroupAnnouncementDAO;
import com.demo.web.dao.Groups.GroupDAO;
import com.demo.web.dto.Events.*;
import com.demo.web.model.Events.Event;
import com.demo.web.model.Groups.Group;
import com.demo.web.model.Groups.GroupAnnouncement;

import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class EventService {

    private EventDAO eventDAO;
    private GroupDAO groupDAO;
    private GroupAnnouncementDAO announcementDAO;
    private EventVoteDAO voteDAO;

    public EventService() {
        this.eventDAO = new EventDAO();
        this.groupDAO = new GroupDAO();
        this.announcementDAO = new GroupAnnouncementDAO();
        this.voteDAO = new EventVoteDAO();
    }

    // Existing helpers (used internally or elsewhere)
    public List<Event> getAllEvents(int userId) { return eventDAO.findByUserId(userId); }
    public List<Event> getUpcomingEvents(int userId) { return eventDAO.findUpcomingEventsByUserId(userId); }
    public List<Event> getPastEvents(int userId) { return eventDAO.findPastEventsByUserId(userId); }
    public boolean isUserGroupAdmin(int userId) { return eventDAO.isUserGroupAdmin(userId); }
    public Event getEventByIdWithPermission(int eventId, int userId) {
        Event event = eventDAO.findById(eventId);
        if (event == null) return null;
        Group eventGroup = groupDAO.findById(event.getGroupId());
        if (eventGroup == null || eventGroup.getUserId() != userId) return null;
        return event;
    }
    public List<Group> getUserGroups(int userId) { return groupDAO.findByUserId(userId); }

    // --- NEW DTO-BASED METHODS ---

    public EventDashboardResponse getDashboardData(EventDashboardRequest request) {
        EventDashboardResponse response = new EventDashboardResponse();
        try {
            int userId = request.getUserId();
            response.setGroupAdmin(isUserGroupAdmin(userId));
            response.setAllEvents(getAllEvents(userId));
            response.setUpcomingEvents(getUpcomingEvents(userId));
            response.setPastEvents(getPastEvents(userId));
            response.setUpcomingCount(response.getUpcomingEvents() != null ? response.getUpcomingEvents().size() : 0);
            response.setPastCount(response.getPastEvents() != null ? response.getPastEvents().size() : 0);
            response.setTotalCount(response.getAllEvents() != null ? response.getAllEvents().size() : 0);
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while fetching events: " + e.getMessage());
        }
        return response;
    }

    public EventCreateFormResponse getCreateFormData(EventCreateFormRequest request) {
        EventCreateFormResponse response = new EventCreateFormResponse();
        try {
            List<Group> userGroups = getUserGroups(request.getUserId());
            if (userGroups == null || userGroups.isEmpty()) {
                response.setNoGroups(true);
                response.setErrorMessage("You need to create a group first before creating events.");
            }
            response.setUserGroups(userGroups);
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while loading groups: " + e.getMessage());
        }
        return response;
    }

    public EventEditFormResponse getEditFormData(EventEditFormRequest request) {
        EventEditFormResponse response = new EventEditFormResponse();
        response.setSuccess(false);
        try {
            if (request.getEventIdParam() == null || request.getEventIdParam().trim().isEmpty()) {
                response.setErrorMessage("Event ID is required");
                return response;
            }
            int eventId = Integer.parseInt(request.getEventIdParam());
            Event event = getEventByIdWithPermission(eventId, request.getUserId());
            if (event == null) {
                response.setErrorMessage("Event not found or you don't have permission");
                return response;
            }

            response.setEvent(event);
            response.setUserGroups(getUserGroups(request.getUserId()));
            response.setEventGroupIds(eventDAO.getGroupIdsForEvent(eventId));
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            response.setFormattedDate(dateFormat.format(event.getEventDate()));

            String existingImageUrl = event.getEventPicUrl();
            if (existingImageUrl != null && !existingImageUrl.isEmpty()) {
                response.setDisplayImageUrl(existingImageUrl); // Base URL string, Context path injected at controller
            }
            response.setSuccess(true);

        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid event ID");
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while loading the event");
        }
        return response;
    }

    public EventInfoResponse getEventInfoData(EventInfoRequest request, String contextPath) {
        EventInfoResponse response = new EventInfoResponse();
        response.setSuccess(false);

        try {
            if (request.getEventIdParam() == null || request.getEventIdParam().trim().isEmpty()) {
                response.setErrorMessage("Event ID is required");
                return response;
            }

            int eventId = Integer.parseInt(request.getEventIdParam());
            Event event = eventDAO.findById(eventId);
            if (event == null) {
                response.setErrorMessage("Event not found");
                return response;
            }

            List<Group> eventGroups = new ArrayList<>();
            List<Integer> groupIds = eventDAO.getGroupIdsForEvent(eventId);
            if (groupIds.isEmpty()) { groupIds.add(event.getGroupId()); }
            for (int gid : groupIds) {
                Group g = groupDAO.findById(gid);
                if (g != null) eventGroups.add(g);
            }

            boolean hasAccess = false;
            for (Group g : eventGroups) {
                if (g.getUserId() == request.getUserId()) { hasAccess = true; break; }
            }
            if (!hasAccess) {
                response.setErrorMessage("You don't have permission to view this event");
                return response;
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
            response.setFormattedDate(dateFormat.format(event.getEventDate()));
            String eventPicUrl = event.getEventPicUrl();
            response.setHasImage(eventPicUrl != null && !eventPicUrl.isEmpty());
            if (response.isHasImage()) {
                response.setDisplayPicUrl(contextPath + "/" + eventPicUrl);
            }
            response.setPastEvent(event.getEventDate().before(new Date()));

            StringBuilder groupNamesStr = new StringBuilder();
            for (int i = 0; i < eventGroups.size(); i++) {
                groupNamesStr.append(eventGroups.get(i).getName());
                if (i < eventGroups.size() - 1) groupNamesStr.append(", ");
            }
            response.setGroupNamesStr(groupNamesStr.toString());

            Integer filterGroupId = null;
            if (request.getGroupIdParam() != null && !request.getGroupIdParam().trim().isEmpty()) {
                try { filterGroupId = Integer.parseInt(request.getGroupIdParam()); } catch (Exception ignore) {}
            }
            List<Group> pollGroups;
            if (filterGroupId != null) {
                pollGroups = new ArrayList<>();
                for (Group g : eventGroups) {
                    if (g.getGroupId() == filterGroupId) { pollGroups.add(g); break; }
                }
            } else {
                pollGroups = eventGroups;
            }

            Map<Integer, Map<String, Integer>> voteCountsMap = new HashMap<>();
            Map<Integer, String> userVoteMap = new HashMap<>();
            Map<Integer, List<Map<String, Object>>> votersMap = new HashMap<>();

            for (Group pollGroup : pollGroups) {
                int pgId = pollGroup.getGroupId();
                voteCountsMap.put(pgId, voteDAO.getVoteCounts(eventId, pgId));
                userVoteMap.put(pgId, voteDAO.getUserVote(eventId, pgId, request.getUserId()));
                votersMap.put(pgId, voteDAO.getVoters(eventId, pgId));
            }

            response.setEvent(event);
            response.setEventGroups(eventGroups);
            response.setPollGroups(pollGroups);
            response.setVoteCountsMap(voteCountsMap);
            response.setUserVoteMap(userVoteMap);
            response.setVotersMap(votersMap);
            response.setUserId(request.getUserId());
            response.setSuccess(true);

        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid event ID");
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while loading the event");
        }
        return response;
    }

    public EventCreateResponse createEvent(EventCreateRequest request) {
        EventCreateResponse response = new EventCreateResponse();
        response.setSuccess(false);

        try {
            if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required");
            }
            if (request.getDateStr() == null || request.getDateStr().trim().isEmpty()) {
                throw new IllegalArgumentException("Event date is required");
            }
            if (request.getSelectedGroupIds() == null || request.getSelectedGroupIds().isEmpty()) {
                throw new IllegalArgumentException("Please select at least one group");
            }

            for (int gid : request.getSelectedGroupIds()) {
                Group g = groupDAO.findById(gid);
                if (g == null || g.getUserId() != request.getUserId()) {
                    throw new SecurityException("You can only create events for your own groups");
                }
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(request.getDateStr());
            Timestamp eventDate = new Timestamp(parsedDate.getTime());

            String eventPicUrl = null;
            if (request.getFilePart() != null && request.getFilePart().getSize() > 0) {
                String fileName = getSubmittedFileName(request.getFilePart());
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "event_" + UUID.randomUUID().toString() + fileExtension;
                File uploadDir = new File(request.getUploadPath());
                if (!uploadDir.exists()) uploadDir.mkdirs();
                String filePath = request.getUploadPath() + File.separator + uniqueFileName;
                request.getFilePart().write(filePath);
                eventPicUrl = "media_uploads/" + uniqueFileName;
            }

            Event newEvent = new Event();
            newEvent.setTitle(request.getTitle().trim());
            newEvent.setDescription(request.getDescription() != null ? request.getDescription().trim() : "");
            newEvent.setEventDate(eventDate);
            newEvent.setEventTime(LocalTime.parse(request.getTimeStr()));
            newEvent.setGroupId(request.getSelectedGroupIds().get(0));
            newEvent.setEventPicUrl(eventPicUrl);
            newEvent.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            int eventId = eventDAO.createEvent(newEvent);
            if (eventId > 0) {
                eventDAO.setEventGroups(eventId, request.getSelectedGroupIds());

                for (int groupId : request.getSelectedGroupIds()) {
                    String announcementContent = "A new event '" + newEvent.getTitle() + "' has been scheduled for " + request.getDateStr() + ".";
                    GroupAnnouncement announcement = new GroupAnnouncement(groupId, request.getUserId(), "New Event: " + newEvent.getTitle(), announcementContent);
                    announcement.setEventId(eventId);
                    announcementDAO.createAnnouncement(announcement);
                }
                response.setSuccess(true);
            } else {
                throw new RuntimeException("Failed to create event");
            }

        } catch (ParseException e) {
            response.setErrorMessage("Invalid date format");
        } catch (IllegalArgumentException | SecurityException e) {
            response.setErrorMessage(e.getMessage());
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while creating the event: " + e.getMessage());
        }
        return response;
    }

    public EventUpdateResponse updateEvent(EventUpdateRequest request) {
        EventUpdateResponse response = new EventUpdateResponse();
        response.setSuccess(false);

        try {
            if (request.getEventIdStr() == null || request.getEventIdStr().trim().isEmpty()) {
                throw new IllegalArgumentException("Event ID is required");
            }
            response.setEventIdStr(request.getEventIdStr());

            if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
                throw new IllegalArgumentException("Event title is required");
            }
            if (request.getDateStr() == null || request.getDateStr().trim().isEmpty()) {
                throw new IllegalArgumentException("Event date is required");
            }
            if (request.getSelectedGroupIds() == null || request.getSelectedGroupIds().isEmpty()) {
                throw new IllegalArgumentException("Please select at least one group");
            }

            int eventId = Integer.parseInt(request.getEventIdStr());
            Event existingEvent = eventDAO.findById(eventId);
            if (existingEvent == null) throw new IllegalArgumentException("Event not found");

            for (int gid : request.getSelectedGroupIds()) {
                Group g = groupDAO.findById(gid);
                if (g == null || g.getUserId() != request.getUserId()) {
                    throw new SecurityException("You can only assign events to your own groups");
                }
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(request.getDateStr());
            Timestamp eventDate = new Timestamp(parsedDate.getTime());

            String eventPicUrl = existingEvent.getEventPicUrl();
            if (request.getFilePart() != null && request.getFilePart().getSize() > 0) {
                if (existingEvent.getEventPicUrl() != null && !existingEvent.getEventPicUrl().isEmpty()) {
                    deleteEventImage(request.getRealPathBase(), existingEvent.getEventPicUrl());
                }
                String fileName = getSubmittedFileName(request.getFilePart());
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "event_" + UUID.randomUUID().toString() + fileExtension;
                File uploadDir = new File(request.getUploadPath());
                if (!uploadDir.exists()) uploadDir.mkdirs();
                String filePath = request.getUploadPath() + File.separator + uniqueFileName;
                request.getFilePart().write(filePath);
                eventPicUrl = "media_uploads/" + uniqueFileName;
            }

            List<Integer> oldGroupIds = eventDAO.getGroupIdsForEvent(eventId);
            List<Integer> newlyAddedGroups = new ArrayList<>();
            for (int gid : request.getSelectedGroupIds()) {
                if (!oldGroupIds.contains(gid)) {
                    newlyAddedGroups.add(gid);
                }
            }

            existingEvent.setTitle(request.getTitle().trim());
            existingEvent.setDescription(request.getDescription() != null ? request.getDescription().trim() : "");
            existingEvent.setEventDate(eventDate);
            existingEvent.setGroupId(request.getSelectedGroupIds().get(0));
            existingEvent.setEventPicUrl(eventPicUrl);

            boolean success = eventDAO.updateEvent(existingEvent);
            if (success) {
                eventDAO.setEventGroups(eventId, request.getSelectedGroupIds());

                for (int groupId : newlyAddedGroups) {
                    GroupAnnouncement announcement = new GroupAnnouncement(groupId, request.getUserId(), "New Event: " + existingEvent.getTitle(), "A new event '" + existingEvent.getTitle() + "' has been scheduled for " + request.getDateStr() + ".");
                    announcement.setEventId(eventId);
                    announcementDAO.createAnnouncement(announcement);
                }
                response.setSuccess(true);
            } else {
                throw new RuntimeException("Failed to update event");
            }
        } catch (ParseException e) {
            response.setErrorMessage("Invalid date format");
        } catch (IllegalArgumentException | SecurityException e) {
            response.setErrorMessage(e.getMessage());
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while updating the event: " + e.getMessage());
        }
        return response;
    }

    public EventDeleteResponse deleteEvent(EventDeleteRequest request) {
        EventDeleteResponse response = new EventDeleteResponse();
        response.setSuccess(false);
        try {
            if (request.getEventIdStr() == null || request.getEventIdStr().trim().isEmpty()) {
                response.setErrorMessage("Event ID is required");
                return response;
            }
            int eventId = Integer.parseInt(request.getEventIdStr());
            Event event = eventDAO.findById(eventId);
            if (event == null) {
                response.setErrorMessage("Event not found");
                return response;
            }
            // Add ownership verification via group using DTO
            Group eventGroup = groupDAO.findById(event.getGroupId());
            if (eventGroup == null || eventGroup.getUserId() != request.getUserId()) {
                response.setErrorMessage("Permission denied");
                return response;
            }

            boolean deleted = eventDAO.deleteEvent(eventId);
            if (deleted) {
                if (event.getEventPicUrl() != null && !event.getEventPicUrl().isEmpty()) {
                    deleteEventImage(request.getRealPathBase(), event.getEventPicUrl());
                }
                response.setSuccess(true);
            } else {
                response.setErrorMessage("Failed to delete event");
            }
        } catch (NumberFormatException e) {
            response.setErrorMessage("Invalid event ID");
        } catch (Exception e) {
            response.setErrorMessage("An error occurred while deleting the event");
        }
        return response;
    }

    public EventVoteActionResponse castVote(EventVoteActionRequest request) {
        EventVoteActionResponse response = new EventVoteActionResponse();
        try {
            int eventId = Integer.parseInt(request.getEventIdStr());
            int groupId = Integer.parseInt(request.getGroupIdStr());
            String vote = request.getVoteStr();

            if (vote == null || (!vote.equals("going") && !vote.equals("not_going") && !vote.equals("maybe"))) {
                response.setStatusCode(400);
                response.setJsonResponse("{\"success\": false, \"error\": \"Invalid vote. Must be going, not_going, or maybe\"}");
                return response;
            }

            String existingVote = voteDAO.getUserVote(eventId, groupId, request.getUserId());
            if (existingVote != null && existingVote.equals(vote)) {
                voteDAO.removeVote(eventId, groupId, request.getUserId());
            } else {
                voteDAO.castVote(eventId, groupId, request.getUserId(), vote);
            }

            Map<String, Integer> counts = voteDAO.getVoteCounts(eventId, groupId);
            String currentVote = voteDAO.getUserVote(eventId, groupId, request.getUserId());

            response.setStatusCode(200);
            response.setJsonResponse("{\"success\": true, " +
                    "\"going\": " + counts.get("going") + ", " +
                    "\"not_going\": " + counts.get("not_going") + ", " +
                    "\"maybe\": " + counts.get("maybe") + ", " +
                    "\"total\": " + counts.get("total") + ", " +
                    "\"userVote\": " + (currentVote != null ? "\"" + currentVote + "\"" : "null") +
                    "}");
        } catch (NumberFormatException e) {
            response.setStatusCode(400);
            response.setJsonResponse("{\"success\": false, \"error\": \"Invalid event_id or group_id\"}");
        } catch (Exception e) {
            response.setStatusCode(500);
            response.setJsonResponse("{\"success\": false, \"error\": \"Server error\"}");
        }
        return response;
    }

    public EventVoteDataResponse getVoteData(EventVoteDataRequest request) {
        EventVoteDataResponse response = new EventVoteDataResponse();
        try {
            int eventId = Integer.parseInt(request.getEventIdStr());
            int groupId = Integer.parseInt(request.getGroupIdStr());

            if ("voters".equals(request.getTypeStr())) {
                List<Map<String, Object>> voters = voteDAO.getVoters(eventId, groupId);
                StringBuilder sb = new StringBuilder("{\"success\": true, \"voters\": [");
                for (int i = 0; i < voters.size(); i++) {
                    Map<String, Object> v = voters.get(i);
                    sb.append("{");
                    sb.append("\"user_id\": ").append(v.get("user_id")).append(", ");
                    sb.append("\"username\": \"").append(escapeJson((String) v.get("username"))).append("\", ");
                    sb.append("\"profile_picture_url\": ")
                            .append(v.get("profile_picture_url") != null ? "\"" + escapeJson((String) v.get("profile_picture_url")) + "\"" : "null")
                            .append(", ");
                    sb.append("\"vote\": \"").append(v.get("vote")).append("\"");
                    sb.append("}");
                    if (i < voters.size() - 1) sb.append(", ");
                }
                sb.append("]}");
                response.setStatusCode(200);
                response.setJsonResponse(sb.toString());
            } else {
                Map<String, Integer> counts = voteDAO.getVoteCounts(eventId, groupId);
                String currentVote = voteDAO.getUserVote(eventId, groupId, request.getUserId());
                response.setStatusCode(200);
                response.setJsonResponse("{\"success\": true, " +
                        "\"going\": " + counts.get("going") + ", " +
                        "\"not_going\": " + counts.get("not_going") + ", " +
                        "\"maybe\": " + counts.get("maybe") + ", " +
                        "\"total\": " + counts.get("total") + ", " +
                        "\"userVote\": " + (currentVote != null ? "\"" + currentVote + "\"" : "null") +
                        "}");
            }
        } catch (NumberFormatException e) {
            response.setStatusCode(400);
            response.setJsonResponse("{\"success\": false, \"error\": \"Invalid event_id or group_id\"}");
        } catch (Exception e) {
            response.setStatusCode(500);
            response.setJsonResponse("{\"success\": false, \"error\": \"Server error\"}");
        }
        return response;
    }

    // --- Private Helpers ---

    private void deleteEventImage(String realPathBase, String imageUrl) {
        try {
            String realPath = realPathBase + File.separator + imageUrl;
            File imageFile = new File(realPath);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        } catch (Exception e) {
            // Ignored
        }
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

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
