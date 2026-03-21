package com.demo.web.dto.Journals;

public class JournalDashboardRequest { private Integer userId; private String action; private String idParam; public JournalDashboardRequest(Integer userId, String action, String idParam) { this.userId = userId; this.action = action; this.idParam = idParam; } public Integer getUserId() { return userId; } public String getAction() { return action; } public String getIdParam() { return idParam; } }
