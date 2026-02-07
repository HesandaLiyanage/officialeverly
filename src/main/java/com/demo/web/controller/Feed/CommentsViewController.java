package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedCommentDAO;
import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.FeedPostLikeDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.dao.MediaDAO;
import com.demo.web.model.FeedComment;
import com.demo.web.model.FeedPost;
import com.demo.web.model.FeedProfile;
import com.demo.web.model.MediaItem;

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
public class CommentsViewController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CommentsViewController.class.getName());
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

        // Set attributes for JSP
        request.setAttribute("post", post);
        request.setAttribute("comments", comments);
        request.setAttribute("likeCount", likeCount);
        request.setAttribute("isLikedByUser", isLikedByUser);
        request.setAttribute("commentCount", commentCount);
        request.setAttribute("currentProfile", currentProfile);
        request.setAttribute("isPostOwner", isPostOwner);
        request.setAttribute("mediaItems", mediaItems);

        logger.info("[CommentsViewController] Loaded comments page for post " + postId +
                " with " + comments.size() + " comments");

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/app/feedcomment.jsp");
        dispatcher.forward(request, response);
    }
}
