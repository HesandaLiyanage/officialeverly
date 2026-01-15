package com.demo.web.model;

import java.sql.Date;

public class autographEntry {
    private int entryId;
    private String link; // Unique token for this entry
    private String content; // The autograph content/message
    private Date submittedAt;
    private int autographId; // FK to autograph book
    private int userId; // FK to user who submitted

    // Default constructor
    public autographEntry() {
    }

    // Getters and Setters
    public int getEntryId() {
        return entryId;
    }

    public void setEntryId(int entryId) {
        this.entryId = entryId;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Date submittedAt) {
        this.submittedAt = submittedAt;
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

    @Override
    public String toString() {
        return "AutographEntry{" +
                "entryId=" + entryId +
                ", link='" + link + '\'' +
                ", content='" + content + '\'' +
                ", submittedAt=" + submittedAt +
                ", autographId=" + autographId +
                ", userId=" + userId +
                '}';
    }
}
