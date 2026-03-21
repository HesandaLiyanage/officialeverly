package com.demo.web.dto.Events;

public class EventEditFormRequest { private int userId; private String eventIdParam; public EventEditFormRequest(int userId, String eventIdParam) { this.userId = userId; this.eventIdParam = eventIdParam; } public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; } public String getEventIdParam() { return eventIdParam; } public void setEventIdParam(String eventIdParam) { this.eventIdParam = eventIdParam; } }
