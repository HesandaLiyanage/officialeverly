package com.demo.web.model;

import java.sql.Timestamp;

public class user {
    private int user_id;
    private String username;
    private String email;
    private String password;
    private String salt;
    private String bio;
    private String profile_picture_url;
    private boolean is_active;
    private Timestamp joined_at;
    private Timestamp last_login;

    // Default constructor
    public user() {
    }

    // Getters and Setters
    public int getId() {
        return user_id;
    }

    public void setId(int id) {
        this.user_id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getProfilePictureUrl() {
        return profile_picture_url;
    }

    public void setProfilePictureUrl(String profile_picture_url) {
        this.profile_picture_url = profile_picture_url;
    }

    public boolean is_active() {
        return is_active;
    }

    public void set_active(boolean active) {
        is_active = active;
    }

    public Timestamp getCreatedAt() {
        return joined_at;
    }

    public void setCreatedAt(Timestamp joined_at) {
        this.joined_at = joined_at;
    }

    public Timestamp getLastLogin() {
        return last_login;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.last_login = lastLogin;
    }

    private int plan_id;

    public int getPlanId() {
        return plan_id;
    }

    public void setPlanId(int planId) {
        this.plan_id = planId;
    }

    // Optional: toString method for debugging
    @Override
    public String toString() {
        return "user{" +
                "id=" + user_id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", bio='" + bio + '\'' +
                ", profilePictureUrl='" + profile_picture_url + '\'' +
                ", isActive=" + is_active +
                ", createdAt=" + joined_at +
                ", lastLogin=" + last_login +
                ", planId=" + plan_id +
                '}';
    }
}