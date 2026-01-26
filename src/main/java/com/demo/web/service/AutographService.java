package com.demo.web.service;

import com.demo.web.dao.autographDAO;
import com.demo.web.model.autograph;

import java.util.List;

/**
 * Service for autograph operations.
 * Extracted from FrontControllerServlet.AutographListLogicHandler,
 * AutographViewLogicHandler, and EditAutographLogicHandler
 */
public class AutographService {

    private autographDAO autographDAO;

    public AutographService() {
        this.autographDAO = new autographDAO();
    }

    /**
     * Gets all autographs for a user.
     * 
     * @param userId The user ID
     * @return List of autographs
     */
    public List<autograph> getAutographsByUserId(int userId) {
        return autographDAO.findByUserId(userId);
    }

    /**
     * Gets an autograph by ID with ownership verification.
     * 
     * @param autographId The autograph ID
     * @param userId      The user ID for ownership check
     * @return The autograph if found and owned by user, null otherwise
     */
    public autograph getAutographById(int autographId, int userId) {
        autograph result = autographDAO.findById(autographId);

        // Verify ownership
        if (result == null || result.getUserId() != userId) {
            return null;
        }

        return result;
    }

    /**
     * Gets an autograph by ID without ownership check.
     * Use this only for admin operations.
     * 
     * @param autographId The autograph ID
     * @return The autograph if found, null otherwise
     */
    public autograph getAutographByIdUnsafe(int autographId) {
        return autographDAO.findById(autographId);
    }
}
