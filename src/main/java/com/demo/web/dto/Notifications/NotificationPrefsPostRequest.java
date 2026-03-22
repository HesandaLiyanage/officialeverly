package com.demo.web.dto.Notifications;

public class NotificationPrefsPostRequest { private Integer userId; private String notifType; private String enabledStr; public NotificationPrefsPostRequest(Integer userId, String notifType, String enabledStr) { this.userId = userId; this.notifType = notifType; this.enabledStr = enabledStr; } public Integer getUserId() { return userId; } public String getNotifType() { return notifType; } public String getEnabledStr() { return enabledStr; } }
