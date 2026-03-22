package com.demo.web.dto.Settings;

public class SettingsDeactivateResponse { private boolean success; private String errorMessage; private String redirectUrl; public boolean isSuccess() { return success; } public void setSuccess(boolean success) { this.success = success; } public String getErrorMessage() { return errorMessage; } public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; } public String getRedirectUrl() { return redirectUrl; } public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; } }
