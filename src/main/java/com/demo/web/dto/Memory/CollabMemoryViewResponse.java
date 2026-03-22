package com.demo.web.dto.Memory;

import com.demo.web.model.Memory.Memory;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.MemoryMember;
import java.util.List;

public class CollabMemoryViewResponse {
    private Memory memory;
    private List<MediaItem> mediaItems;
    private List<MemoryMember> members;
    private boolean isOwner;
    private boolean isMember;
    private boolean isCollaborative;
    private String errorMessage;

    public Memory getMemory() { return memory; }
    public void setMemory(Memory memory) { this.memory = memory; }
    public List<MediaItem> getMediaItems() { return mediaItems; }
    public void setMediaItems(List<MediaItem> mediaItems) { this.mediaItems = mediaItems; }
    public List<MemoryMember> getMembers() { return members; }
    public void setMembers(List<MemoryMember> members) { this.members = members; }
    public boolean isOwner() { return isOwner; }
    public void setOwner(boolean owner) { isOwner = owner; }
    public boolean isMember() { return isMember; }
    public void setMember(boolean member) { isMember = member; }
    public boolean isCollaborative() { return isCollaborative; }
    public void setCollaborative(boolean collaborative) { isCollaborative = collaborative; }
    public String getErrorMessage() { return errorMessage; }
    public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
}
