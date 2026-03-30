package com.demo.web.dto.Auth;

public class AuthGoogleCallbackRequest { private String code; private String receivedState; private String storedState; public AuthGoogleCallbackRequest(String code, String receivedState, String storedState) { this.code = code; this.receivedState = receivedState; this.storedState = storedState; } public String getCode() { return code; } public String getReceivedState() { return receivedState; } public String getStoredState() { return storedState; } }
