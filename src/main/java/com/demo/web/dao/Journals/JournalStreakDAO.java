package com.demo.web.dao.Journals;

import com.demo.web.model.Journals.JournalStreak;
import com.demo.web.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class JournalStreakDAO {

    public JournalStreak getStreakByUserId(int userId) {
        String sql = "SELECT * FROM journal_streaks WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStreak(rs);
            } else {
                return createStreakForUser(userId);
            }

        } catch (SQLException e) {
            System.err.println("Error getting streak for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public JournalStreak createStreakForUser(int userId) {
        String sql = "INSERT INTO journal_streaks (user_id, current_streak, longest_streak) " +
                "VALUES (?, 0, 0) RETURNING *";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                System.out.println("Created new streak record for user " + userId);
                return mapResultSetToStreak(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error creating streak for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStreakOnNewEntry(int userId, Date entryDate) {
        JournalStreak streak = getStreakByUserId(userId);

        if (streak == null) {
            streak = createStreakForUser(userId);
            if (streak == null) return false;
        }

        LocalDate todayDate = entryDate.toLocalDate();
        Date lastEntryDate = streak.getLastEntryDate();

        int newCurrentStreak = streak.getCurrentStreak();

        if (lastEntryDate == null) {
            newCurrentStreak = 1;
        } else {
            LocalDate lastDate = lastEntryDate.toLocalDate();
            long daysBetween = ChronoUnit.DAYS.between(lastDate, todayDate);

            if (daysBetween == 0) {
                return true;
            } else if (daysBetween == 1) {
                newCurrentStreak = streak.getCurrentStreak() + 1;
            } else if (daysBetween > 1) {
                newCurrentStreak = 1;
            }
        }

        int newLongestStreak = Math.max(streak.getLongestStreak(), newCurrentStreak);

        return updateStreak(userId, newCurrentStreak, newLongestStreak, entryDate);
    }

    private boolean updateStreak(int userId, int currentStreak, int longestStreak, Date lastEntryDate) {
        String sql = "UPDATE journal_streaks " +
                "SET current_streak = ?, longest_streak = ?, last_entry_date = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, currentStreak);
            pstmt.setInt(2, longestStreak);
            pstmt.setDate(3, lastEntryDate);
            pstmt.setInt(4, userId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("Updated streak for user " + userId +
                        ": current=" + currentStreak +
                        ", longest=" + longestStreak);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating streak: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public void checkAndUpdateStreakStatus(int userId) {
        JournalStreak streak = getStreakByUserId(userId);

        if (streak == null || streak.getLastEntryDate() == null) {
            return; // No streak to check
        }

        LocalDate today = LocalDate.now();
        LocalDate lastEntry = streak.getLastEntryDate().toLocalDate();
        long daysSinceLastEntry = ChronoUnit.DAYS.between(lastEntry, today);

        if (daysSinceLastEntry > 1 && streak.getCurrentStreak() > 0) {
            System.out.println("Streak broken for user " + userId + ". Resetting to 0.");
            updateStreak(userId, 0, streak.getLongestStreak(), streak.getLastEntryDate());
        }
    }

    public boolean deleteStreak(int userId) {
        String sql = "DELETE FROM journal_streaks WHERE user_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            int rowsAffected = pstmt.executeUpdate();

            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting streak: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetCurrentStreak(int userId) {
        JournalStreak streak = getStreakByUserId(userId);

        if (streak == null) return false;

        return updateStreak(userId, 0, streak.getLongestStreak(), streak.getLastEntryDate());
    }

    private JournalStreak mapResultSetToStreak(ResultSet rs) throws SQLException {
        JournalStreak streak = new JournalStreak();
        streak.setStreakId(rs.getInt("streak_id"));
        streak.setUserId(rs.getInt("user_id"));
        streak.setCurrentStreak(rs.getInt("current_streak"));
        streak.setLongestStreak(rs.getInt("longest_streak"));
        streak.setLastEntryDate(rs.getDate("last_entry_date"));
        streak.setCreatedAt(rs.getTimestamp("created_at"));
        streak.setUpdatedAt(rs.getTimestamp("updated_at"));
        return streak;
    }
}
