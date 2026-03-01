package com.demo.web.dao;

import com.demo.web.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DAO for event voting (RSVP) functionality.
 * Supports going / not_going / maybe votes per event per group per user.
 */
public class EventVoteDAO {

    /**
     * Cast or update a vote. Uses UPSERT (INSERT ON CONFLICT UPDATE).
     * Each user can only have ONE vote per event+group.
     */
    public boolean castVote(int eventId, int groupId, int userId, String vote) {
        String sql = "INSERT INTO event_vote (event_id, group_id, user_id, vote, voted_at) " +
                "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                "ON CONFLICT (event_id, group_id, user_id) " +
                "DO UPDATE SET vote = EXCLUDED.vote, voted_at = CURRENT_TIMESTAMP";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            stmt.setInt(3, userId);
            stmt.setString(4, vote);
            int rows = stmt.executeUpdate();
            System.out.println("[EventVoteDAO] castVote: eventId=" + eventId + ", groupId=" + groupId +
                    ", userId=" + userId + ", vote=" + vote + ", rows=" + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in castVote: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Remove a user's vote (un-vote).
     */
    public boolean removeVote(int eventId, int groupId, int userId) {
        String sql = "DELETE FROM event_vote WHERE event_id = ? AND group_id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in removeVote: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get the current user's vote for a specific event+group.
     * Returns null if not voted.
     */
    public String getUserVote(int eventId, int groupId, int userId) {
        String sql = "SELECT vote FROM event_vote WHERE event_id = ? AND group_id = ? AND user_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            stmt.setInt(3, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("vote");
            }
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in getUserVote: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get vote counts for a specific event+group.
     * Returns map: { "going": 5, "not_going": 2, "maybe": 3, "total": 10 }
     */
    public Map<String, Integer> getVoteCounts(int eventId, int groupId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("going", 0);
        counts.put("not_going", 0);
        counts.put("maybe", 0);
        counts.put("total", 0);

        String sql = "SELECT vote, COUNT(*) as cnt FROM event_vote " +
                "WHERE event_id = ? AND group_id = ? GROUP BY vote";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            ResultSet rs = stmt.executeQuery();
            int total = 0;
            while (rs.next()) {
                String vote = rs.getString("vote");
                int cnt = rs.getInt("cnt");
                counts.put(vote, cnt);
                total += cnt;
            }
            counts.put("total", total);
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in getVoteCounts: " + e.getMessage());
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Get all voters for a specific event+group, including their usernames and
     * profile pics.
     * Returns list of maps: { "user_id", "username", "profile_picture_url", "vote",
     * "voted_at" }
     */
    public List<Map<String, Object>> getVoters(int eventId, int groupId) {
        List<Map<String, Object>> voters = new ArrayList<>();
        String sql = "SELECT ev.user_id, ev.vote, ev.voted_at, u.username, u.profile_picture_url " +
                "FROM event_vote ev " +
                "JOIN users u ON ev.user_id = u.user_id " +
                "WHERE ev.event_id = ? AND ev.group_id = ? " +
                "ORDER BY ev.voted_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> voter = new HashMap<>();
                voter.put("user_id", rs.getInt("user_id"));
                voter.put("username", rs.getString("username"));
                voter.put("profile_picture_url", rs.getString("profile_picture_url"));
                voter.put("vote", rs.getString("vote"));
                voter.put("voted_at", rs.getTimestamp("voted_at"));
                voters.add(voter);
            }
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in getVoters: " + e.getMessage());
            e.printStackTrace();
        }
        return voters;
    }

    /**
     * Get voters filtered by vote type for a specific event+group.
     */
    public List<Map<String, Object>> getVotersByType(int eventId, int groupId, String voteType) {
        List<Map<String, Object>> voters = new ArrayList<>();
        String sql = "SELECT ev.user_id, ev.vote, ev.voted_at, u.username, u.profile_picture_url " +
                "FROM event_vote ev " +
                "JOIN users u ON ev.user_id = u.user_id " +
                "WHERE ev.event_id = ? AND ev.group_id = ? AND ev.vote = ? " +
                "ORDER BY ev.voted_at DESC";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, groupId);
            stmt.setString(3, voteType);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> voter = new HashMap<>();
                voter.put("user_id", rs.getInt("user_id"));
                voter.put("username", rs.getString("username"));
                voter.put("profile_picture_url", rs.getString("profile_picture_url"));
                voter.put("vote", rs.getString("vote"));
                voter.put("voted_at", rs.getTimestamp("voted_at"));
                voters.add(voter);
            }
        } catch (SQLException e) {
            System.err.println("[EventVoteDAO] Error in getVotersByType: " + e.getMessage());
            e.printStackTrace();
        }
        return voters;
    }
}
