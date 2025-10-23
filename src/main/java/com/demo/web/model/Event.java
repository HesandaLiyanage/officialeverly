package com.demo.web.model;

import java.sql.Timestamp;

public class Event {
    private int eventId;          // Maps to 'event_id' in DB
    private String title;          // Maps to 'e_title' in DB
    private String description;    // Maps to 'e_description' in DB
    private Timestamp eventDate;   // Maps to 'e_date' in DB
    private Timestamp createdAt;   // Maps to 'created_at' in DB
    private int groupId;           // Maps to 'group_id' in DB
    private String eventPicUrl;    // Maps to 'event_pic' in DB

    // Default constructor
    public Event() {
    }

    // Constructor with parameters
    public Event(int eventId, String title, String description, Timestamp eventDate,
                 Timestamp createdAt, int groupId, String eventPicUrl) {
        this.eventId = eventId;
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.createdAt = createdAt;
        this.groupId = groupId;
        this.eventPicUrl = eventPicUrl;
    }

    // Getters and Setters
    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getEventDate() {
        return eventDate;
    }

    public void setEventDate(Timestamp eventDate) {
        this.eventDate = eventDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getEventPicUrl() {
        return eventPicUrl;
    }

    public void setEventPicUrl(String eventPicUrl) {
        this.eventPicUrl = eventPicUrl;
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventId=" + eventId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", eventDate=" + eventDate +
                ", createdAt=" + createdAt +
                ", groupId=" + groupId +
                ", eventPicUrl='" + eventPicUrl + '\'' +
                '}';
    }
}