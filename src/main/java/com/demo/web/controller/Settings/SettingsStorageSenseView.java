package com.demo.web.controller.Settings;

import com.demo.web.dao.Settings.SubscriptionDAO;
import com.demo.web.model.Settings.Plan;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/storagesenseview")
public class SettingsStorageSenseView extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SubscriptionDAO subDAO = new SubscriptionDAO();

        // Get user's plan
        Plan plan = subDAO.getPlanByUserId(userId);
        if (plan == null) {
            // Default to free plan
            plan = new Plan(0, "Free", 5L * 1024 * 1024 * 1024, 0, 0, 1, "Free Plan", 50);
        }

        // Get storage usage
        long usedStorageBytes = subDAO.getUsedStorage(userId);
        long storageLimitBytes = plan.getStorageLimitBytes();
        int usedPercent = storageLimitBytes > 0 ? (int) (usedStorageBytes * 100 / storageLimitBytes) : 0;
        if (usedPercent > 100)
            usedPercent = 100;

        // Get content type breakdown
        Map<String, Long> contentTypeBreakdown = subDAO.getStorageByContentType(userId);

        // Get top memories by storage
        List<Map<String, Object>> topMemories = subDAO.getStorageByMemory(userId, 5);

        // Get top groups by storage
        List<Map<String, Object>> topGroups = subDAO.getStorageByGroup(userId, 5);

        // Get duplicate file count
        List<Map<String, Object>> duplicates = subDAO.getDuplicateFiles(userId);
        int duplicateCount = duplicates.size();
        long duplicateSize = 0;
        for (Map<String, Object> dup : duplicates) {
            duplicateSize += (Long) dup.get("fileSize");
        }

        // Get trash item count
        int trashCount = subDAO.getTrashItemCount(userId);

        // Get memory count
        int memoryCount = subDAO.getMemoryCount(userId);

        // Set all attributes for JSP
        request.setAttribute("plan", plan);
        request.setAttribute("usedStorageBytes", usedStorageBytes);
        request.setAttribute("storageLimitBytes", storageLimitBytes);
        request.setAttribute("usedPercent", usedPercent);
        request.setAttribute("contentTypeBreakdown", contentTypeBreakdown);
        request.setAttribute("topMemories", topMemories);
        request.setAttribute("topGroups", topGroups);
        request.setAttribute("duplicateCount", duplicateCount);
        request.setAttribute("duplicateSize", duplicateSize);
        request.setAttribute("trashCount", trashCount);
        request.setAttribute("memoryCount", memoryCount);

        request.getRequestDispatcher("/WEB-INF/views/app/Settings/storagesense.jsp").forward(request, response);
    }
}
