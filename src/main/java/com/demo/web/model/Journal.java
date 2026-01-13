// File: com/demo/web/model/Journal.java
package com.demo.web.model;

import java.sql.Timestamp;

public class Journal {
    private int journalId;
    private String title;
    private String content;
    private int userId;
    private String journalPic;  // Optional picture for the journal entry

    // 🔻 NEW: Soft-delete fields for Recycle Bin
    private boolean isDeleted;
    private Timestamp deletedAt;
    private Timestamp restoredAt;

    // Constructors
    public Journal() {
        // Default: not deleted
        this.isDeleted = false;
    }

    // Full constructor (including new fields)
    public Journal(int journalId, String title, String content, int userId, String journalPic,
                   boolean isDeleted, Timestamp deletedAt, Timestamp restoredAt) {
        this.journalId = journalId;
        this.title = title;
        this.content = content;
        this.userId = userId;
        this.journalPic = journalPic;
        this.isDeleted = isDeleted;
        this.deletedAt = deletedAt;
        this.restoredAt = restoredAt;
    }

    // Getters and Setters for existing fields (unchanged)
    public int getJournalId() { return journalId; }
    public void setJournalId(int journalId) { this.journalId = journalId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getJournalPic() { return journalPic; }
    public void setJournalPic(String journalPic) { this.journalPic = journalPic; }

    // 🔻 NEW: Getters and Setters for soft-delete fields
    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public Timestamp getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Timestamp deletedAt) {
        this.deletedAt = deletedAt;
    }

    public Timestamp getRestoredAt() {
        return restoredAt;
    }

    public void setRestoredAt(Timestamp restoredAt) {
        this.restoredAt = restoredAt;
    }

    @Override
    public String toString() {
        return "Journal{" +
                "journalId=" + journalId +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", userId=" + userId +
                ", journalPic='" + journalPic + '\'' +
                ", isDeleted=" + isDeleted +
                ", deletedAt=" + deletedAt +
                ", restoredAt=" + restoredAt +
                '}';
    }
}