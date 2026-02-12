package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedCommentDAO;
import com.demo.web.dao.FeedPostDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedComment;
import com.demo.web.model.FeedPost;
import com.demo.web.model.FeedProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;

/**
 * Servlet to handle comment AJAX operations (add, delete, like)
 */
@WebServlet("/commentAction")
public class FeedCommentServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(FeedCommentServlet.class.getName());
    private FeedCommentDAO commentDAO = new FeedCommentDAO();
    private FeedPostDAO postDAO = new FeedPostDAO();
    private FeedProfileDAO profileDAO = new FeedProfileDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"error\": \"Not authenticated\"}");
            return;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile currentProfile = (FeedProfile) session.getAttribute("feedProfile");

        if (currentProfile == null) {
            currentProfile = profileDAO.findByUserId(userId);
        }

        if (currentProfile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"No feed profile found\"}");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAddComment(request, response, currentProfile);
                    break;
                case "delete":
                    handleDeleteComment(request, response, currentProfile);
                    break;
                case "like":
                    handleLikeComment(request, response, currentProfile);
                    break;
                case "unlike":
                    handleUnlikeComment(request, response, currentProfile);
                    break;
                case "getReplies":
                    handleGetReplies(request, response, currentProfile);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\": false, \"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            logger.severe("[FeedCommentServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }

    private void handleAddComment(HttpServletRequest request, HttpServletResponse response, FeedProfile currentProfile)
            throws IOException {
        PrintWriter out = response.getWriter();

        String postIdStr = request.getParameter("postId");
        String commentText = request.getParameter("commentText");
        String parentCommentIdStr = request.getParameter("parentCommentId");

        if (postIdStr == null || commentText == null || commentText.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing required parameters\"}");
            return;
        }

        int postId = Integer.parseInt(postIdStr);

        FeedComment comment = new FeedComment();
        comment.setPostId(postId);
        comment.setFeedProfileId(currentProfile.getFeedProfileId());
        comment.setCommentText(commentText.trim());

        if (parentCommentIdStr != null && !parentCommentIdStr.isEmpty()) {
            comment.setParentCommentId(Integer.parseInt(parentCommentIdStr));
        }

        FeedComment createdComment = commentDAO.createComment(comment);

        if (createdComment != null) {
            // Return the comment data for rendering
            String json = String.format(
                    "{\"success\": true, \"comment\": {" +
                            "\"commentId\": %d," +
                            "\"commentText\": \"%s\"," +
                            "\"username\": \"%s\"," +
                            "\"initials\": \"%s\"," +
                            "\"profilePictureUrl\": %s," +
                            "\"relativeTime\": \"%s\"," +
                            "\"likeCount\": 0," +
                            "\"isLiked\": false" +
                            "}}",
                    createdComment.getCommentId(),
                    escapeJson(createdComment.getCommentText()),
                    escapeJson(currentProfile.getFeedUsername()),
                    escapeJson(currentProfile.getInitials()),
                    currentProfile.getFeedProfilePictureUrl() != null
                            ? "\"" + escapeJson(currentProfile.getFeedProfilePictureUrl()) + "\""
                            : "null",
                    createdComment.getRelativeTime());
            out.print(json);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Failed to create comment\"}");
        }
    }

    private void handleDeleteComment(HttpServletRequest request, HttpServletResponse response,
            FeedProfile currentProfile)
            throws IOException {
        PrintWriter out = response.getWriter();

        String commentIdStr = request.getParameter("commentId");

        if (commentIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing comment ID\"}");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);

        // Get the comment to check ownership
        FeedComment comment = commentDAO.getCommentById(commentId);

        if (comment == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"success\": false, \"error\": \"Comment not found\"}");
            return;
        }

        // Check if user owns the comment OR the post
        FeedPost post = postDAO.findById(comment.getPostId());
        boolean isCommentOwner = comment.getFeedProfileId() == currentProfile.getFeedProfileId();
        boolean isPostOwner = post != null && post.getFeedProfileId() == currentProfile.getFeedProfileId();

        if (!isCommentOwner && !isPostOwner) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.print("{\"success\": false, \"error\": \"Not authorized to delete this comment\"}");
            return;
        }

        boolean deleted = commentDAO.deleteComment(commentId);

        if (deleted) {
            out.print("{\"success\": true}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Failed to delete comment\"}");
        }
    }

    private void handleLikeComment(HttpServletRequest request, HttpServletResponse response, FeedProfile currentProfile)
            throws IOException {
        PrintWriter out = response.getWriter();

        String commentIdStr = request.getParameter("commentId");

        if (commentIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing comment ID\"}");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);
        boolean liked = commentDAO.likeComment(commentId, currentProfile.getFeedProfileId());
        int newLikeCount = commentDAO.getCommentLikeCount(commentId);

        out.print(String.format("{\"success\": %b, \"isLiked\": true, \"likeCount\": %d}", liked, newLikeCount));
    }

    private void handleUnlikeComment(HttpServletRequest request, HttpServletResponse response,
            FeedProfile currentProfile)
            throws IOException {
        PrintWriter out = response.getWriter();

        String commentIdStr = request.getParameter("commentId");

        if (commentIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing comment ID\"}");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);
        commentDAO.unlikeComment(commentId, currentProfile.getFeedProfileId());
        int newLikeCount = commentDAO.getCommentLikeCount(commentId);

        out.print(String.format("{\"success\": true, \"isLiked\": false, \"likeCount\": %d}", newLikeCount));
    }

    private void handleGetReplies(HttpServletRequest request, HttpServletResponse response, FeedProfile currentProfile)
            throws IOException {
        PrintWriter out = response.getWriter();

        String commentIdStr = request.getParameter("commentId");

        if (commentIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing comment ID\"}");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);
        java.util.List<FeedComment> replies = commentDAO.getRepliesForComment(commentId,
                currentProfile.getFeedProfileId());

        StringBuilder json = new StringBuilder("{\"success\": true, \"replies\": [");
        for (int i = 0; i < replies.size(); i++) {
            FeedComment reply = replies.get(i);
            FeedProfile replyProfile = reply.getFeedProfile();
            if (i > 0)
                json.append(",");
            json.append(String.format(
                    "{\"commentId\": %d, \"commentText\": \"%s\", \"username\": \"%s\", \"initials\": \"%s\", " +
                            "\"profilePictureUrl\": %s, \"relativeTime\": \"%s\", \"likeCount\": %d, \"isLiked\": %b, \"feedProfileId\": %d}",
                    reply.getCommentId(),
                    escapeJson(reply.getCommentText()),
                    escapeJson(replyProfile != null ? replyProfile.getFeedUsername() : "unknown"),
                    escapeJson(replyProfile != null ? replyProfile.getInitials() : "?"),
                    replyProfile != null && replyProfile.getFeedProfilePictureUrl() != null
                            ? "\"" + escapeJson(replyProfile.getFeedProfilePictureUrl()) + "\""
                            : "null",
                    reply.getRelativeTime(),
                    reply.getLikeCount(),
                    reply.isLikedByCurrentUser(),
                    reply.getFeedProfileId()));
        }
        json.append("]}");
        out.print(json.toString());
    }

    /**
     * Escape special characters for JSON
     */
    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
