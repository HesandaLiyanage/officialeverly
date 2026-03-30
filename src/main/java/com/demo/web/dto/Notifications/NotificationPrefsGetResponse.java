package com.demo.web.dto.Notifications;

import java.util.Map; public class NotificationPrefsGetResponse { private Map<String, Boolean> prefs; private String redirectUrl; public Map<String, Boolean> getPrefs() { return prefs; } public void setPrefs(Map<String, Boolean> prefs) { this.prefs = prefs; } public String getRedirectUrl() { return redirectUrl; } public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; } }
