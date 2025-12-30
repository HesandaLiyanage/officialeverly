package com.demo.web.model;

import java.sql.Date;
import java.sql.Timestamp;

public class JournalStreak {
    private int streakId;
    private int userId;
    private int currentStreak;
    private int longestStreak;
    private Date lastEntryDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public JournalStreak() {
    }

    public JournalStreak(int userId, int currentStreak, int longestStreak, Date lastEntryDate) {
        this.userId = userId;
        this.currentStreak = currentStreak;
        this.longestStreak = longestStreak;
        this.lastEntryDate = lastEntryDate;
    }

    // Getters and Setters
    public int getStreakId() {
        return streakId;
    }

    public void setStreakId(int streakId) {
        this.streakId = streakId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCurrentStreak() {
        return currentStreak;
    }

    public void setCurrentStreak(int currentStreak) {
        this.currentStreak = currentStreak;
    }

    public int getLongestStreak() {
        return longestStreak;
    }

    public void setLongestStreak(int longestStreak) {
        this.longestStreak = longestStreak;
    }

    public Date getLastEntryDate() {
        return lastEntryDate;
    }

    public void setLastEntryDate(Date lastEntryDate) {
        this.lastEntryDate = lastEntryDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "JournalStreak{" +
                "streakId=" + streakId +
                ", userId=" + userId +
                ", currentStreak=" + currentStreak +
                ", longestStreak=" + longestStreak +
                ", lastEntryDate=" + lastEntryDate +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}