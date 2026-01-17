package com.demo.web.model;

import java.sql.Timestamp;

public class AutographEntry {
    private int entryId;
    private int autographId;
    private int userId; // 0 for anonymous
    private String content;
    private String decorations;
    private Timestamp submittedAt;

    public int getEntryId() {
        return entryId;
    }

    public void setEntryId(int entryId) {
        this.entryId = entryId;
    }

    public int getAutographId() {
        return autographId;
    }

    public void setAutographId(int autographId) {
        this.autographId = autographId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getDecorations() {
        return decorations;
    }

    public void setDecorations(String decorations) {
        this.decorations = decorations;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
}
