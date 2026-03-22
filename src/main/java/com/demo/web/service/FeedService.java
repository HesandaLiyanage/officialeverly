package com.demo.web.service;

import com.demo.web.dao.Feed.BlockedUserDAO;
import com.demo.web.dao.Feed.FeedFollowDAO;
import com.demo.web.dao.Feed.FeedPostDAO;
import com.demo.web.dao.Feed.FeedPostLikeDAO;
import com.demo.web.dao.Feed.FeedProfileDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.dto.Feed.FeedPostCreateRequest;
import com.demo.web.dto.Feed.FeedViewDTO;
import com.demo.web.model.Feed.FeedPost;
import com.demo.web.model.Feed.FeedProfile;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.Memory;

import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;

public class FeedService {
    private static final Logger logger = Logger.getLogger(FeedService.class.getName());

    private FeedProfileDAO feedProfileDAO = new FeedProfileDAO();
    private FeedPostDAO feedPostDAO = new FeedPostDAO();
    private FeedFollowDAO feedFollowDAO = new FeedFollowDAO();
    private FeedPostLikeDAO feedPostLikeDAO = new FeedPostLikeDAO();
    private MediaDAO mediaDAO = new MediaDAO();
    private BlockedUserDAO blockedUserDAO = new BlockedUserDAO();
    private memoryDAO memoryDao = new memoryDAO();

    public FeedService() {
        blockedUserDAO.ensureTableExists();
    }

    public FeedProfile getFeedProfileByUserId(int userId) throws SQLException {
        return feedProfileDAO.findByUserId(userId);
    }

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
}
