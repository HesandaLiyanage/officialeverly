package com.demo.web.dto.Memory;

import com.demo.web.model.Groups.Group;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.Memory;
import java.util.List;

public class MemoryEditResponse {
    private Memory memory;
    private List<MediaItem> mediaItems;
    private Group group;
    private boolean isGroupMemory;
    private boolean canEdit;
    private String errorMessage;
    private Integer redirectGroupId; // Set if need to redirect

    public Memory getMemory() { return memory; }
    public void setMemory(Memory memory) { this.memory = memory; }
    public List<MediaItem> getMediaItems() { return mediaItems; }
    public void setMediaItems(List<MediaItem> mediaItems) { this.mediaItems = mediaItems; }
    public Group getGroup() { return group; }
    public void setGroup(Group group) { this.group = group; }
    public boolean isGroupMemory() { return isGroupMemory; }
    public void setGroupMemory(boolean groupMemory) { isGroupMemory = groupMemory; }
    public boolean isCanEdit() { return canEdit; }
    public void setCanEdit(boolean canEdit) { this.canEdit = canEdit; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
    public Integer getRedirectGroupId() { return redirectGroupId; }
    public void setRedirectGroupId(Integer redirectGroupId) { this.redirectGroupId = redirectGroupId; }
}
