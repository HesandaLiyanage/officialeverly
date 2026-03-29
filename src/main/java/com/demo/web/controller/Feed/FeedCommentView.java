package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedCommentViewDTO;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

/**
 * Servlet to display the comments page for a post.
 * Thin controller — all business logic delegated to FeedService.
 */
@WebServlet("/viewComments")
public class FeedCommentView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedCommentView.class.getName());
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

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");
        if (currentProfile == null) {
            try { currentProfile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
        }
        if (currentProfile == null) {
            response.sendRedirect(request.getContextPath() + "/feedprofile/setup");
            return;
        }

        // 2. Extract parameters
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        int postId;
        try {
            postId = Integer.parseInt(postIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // 3. Delegate to service
        FeedCommentViewDTO dto = feedService.getCommentViewData(postId, currentProfile);

        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // 4. Set attributes from DTO and forward
        request.setAttribute("post", dto.getPost());
        request.setAttribute("comments", dto.getComments());
        request.setAttribute("likeCount", dto.getLikeCount());
        request.setAttribute("isLikedByUser", dto.isLikedByUser());
        request.setAttribute("commentCount", dto.getCommentCount());
        request.setAttribute("currentProfile", dto.getCurrentProfile());
        request.setAttribute("isPostOwner", dto.isPostOwner());
        request.setAttribute("mediaItems", dto.getMediaItems());
        request.setAttribute("hasOwnerPic", dto.isHasOwnerPic());
        request.setAttribute("ownerPic", dto.getOwnerPic());
        request.setAttribute("ownerGradient", dto.getOwnerGradient());
        request.setAttribute("postLikedClass", dto.getPostLikedClass());
        request.setAttribute("postFillColor", dto.getPostFillColor());
        request.setAttribute("postStrokeColor", dto.getPostStrokeColor());
        request.setAttribute("cpUrlSafe", dto.getCpUrlSafe());
        request.setAttribute("hasMultipleMedia", dto.isHasMultipleMedia());
        request.setAttribute("mediaCount", dto.getMediaCount());
        request.setAttribute("currentProfileId", dto.getCurrentProfileId());

        logger.info("[CommentViewController] Loaded comments for post " + postId);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/app/Feed/feedcomment.jsp");
        dispatcher.forward(request, response);
    }
}
