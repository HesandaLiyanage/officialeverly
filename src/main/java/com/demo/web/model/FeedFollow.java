package com.demo.web.model;

import java.sql.Timestamp;

/**
 * Model class for Feed Follow relationships.
 * Represents a follower/following relationship between two feed profiles.
 */
public class FeedFollow {
    private int followId;
    private int followerId;
    private int followingId;
    private Timestamp createdAt;

    // Transient fields for display (populated by DAO joins)
    private FeedProfile follower;
    private FeedProfile following;

    // Default constructor
    public FeedFollow() {
    }

    // Constructor with essential fields
    public FeedFollow(int followerId, int followingId) {
        this.followerId = followerId;
        this.followingId = followingId;
    }

    // Getters and Setters
    public int getFollowId() {
        return followId;
    }

    public void setFollowId(int followId) {
        this.followId = followId;
    }

    public int getFollowerId() {
        return followerId;
    }

    public void setFollowerId(int followerId) {
        this.followerId = followerId;
    }

    public int getFollowingId() {
        return followingId;
    }

    public void setFollowingId(int followingId) {
        this.followingId = followingId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public FeedProfile getFollower() {
        return follower;
    }

    public void setFollower(FeedProfile follower) {
        this.follower = follower;
    }

    public FeedProfile getFollowing() {
        return following;
    }

    public void setFollowing(FeedProfile following) {
        this.following = following;
    }

    @Override
    public String toString() {
        return "FeedFollow{" +
                "followId=" + followId +
                ", followerId=" + followerId +
                ", followingId=" + followingId +
                ", createdAt=" + createdAt +
                '}';
    }
}
