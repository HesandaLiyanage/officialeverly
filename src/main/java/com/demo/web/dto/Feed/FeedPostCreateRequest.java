package com.demo.web.dto.Feed;

public class FeedPostCreateRequest {
    private int memoryId;
    private String caption;
    private int userId;
    
    public FeedPostCreateRequest(int memoryId, String caption, int userId) {
        this.memoryId = memoryId;
        this.caption = caption;
        this.userId = userId;
    }

    public int getMemoryId() { return memoryId; }
    public String getCaption() { return caption; }
    public int getUserId() { return userId; }
}
