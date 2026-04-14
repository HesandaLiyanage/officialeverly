package com.demo.web.dto.Journals;

public class JournalDashboardRequest {
  private Integer userId;

  public JournalDashboardRequest(Integer userId) {
    this.userId = userId;
  }

  public Integer getUserId() {
    return userId;
  }
}
