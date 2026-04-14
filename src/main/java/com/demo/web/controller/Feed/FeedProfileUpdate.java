package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
import com.demo.web.dto.Feed.FeedProfileEditDTO;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Logger;

/**
 * UpdateFeedProfileServlet - Handles feed profile updates.
 * Thin controller — all business logic delegated to FeedService.
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024,   // 1 MB
        maxFileSize = 5 * 1024 * 1024,         // 5 MB
        maxRequestSize = 10 * 1024 * 1024      // 10 MB
)
public class FeedProfileUpdate extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedProfileUpdate.class.getName());
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authenticate
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (feedProfile == null) {
            try { feedProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
        }

        // 2. Extract form data
        String bio = request.getParameter("bio");

        InputStream profilePicStream = null;
        String profilePicFileName = null;
        try {
            Part filePart = request.getPart("profile_picture");
            if (filePart != null && filePart.getSize() > 0) {
                profilePicFileName = getSubmittedFileName(filePart);
                profilePicStream = filePart.getInputStream();
            }
        } catch (Exception e) {
            // Continue without profile picture
        }

        String uploadDir = getServletContext().getRealPath("/uploads/feed-profiles");

        // 3. Delegate to service
        FeedActionResponse result = feedService.updateProfile(feedProfile, bio,
                profilePicStream, profilePicFileName, userId, uploadDir);

        // 4. Handle response
        if (result.isSuccess()) {
            session.setAttribute("feedProfile", feedProfile);
            request.setAttribute("successMessage", result.getMessage());
        } else {
            request.setAttribute("errorMessage", result.getError());
        }

        // Set display data and forward back to edit page
        FeedProfileEditDTO dto = feedService.getProfileEditData(feedProfile);
        request.setAttribute("feedProfile", dto.getFeedProfile());
        request.setAttribute("feedUsername", dto.getFeedUsername());
        request.setAttribute("feedBio", dto.getFeedBio());
        request.setAttribute("feedProfilePicture", dto.getFeedProfilePicture());
        request.setAttribute("feedInitials", dto.getFeedInitials());
        request.setAttribute("hasDefaultPic", dto.isHasDefaultPic());
        request.setAttribute("feedBioLength", dto.getFeedBioLength());

        request.getRequestDispatcher("/WEB-INF/views/app/Feed/editpublicprofile.jsp").forward(request, response);
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }
}
