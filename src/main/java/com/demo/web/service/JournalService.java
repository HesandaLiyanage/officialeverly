package com.demo.web.service;

import com.demo.web.dao.JournalDAO;
import com.demo.web.dao.JournalStreakDAO;
import com.demo.web.model.Journal;
import com.demo.web.model.JournalStreak;

import java.util.List;

/**
 * Service for journal operations.
 * Extracted from FrontControllerServlet.JournalListLogicHandler,
 * JournalViewLogicHandler, and EditJournalLogicHandler
 */
public class JournalService {

    private JournalDAO journalDAO;
    private JournalStreakDAO streakDAO;

    public JournalService() {
        this.journalDAO = new JournalDAO();
        this.streakDAO = new JournalStreakDAO();
    }

    /**
     * Gets all journals for a user.
     * 
     * @param userId The user ID
     * @return List of journals
     */
    public List<Journal> getJournalsByUserId(int userId) {
        return journalDAO.findByUserId(userId);
    }

    /**
     * Gets a journal by ID with ownership verification.
     * 
     * @param journalId The journal ID
     * @param userId    The user ID for ownership check
     * @return The journal if found and owned by user, null otherwise
     */
    public Journal getJournalById(int journalId, int userId) {
        Journal result = journalDAO.findById(journalId);

        // Verify ownership
        if (result == null || result.getUserId() != userId) {
            return null;
        }

        return result;
    }

    /**
     * Gets the total journal count for a user.
     * 
     * @param userId The user ID
     * @return The total count
     */
    public int getJournalCount(int userId) {
        return journalDAO.getJournalCount(userId);
    }

    /**
     * Gets streak information for a user.
     * Also checks and updates streak status (in case user missed a day).
     * 
     * @param userId The user ID
     * @return The JournalStreak object, may be null if never journaled
     */
    public JournalStreak getStreakInfo(int userId) {
        // Check and update streak status first
        streakDAO.checkAndUpdateStreakStatus(userId);
        return streakDAO.getStreakByUserId(userId);
    }

    /**
     * Gets current streak days for a user.
     * 
     * @param userId The user ID
     * @return Current streak days, 0 if no streak
     */
    public int getCurrentStreakDays(int userId) {
        JournalStreak streak = getStreakInfo(userId);
        return streak != null ? streak.getCurrentStreak() : 0;
    }

    /**
     * Gets longest streak days for a user.
     * 
     * @param userId The user ID
     * @return Longest streak days, 0 if no streak
     */
    public int getLongestStreakDays(int userId) {
        JournalStreak streak = getStreakInfo(userId);
        return streak != null ? streak.getLongestStreak() : 0;
    }
}
