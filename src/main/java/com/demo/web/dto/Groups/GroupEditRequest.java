package com.demo.web.dto.Groups;

import javax.servlet.http.Part;

public class GroupEditRequest {
    private Integer userId;
    private String groupIdStr;
    private String groupName;
    private String groupDescription;
    private String customLink;
    private Part filePart;
    private String contextPath;
    private String applicationPath;

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getGroupIdStr() { return groupIdStr; }
    public void setGroupIdStr(String groupIdStr) { this.groupIdStr = groupIdStr; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public String getGroupDescription() { return groupDescription; }
    public void setGroupDescription(String groupDescription) { this.groupDescription = groupDescription; }
    public String getCustomLink() { return customLink; }
    public void setCustomLink(String customLink) { this.customLink = customLink; }
    public Part getFilePart() { return filePart; }
    public void setFilePart(Part filePart) { this.filePart = filePart; }
    public String getContextPath() { return contextPath; }
    public void setContextPath(String contextPath) { this.contextPath = contextPath; }
    public String getApplicationPath() { return applicationPath; }
    public void setApplicationPath(String applicationPath) { this.applicationPath = applicationPath; }
}
