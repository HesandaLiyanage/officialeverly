package com.demo.web.dto.Auth;

public class AuthSignupStep1Request { private String email; private String password; private String confirmPassword; private String terms; public AuthSignupStep1Request(String email, String password, String confirmPassword, String terms) { this.email = email; this.password = password; this.confirmPassword = confirmPassword; this.terms = terms; } public String getEmail() { return email; } public String getPassword() { return password; } public String getConfirmPassword() { return confirmPassword; } public String getTerms() { return terms; } }
