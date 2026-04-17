package com.demo.web.dto.Memory;

import javax.servlet.http.Part;
import java.util.Collection;

public class MemoryUpdateRequest {
    private int memoryId;
    private int userId;
    private String title;
    private String description;
    
    private String[] removedMediaIds;
    private Collection<Part> newMediaFiles;
    private String applicationPath;
    
    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String[] getRemovedMediaIds() { return removedMediaIds; }
    public void setRemovedMediaIds(String[] removedMediaIds) { this.removedMediaIds = removedMediaIds; }
    public Collection<Part> getNewMediaFiles() { return newMediaFiles; }
    public void setNewMediaFiles(Collection<Part> newMediaFiles) { this.newMediaFiles = newMediaFiles; }
    public String getApplicationPath() { return applicationPath; }
    public void setApplicationPath(String applicationPath) { this.applicationPath = applicationPath; }
}
