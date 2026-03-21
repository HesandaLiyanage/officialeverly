package com.demo.web.dto.Memory;

public class MemoryDeleteRequest {
    private int memoryId;
    private int userId;

    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}
