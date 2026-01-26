package com.demo.web.service;

import com.demo.web.dao.userDAO;
import com.demo.web.model.user;

import java.sql.SQLException;

/**
 * Service for user profile operations.
 * Extracted from FrontControllerServlet.EditProfileLogicHandler
 */
public class ProfileService {

    private userDAO userDAO;

    public ProfileService() {
        this.userDAO = new userDAO();
    }

    /**
     * Gets fresh user data from database for editing.
     * 
     * @param userId The user ID
     * @return The user object, or null if not found
     */
    public user getUserForEdit(int userId) {
        return userDAO.findById(userId);
    }

    /**
     * Updates user profile information.
     * 
     * @param userId            The user ID
     * @param profilePictureUrl The new profile picture URL
     * @return true if successful, false on failure
     */
    public boolean updateProfilePicture(int userId, String profilePictureUrl) {
        try {
            return userDAO.updateProfilePicture(userId, profilePictureUrl);
        } catch (SQLException e) {
            System.err.println("Error updating profile picture for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
