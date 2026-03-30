package com.demo.web.controller.Feed;

import com.demo.web.dto.Feed.FeedActionResponse;
import com.demo.web.model.Feed.FeedComment;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.service.FeedService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet to handle comment AJAX operations (add, delete, like, unlike, getReplies).
 * Thin controller — all business logic delegated to FeedService.
 */
@WebServlet("/commentAction")
public class FeedCommentAction extends HttpServlet {

    private FeedService feedService;

    @Override
    public void init() throws ServletException {
        feedService = new FeedService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Authenticate
        FeedProfile currentProfile = resolveProfile(request, response);
        if (currentProfile == null) return;

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAdd(request, out, currentProfile);
                    break;
                case "delete":
                    handleDelete(request, response, out, currentProfile);
                    break;
                case "like":
                    handleLike(request, out, currentProfile);
                    break;
                case "unlike":
                    handleUnlike(request, out, currentProfile);
                    break;
                case "getReplies":
                    handleGetReplies(request, out, currentProfile);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\": false, \"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }

    private void handleAdd(HttpServletRequest request, PrintWriter out, FeedProfile currentProfile) {
        String postIdStr = request.getParameter("postId");
        String commentText = request.getParameter("commentText");
        String parentCommentIdStr = request.getParameter("parentCommentId");

        if (postIdStr == null) {
            out.print("{\"success\": false, \"error\": \"Missing required parameters\"}");
            return;
        }

        Integer parentCommentId = null;
        if (parentCommentIdStr != null && !parentCommentIdStr.isEmpty()) {
            try { parentCommentId = Integer.parseInt(parentCommentIdStr); } catch (NumberFormatException e) { /* ignored */ }
        }

        // Delegate to service
        FeedActionResponse result = feedService.addComment(
                Integer.parseInt(postIdStr), commentText, parentCommentId, currentProfile);

        if (result.isSuccess()) {
            out.print(String.format(
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
                    result.getCommentId(),
                    escapeJson(result.getCommentText()),
                    escapeJson(result.getUsername()),
                    escapeJson(result.getInitials()),
                    result.getProfilePictureUrl() != null
                            ? "\"" + escapeJson(result.getProfilePictureUrl()) + "\""
                            : "null",
                    result.getRelativeTime()));
        } else {
            out.print("{\"success\": false, \"error\": \"" + result.getError() + "\"}");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, PrintWriter out, FeedProfile currentProfile) {
        String commentIdStr = request.getParameter("commentId");
        if (commentIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing comment ID\"}");
            return;
        }

        FeedActionResponse result = feedService.deleteComment(Integer.parseInt(commentIdStr), currentProfile);

        if (!result.isSuccess()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
        out.print("{\"success\": " + result.isSuccess() +
                (result.getError() != null ? ", \"error\": \"" + result.getError() + "\"" : "") + "}");
    }

    private void handleLike(HttpServletRequest request, PrintWriter out, FeedProfile currentProfile) {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        FeedActionResponse result = feedService.likeComment(commentId, currentProfile.getFeedProfileId());
        out.print(String.format("{\"success\": %b, \"isLiked\": true, \"likeCount\": %d}",
                result.isSuccess(), result.getLikeCount()));
    }

    private void handleUnlike(HttpServletRequest request, PrintWriter out, FeedProfile currentProfile) {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        FeedActionResponse result = feedService.unlikeComment(commentId, currentProfile.getFeedProfileId());
        out.print(String.format("{\"success\": true, \"isLiked\": false, \"likeCount\": %d}", result.getLikeCount()));
    }

    private void handleGetReplies(HttpServletRequest request, PrintWriter out, FeedProfile currentProfile) {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        List<FeedComment> replies = feedService.getRepliesForComment(commentId, currentProfile.getFeedProfileId());

        StringBuilder json = new StringBuilder("{\"success\": true, \"replies\": [");
        for (int i = 0; i < replies.size(); i++) {
            FeedComment reply = replies.get(i);
            FeedProfile replyProfile = reply.getFeedProfile();
            if (i > 0) json.append(",");
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

    private FeedProfile resolveProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("{\"success\": false, \"error\": \"Not authenticated\"}");
            return null;
        }

        Integer userId = (Integer) session.getAttribute("user_id");
        FeedProfile profile = (FeedProfile) session.getAttribute("feedProfile");
        if (profile == null) {
            try { profile = feedService.getFeedProfileByUserId(userId); } catch (Exception e) { /* ignored */ }
        }

        if (profile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"success\": false, \"error\": \"No feed profile found\"}");
            return null;
        }
        return profile;
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
