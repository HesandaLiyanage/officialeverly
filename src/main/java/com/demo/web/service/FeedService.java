package com.demo.web.service;

import com.demo.web.dao.Feed.*;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dao.Notifications.NotificationDAO;
import com.demo.web.dto.Feed.*;
import com.demo.web.model.Feed.FeedComment;
import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.Memory;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 * FeedService - Contains ALL business logic for the Feed module.
 *
 * Controllers only extract HTTP params → build DTOs → call this service → handle response.
 * This service handles: profiles, posts, likes, comments, follows, blocks, saves, reports.
 */
public class FeedService {
    private static final Logger logger = Logger.getLogger(FeedService.class.getName());

    // Username pattern: 3-30 chars, alphanumeric and underscores only
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

    private FeedProfileDAO feedProfileDAO = new FeedProfileDAO();
    private FeedPostDAO feedPostDAO = new FeedPostDAO();
    private FeedFollowDAO feedFollowDAO = new FeedFollowDAO();
    private FeedPostLikeDAO feedPostLikeDAO = new FeedPostLikeDAO();
    private FeedCommentDAO feedCommentDAO = new FeedCommentDAO();
    private SavedPostDAO savedPostDAO = new SavedPostDAO();
    private BlockedUserDAO blockedUserDAO = new BlockedUserDAO();
    private PostReportDAO postReportDAO = new PostReportDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();
    private MediaDAO mediaDAO = new MediaDAO();
    private memoryDAO memoryDao = new memoryDAO();

    public FeedService() {
        blockedUserDAO.ensureTableExists();
    }

    // ============================================
    // PROFILE RESOLUTION (shared helper)
    // ============================================

    /**
     * Get or resolve the user's feed profile from session or database.
     */
    public FeedProfile getFeedProfileByUserId(int userId) throws SQLException {
        return feedProfileDAO.findByUserId(userId);
    }

    public FeedProfile getFeedProfileByUsername(String username) {
        return feedProfileDAO.findByUsername(username);
    }

    public FeedProfile getFeedProfileById(int feedProfileId) {
        return feedProfileDAO.findByFeedProfileId(feedProfileId);
    }

    // ============================================
    // FEED VIEW (Main Feed Page)
    // ============================================

    /**
     * Retrieves all necessary data to construct the main Feed view.
     */
    public FeedViewDTO getFeedViewData(FeedProfile feedProfile, String contextPath) throws Exception {
        if (feedProfile == null) return null;

        List<FeedPost> posts = feedPostDAO.findAllPosts();
        List<Integer> blockedProfileIds = blockedUserDAO.getBlockedProfileIds(feedProfile.getFeedProfileId());

        if (!blockedProfileIds.isEmpty()) {
            posts.removeIf(post -> {
                FeedProfile poster = post.getFeedProfile();
                return poster != null && blockedProfileIds.contains(poster.getFeedProfileId());
            });
        }

        for (FeedPost post : posts) {
            try {
                List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(post.getMemoryId());
                post.setMediaItems(mediaItems);
                if (post.getCoverMediaUrl() == null && mediaItems != null && !mediaItems.isEmpty()) {
                    post.setCoverMediaUrl(contextPath + "/viewmedia?id=" + mediaItems.get(0).getMediaId());
                }
                post.setLikeCount(feedPostLikeDAO.getLikeCount(post.getPostId()));
                post.setLikedByCurrentUser(feedPostLikeDAO.hasLikedPost(post.getPostId(), feedProfile.getFeedProfileId()));
            } catch (Exception e) {
                logger.warning("[FeedService] Media load error: " + e.getMessage());
            }
        }

        List<FeedProfile> recommendedUsers;
        try {
            recommendedUsers = feedFollowDAO.getRecommendedUsers(feedProfile.getFeedProfileId(), 5);
        } catch (Exception e) {
            recommendedUsers = feedProfileDAO.findRandomProfiles(feedProfile.getFeedProfileId(), 5);
        }

        String feedUsername = feedProfile.getFeedUsername() != null ? feedProfile.getFeedUsername() : "user";
        String feedProfilePic = feedProfile.getFeedProfilePictureUrl() != null ? feedProfile.getFeedProfilePictureUrl() : "/resources/assets/default-feed-avatar.png";
        String feedInitials = feedProfile.getInitials() != null ? feedProfile.getInitials() : "U";
        boolean hasDefaultPic = feedProfilePic.startsWith("/resources/assets/default") || feedProfilePic.contains("default");

        return new FeedViewDTO(feedProfile, posts, recommendedUsers, feedUsername, feedProfilePic, feedInitials, hasDefaultPic, feedProfile.getFeedProfileId());
    }

    // ============================================
    // POST CREATION
    // ============================================

    /**
     * Retrieves memories that user can convert to posts.
     */
    public List<Memory> getAvailableMemoriesForPost(int userId, int feedProfileId, String contextPath) throws Exception {
        List<Memory> allMemories = memoryDao.getMemoriesByUserId(userId);
        List<Memory> availableMemories = new ArrayList<>();

        for (Memory memory : allMemories) {
            if (!feedPostDAO.isMemoryPosted(memory.getMemoryId(), feedProfileId)) {
                Integer mediaId = feedPostDAO.getFirstMediaId(memory.getMemoryId());
                if (mediaId != null) {
                    memory.setCoverUrl(contextPath + "/viewMedia?mediaId=" + mediaId);
                }
                availableMemories.add(memory);
            }
        }
        return availableMemories;
    }

    /**
     * Process creation of a feed post.
     */
    public int createFeedPost(FeedPostCreateRequest request) throws Exception {
        Memory memory = memoryDao.getMemoryById(request.getMemoryId());
        if (memory == null || memory.getUserId() != request.getUserId()) {
            throw new IllegalArgumentException("Memory not found or access denied");
        }

        FeedProfile feedProfile = feedProfileDAO.findByUserId(request.getUserId());
        if (feedProfile == null) {
            throw new IllegalStateException("Feed profile not found");
        }

        if (feedPostDAO.isMemoryPosted(request.getMemoryId(), feedProfile.getFeedProfileId())) {
            throw new IllegalStateException("This memory is already posted");
        }

        FeedPost post = new FeedPost(request.getMemoryId(), feedProfile.getFeedProfileId());
        post.setCaption(request.getCaption() != null ? request.getCaption().trim() : memory.getDescription());
        return feedPostDAO.createPost(post);
    }

    // ============================================
    // LIKE / UNLIKE
    // ============================================

    /**
     * Handle post like/unlike/toggle action.
     */
    public FeedActionResponse handlePostLike(int postId, String action, FeedProfile currentProfile) {
        try {
            boolean isLiked;

            if ("like".equals(action)) {
                feedPostLikeDAO.likePost(postId, currentProfile.getFeedProfileId());
                isLiked = true;
            } else if ("unlike".equals(action)) {
                feedPostLikeDAO.unlikePost(postId, currentProfile.getFeedProfileId());
                isLiked = false;
            } else if ("toggle".equals(action)) {
                isLiked = feedPostLikeDAO.toggleLike(postId, currentProfile.getFeedProfileId());
            } else {
                return FeedActionResponse.error("Invalid action");
            }

            int newLikeCount = feedPostLikeDAO.getLikeCount(postId);

            FeedActionResponse response = FeedActionResponse.success(null);
            response.setIsLiked(isLiked);
            response.setLikeCount(newLikeCount);

            // Send notification when liked
            if (isLiked) {
                sendNotificationSafe(postId, currentProfile.getUserId(),
                        "comments_reactions", "New Like", "liked your post", "/feed");
            }

            logger.info("[FeedService] Profile " + currentProfile.getFeedProfileId() +
                    (isLiked ? " liked" : " unliked") + " post " + postId);

            return response;
        } catch (Exception e) {
            logger.severe("[FeedService] Like error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    // ============================================
    // SAVE / UNSAVE (Bookmark)
    // ============================================

    /**
     * Handle post save/unsave action.
     */
    public FeedActionResponse handlePostSave(int postId, String action, int currentProfileId) {
        try {
            boolean success;
            boolean isSaved;

            if ("save".equals(action)) {
                success = savedPostDAO.savePost(currentProfileId, postId);
                isSaved = true;
                logger.info("[FeedService] Profile " + currentProfileId + " saved post " + postId);
            } else if ("unsave".equals(action)) {
                success = savedPostDAO.unsavePost(currentProfileId, postId);
                isSaved = false;
                logger.info("[FeedService] Profile " + currentProfileId + " unsaved post " + postId);
            } else {
                return FeedActionResponse.error("Invalid action");
            }

            FeedActionResponse response = new FeedActionResponse(success, null);
            response.setIsSaved(isSaved);
            return response;
        } catch (Exception e) {
            logger.severe("[FeedService] Save error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    // ============================================
    // FOLLOW / UNFOLLOW
    // ============================================

    /**
     * Handle follow/unfollow action.
     */
    public FeedActionResponse handleFollow(String action, int currentProfileId, int targetProfileId) {
        // Prevent self-follow
        if (targetProfileId == currentProfileId) {
            return FeedActionResponse.error("Cannot follow yourself");
        }

        try {
            boolean success;
            String resultAction;

            if ("follow".equals(action)) {
                success = feedFollowDAO.follow(currentProfileId, targetProfileId);
                resultAction = "followed";
            } else if ("unfollow".equals(action)) {
                success = feedFollowDAO.unfollow(currentProfileId, targetProfileId);
                resultAction = "unfollowed";
            } else {
                return FeedActionResponse.error("Invalid action");
            }

            int followerCount = feedFollowDAO.getFollowerCount(targetProfileId);
            int followingCount = feedFollowDAO.getFollowingCount(currentProfileId);
            boolean isNowFollowing = feedFollowDAO.isFollowing(currentProfileId, targetProfileId);

            FeedActionResponse response = new FeedActionResponse(success, null);
            response.setAction(resultAction);
            response.setIsFollowing(isNowFollowing);
            response.setFollowerCount(followerCount);
            response.setFollowingCount(followingCount);

            logger.info("[FeedService] Profile " + currentProfileId + " " + resultAction + " " + targetProfileId);
            return response;
        } catch (Exception e) {
            logger.severe("[FeedService] Follow error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Check if currentProfile follows targetProfile.
     */
    public FeedActionResponse checkFollowStatus(int currentProfileId, int targetProfileId) {
        try {
            boolean isFollowing = feedFollowDAO.isFollowing(currentProfileId, targetProfileId);
            FeedActionResponse response = FeedActionResponse.success(null);
            response.setIsFollowing(isFollowing);
            return response;
        } catch (Exception e) {
            return FeedActionResponse.error("Server error");
        }
    }

    // ============================================
    // BLOCK / UNBLOCK
    // ============================================

    /**
     * Block a user.
     */
    public FeedActionResponse blockUser(int currentProfileId, int targetProfileId) {
        if (targetProfileId == currentProfileId) {
            return FeedActionResponse.error("Cannot block yourself");
        }

        try {
            boolean success = blockedUserDAO.blockUser(currentProfileId, targetProfileId);
            if (success) {
                logger.info("[FeedService] Profile " + currentProfileId + " blocked " + targetProfileId);
                return FeedActionResponse.success("User blocked successfully");
            } else {
                return FeedActionResponse.error("User is already blocked or could not be blocked");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Block error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Unblock a user.
     */
    public FeedActionResponse unblockUser(int currentProfileId, int blockedProfileId) {
        try {
            boolean success = blockedUserDAO.unblockUser(currentProfileId, blockedProfileId);
            if (success) {
                logger.info("[FeedService] Profile " + currentProfileId + " unblocked " + blockedProfileId);
                return FeedActionResponse.success("User unblocked");
            } else {
                return FeedActionResponse.error("Could not unblock user");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Unblock error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Get blocked users list.
     */
    public List<FeedProfile> getBlockedUsers(int currentProfileId) {
        try {
            return blockedUserDAO.getBlockedUsers(currentProfileId);
        } catch (Exception e) {
            logger.severe("[FeedService] Error loading blocked users: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // ============================================
    // COMMENTS
    // ============================================

    /**
     * Add a comment.
     */
    public FeedActionResponse addComment(int postId, String commentText, Integer parentCommentId, FeedProfile currentProfile) {
        if (commentText == null || commentText.trim().isEmpty()) {
            return FeedActionResponse.error("Comment text is required");
        }

        try {
            FeedComment comment = new FeedComment();
            comment.setPostId(postId);
            comment.setFeedProfileId(currentProfile.getFeedProfileId());
            comment.setCommentText(commentText.trim());

            if (parentCommentId != null && parentCommentId > 0) {
                comment.setParentCommentId(parentCommentId);
            }

            FeedComment createdComment = feedCommentDAO.createComment(comment);

            if (createdComment != null) {
                FeedActionResponse response = FeedActionResponse.success(null);
                response.setCommentId(createdComment.getCommentId());
                response.setCommentText(createdComment.getCommentText());
                response.setUsername(currentProfile.getFeedUsername());
                response.setInitials(currentProfile.getInitials());
                response.setProfilePictureUrl(currentProfile.getFeedProfilePictureUrl());
                response.setRelativeTime(createdComment.getRelativeTime());
                response.setLikeCount(0);
                response.setIsLiked(false);

                // Send notification to post owner
                sendNotificationSafe(postId, currentProfile.getUserId(),
                        "comments_reactions", "New Comment", "commented on your post", "/feed");

                return response;
            } else {
                return FeedActionResponse.error("Failed to create comment");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Comment error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Delete a comment (only if user owns the comment or the post).
     */
    public FeedActionResponse deleteComment(int commentId, FeedProfile currentProfile) {
        try {
            FeedComment comment = feedCommentDAO.getCommentById(commentId);
            if (comment == null) {
                return FeedActionResponse.error("Comment not found");
            }

            FeedPost post = feedPostDAO.findById(comment.getPostId());
            boolean isCommentOwner = comment.getFeedProfileId() == currentProfile.getFeedProfileId();
            boolean isPostOwner = post != null && post.getFeedProfileId() == currentProfile.getFeedProfileId();

            if (!isCommentOwner && !isPostOwner) {
                return FeedActionResponse.error("Not authorized to delete this comment");
            }

            boolean deleted = feedCommentDAO.deleteComment(commentId);
            return deleted ? FeedActionResponse.success(null) : FeedActionResponse.error("Failed to delete comment");
        } catch (Exception e) {
            logger.severe("[FeedService] Delete comment error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Like a comment.
     */
    public FeedActionResponse likeComment(int commentId, int currentProfileId) {
        try {
            boolean liked = feedCommentDAO.likeComment(commentId, currentProfileId);
            int newLikeCount = feedCommentDAO.getCommentLikeCount(commentId);
            FeedActionResponse response = new FeedActionResponse(liked, null);
            response.setIsLiked(true);
            response.setLikeCount(newLikeCount);
            return response;
        } catch (Exception e) {
            logger.severe("[FeedService] Like comment error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Unlike a comment.
     */
    public FeedActionResponse unlikeComment(int commentId, int currentProfileId) {
        try {
            feedCommentDAO.unlikeComment(commentId, currentProfileId);
            int newLikeCount = feedCommentDAO.getCommentLikeCount(commentId);
            FeedActionResponse response = FeedActionResponse.success(null);
            response.setIsLiked(false);
            response.setLikeCount(newLikeCount);
            return response;
        } catch (Exception e) {
            logger.severe("[FeedService] Unlike comment error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    /**
     * Get replies for a comment.
     */
    public List<FeedComment> getRepliesForComment(int commentId, int currentProfileId) {
        try {
            return feedCommentDAO.getRepliesForComment(commentId, currentProfileId);
        } catch (Exception e) {
            logger.severe("[FeedService] Get replies error: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // ============================================
    // COMMENT VIEW PAGE
    // ============================================

    /**
     * Build all data needed for the comment view page.
     */
    public FeedCommentViewDTO getCommentViewData(int postId, FeedProfile currentProfile) {
        FeedPost post = feedPostDAO.findById(postId);
        if (post == null) return null;

        List<FeedComment> comments = feedCommentDAO.getCommentsForPost(postId, currentProfile.getFeedProfileId());
        int likeCount = feedPostLikeDAO.getLikeCount(postId);
        boolean isLikedByUser = feedPostLikeDAO.hasLikedPost(postId, currentProfile.getFeedProfileId());
        int commentCount = feedCommentDAO.getCommentCount(postId);

        List<MediaItem> mediaItems = null;
        if (post.getMemoryId() > 0) {
            try {
                mediaItems = mediaDAO.getMediaByMemoryId(post.getMemoryId());
            } catch (SQLException e) {
                logger.warning("[FeedService] Error getting media items: " + e.getMessage());
            }
        }

        boolean isPostOwner = post.getFeedProfileId() == currentProfile.getFeedProfileId();

        // Pre-compute derived display values
        FeedProfile postOwner = post.getFeedProfile();
        String ownerPic = (postOwner != null) ? postOwner.getFeedProfilePictureUrl() : null;
        boolean hasOwnerPic = ownerPic != null && !ownerPic.isEmpty() && !ownerPic.contains("default");

        String cpUrl = currentProfile.getFeedProfilePictureUrl();

        FeedCommentViewDTO dto = new FeedCommentViewDTO();
        dto.setPost(post);
        dto.setComments(comments);
        dto.setLikeCount(likeCount);
        dto.setLikedByUser(isLikedByUser);
        dto.setCommentCount(commentCount);
        dto.setCurrentProfile(currentProfile);
        dto.setPostOwner(isPostOwner);
        dto.setMediaItems(mediaItems);
        dto.setHasOwnerPic(hasOwnerPic);
        dto.setOwnerPic(ownerPic);
        dto.setOwnerGradient("linear-gradient(135deg, #667eea 0%, #764ba2 100%)");
        dto.setPostLikedClass(isLikedByUser ? "liked" : "");
        dto.setPostFillColor(isLikedByUser ? "#ed4956" : "none");
        dto.setPostStrokeColor(isLikedByUser ? "#ed4956" : "currentColor");
        dto.setCpUrlSafe(cpUrl != null ? cpUrl : "");
        dto.setHasMultipleMedia(mediaItems != null && mediaItems.size() > 1);
        dto.setMediaCount(mediaItems != null ? mediaItems.size() : 0);
        dto.setCurrentProfileId(currentProfile.getFeedProfileId());

        return dto;
    }

    // ============================================
    // PROFILE VIEW PAGE
    // ============================================

    /**
     * Build all data needed for the profile view page.
     */
    public FeedProfileViewDTO getProfileViewData(String targetUsername, FeedProfile currentUserProfile, String contextPath) {
        FeedProfile profileToView;
        boolean isOwnProfile;

        if (targetUsername != null && !targetUsername.isEmpty()) {
            profileToView = feedProfileDAO.findByUsername(targetUsername);
            if (profileToView == null) return null;
            isOwnProfile = (profileToView.getFeedProfileId() == currentUserProfile.getFeedProfileId());
        } else {
            profileToView = currentUserProfile;
            isOwnProfile = true;
        }

        int followerCount = 0;
        int followingCount = 0;
        boolean isFollowing = false;
        boolean isBlocked = false;
        List<FeedProfile> recommendedUsers = new ArrayList<>();

        try {
            followerCount = feedFollowDAO.getFollowerCount(profileToView.getFeedProfileId());
            followingCount = feedFollowDAO.getFollowingCount(profileToView.getFeedProfileId());

            if (!isOwnProfile) {
                isFollowing = feedFollowDAO.isFollowing(
                        currentUserProfile.getFeedProfileId(),
                        profileToView.getFeedProfileId());
                isBlocked = blockedUserDAO.isBlocked(
                        currentUserProfile.getFeedProfileId(),
                        profileToView.getFeedProfileId());
            }

            recommendedUsers = feedFollowDAO.getRecommendedUsers(
                    currentUserProfile.getFeedProfileId(), 5);
        } catch (Exception e) {
            logger.warning("[FeedService] Follow data error, using fallback: " + e.getMessage());
            recommendedUsers = feedProfileDAO.findRandomProfiles(currentUserProfile.getFeedProfileId(), 5);
        }

        List<FeedPost> userPosts;
        try {
            userPosts = feedPostDAO.findByFeedProfileId(profileToView.getFeedProfileId());
            for (FeedPost post : userPosts) {
                if (post.getCoverMediaUrl() == null) {
                    Integer mediaId = feedPostDAO.getFirstMediaId(post.getMemoryId());
                    if (mediaId != null) {
                        post.setCoverMediaUrl(contextPath + "/viewMedia?mediaId=" + mediaId);
                    }
                }
            }
        } catch (Exception e) {
            userPosts = new ArrayList<>();
        }

        List<FeedPost> savedPosts = null;
        if (isOwnProfile) {
            try {
                savedPosts = savedPostDAO.getSavedPosts(currentUserProfile.getFeedProfileId());
                for (FeedPost post : savedPosts) {
                    if (post.getCoverMediaUrl() == null) {
                        Integer mediaId = feedPostDAO.getFirstMediaId(post.getMemoryId());
                        if (mediaId != null) {
                            post.setCoverMediaUrl(contextPath + "/viewMedia?mediaId=" + mediaId);
                        }
                    }
                }
            } catch (Exception e) {
                logger.warning("[FeedService] Saved posts error: " + e.getMessage());
                savedPosts = new ArrayList<>();
            }
        }

        // Pre-compute display values
        String profileUsername = profileToView.getFeedUsername() != null ? profileToView.getFeedUsername() : "user";
        String profilePic = profileToView.getFeedProfilePictureUrl();
        String profileBio = profileToView.getFeedBio() != null ? profileToView.getFeedBio() : "No bio yet";
        String profileInitials = profileToView.getInitials() != null ? profileToView.getInitials() : "U";
        boolean hasProfilePic = (profilePic != null && !profilePic.contains("default"));

        FeedProfileViewDTO dto = new FeedProfileViewDTO();
        dto.setProfileToView(profileToView);
        dto.setOwnProfile(isOwnProfile);
        dto.setFollowing(isFollowing);
        dto.setBlocked(isBlocked);
        dto.setFollowerCount(followerCount);
        dto.setFollowingCount(followingCount);
        dto.setPostCount(userPosts.size());
        dto.setUserPosts(userPosts);
        dto.setSavedPosts(savedPosts);
        dto.setRecommendedUsers(recommendedUsers);
        dto.setCurrentUserProfile(currentUserProfile);
        dto.setProfileUsername(profileUsername);
        dto.setProfilePic(profilePic);
        dto.setProfileBio(profileBio);
        dto.setProfileInitials(profileInitials);
        dto.setProfileId(profileToView.getFeedProfileId());
        dto.setHasProfilePic(hasProfilePic);

        return dto;
    }

    // ============================================
    // FOLLOWERS/FOLLOWING LIST PAGE
    // ============================================

    /**
     * Build all data needed for the followers/following list page.
     */
    public FeedFollowersViewDTO getFollowersViewData(String type, String profileIdStr, FeedProfile currentUserProfile) {
        int profileId = currentUserProfile.getFeedProfileId();
        if (profileIdStr != null && !profileIdStr.isEmpty()) {
            try {
                profileId = Integer.parseInt(profileIdStr);
            } catch (NumberFormatException e) {
                profileId = currentUserProfile.getFeedProfileId();
            }
        }

        FeedProfile profileToView;
        if (profileId == currentUserProfile.getFeedProfileId()) {
            profileToView = currentUserProfile;
        } else {
            profileToView = feedProfileDAO.findByFeedProfileId(profileId);
            if (profileToView == null) return null;
        }

        List<FeedProfile> userList = new ArrayList<>();
        String pageTitle;
        String jspPage;

        if ("following".equals(type)) {
            pageTitle = "Following";
            jspPage = "/WEB-INF/views/app/Feed/following.jsp";
        } else {
            pageTitle = "Followers";
            jspPage = "/WEB-INF/views/app/Feed/followers.jsp";
        }

        try {
            if ("following".equals(type)) {
                userList = feedFollowDAO.getFollowing(profileId);
            } else {
                userList = feedFollowDAO.getFollowers(profileId);
            }
            logger.info("[FeedService] Getting " + pageTitle.toLowerCase() + " for profile " + profileId + ": " + userList.size());
        } catch (Exception e) {
            logger.warning("[FeedService] Error getting follow list: " + e.getMessage());
        }

        FeedFollowersViewDTO dto = new FeedFollowersViewDTO();
        dto.setUserList(userList);
        dto.setPageTitle(pageTitle);
        dto.setJspPage(jspPage);
        dto.setProfileToView(profileToView);
        dto.setCurrentUserProfile(currentUserProfile);
        dto.setOwnProfile(profileId == currentUserProfile.getFeedProfileId());
        dto.setProfileUsername(profileToView != null ? profileToView.getFeedUsername() : "user");
        dto.setCurrentProfileId(currentUserProfile.getFeedProfileId());

        return dto;
    }

    /**
     * Check if currentProfile follows targetProfile (for followers list rendering).
     */
    public boolean isFollowing(int currentProfileId, int targetProfileId) {
        try {
            return feedFollowDAO.isFollowing(currentProfileId, targetProfileId);
        } catch (Exception e) {
            return false;
        }
    }

    // ============================================
    // PROFILE EDIT PAGE
    // ============================================

    /**
     * Build data for the profile edit page.
     */
    public FeedProfileEditDTO getProfileEditData(FeedProfile feedProfile) {
        FeedProfileEditDTO dto = new FeedProfileEditDTO();
        dto.setFeedProfile(feedProfile);
        dto.setFeedUsername(feedProfile.getFeedUsername() != null ? feedProfile.getFeedUsername() : "");
        dto.setFeedBio(feedProfile.getFeedBio() != null ? feedProfile.getFeedBio() : "");
        dto.setFeedProfilePicture(feedProfile.getFeedProfilePictureUrl());
        dto.setFeedInitials(feedProfile.getInitials() != null ? feedProfile.getInitials() : "U");
        String pic = feedProfile.getFeedProfilePictureUrl();
        dto.setHasDefaultPic(pic == null || pic.isEmpty() || pic.contains("default"));
        dto.setFeedBioLength(feedProfile.getFeedBio() != null ? feedProfile.getFeedBio().length() : 0);
        return dto;
    }

    // ============================================
    // PROFILE SETUP
    // ============================================

    /**
     * Check if user already has a feed profile.
     */
    public boolean hasExistingProfile(int userId) {
        try {
            return feedProfileDAO.findByUserId(userId) != null;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Set up a new feed profile.
     */
    public FeedActionResponse setupProfile(int userId, String feedUsername, String feedBio, 
                                            InputStream profilePicStream, String profilePicFileName,
                                            String uploadDir) {
        // Validate username
        if (feedUsername == null || feedUsername.trim().isEmpty()) {
            return FeedActionResponse.error("Username is required.");
        }

        feedUsername = feedUsername.trim().toLowerCase();

        if (!USERNAME_PATTERN.matcher(feedUsername).matches()) {
            return FeedActionResponse.error("Username must be 3-30 characters and can only contain letters, numbers, and underscores.");
        }

        if (feedProfileDAO.usernameExists(feedUsername)) {
            return FeedActionResponse.error("This username is already taken. Please choose another.");
        }

        if (feedBio != null && feedBio.length() > 500) {
            return FeedActionResponse.error("Bio must be 500 characters or less.");
        }

        // Handle profile picture
        String profilePictureUrl = null;
        if (profilePicStream != null && profilePicFileName != null && !profilePicFileName.isEmpty()) {
            String extension = getFileExtension(profilePicFileName);
            if (!isAllowedExtension(extension)) {
                return FeedActionResponse.error("Invalid file type. Allowed: JPG, JPEG, PNG, GIF, WEBP");
            }

            try {
                String newFileName = "feed_" + userId + "_" + UUID.randomUUID().toString() + extension;
                File uploadDirFile = new File(uploadDir);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                Path filePath = Paths.get(uploadDir, newFileName);
                Files.copy(profilePicStream, filePath);
                profilePictureUrl = "/uploads/feed-profiles/" + newFileName;
            } catch (Exception e) {
                logger.warning("[FeedService] Error handling profile picture upload: " + e.getMessage());
            }
        }

        if (profilePictureUrl == null || profilePictureUrl.isEmpty()) {
            profilePictureUrl = "/resources/assets/default-feed-avatar.png";
        }

        // Create profile
        try {
            FeedProfile newProfile = new FeedProfile();
            newProfile.setUserId(userId);
            newProfile.setFeedUsername(feedUsername);
            newProfile.setFeedProfilePictureUrl(profilePictureUrl);
            newProfile.setFeedBio(feedBio != null ? feedBio.trim() : "");

            boolean created = feedProfileDAO.createProfile(newProfile);
            if (created) {
                logger.info("[FeedService] Feed profile created for user " + userId + ": @" + feedUsername);
                FeedActionResponse response = FeedActionResponse.success("Profile created successfully");
                return response;
            } else {
                return FeedActionResponse.error("Failed to create profile. Please try again.");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Error creating profile: " + e.getMessage());
            return FeedActionResponse.error("An unexpected error occurred. Please try again.");
        }
    }

    // ============================================
    // PROFILE UPDATE
    // ============================================

    /**
     * Update a feed profile (bio and optionally profile picture).
     */
    public FeedActionResponse updateProfile(FeedProfile feedProfile, String bio,
                                             InputStream profilePicStream, String profilePicFileName,
                                             int userId, String uploadDir) {
        try {
            if (bio != null) {
                bio = bio.trim();
                if (bio.length() > 500) {
                    bio = bio.substring(0, 500);
                }
                feedProfile.setFeedBio(bio);
            }

            // Handle profile picture upload
            if (profilePicStream != null && profilePicFileName != null && !profilePicFileName.isEmpty()) {
                String extension = getFileExtension(profilePicFileName);
                if (isAllowedExtension(extension)) {
                    String newFileName = "feed_" + userId + "_" + UUID.randomUUID().toString() + extension;
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }
                    Path filePath = Paths.get(uploadDir, newFileName);
                    Files.copy(profilePicStream, filePath);
                    feedProfile.setFeedProfilePictureUrl("/uploads/feed-profiles/" + newFileName);
                    logger.info("[FeedService] Uploaded new profile picture for user " + userId);
                }
            }

            boolean updated = feedProfileDAO.updateProfile(feedProfile);
            if (updated) {
                logger.info("[FeedService] Profile updated for @" + feedProfile.getFeedUsername());
                return FeedActionResponse.success("Profile updated successfully!");
            } else {
                return FeedActionResponse.error("Failed to update profile. Please try again.");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Error updating profile: " + e.getMessage());
            return FeedActionResponse.error("An error occurred. Please try again.");
        }
    }

    // ============================================
    // REPORT POST
    // ============================================

    /**
     * Report a post.
     */
    public FeedActionResponse reportPost(int postId, String reason, int userId) {
        try {
            FeedProfile reporterProfile = feedProfileDAO.findByUserId(userId);
            if (reporterProfile == null) {
                return FeedActionResponse.error("Feed profile not found");
            }

            if (postReportDAO.hasUserReported(postId, reporterProfile.getFeedProfileId())) {
                return FeedActionResponse.error("You have already reported this post");
            }

            boolean created = postReportDAO.createReport(postId, reporterProfile.getFeedProfileId(), reason);
            if (created) {
                logger.info("[FeedService] Post " + postId + " reported by user " + userId + " reason: " + reason);
                return FeedActionResponse.success("Post reported successfully. Our team will review it.");
            } else {
                return FeedActionResponse.error("Failed to report post. Please try again.");
            }
        } catch (Exception e) {
            logger.severe("[FeedService] Report error: " + e.getMessage());
            return FeedActionResponse.error("Server error");
        }
    }

    // ============================================
    // PRIVATE HELPERS
    // ============================================

    private void sendNotificationSafe(int postId, int actorUserId,
                                       String type, String title, String message, String link) {
        try {
            int postOwnerUserId = notificationDAO.getPostOwnerUserId(postId);
            if (postOwnerUserId > 0 && postOwnerUserId != actorUserId) {
                notificationDAO.createNotification(postOwnerUserId, type, title, message, link, actorUserId);
            }
        } catch (Exception e) {
            logger.warning("[FeedService] Failed to send notification: " + e.getMessage());
        }
    }

    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            return fileName.substring(lastDot).toLowerCase();
        }
        return "";
    }

    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}
