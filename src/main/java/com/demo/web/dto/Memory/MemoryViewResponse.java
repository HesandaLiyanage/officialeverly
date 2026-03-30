package com.demo.web.dto.Memory;

import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.MemoryMember;
import com.demo.web.model.Groups.Group;
import java.util.List;

public class MemoryViewResponse {
    private boolean success;
    private String errorMessage;
    private int statusCode;
    
    private Memory memory;
    private List<MediaItem> mediaItems;
    private List<MemoryMember> collaborators;
    private boolean isOwner;
    
    private Group group;
    private boolean canEdit;
    private String userRole;
    private boolean isAdmin;
    private boolean isGroupMemory;
    
    public static MemoryViewResponse error(String errorMessage, int statusCode) {
        MemoryViewResponse response = new MemoryViewResponse();
        response.setSuccess(false);
        response.setErrorMessage(errorMessage);
        response.setStatusCode(statusCode);
        return response;
    }

    public static MemoryViewResponse success(Memory memory, List<MediaItem> mediaItems, List<MemoryMember> collaborators, boolean isOwner) {
        MemoryViewResponse response = new MemoryViewResponse();
        response.setSuccess(true);
        response.setMemory(memory);
        response.setMediaItems(mediaItems);
        response.setCollaborators(collaborators);
        response.setOwner(isOwner);
        response.setStatusCode(200);
        return response;
    }

    // Getters and Setters
    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public int getStatusCode() { return statusCode; }
    public void setStatusCode(int statusCode) { this.statusCode = statusCode; }
    public Memory getMemory() { return memory; }
    public void setMemory(Memory memory) { this.memory = memory; }
    public List<MediaItem> getMediaItems() { return mediaItems; }
    public void setMediaItems(List<MediaItem> mediaItems) { this.mediaItems = mediaItems; }
    public List<MemoryMember> getCollaborators() { return collaborators; }
    public void setCollaborators(List<MemoryMember> collaborators) { this.collaborators = collaborators; }
    public boolean isOwner() { return isOwner; }
    public void setOwner(boolean owner) { this.isOwner = owner; }
    
    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public boolean isCanEdit() { return canEdit; }
    public void setCanEdit(boolean canEdit) { this.canEdit = canEdit; }
    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { this.isAdmin = admin; }
    public boolean isGroupMemory() { return isGroupMemory; }
    public void setGroupMemory(boolean groupMemory) { this.isGroupMemory = groupMemory; }
}
