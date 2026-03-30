package com.demo.web.dto.Auth;

public class AuthLoginRequest { private String username; private String password; private String rememberMe; private String deactivated; public AuthLoginRequest(String username, String password, String rememberMe, String deactivated) { this.username = username; this.password = password; this.rememberMe = rememberMe; this.deactivated = deactivated; } public String getUsername() { return username; } public String getPassword() { return password; } public String getRememberMe() { return rememberMe; } public String getDeactivated() { return deactivated; } }
