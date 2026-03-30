package com.demo.web.dto.Autographs;

public class AutographDeleteRequest { private Integer userId; private String autographIdStr; public AutographDeleteRequest(Integer userId, String autographIdStr) { this.userId = userId; this.autographIdStr = autographIdStr; } public Integer getUserId() { return userId; } public String getAutographIdStr() { return autographIdStr; } }
