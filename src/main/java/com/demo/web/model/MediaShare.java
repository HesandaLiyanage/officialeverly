package com.demo.web.model;

import java.sql.Timestamp;

public class MediaShare {
    public static final String SHARE_TYPE_PUBLIC = "PUBLIC";
    public static final String SHARE_TYPE_LINK = "LINK";
    public static final String SHARE_TYPE_GROUP = "GROUP";

    private int shareId;
    private int mediaId;
    private String shareType;
    private String shareKey;
    private Timestamp expiresAt;
    private Timestamp createdAt;

    public MediaShare() {}

    public MediaShare(int mediaId, String shareType) {
        this.mediaId = mediaId;
        this.shareType = shareType;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Getters and Setters
    public int getShareId() { return shareId; }
    public void setShareId(int shareId) { this.shareId = shareId; }

    public int getMediaId() { return mediaId; }
    public void setMediaId(int mediaId) { this.mediaId = mediaId; }

    public String getShareType() { return shareType; }
    public void setShareType(String shareType) { this.shareType = shareType; }

    public String getShareKey() { return shareKey; }
    public void setShareKey(String shareKey) { this.shareKey = shareKey; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}