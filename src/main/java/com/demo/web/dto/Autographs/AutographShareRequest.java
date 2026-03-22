package com.demo.web.dto.Autographs;

public class AutographShareRequest { private Integer userId; private String autographIdStr; public AutographShareRequest(Integer userId, String autographIdStr) { this.userId = userId; this.autographIdStr = autographIdStr; } public Integer getUserId() { return userId; } public String getAutographIdStr() { return autographIdStr; } }
