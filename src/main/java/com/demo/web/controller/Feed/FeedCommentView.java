package com.demo.web.controller.Feed;

import com.demo.web.dao.Feed.FeedCommentDAO;
import com.demo.web.dao.Feed.FeedPostDAO;
import com.demo.web.dao.Feed.FeedPostLikeDAO;
import com.demo.web.dao.Feed.FeedProfileDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.model.Feed.FeedComment;
import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.MediaItem;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet to display the comments page for a post
 */
@WebServlet("/viewComments")
public class FeedCommentView extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedCommentView.class.getName());
    private FeedPostDAO postDAO = new FeedPostDAO();
    private FeedCommentDAO commentDAO = new FeedCommentDAO();
    private FeedPostLikeDAO likeDAO = new FeedPostLikeDAO();
    private FeedProfileDAO profileDAO = new FeedProfileDAO();
    private MediaDAO mediaDAO = new MediaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");

        if (currentProfile == null) {
            currentProfile = profileDAO.findByUserId(userId);
        }

        if (currentProfile == null) {
            response.sendRedirect(request.getContextPath() + "/feedprofile/setup");
            return;
        }

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

        // Get the post with all details
        FeedPost post = postDAO.findById(postId);
        if (post == null) {
            response.sendRedirect(request.getContextPath() + "/feed");
            return;
        }

        // Get all comments for this post
        List<FeedComment> comments = commentDAO.getCommentsForPost(postId, currentProfile.getFeedProfileId());

        // Get like count and whether current user has liked the post
        int likeCount = likeDAO.getLikeCount(postId);
        boolean isLikedByUser = likeDAO.hasLikedPost(postId, currentProfile.getFeedProfileId());

        // Get comment count
        int commentCount = commentDAO.getCommentCount(postId);

        // Get media items for the post's memory
        List<MediaItem> mediaItems = null;
        if (post.getMemoryId() > 0) {
            try {
                mediaItems = mediaDAO.getMediaByMemoryId(post.getMemoryId());
            } catch (java.sql.SQLException e) {
                logger.warning("[CommentsViewController] Error getting media items: " + e.getMessage());
            }
        }

        // Check if current user is the post owner
        boolean isPostOwner = post.getFeedProfileId() == currentProfile.getFeedProfileId();

        // Pre-compute derived values for the JSP (avoids scriptlets)
        FeedProfile postOwner = post.getFeedProfile();
        String ownerPic = (postOwner != null) ? postOwner.getFeedProfilePictureUrl() : null;
        boolean hasOwnerPic = ownerPic != null && !ownerPic.isEmpty() && !ownerPic.contains("default");
        String ownerGradient = "linear-gradient(135deg, #667eea 0%, #764ba2 100%)";

        String postLikedClass = isLikedByUser ? "liked" : "";
        String postFillColor = isLikedByUser ? "#ed4956" : "none";
        String postStrokeColor = isLikedByUser ? "#ed4956" : "currentColor";

        String cpUrl = currentProfile.getFeedProfilePictureUrl();
        String cpUrlSafe = (cpUrl != null) ? cpUrl : "";

        boolean hasMultipleMedia = mediaItems != null && mediaItems.size() > 1;
        int mediaCount = (mediaItems != null) ? mediaItems.size() : 0;
        int currentProfileId = currentProfile.getFeedProfileId();

        // Set attributes for JSP
        request.setAttribute("post", post);
        request.setAttribute("comments", comments);
        request.setAttribute("likeCount", likeCount);
        request.setAttribute("isLikedByUser", isLikedByUser);
        request.setAttribute("commentCount", commentCount);
        request.setAttribute("currentProfile", currentProfile);
        request.setAttribute("isPostOwner", isPostOwner);
        request.setAttribute("mediaItems", mediaItems);

        // Derived presentation attributes
        request.setAttribute("hasOwnerPic", hasOwnerPic);
        request.setAttribute("ownerPic", ownerPic);
        request.setAttribute("ownerGradient", ownerGradient);
        request.setAttribute("postLikedClass", postLikedClass);
        request.setAttribute("postFillColor", postFillColor);
        request.setAttribute("postStrokeColor", postStrokeColor);
        request.setAttribute("cpUrlSafe", cpUrlSafe);
        request.setAttribute("hasMultipleMedia", hasMultipleMedia);
        request.setAttribute("mediaCount", mediaCount);
        request.setAttribute("currentProfileId", currentProfileId);

        logger.info("[CommentsViewController] Loaded comments page for post " + postId +
                " with " + comments.size() + " comments");

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/app/Feed/feedcomment.jsp");
        dispatcher.forward(request, response);
    }
}
