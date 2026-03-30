package com.demo.web.dto.Notifications;

public class NotificationsListPostRequest { private Integer userId; private String action; private String notificationIdStr; public NotificationsListPostRequest(Integer userId, String action, String notificationIdStr) { this.userId = userId; this.action = action; this.notificationIdStr = notificationIdStr; } public Integer getUserId() { return userId; } public String getAction() { return action; } public String getNotificationIdStr() { return notificationIdStr; } }
