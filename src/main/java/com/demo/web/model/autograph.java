package com.demo.web.model;

import java.sql.Timestamp;

public class autograph {
    private int autograph_id;
    private String a_title;
    private String a_description;
    private Timestamp created_at;
    private int user_id;

    // Default constructor
    public autograph() {
    }

    // Getters and Setters
    public int getAutographId() {
        return autograph_id;
    }

    public void setAutographId(int autograph_id) {
        this.autograph_id = autograph_id;
    }

    public String getTitle() {
        return a_title;
    }

    public void setTitle(String a_title) {
        this.a_title = a_title;
    }

    public String getDescription() {
        return a_description;
    }

    public void setDescription(String a_description) {
        this.a_description = a_description;
    }

    public Timestamp getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(Timestamp created_at) {
        this.created_at = created_at;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }

    // Optional: toString method for debugging
    @Override
    public String toString() {
        return "autograph{" +
                "autograph_id=" + autograph_id +
                ", title='" + a_title + '\'' +
                ", description='" + a_description + '\'' +
                ", created_at=" + created_at +
                ", user_id=" + user_id +
                '}';
    }
}
