package com.demo.web.dto.Settings;

public class SettingsSharedLinksRequest { private Integer userId; private String action; private String idStr; public SettingsSharedLinksRequest(Integer userId, String action, String idStr) { this.userId = userId; this.action = action; this.idStr = idStr; } public Integer getUserId() { return userId; } public String getAction() { return action; } public String getIdStr() { return idStr; } }
