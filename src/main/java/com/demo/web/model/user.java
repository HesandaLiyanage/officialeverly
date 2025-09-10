package com.demo.web.model;

import java.sql.Timestamp;

public class user {
    private int id;
    private String username;
    private String email;
    private String password_hash;
    private String salt;
    private boolean is_active;
    private Timestamp created_at;
    private Timestamp last_login;

    // Default constructor
    public user() {}

    // Constructor with essential fields
    public user(String username, String email) {
        this.username = username;
        this.email = email;
        this.is_active = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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
        return password_hash;
    }

    public void setPassword(String passwordHash) {
        this.password_hash = passwordHash;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public boolean isActive() {
        return is_active;
    }

    public void setActive(boolean active) {
        is_active = active;
    }

    public Timestamp getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.created_at = createdAt;
    }

    public Timestamp getLastLogin() {
        return last_login;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.last_login = lastLogin;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", isActive=" + is_active +
                ", createdAt=" + created_at +
                ", lastLogin=" + last_login +
                '}';
    }
}