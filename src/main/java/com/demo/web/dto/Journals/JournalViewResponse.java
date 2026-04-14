package com.demo.web.dto.Journals;

import com.demo.web.model.Journals.Journal;

public class JournalViewResponse {

    private boolean success;
    private String errorMessage;
    private Journal journal;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Journal getJournal() {
        return journal;
    }

    public void setJournal(Journal journal) {
        this.journal = journal;
    }
}
