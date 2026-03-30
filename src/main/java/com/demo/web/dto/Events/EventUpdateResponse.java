package com.demo.web.dto.Events;

public class EventUpdateResponse { private boolean success; private String eventIdStr; private String errorMessage; public boolean isSuccess() { return success; } public void setSuccess(boolean success) { this.success = success; } public String getEventIdStr() { return eventIdStr; } public void setEventIdStr(String eventIdStr) { this.eventIdStr = eventIdStr; } public String getErrorMessage() { return errorMessage; } public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; } }
