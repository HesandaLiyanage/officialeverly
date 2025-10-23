// File: com/demo/web/model/Journal.java
package com.demo.web.model;

public class Journal {
    private int journalId;
    private String title;
    private String content;
    private int userId;
    private String journalPic;  // Optional picture for the journal entry

    // Constructors
    public Journal() {
    }

    public Journal(int journalId, String title, String content, int userId, String journalPic) {
        this.journalId = journalId;
        this.title = title;
        this.content = content;
        this.userId = userId;
        this.journalPic = journalPic;
    }

    // Getters and Setters
    public int getJournalId() {
        return journalId;
    }

    public void setJournalId(int journalId) {
        this.journalId = journalId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getJournalPic() {
        return journalPic;
    }

    public void setJournalPic(String journalPic) {
        this.journalPic = journalPic;
    }

    @Override
    public String toString() {
        return "Journal{" +
                "journalId=" + journalId +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", userId=" + userId +
                ", journalPic='" + journalPic + '\'' +
                '}';
    }
}