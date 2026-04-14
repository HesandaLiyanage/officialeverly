package com.demo.web.dto.Journals;

public class JournalViewRequest {

    private final Integer userId;
    private final String journalIdParam;

    public JournalViewRequest(Integer userId, String journalIdParam) {
        this.userId = userId;
        this.journalIdParam = journalIdParam;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getJournalIdParam() {
        return journalIdParam;
    }
}
