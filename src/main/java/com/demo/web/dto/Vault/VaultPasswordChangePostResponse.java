package com.demo.web.dto.Vault;

public class VaultPasswordChangePostResponse { private boolean success; private String errorMessage; private String successMessage; public boolean isSuccess() { return success; } public void setSuccess(boolean success) { this.success = success; } public String getErrorMessage() { return errorMessage; } public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; } public String getSuccessMessage() { return successMessage; } public void setSuccessMessage(String successMessage) { this.successMessage = successMessage; } }
