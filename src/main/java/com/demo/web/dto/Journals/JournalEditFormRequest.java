package com.demo.web.dto.Journals;

public class JournalEditFormRequest {

    private final Integer userId;
    private final String journalIdParam;

    public JournalEditFormRequest(Integer userId, String journalIdParam) {
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
