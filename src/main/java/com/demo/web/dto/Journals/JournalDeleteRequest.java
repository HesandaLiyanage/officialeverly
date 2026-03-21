package com.demo.web.dto.Journals;

public class JournalDeleteRequest { private Integer userId; private String journalIdStr; public JournalDeleteRequest(Integer userId, String journalIdStr) { this.userId = userId; this.journalIdStr = journalIdStr; } public Integer getUserId() { return userId; } public String getJournalIdStr() { return journalIdStr; } }
