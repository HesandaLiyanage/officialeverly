package com.demo.web.dto.Memory;

import javax.servlet.http.Part;
import java.util.Collection;

/**
 * Data Transfer Object for creating a new memory.
 * Carries data from the Controller layer to the Service layer.
 */
public class MemoryCreateRequest {
    private int userId;
    private String memoryName;
    private String memoryDate;
    private boolean isCollaborative;
    private Integer groupId;
    private Collection<Part> mediaFiles;

    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMemoryName() {
        return memoryName;
    }

    public void setMemoryName(String memoryName) {
        this.memoryName = memoryName;
    }

    public String getMemoryDate() {
        return memoryDate;
    }

    public void setMemoryDate(String memoryDate) {
        this.memoryDate = memoryDate;
    }

    public boolean isCollaborative() {
        return isCollaborative;
    }

    public void setCollaborative(boolean collaborative) {
        isCollaborative = collaborative;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Collection<Part> getMediaFiles() {
        return mediaFiles;
    }

    public void setMediaFiles(Collection<Part> mediaFiles) {
        this.mediaFiles = mediaFiles;
    }
}
