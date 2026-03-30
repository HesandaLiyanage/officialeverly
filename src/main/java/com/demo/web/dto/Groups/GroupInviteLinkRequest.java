package com.demo.web.dto.Groups;

public class GroupInviteLinkRequest {
    private Integer userId;
    private String groupIdStr;
    private String serverUrlBase;

    public GroupInviteLinkRequest(Integer userId, String groupIdStr, String serverUrlBase) {
        this.userId = userId;
        this.groupIdStr = groupIdStr;
        this.serverUrlBase = serverUrlBase;
    }

    public Integer getUserId() { return userId; }
    public String getGroupIdStr() { return groupIdStr; }
    public String getServerUrlBase() { return serverUrlBase; }
}
