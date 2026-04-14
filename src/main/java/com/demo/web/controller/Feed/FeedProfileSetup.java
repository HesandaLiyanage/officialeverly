package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

/**
 * Servlet for handling Feed Profile setup and creation.
 * Thin controller — all business logic delegated to FeedService.
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024,   // 1MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 15     // 15MB
)
public class FeedProfileSetup extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if user already has a profile
        if (feedService.hasExistingProfile(userId)) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/app/Feed/feedProfileSetup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");

        // Check if user already has a profile
        if (feedService.hasExistingProfile(userId)) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // Extract form parameters
        String feedUsername = request.getParameter("feedUsername");
        String feedBio = request.getParameter("feedBio");

        // Extract profile picture file
        InputStream profilePicStream = null;
        String profilePicFileName = null;
        try {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                profilePicFileName = getSubmittedFileName(filePart);
                profilePicStream = filePart.getInputStream();
            }
        } catch (Exception e) {
            // Continue without profile picture
        }

        String uploadDir = getServletContext().getRealPath("/uploads/feed-profiles");

        // Delegate to service
        FeedActionResponse result = feedService.setupProfile(userId, feedUsername, feedBio,
                profilePicStream, profilePicFileName, uploadDir);

        if (result.isSuccess()) {
            // Re-fetch the profile for session
            try {
                FeedProfile newProfile = feedService.getFeedProfileByUserId(userId);
                session.setAttribute("feedProfile", newProfile);
            } catch (Exception e) { /* ignored */ }
            response.sendRedirect(request.getContextPath() + "/feed");
        } else {
            request.setAttribute("errorMessage", result.getError());
            request.setAttribute("feedUsername", feedUsername);
            request.setAttribute("feedBio", feedBio);
            request.getRequestDispatcher("/WEB-INF/views/app/Feed/feedProfileSetup.jsp").forward(request, response);
        }
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
