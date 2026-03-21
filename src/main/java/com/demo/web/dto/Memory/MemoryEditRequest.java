package com.demo.web.dto.Memory;

public class MemoryEditRequest {
    private int userId;
    private int memoryId;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }
}
