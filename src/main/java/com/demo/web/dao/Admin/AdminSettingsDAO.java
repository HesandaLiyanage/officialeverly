package com.demo.web.dao.Admin;

import com.demo.web.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * Admin settings DAO focused on subscription/storage cap management.
 */
public class AdminSettingsDAO {

    private static final Logger logger = Logger.getLogger(AdminSettingsDAO.class.getName());

    public List<Map<String, Object>> getPlanSummaries() {
        List<Map<String, Object>> plans = new ArrayList<>();

        String sql = """
                SELECT p.plan_id,
                       p.name,
                       p.storage_limit_bytes,
                       p.memory_limit,
                       p.price_monthly,
                       p.max_members,
                       COUNT(u.user_id) AS user_count
                FROM plans p
                LEFT JOIN users u ON u.plan_id = p.plan_id
                GROUP BY p.plan_id, p.name, p.storage_limit_bytes, p.memory_limit, p.price_monthly, p.max_members
                ORDER BY p.plan_id ASC
                """;

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> plan = new HashMap<>();
                long storageBytes = rs.getLong("storage_limit_bytes");
                plan.put("planId", rs.getInt("plan_id"));
                plan.put("name", rs.getString("name"));
                plan.put("storageLimitBytes", storageBytes);
                plan.put("storageLimitGb", bytesToRoundedGb(storageBytes));
                plan.put("memoryLimit", rs.getInt("memory_limit"));
                plan.put("priceMonthly", rs.getDouble("price_monthly"));
                plan.put("maxMembers", rs.getInt("max_members"));
                plan.put("userCount", rs.getInt("user_count"));
                plans.add(plan);
            }
        } catch (SQLException e) {
            logger.severe("[AdminSettingsDAO] Error loading plan summaries: " + e.getMessage());
        }

        return plans;
    }

    public boolean updatePlanLimits(int planId, long storageLimitBytes, int memoryLimit) {
        String sql = "UPDATE plans SET storage_limit_bytes = ?, memory_limit = ? WHERE plan_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, storageLimitBytes);
            stmt.setInt(2, memoryLimit);
            stmt.setInt(3, planId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("[AdminSettingsDAO] Error updating plan limits: " + e.getMessage());
            return false;
        }
    }

    private long bytesToRoundedGb(long bytes) {
        long gb = 1024L * 1024L * 1024L;
        if (bytes <= 0) {
            return 0;
        }
        return Math.max(1, Math.round((double) bytes / gb));
    }
}
