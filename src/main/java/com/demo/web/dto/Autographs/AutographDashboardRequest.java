package com.demo.web.dto.Autographs;

public class AutographDashboardRequest { private Integer userId; private String action; private String idParam; public AutographDashboardRequest(Integer userId, String action, String idParam) { this.userId = userId; this.action = action; this.idParam = idParam; } public Integer getUserId() { return userId; } public String getAction() { return action; } public String getIdParam() { return idParam; } }
