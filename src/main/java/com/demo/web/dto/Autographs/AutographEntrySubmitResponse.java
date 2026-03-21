package com.demo.web.dto.Autographs;

public class AutographEntrySubmitResponse { private boolean success; private String message; private int statusCode = 200; public boolean isSuccess() { return success; } public void setSuccess(boolean success) { this.success = success; } public String getMessage() { return message; } public void setMessage(String message) { this.message = message; } public int getStatusCode() { return statusCode; } public void setStatusCode(int statusCode) { this.statusCode = statusCode; } }
