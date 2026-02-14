package com.demo.web.service;

import com.demo.web.dao.GroupDAO;
import com.demo.web.model.Group;

import java.util.List;

/**
 * Service for group operations.
 * Extracted from FrontControllerServlet.GroupListLogicHandler,
 * GroupViewLogicHandler, and EditGroupLogicHandler
 */
public class GroupService {

    private GroupDAO groupDAO;

    public GroupService() {
        this.groupDAO = new GroupDAO();
    }

    /**
     * Gets all groups owned by a user.
     *
     * @param userId The user ID
     * @return List of groups
     */
    public List<Group> getGroupsByUserId(int userId) {
        return groupDAO.findByUserId(userId);
    }

    /**
     * Gets a group by ID with ownership verification.
     *
     * @param groupId The group ID
     * @param userId  The user ID for ownership check
     * @return The group if found and owned by user, null otherwise
     */
    public Group getGroupById(int groupId, int userId) {
        Group result = groupDAO.findById(groupId);

        // Verify ownership
        if (result == null || result.getUserId() != userId) {
            return null;
        }

        return result;
    }

    /**
     * Gets a group by ID without ownership check.
     *
     * @param groupId The group ID
     * @return The group if found, null otherwise
     */
    public Group getGroupByIdUnsafe(int groupId) {
        return groupDAO.findById(groupId);
    }

    /**
     * Gets the member count for a group.
     *
     * @param groupId The group ID
     * @return The number of members
     */
    public int getMemberCount(int groupId) {
        return groupDAO.getMemberCount(groupId);
    }

    /**
     * Gets the GroupDAO for legacy JSP compatibility.
     *
     * @deprecated Use specific methods instead
     * @return The GroupDAO instance
     */
    @Deprecated
    public GroupDAO getGroupDAO() {
        return groupDAO;
    }
}
