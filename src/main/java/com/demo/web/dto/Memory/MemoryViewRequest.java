package com.demo.web.dto.Memory;

public class MemoryViewRequest {
    private int memoryId;
    private int userId;
    
    // For collab views or share links
    private String shareToken;

    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getShareToken() { return shareToken; }
    public void setShareToken(String shareToken) { this.shareToken = shareToken; }
}
