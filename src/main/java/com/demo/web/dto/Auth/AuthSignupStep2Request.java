package com.demo.web.dto.Auth;

public class AuthSignupStep2Request { private String email; private String password; private String name; private String bio; public AuthSignupStep2Request(String email, String password, String name, String bio) { this.email = email; this.password = password; this.name = name; this.bio = bio; } public String getEmail() { return email; } public String getPassword() { return password; } public String getName() { return name; } public String getBio() { return bio; } }
