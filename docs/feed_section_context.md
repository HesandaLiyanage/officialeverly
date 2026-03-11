# Feed & Comments Section Context
**Status:** In Progress / Maintenance
**Last Updated:** 2026-02-12

## Current Objective
Successfully fix bugs and complete features in the Feed section, primarily focusing on comment visibility across different users and the post "like" functionality.

## Recent Changes & Implementation Status

### 1. Comment System (`feedcomment.jsp` & `FeedCommentDAO`)
- **Status:** **FIXED (Pending User Confirmation)**
- **Issue:** Comments made by "other" users were not visible when viewing the post from a different account.
- **Root Cause Identified:** The SQL query used an `INNER JOIN` between `feed_post_comments` and `feed_profiles`. If a user's profile data was missing or the join failed (e.g., new user without a complete profile), the comment was hidden.
- **Fix Applied:** 
    - Changed `INNER JOIN` to `LEFT JOIN` in `FeedCommentDAO.getCommentsForPost`.
    - Updated `feedcomment.jsp` to handle null profile data gracefully (displays "Unknown" user and default avatar instead of crashing or hiding the comment).
    -Added detailed server-side logging for comment creation and retrieval.

- **Key Files:**
    - `src/main/java/com/demo/web/dao/FeedCommentDAO.java`
    - `src/main/webapp/views/app/feedcomment.jsp`
    - `src/main/java/com/demo/web/controller/Feed/FeedCommentServlet.java`

### 2. Post Like Feature
- **Status:** **COMPLETED**
- **Implementation:**
    - **Backend:** `FeedPostLikeDAO` handles database operations. `PostLikeServlet` handles AJAX toggle requests.
    - **Frontend:** `publicfeed.jsp` updated to show the correct initial state (red heart if liked). 
    - **Model:** `FeedPost` class updated with `likeCount` and `likedByCurrentUser` fields.
    - **Controller:** `FeedViewController` populates like data for each post.
- **Features:** 
    - Real-time like count updates via AJAX.
    - Persistent state (refreshing page shows correct like status).

### 3. UI Improvements
- **Comments Popup:** Changed from a separate page to a **popup overlay** with a semi-transparent dark background (`rgba(0,0,0,0.65)`) for a better user experience.
- **Styling:** Fixed border lines in the comments section to extend edge-to-edge.

### 4. JSP Compilation Fixes
- **Issue:** `publicfeed.jsp` had Java string literals split across multiple lines due to auto-formatting, causing HTTP 500 errors.
- **Fix:** Consolidatd split string literals onto single lines.

## Next Steps / Outstanding Tasks
1. **Verify Comment Visibility:** Confirm that the `LEFT JOIN` fix allows comments from all users to be seen, even those with incomplete profiles.
2. **Profile Creation Flow:** Ensure new users are forced to complete their `FeedProfile` (username/bio/pic) *before* they can comment, to avoid "Unknown" users appearing in the feed.
3. **Reply System:** Verify nested replies are working correctly (filtering logic `if (comment.getParentCommentId() != null) continue;` is currently in place for the main list).

## Pertinent Code Snippets

**FeedCommentDAO.java (Current Query):**
```java
String sql = "SELECT ... " +
        "FROM feed_post_comments c " +
        "LEFT JOIN feed_profiles fp ON c.feed_profile_id = fp.feed_profile_id " + // CHANGED FROM JOIN
        "WHERE c.post_id = ? " +
        "ORDER BY c.created_at ASC";
```

**FeedCommentDAO.java (Map ResultSet):**
```java
// Graceful handling of nulls from LEFT JOIN
FeedProfile profile = new FeedProfile();
profile.setFeedProfileId(rs.getInt("feed_profile_id"));
profile.setFeedUsername(rs.getString("feed_username")); // May be null
profile.setFeedProfilePictureUrl(rs.getString("feed_profile_picture_url")); // May be null
```

**feedcomment.jsp (Rendering):**
```jsp
<%-- Fallback for missing profile data --%>
String commenterUsername = (commenter != null && commenter.getFeedUsername() != null) 
    ? commenter.getFeedUsername() : "Unknown";
```
