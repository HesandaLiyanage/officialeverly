package com.demo.web.dto.Notifications;

public class NotificationsListPostResponse { private boolean success; private String errorMessage; private int statusCode = 200; public boolean isSuccess() { return success; } public void setSuccess(boolean success) { this.success = success; } public String getErrorMessage() { return errorMessage; } public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; } public int getStatusCode() { return statusCode; } public void setStatusCode(int statusCode) { this.statusCode = statusCode; } }
