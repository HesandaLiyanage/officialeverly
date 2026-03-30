package com.demo.web.dto.Autographs;

public class AutographCreateRequest { private Integer userId; private String title; private String description; private String picUrl; public AutographCreateRequest(Integer userId, String title, String description, String picUrl) { this.userId = userId; this.title = title; this.description = description; this.picUrl = picUrl; } public Integer getUserId() { return userId; } public String getTitle() { return title; } public String getDescription() { return description; } public String getPicUrl() { return picUrl; } }
