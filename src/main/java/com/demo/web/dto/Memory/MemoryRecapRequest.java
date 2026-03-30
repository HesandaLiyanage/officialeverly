package com.demo.web.dto.Memory;

public class MemoryRecapRequest {
    private int userId;
    private String contextPath;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getContextPath() { return contextPath; }
    public void setContextPath(String contextPath) { this.contextPath = contextPath; }
}
