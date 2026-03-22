package com.demo.web.dto.Groups;

public class GroupInviteLinkResponse {
    private int statusCode;
    private String jsonResponse;

    public GroupInviteLinkResponse(int statusCode, String jsonResponse) {
        this.statusCode = statusCode;
        this.jsonResponse = jsonResponse;
    }

    public int getStatusCode() { return statusCode; }
    public String getJsonResponse() { return jsonResponse; }
}
