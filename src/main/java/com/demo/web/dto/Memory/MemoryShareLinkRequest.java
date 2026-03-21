package com.demo.web.dto.Memory;

public class MemoryShareLinkRequest {
    private int memoryId;
    private int userId;
    private boolean generateNew;
    private boolean revoke;

    public int getMemoryId() { return memoryId; }
    public void setMemoryId(int memoryId) { this.memoryId = memoryId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public boolean isGenerateNew() { return generateNew; }
    public void setGenerateNew(boolean generateNew) { this.generateNew = generateNew; }
    public boolean isRevoke() { return revoke; }
    public void setRevoke(boolean revoke) { this.revoke = revoke; }
}
