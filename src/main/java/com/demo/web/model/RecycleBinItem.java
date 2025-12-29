// File: src/main/java/com/demo/web/model/RecycleBinItem.java
package com.demo.web.model;

import java.sql.Timestamp;

public class RecycleBinItem {
    private int id;
    private int originalId;
    private String itemType;
    private int userId;
    private String title;
    private String content;
    private String metadata; // JSON string
    private Timestamp deletedAt;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOriginalId() { return originalId; }
    public void setOriginalId(int originalId) { this.originalId = originalId; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getMetadata() { return metadata; }
    public void setMetadata(String metadata) { this.metadata = metadata; }

    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
}