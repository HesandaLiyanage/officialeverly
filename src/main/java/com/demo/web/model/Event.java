package com.demo.web.model;

import java.sql.Timestamp;

public class Event {
    private int eventId;
    private String name;
    private Timestamp eventDate;
    private Group group; // associated group

    // Default constructor
    public Event() {
    }

    // Constructor with parameters
    public Event(int eventId, String name, Timestamp eventDate, Group group) {
        this.eventId = eventId;
        this.name = name;
        this.eventDate = eventDate;
        this.group = group;
    }

    // Getters and Setters
    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Timestamp getEventDate() {
        return eventDate;
    }

    public void setEventDate(Timestamp eventDate) {
        this.eventDate = eventDate;
    }

    public Group getGroup() {
        return group;
    }

    public void setGroup(Group group) {
        this.group = group;
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventId=" + eventId +
                ", name='" + name + '\'' +
                ", eventDate=" + eventDate +
                ", group=" + group +
                '}';
    }
}
