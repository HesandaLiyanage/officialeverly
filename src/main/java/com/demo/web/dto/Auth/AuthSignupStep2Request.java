package com.demo.web.dto.Auth;

public class AuthSignupStep2Request {
    private final String email;
    private final String password;
    private final String confirmPassword;
    private final String name;
    private final String bio;

    public AuthSignupStep2Request(String email, String password, String confirmPassword, String name, String bio) {
        this.email = email;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.name = name;
        this.bio = bio;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public String getName() {
        return name;
    }

    public String getBio() {
        return bio;
    }
}
