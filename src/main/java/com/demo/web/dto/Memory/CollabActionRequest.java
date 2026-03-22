package com.demo.web.dto.Memory;

/**
 * Unified request for collaborative actions (Join, Leave, Remove).
 */
public class CollabActionRequest {
    private int memoryId;
    private int requesterId; // The user making the request
    private Integer targetUserId; // The user being acted upon (if removing someone else)
    private String action; // "JOIN", "LEAVE", "REMOVE"
    private String shareKey; // Optional: For joining via invite link

    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }
    public int getRequesterId() { return requesterId; }
    public void setRequesterId(int requesterId) { this.requesterId = requesterId; }
    public Integer getTargetUserId() { return targetUserId; }
    public void setTargetUserId(Integer targetUserId) { this.targetUserId = targetUserId; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
    public String getShareKey() { return shareKey; }
    public void setShareKey(String shareKey) { this.shareKey = shareKey; }
}
