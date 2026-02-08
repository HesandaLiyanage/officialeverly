package com.demo.web.model;

import java.util.Date;

public class AutographEntry {
    private int entryId;
    private String link;
    private String content; // Will store the rich HTML (text + emotions + doodles)
    private Date submittedAt;
    private int autographId;
    private int userId;
    private String contentPlain; // Will store just the plain text

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

    public String getContentPlain() {
        return contentPlain;
    }

    public void setContentPlain(String contentPlain) {
        this.contentPlain = contentPlain;
    }
}
