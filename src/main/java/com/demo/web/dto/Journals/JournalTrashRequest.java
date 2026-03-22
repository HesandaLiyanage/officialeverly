package com.demo.web.dto.Journals;

public class JournalTrashRequest { private Integer userId; private String action; private String recycleBinIdStr; public JournalTrashRequest(Integer userId, String action, String recycleBinIdStr) { this.userId = userId; this.action = action; this.recycleBinIdStr = recycleBinIdStr; } public Integer getUserId() { return userId; } public String getAction() { return action; } public String getRecycleBinIdStr() { return recycleBinIdStr; } }
