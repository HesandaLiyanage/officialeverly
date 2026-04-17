package com.demo.web.dto.Events;

public class EventInfoRequest {
  private int userId;
  private String eventIdParam;
  private String groupIdParam;
  public EventInfoRequest(int userId, String eventIdParam, String groupIdParam) {
    this.userId = userId; this.eventIdParam = eventIdParam; this.groupIdParam = groupIdParam; }
  public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
  public String getEventIdParam() { return eventIdParam; }
  public void setEventIdParam(String eventIdParam) { this.eventIdParam = eventIdParam; }
  public String getGroupIdParam() { return groupIdParam; }
  public void setGroupIdParam(String groupIdParam) { this.groupIdParam = groupIdParam; } }
