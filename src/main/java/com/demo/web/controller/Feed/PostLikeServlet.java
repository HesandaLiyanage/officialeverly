package com.demo.web.controller.Feed;

import com.demo.web.dao.FeedPostLikeDAO;
import com.demo.web.dao.FeedProfileDAO;
import com.demo.web.model.FeedProfile;
import com.demo.web.model.user;

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
 * Servlet to handle post like/unlike AJAX operations
 */
@WebServlet("/postLike")
public class PostLikeServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(PostLikeServlet.class.getName());
    private FeedPostLikeDAO likeDAO = new FeedPostLikeDAO();
    private FeedProfileDAO profileDAO = new FeedProfileDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"error\": \"Not authenticated\"}");
            return;
        }

        user currentUser = (user) session.getAttribute("user");
        FeedProfile currentProfile = profileDAO.findByUserId(currentUser.getId());

        if (currentProfile == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"No feed profile found\"}");
            return;
        }

        String postIdStr = request.getParameter("postId");
        String action = request.getParameter("action");

        if (postIdStr == null || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Missing required parameters\"}");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdStr);
            boolean isLiked;

            if ("like".equals(action)) {
                likeDAO.likePost(postId, currentProfile.getFeedProfileId());
                isLiked = true;
            } else if ("unlike".equals(action)) {
                likeDAO.unlikePost(postId, currentProfile.getFeedProfileId());
                isLiked = false;
            } else if ("toggle".equals(action)) {
                isLiked = likeDAO.toggleLike(postId, currentProfile.getFeedProfileId());
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"error\": \"Invalid action\"}");
                return;
            }

            int newLikeCount = likeDAO.getLikeCount(postId);
            out.print(String.format("{\"success\": true, \"isLiked\": %b, \"likeCount\": %d}", isLiked, newLikeCount));

            logger.info("[PostLikeServlet] Profile " + currentProfile.getFeedProfileId() +
                    (isLiked ? " liked" : " unliked") + " post " + postId);

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"error\": \"Invalid post ID\"}");
        } catch (Exception e) {
            logger.severe("[PostLikeServlet] Error: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"error\": \"Server error\"}");
        }
    }
}
