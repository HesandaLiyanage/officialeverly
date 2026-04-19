package com.demo.web.dto.Journals;

import com.demo.web.model.Journals.Journal;

import java.util.List;
import java.util.Map;

public class JournalDashboardResponse {
    private String error;
    private List<Journal> journals;
    private int totalCount;
    private int thisMonthCount;
    private int streakDays;
    private int longestStreak;
    private Map<Integer, Integer> wordCounts;

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public List<Journal> getJournals() {
        return journals;
    }

    public void setJournals(List<Journal> journals) {
        this.journals = journals;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getStreakDays() {
        return streakDays;
    }

    public void setStreakDays(int streakDays) {
        this.streakDays = streakDays;
    }

    public int getThisMonthCount() {
        return thisMonthCount;
    }

    public void setThisMonthCount(int thisMonthCount) {
        this.thisMonthCount = thisMonthCount;
    }

    public int getLongestStreak() {
        return longestStreak;
    }

    public void setLongestStreak(int longestStreak) {
        this.longestStreak = longestStreak;
    }

    public Map<Integer, Integer> getWordCounts() {
        return wordCounts;
    }

    public void setWordCounts(Map<Integer, Integer> wordCounts) {
        this.wordCounts = wordCounts;
    }
}
