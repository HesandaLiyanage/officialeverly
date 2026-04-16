package com.demo.web.dto.Memory;

public class MemoryCreatePageRequest {
    private int userId;

    public MemoryCreatePageRequest() {
    }

    public MemoryCreatePageRequest(int userId) {
        this.userId = userId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
