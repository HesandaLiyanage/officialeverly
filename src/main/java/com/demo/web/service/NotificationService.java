package com.demo.web.service;

import com.demo.web.dao.Notifications.NotificationDAO;
import com.demo.web.dto.Notifications.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService() {
        this.notificationDAO = new NotificationDAO();
    }

    public NotificationCountResponse getUnreadCount(NotificationCountRequest request) {
        NotificationCountResponse response = new NotificationCountResponse();
        
        if (request.getUserId() == null) {
            response.setCount(0);
            response.setSuccess(false);
            return response;
        }

        int count = notificationDAO.getUnreadCount(request.getUserId());
        response.setCount(count);
        response.setSuccess(true);
        return response;
    }

    public NotificationPrefsGetResponse getPreferences(NotificationPrefsGetRequest request) {
        NotificationPrefsGetResponse response = new NotificationPrefsGetResponse();

        if (request.getUserId() == null) {
            response.setRedirectUrl("/login");
            return response;
        }

        Map<String, Boolean> prefs = notificationDAO.getPreferences(request.getUserId());
        response.setPrefs(prefs);
        return response;
    }

    public NotificationPrefsPostResponse updatePreference(NotificationPrefsPostRequest request) {
        NotificationPrefsPostResponse response = new NotificationPrefsPostResponse();

        if (request.getUserId() == null) {
            response.setStatusCode(401);
            response.setErrorMessage("Not authenticated");
            response.setSuccess(false);
            return response;
        }

        if (request.getNotifType() == null || request.getEnabledStr() == null) {
            response.setStatusCode(400);
            response.setErrorMessage("Missing parameters");
            response.setSuccess(false);
            return response;
        }

        boolean enabled = Boolean.parseBoolean(request.getEnabledStr());
        boolean success = notificationDAO.updatePreference(request.getUserId(), request.getNotifType(), enabled);

        response.setSuccess(success);
        return response;
    }

    public NotificationsListGetResponse getNotifications(NotificationsListGetRequest request) {
        NotificationsListGetResponse response = new NotificationsListGetResponse();

        if (request.getUserId() == null) {
            response.setRedirectUrl("/login");
            return response;
        }

        List<Map<String, Object>> notifications = notificationDAO.getNotifications(request.getUserId(), 50);
        int unreadCount = notificationDAO.getUnreadCount(request.getUserId());

        for (Map<String, Object> n : notifications) {
            String type = (String) n.get("notifType");
            n.put("gradient", getGradient(type));
            n.put("typeIcon", getTypeIcon(type));
            n.put("typeLabel", getTypeLabel(type));
            n.put("timeAgo", timeAgo((Timestamp) n.get("createdAt")));
            n.put("initials", getInitials((String) n.get("actorUsername")));
        }

        response.setNotifications(notifications);
        response.setUnreadCount(unreadCount);
        return response;
    }

    public NotificationsListPostResponse handleAction(NotificationsListPostRequest request) {
        NotificationsListPostResponse response = new NotificationsListPostResponse();

        if (request.getUserId() == null) {
            response.setStatusCode(401);
            response.setErrorMessage("Not authenticated");
            response.setSuccess(false);
            return response;
        }

        String action = request.getAction();

        if ("markAllRead".equals(action)) {
            boolean success = notificationDAO.markAllAsRead(request.getUserId());
            response.setSuccess(success);
        } else if ("markRead".equals(action)) {
            if (request.getNotificationIdStr() != null) {
                try {
                    int notifId = Integer.parseInt(request.getNotificationIdStr());
                    boolean success = notificationDAO.markAsRead(notifId, request.getUserId());
                    response.setSuccess(success);
                } catch (NumberFormatException e) {
                    response.setStatusCode(400);
                    response.setErrorMessage("Invalid notificationId format");
                    response.setSuccess(false);
                }
            } else {
                response.setStatusCode(400);
                response.setErrorMessage("Missing notificationId");
                response.setSuccess(false);
            }
        } else if ("delete".equals(action)) {
            if (request.getNotificationIdStr() != null) {
                try {
                    int notifId = Integer.parseInt(request.getNotificationIdStr());
                    boolean success = notificationDAO.deleteNotification(notifId, request.getUserId());
                    response.setSuccess(success);
                } catch (NumberFormatException e) {
                    response.setStatusCode(400);
                    response.setErrorMessage("Invalid notificationId format");
                    response.setSuccess(false);
                }
            } else {
                response.setStatusCode(400);
                response.setErrorMessage("Missing notificationId");
                response.setSuccess(false);
            }
        } else {
            response.setStatusCode(400);
            response.setErrorMessage("Unknown action");
            response.setSuccess(false);
        }

        return response;
    }

    private String timeAgo(Timestamp ts) {
        if (ts == null) return "";
        long diff = System.currentTimeMillis() - ts.getTime();
        long seconds = diff / 1000;
        if (seconds < 60) return "Just now";
        long minutes = seconds / 60;
        if (minutes < 60) return minutes + (minutes == 1 ? " minute ago" : " minutes ago");
        long hours = minutes / 60;
        if (hours < 24) return hours + (hours == 1 ? " hour ago" : " hours ago");
        long days = hours / 24;
        if (days < 7) return days + (days == 1 ? " day ago" : " days ago");
        long weeks = days / 7;
        if (weeks < 4) return weeks + (weeks == 1 ? " week ago" : " weeks ago");
        long months = days / 30;
        if (months < 12) return months + (months == 1 ? " month ago" : " months ago");
        return (days / 365) + " year(s) ago";
    }

    private String getInitials(String username) {
        if (username == null || username.isEmpty()) return "EV";
        String[] parts = username.trim().split("\\s+");
        if (parts.length >= 2) {
            return ("" + parts[0].charAt(0) + parts[1].charAt(0)).toUpperCase();
        }
        return username.substring(0, Math.min(2, username.length())).toUpperCase();
    }

    private String getGradient(String type) {
        if ("memory_uploads".equals(type)) return "linear-gradient(135deg, #667eea 0%, #764ba2 100%)";
        if ("comments_reactions".equals(type)) return "linear-gradient(135deg, #f093fb 0%, #f5576c 100%)";
        if ("group_announcements".equals(type)) return "linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)";
        if ("event_updates".equals(type)) return "linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)";
        if ("group_invites".equals(type)) return "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)";
        if ("memory_recaps".equals(type)) return "linear-gradient(135deg, #fa709a 0%, #fee140 100%)";
        if ("group_member_joined".equals(type)) return "linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)";
        if ("group_memory_edited".equals(type)) return "linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)";
        return "linear-gradient(135deg, #9A74D8 0%, #c4a7e7 100%)";
    }

    private String getTypeIcon(String type) {
        if ("memory_uploads".equals(type)) return "&#128248;";
        if ("comments_reactions".equals(type)) return "&#128172;";
        if ("group_announcements".equals(type)) return "&#128227;";
        if ("event_updates".equals(type)) return "&#128197;";
        if ("group_invites".equals(type)) return "&#128101;";
        if ("memory_recaps".equals(type)) return "&#128247;";
        if ("group_member_joined".equals(type)) return "&#128100;";
        if ("group_memory_edited".equals(type)) return "&#9998;";
        return "&#128276;";
    }

    private String getTypeLabel(String type) {
        if ("memory_uploads".equals(type)) return "Memory";
        if ("comments_reactions".equals(type)) return "Social";
        if ("group_announcements".equals(type)) return "Group";
        if ("event_updates".equals(type)) return "Event";
        if ("group_invites".equals(type)) return "Invite";
        if ("memory_recaps".equals(type)) return "Recap";
        if ("group_member_joined".equals(type)) return "Member";
        if ("group_memory_edited".equals(type)) return "Memory";
        return "Notification";
    }
}
