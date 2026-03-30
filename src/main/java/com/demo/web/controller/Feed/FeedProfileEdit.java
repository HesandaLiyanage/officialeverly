package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedProfileEditDTO;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * EditFeedProfileViewController - Loads feed profile data for editing.
 * Thin controller — all business logic delegated to FeedService.
 */
public class FeedProfileEdit extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedProfileEdit.class.getName());
    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authenticate
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        FeedProfile feedProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (feedProfile == null) {
            Integer userId = (Integer) session.getAttribute("user_id");
            try { feedProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
            if (feedProfile == null) {
                response.sendRedirect(request.getContextPath() + "/feedWelcome");
                return;
            }
            session.setAttribute("feedProfile", feedProfile);
        }

        // 2. Delegate to service
        FeedProfileEditDTO dto = feedService.getProfileEditData(feedProfile);

        // 3. Set attributes from DTO and forward
        request.setAttribute("feedProfile", dto.getFeedProfile());
        request.setAttribute("feedUsername", dto.getFeedUsername());
        request.setAttribute("feedBio", dto.getFeedBio());
        request.setAttribute("feedProfilePicture", dto.getFeedProfilePicture());
        request.setAttribute("feedInitials", dto.getFeedInitials());
        request.setAttribute("hasDefaultPic", dto.isHasDefaultPic());
        request.setAttribute("feedBioLength", dto.getFeedBioLength());

        logger.info("[ProfileEditController] Loading profile for editing: @" + dto.getFeedUsername());

        request.getRequestDispatcher("/WEB-INF/views/app/Feed/editpublicprofile.jsp").forward(request, response);
    }
}
