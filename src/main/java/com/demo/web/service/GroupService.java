package com.demo.web.service;

import com.demo.web.dao.Groups.GroupDAO;
import com.demo.web.dao.Groups.GroupMemberDAO;
import com.demo.web.dao.Memory.MediaDAO;
import com.demo.web.dao.Memory.memoryDAO;
import com.demo.web.model.Auth.user;
import com.demo.web.model.Groups.Group;
import com.demo.web.model.Groups.GroupMember;
import com.demo.web.model.Groups.GroupRole;
import com.demo.web.model.Memory.MediaItem;
import com.demo.web.model.Memory.Memory;
import com.demo.web.dao.Groups.GroupAnnouncementDAO;
import com.demo.web.dao.Groups.GroupInviteDAO;
import com.demo.web.dao.Notifications.NotificationDAO;
import com.demo.web.dao.Events.EventDAO;
import com.demo.web.dao.Events.EventVoteDAO;
import com.demo.web.model.Groups.GroupAnnouncement;
import com.demo.web.model.Groups.GroupInvite;
import com.demo.web.model.Events.Event;
import com.demo.web.dto.Groups.*;

import javax.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class GroupService {

    private GroupDAO groupDAO;
    private GroupMemberDAO groupMemberDAO;
    private memoryDAO memoryDao;
    private MediaDAO mediaDAO;
    private GroupAnnouncementDAO announcementDAO;
    private GroupInviteDAO groupInviteDAO;
    private NotificationDAO notificationDAO;
    private EventDAO eventDAO;
    private EventVoteDAO eventVoteDAO;

    private static final String UPLOAD_DIR = "resources/db images";

    public GroupService() {
        this.groupDAO = new GroupDAO();
        this.groupMemberDAO = new GroupMemberDAO();
        this.memoryDao = new memoryDAO();
        this.mediaDAO = new MediaDAO();
        this.announcementDAO = new GroupAnnouncementDAO();
        this.groupInviteDAO = new GroupInviteDAO();
        this.notificationDAO = new NotificationDAO();
        this.eventDAO = new EventDAO();
        this.eventVoteDAO = new EventVoteDAO();
    }

    public List<Group> getGroupsByUserId(int userId) {
        return groupDAO.findGroupsByMemberId(userId);
    }

    public Group getGroupById(int groupId, int userId) {
        Group result = groupDAO.findById(groupId);
        if (result == null || result.getUserId() != userId) {
            return null;
        }
        return result;
    }

    // ==========================================
    // GroupCreate Processing
    // ==========================================
    public GroupCreateResponse createGroup(GroupCreateRequest req) {
        try {
            if (req.getGroupName() == null || req.getGroupName().trim().isEmpty()) {
                return GroupCreateResponse.error("Group name is required");
            }

            String linkSource = req.getCustomLink();
            if (linkSource == null || linkSource.trim().isEmpty()) {
                linkSource = req.getGroupName();
            }

            String cleanedLink = linkSource.trim().toLowerCase()
                    .replaceAll("[^a-z0-9-]", "-")
                    .replaceAll("-+", "-")
                    .replaceAll("^-|-$", "");

            if (cleanedLink.isEmpty()) {
                return GroupCreateResponse.error("Unable to generate group link from the group name.");
            }

            if (groupDAO.isUrlTaken(cleanedLink)) {
                return GroupCreateResponse.error("This group URL is already taken. Please choose another one.");
            }

            String groupPicUrl = null;
            Part filePart = req.getFilePart();

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = "group_" + UUID.randomUUID().toString() + fileExtension;
                String uploadPath = req.getApplicationPath() + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + uniqueFileName;
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                }
                groupPicUrl = req.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
            }

            Group newGroup = new Group();
            newGroup.setName(req.getGroupName().trim());
            newGroup.setDescription(req.getGroupDescription() != null ? req.getGroupDescription().trim() : "");
            newGroup.setUserId(req.getUserId());
            newGroup.setGroupPicUrl(groupPicUrl);
            newGroup.setGroupUrl(cleanedLink);
            newGroup.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            if (groupDAO.createGroup(newGroup)) {
                Group createdGroup = groupDAO.findByUrl(cleanedLink);
                if (createdGroup != null) {
                    GroupMember adminMember = new GroupMember();
                    adminMember.setGroupId(createdGroup.getGroupId());
                    user creatorUser = new user();
                    creatorUser.setId(req.getUserId());
                    adminMember.setUser(creatorUser);
                    adminMember.setRole(GroupRole.ADMIN);
                    adminMember.setJoinedAt(new Timestamp(System.currentTimeMillis()));
                    adminMember.setStatus("active");
                    groupMemberDAO.addGroupMember(adminMember);
                }
                return GroupCreateResponse.success("Group created successfully!");
            } else {
                return GroupCreateResponse.error("Failed to create group. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return GroupCreateResponse.error("An error occurred while creating the group: " + e.getMessage());
        }
    }

    // ==========================================
    // GroupsList (Dashboard) Processing
    // ==========================================
    public GroupsListResponse listGroups(GroupsListRequest req) {
        GroupsListResponse res = new GroupsListResponse();
        try {
            List<Group> groups = groupDAO.findGroupsByMemberId(req.getUserId());
            res.setGroups(groups);

            List<Map<String, Object>> groupDisplayData = new ArrayList<>();
            List<Map<String, Object>> announcementDisplayData = new ArrayList<>();
            int announcementCount = 0;

            if (groups != null) {
                for (Group group : groups) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("groupId", group.getGroupId());
                    data.put("name", group.getName());
                    data.put("nameLower", group.getName().toLowerCase());
                    data.put("description", group.getDescription());

                    String timeAgo = calculateTimeAgo(group.getCreatedAt());
                    data.put("timeAgo", timeAgo);

                    int memberCount = groupDAO.getMemberCount(group.getGroupId());
                    data.put("memberCount", memberCount);
                    data.put("memberLabel", memberCount != 1 ? "members" : "member");

                    boolean hasGroupPic = group.getGroupPicUrl() != null && !group.getGroupPicUrl().isEmpty();
                    data.put("hasGroupPic", hasGroupPic);
                    data.put("groupPicUrl", group.getGroupPicUrl());

                    groupDisplayData.add(data);

                    if (announcementCount < 5) {
                        Map<String, Object> annData = new HashMap<>();
                        annData.put("name", group.getName());
                        annData.put("description", (group.getDescription() != null && !group.getDescription().isEmpty()) ? group.getDescription() : "New group created!");
                        annData.put("timeAgo", timeAgo);
                        announcementDisplayData.add(annData);
                        announcementCount++;
                    }
                }
            }

            res.setGroupDisplayData(groupDisplayData);
            res.setAnnouncementDisplayData(announcementDisplayData);
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            res.setErrorMessage("Error listing groups: " + e.getMessage());
            return res;
        }
    }

    // ==========================================
    // Group Memories Processing
    // ==========================================
    public GroupsListMemoriesResponse getGroupMemories(GroupsListMemoriesRequest req) {
        GroupsListMemoriesResponse res = new GroupsListMemoriesResponse();
        try {
            int groupId = Integer.parseInt(req.getGroupIdParam());
            Group groupDetail = groupDAO.findById(groupId);

            if (groupDetail == null) {
                res.setRedirectUrl("/groups");
                return res;
            }

            boolean isAdmin = (groupDetail.getUserId() == req.getUserId());
            boolean isMember = groupMemberDAO.isUserMember(groupId, req.getUserId());

            if (!isAdmin && !isMember) {
                res.setRedirectUrl("/groups?error=Access denied");
                return res;
            }

            String userRole = isAdmin
                    ? GroupRole.ADMIN.getValue()
                    : GroupRole.normalize(groupMemberDAO.getMemberRole(groupId, req.getUserId()));
            List<Memory> memories = memoryDao.getMemoriesByGroupId(groupId);
            Map<Integer, String> coverImageUrls = new HashMap<>();

            for (Memory memory : memories) {
                List<MediaItem> mediaItems = mediaDAO.getMediaByMemoryId(memory.getMemoryId());
                if (!mediaItems.isEmpty()) {
                    coverImageUrls.put(memory.getMemoryId(), "/viewMedia?mediaId=" + mediaItems.get(0).getMediaId());
                }
            }

            GroupRole memberRole = GroupRole.fromValue(userRole);
            boolean canCreate = isAdmin || (memberRole != null && memberRole.canCreateMemories());

            res.setGroup(groupDetail);
            res.setGroupId(groupId);
            res.setGroupName(groupDetail.getName());
            res.setMemories(memories);
            res.setCoverImageUrls(coverImageUrls);
            res.setAdmin(isAdmin);
            res.setMember(isMember);
            res.setCurrentUserRole(userRole);
            res.setCurrentUserId(req.getUserId());
            res.setCanCreate(canCreate);

            return res;
        } catch (NumberFormatException e) {
            res.setRedirectUrl("/groups");
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            res.setRedirectUrl("/groups?error=Error loading memories");
            return res;
        }
    }

    // ==========================================
    // Group Edit Display Processing
    // ==========================================
    public GroupsListEditResponse getGroupForEditDisplay(GroupsListEditRequest req) {
        GroupsListEditResponse res = new GroupsListEditResponse();
        try {
            int groupId = Integer.parseInt(req.getGroupIdParam());
            Group groupToEdit = getGroupById(groupId, req.getUserId());

            if (groupToEdit == null) {
                res.setRedirectUrl("/groups");
                return res;
            }

            res.setGroup(groupToEdit);
            return res;
        } catch (NumberFormatException e) {
            res.setRedirectUrl("/groups");
            return res;
        }
    }

    // ==========================================
    // Group Edit Processing
    // ==========================================
    public GroupEditResponse editGroup(GroupEditRequest req) {
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group existingGroup = groupDAO.findById(groupId);

            if (existingGroup == null || existingGroup.getUserId() != req.getUserId()) {
                return GroupEditResponse.error(null, "/groups", null);
            }

            if (req.getGroupName() == null || req.getGroupName().trim().isEmpty()) {
                return GroupEditResponse.error("Group name is required", null, existingGroup);
            }

            String customLink = req.getCustomLink();
            if (customLink == null || customLink.trim().isEmpty()) {
                customLink = existingGroup.getGroupUrl();
            } else {
                customLink = customLink.trim().toLowerCase()
                        .replaceAll("[^a-z0-9-]", "-")
                        .replaceAll("-+", "-")
                        .replaceAll("^-|-$", "");
            }

            if (!customLink.equals(existingGroup.getGroupUrl()) && groupDAO.isUrlTaken(customLink)) {
                return GroupEditResponse.error("This group link is already taken. Please choose another.", null, existingGroup);
            }

            String groupPicUrl = existingGroup.getGroupPicUrl();
            Part filePart = req.getFilePart();
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

                String uploadPath = req.getApplicationPath() + File.separator + "uploads" + File.separator + "groups";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                groupPicUrl = req.getContextPath() + "/uploads/groups/" + uniqueFileName;
            }

            existingGroup.setName(req.getGroupName().trim());
            existingGroup.setDescription(req.getGroupDescription() != null ? req.getGroupDescription().trim() : "");
            existingGroup.setGroupPicUrl(groupPicUrl);
            existingGroup.setGroupUrl(customLink.trim());

            if (groupDAO.updateGroup(existingGroup)) {
                return GroupEditResponse.success("/groupmemories?groupId=" + groupId);
            } else {
                return GroupEditResponse.error("Failed to update group. Please try again.", null, existingGroup);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return GroupEditResponse.error("An error occurred while updating the group", "/groups", null);
        }
    }

    // ==========================================
    // Group Profile View Processing
    // ==========================================
    public GroupProfileViewResponse viewGroupProfile(GroupProfileViewRequest req) {
        GroupProfileViewResponse res = new GroupProfileViewResponse();
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            int memberId = Integer.parseInt(req.getMemberIdStr());

            Group group = groupDAO.findById(groupId);
            if (group == null) return GroupProfileViewResponse.error("/groups?error=Group not found");

            GroupMember targetMember = null;
            for (GroupMember gm : groupMemberDAO.getMembersByGroupId(groupId)) {
                if (gm.getUser().getId() == memberId) {
                    targetMember = gm;
                    break;
                }
            }

            if (targetMember == null) return GroupProfileViewResponse.error("/groupmembers?groupId=" + groupId + "&error=Member not found");

            boolean isAdmin = (group.getUserId() == req.getCurrentUserId());
            String memberName = (targetMember.getUser() != null) ? targetMember.getUser().getUsername() : "User";
            String memberEmail = (targetMember.getUser() != null) ? targetMember.getUser().getEmail() : "";
            GroupRole memberRole = targetMember.getRoleEnum();
            if (memberRole == null) {
                memberRole = GroupRole.VIEWER;
            }

            String initials = "";
            if (memberName != null && memberName.length() > 0) {
                String[] parts = memberName.split(" ");
                if (parts.length >= 2) {
                    initials = (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
                } else {
                    initials = memberName.substring(0, Math.min(2, memberName.length())).toUpperCase();
                }
            }

            String joinedDate = "Joined Recently";
            if (targetMember.getJoinedAt() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("MMM yyyy");
                joinedDate = "Joined " + sdf.format(targetMember.getJoinedAt());
            }

            res.setSuccess(true);
            res.setGroup(group);
            res.setMember(targetMember);
            res.setAdmin(isAdmin);
            res.setCurrentUserId(req.getCurrentUserId());
            res.setGroupId(groupId);
            res.setGroupName(group.getName());
            res.setCreatorText(isAdmin ? "Created by You" : "");
            res.setMemberName(memberName);
            res.setMemberEmail(memberEmail);
            res.setMemberRole(memberRole.getLabel());
            res.setInitials(initials);
            res.setJoinedDate(joinedDate);
            res.setCanRemove(isAdmin && targetMember.getUser().getId() != req.getCurrentUserId());
            res.setMemberId(memberId);
            res.setRoleViewer(memberRole == GroupRole.VIEWER);
            res.setRoleMember(memberRole == GroupRole.MEMBER);
            res.setRoleAdmin(memberRole == GroupRole.ADMIN);

            return res;
        } catch (Exception e) {
            return GroupProfileViewResponse.error("/groups?error=Invalid parameters");
        }
    }

    // ==========================================
    // Group Delete Processing
    // ==========================================
    public GroupDeleteResponse deleteGroup(GroupDeleteRequest req) {
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group existingGroup = groupDAO.findById(groupId);

            if (existingGroup == null || existingGroup.getUserId() != req.getUserId()) {
                return GroupDeleteResponse.redirect("/groups");
            }

            if (groupDAO.deleteGroup(groupId)) {
                return GroupDeleteResponse.redirect("/groups?deleted=success");
            } else {
                return GroupDeleteResponse.redirect("/groupmemories?groupId=" + groupId + "&error=delete_failed");
            }
        } catch (NumberFormatException e) {
            return GroupDeleteResponse.redirect("/groups");
        } catch (Exception e) {
            e.printStackTrace();
            return GroupDeleteResponse.redirect("/groups?error=delete_error");
        }
    }

    // ==========================================
    // Private Helpers
    // ==========================================
    private String calculateTimeAgo(java.sql.Timestamp createdAt) {
        long diffInMillies = Math.abs(new Date().getTime() - createdAt.getTime());
        long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

        if (diffInDays == 0) {
            long diffInHours = TimeUnit.HOURS.convert(diffInMillies, TimeUnit.MILLISECONDS);
            if (diffInHours == 0) {
                long diffInMinutes = TimeUnit.MINUTES.convert(diffInMillies, TimeUnit.MILLISECONDS);
                return diffInMinutes + " minutes ago";
            } else return diffInHours + " hours ago";
        } else if (diffInDays == 1) return "Yesterday";
        else if (diffInDays < 7) return diffInDays + " days ago";
        else if (diffInDays < 30) {
            long weeks = diffInDays / 7;
            return weeks + " week" + (weeks > 1 ? "s" : "") + " ago";
        } else if (diffInDays < 365) {
            long months = diffInDays / 30;
            return months + " month" + (months > 1 ? "s" : "") + " ago";
        } else {
            long years = diffInDays / 365;
            return years + " year" + (years > 1 ? "s" : "") + " ago";
        }
    }

    // ==========================================
    // Group Announcement Methods
    // ==========================================
    public GroupAnnouncementCreateResponse createGroupAnnouncement(GroupAnnouncementCreateRequest req) {
        if (req.getGroupIdStr() == null || req.getTitle() == null || req.getContent() == null ||
            req.getTitle().isEmpty() || req.getContent().isEmpty()) {
            return new GroupAnnouncementCreateResponse(false, "All fields are required.", req.getGroupIdStr() != null ? Integer.parseInt(req.getGroupIdStr()) : 0, null);
        }

        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            GroupAnnouncement announcement = new GroupAnnouncement(groupId, req.getUserId(), req.getTitle(), req.getContent());

            boolean success = announcementDAO.createAnnouncement(announcement);
            if (success) {
                sendGroupAnnouncementNotifications(groupId, req.getUserId(), req.getTitle());
                return new GroupAnnouncementCreateResponse(true, null, groupId, "/groupannouncementservlet?groupId=" + groupId);
            } else {
                return new GroupAnnouncementCreateResponse(false, "Failed to create announcement. Please try again.", groupId, null);
            }
        } catch (NumberFormatException e) {
            return new GroupAnnouncementCreateResponse(false, "Invalid group ID", 0, "/groups?error=Invalid group ID");
        }
    }

    public GroupAnnouncementViewResponse viewGroupAnnouncement(GroupAnnouncementViewRequest req) {
        GroupAnnouncementViewResponse response = new GroupAnnouncementViewResponse();
        try {
            int announcementId = Integer.parseInt(req.getAnnouncementIdStr());
            GroupAnnouncement ga = announcementDAO.findById(announcementId);

            if (ga == null) {
                response.setSuccess(false);
                response.setRedirectUrl("/groups?error=Announcement not found");
                return response;
            }

            response.setSuccess(true);
            response.setAnnouncement(ga);
            response.setAuthorInitial((ga.getPostedBy() != null) ? ga.getPostedBy().getUsername().substring(0, 1).toUpperCase() : "A");
            response.setAuthorName((ga.getPostedBy() != null) ? ga.getPostedBy().getUsername() : "Unknown");
            response.setPostDate(ga.getCreatedAt() != null ? ga.getCreatedAt().toString() : "");

            boolean hasEvent = (ga.getEventId() != null);
            response.setHasEvent(hasEvent);
            response.setCurrentUserId(req.getCurrentUserId());

            if (hasEvent) {
                try {
                    Event linkedEvent = eventDAO.findById(ga.getEventId());
                    if (linkedEvent != null) {
                        response.setLinkedEventTitle(linkedEvent.getTitle());
                        if (linkedEvent.getEventPicUrl() != null && !linkedEvent.getEventPicUrl().isEmpty()) {
                            response.setEventPicUrl(linkedEvent.getEventPicUrl()); // context path will be prepended by JSP
                        }
                        response.setFormattedEventDate(new SimpleDateFormat("MMMM dd, yyyy").format(linkedEvent.getEventDate()));
                    }
                } catch (Exception e) {
                    System.err.println("Error loading linked event: " + e.getMessage());
                }

                int pollEventId = ga.getEventId();
                int pollGroupId = ga.getGroupId();

                Map<String, Integer> voteCounts = eventVoteDAO.getVoteCounts(pollEventId, pollGroupId);
                String userCurrentVote = eventVoteDAO.getUserVote(pollEventId, pollGroupId, req.getCurrentUserId());
                List<Map<String, Object>> voters = eventVoteDAO.getVoters(pollEventId, pollGroupId);

                int totalVotes = voteCounts.get("total");
                int goingCount = voteCounts.get("going");
                int notGoingCount = voteCounts.get("not_going");
                int maybeCount = voteCounts.get("maybe");

                response.setPollEventId(pollEventId);
                response.setPollGroupId(pollGroupId);
                response.setTotalVotes(totalVotes);
                response.setGoingCount(goingCount);
                response.setNotGoingCount(notGoingCount);
                response.setMaybeCount(maybeCount);
                
                response.setGoingPercent(totalVotes > 0 ? (goingCount * 100 / totalVotes) : 0);
                response.setNotGoingPercent(totalVotes > 0 ? (notGoingCount * 100 / totalVotes) : 0);
                response.setMaybePercent(totalVotes > 0 ? (maybeCount * 100 / totalVotes) : 0);
                
                response.setUserCurrentVote(userCurrentVote);
                response.setTotalVotesLabel(totalVotes + " vote" + (totalVotes != 1 ? "s" : ""));

                List<Map<String, String>> voterDisplayData = new ArrayList<>();
                if (voters != null) {
                    for (Map<String, Object> voter : voters) {
                        Map<String, String> vd = new HashMap<>();
                        String voterName = (String) voter.get("username");
                        String voterVote = (String) voter.get("vote");
                        vd.put("name", voterName);
                        vd.put("initial", voterName.substring(0, 1).toUpperCase());
                        vd.put("vote", voterVote);
                        vd.put("label", "going".equals(voterVote) ? "Going" : "not_going".equals(voterVote) ? "Not Going" : "Maybe");
                        voterDisplayData.add(vd);
                    }
                }
                response.setVoterDisplayData(voterDisplayData);
            }
            return response;
        } catch (NumberFormatException e) {
            response.setSuccess(false);
            response.setRedirectUrl("/groups?error=Invalid announcement ID");
            return response;
        }
    }

    public GroupAnnouncementsListResponse listGroupAnnouncements(GroupAnnouncementsListRequest req) {
        GroupAnnouncementsListResponse response = new GroupAnnouncementsListResponse();
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group group = groupDAO.findById(groupId);

            if (group == null) {
                response.setSuccess(false);
                response.setRedirectUrl("/groups?error=Group not found");
                return response;
            }

            List<GroupAnnouncement> announcements = announcementDAO.findByGroupId(groupId);

            response.setSuccess(true);
            response.setGroup(group);
            response.setGroupId(groupId);
            response.setGroupName(group.getName());
            response.setGroupDescription((group.getDescription() != null && !group.getDescription().isEmpty()) ? group.getDescription() : "Created by You");
            response.setAnnouncements(announcements);

            List<Map<String, String>> announcementDisplayData = new ArrayList<>();
            if (announcements != null) {
                for (GroupAnnouncement ann : announcements) {
                    Map<String, String> data = new HashMap<>();
                    data.put("announcementId", String.valueOf(ann.getAnnouncementId()));
                    data.put("title", ann.getTitle());

                    String content = ann.getContent();
                    if (content.length() > 120) {
                        content = content.substring(0, 117) + "...";
                    }
                    data.put("truncatedContent", content);
                    data.put("createdAt", ann.getCreatedAt() != null ? ann.getCreatedAt().toString() : "");
                    data.put("authorName", ann.getPostedBy() != null ? ann.getPostedBy().getUsername() : "Unknown");
                    announcementDisplayData.add(data);
                }
            }
            response.setAnnouncementDisplayData(announcementDisplayData);

            return response;
        } catch (NumberFormatException e) {
            response.setSuccess(false);
            response.setRedirectUrl("/groups?error=Invalid group ID");
            return response;
        }
    }

    // ==========================================
    // Group Member and Invite Methods
    // ==========================================
    public GroupInviteJoinResponse joinGroupInvite(GroupInviteJoinRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            return new GroupInviteJoinResponse(false, "/groups?error=Invalid invite link", null);
        }

        String token = pathInfo.substring(1);
        GroupInvite invite = groupInviteDAO.findByToken(token);
        if (invite == null) {
            return new GroupInviteJoinResponse(false, "/groups?error=Invite link is invalid or expired", null);
        }

        if (req.getUserId() == null) {
            return new GroupInviteJoinResponse(false, "/login?redirect=invite", token);
        }

        int groupId = invite.getGroupId();
        if (groupMemberDAO.isUserMember(groupId, req.getUserId())) {
            String message = URLEncoder.encode("You are already a member of this group", StandardCharsets.UTF_8);
            return new GroupInviteJoinResponse(true, "/groupmemories?groupId=" + groupId + "&msg=" + message, null);
        }

        Group group = groupDAO.findById(groupId);
        if (group == null) {
            return new GroupInviteJoinResponse(false, "/groups?error=Group not found", null);
        }

        GroupMember newMember = new GroupMember();
        newMember.setGroupId(groupId);
        user memberUser = new user();
        memberUser.setId(req.getUserId());
        newMember.setUser(memberUser);
        newMember.setRole(GroupRole.VIEWER);
        newMember.setJoinedAt(new Timestamp(System.currentTimeMillis()));
        newMember.setStatus("active");

        boolean success = groupMemberDAO.addGroupMember(newMember);
        if (success) {
            sendGroupJoinNotificationToAdmin(groupId, req.getUserId());
            String message = URLEncoder.encode("Successfully joined " + group.getName(), StandardCharsets.UTF_8);
            return new GroupInviteJoinResponse(true, "/groupmemories?groupId=" + groupId + "&msg=" + message, null);
        } else {
            return new GroupInviteJoinResponse(false, "/groups?error=Failed to join group", null);
        }
    }

    public GroupInviteLinkResponse generateGroupInviteLink(GroupInviteLinkRequest req) {
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group group = groupDAO.findById(groupId);

            if (group == null) {
                return new GroupInviteLinkResponse(404, "{\"error\": \"Group not found\"}");
            }
            if (group.getUserId() != req.getUserId()) {
                return new GroupInviteLinkResponse(403, "{\"error\": \"Only group admin can generate invite links\"}");
            }

            String token = groupInviteDAO.generateToken();
            GroupInvite invite = new GroupInvite();
            invite.setGroupId(groupId);
            invite.setInviteToken(token);
            invite.setCreatedBy(req.getUserId());
            invite.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            invite.setActive(true);

            boolean success = groupInviteDAO.createInvite(invite);
            if (success) {
                String inviteUrl = req.getServerUrlBase() + "/invite/" + token;
                return new GroupInviteLinkResponse(200, "{\"success\": true, \"inviteUrl\": \"" + inviteUrl + "\", \"token\": \"" + token + "\"}");
            } else {
                return new GroupInviteLinkResponse(500, "{\"error\": \"Failed to generate invite link\"}");
            }
        } catch (NumberFormatException e) {
            return new GroupInviteLinkResponse(400, "{\"error\": \"Invalid group ID\"}");
        }
    }

    public GroupMemberRemoveResponse removeGroupMember(GroupMemberRemoveRequest req) {
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            int memberId = Integer.parseInt(req.getMemberIdStr());

            Group group = groupDAO.findById(groupId);
            if (group == null) {
                return new GroupMemberRemoveResponse("/groups?error=Group not found");
            }
            if (group.getUserId() != req.getCurrentUserId()) {
                return new GroupMemberRemoveResponse("/groupmembers?groupId=" + groupId + "&error=You do not have permission to remove members");
            }
            if (memberId == req.getCurrentUserId()) {
                return new GroupMemberRemoveResponse("/groupmembers?groupId=" + groupId + "&error=You cannot remove yourself");
            }

            boolean success = groupMemberDAO.deleteGroupMember(groupId, memberId);
            if (success) {
                return new GroupMemberRemoveResponse("/groupmembers?groupId=" + groupId + "&msg=Member removed successfully");
            } else {
                return new GroupMemberRemoveResponse("/groupmembers?groupId=" + groupId + "&error=Failed to remove member");
            }
        } catch (NumberFormatException e) {
            return new GroupMemberRemoveResponse("/groups?error=Invalid parameters");
        }
    }

    public GroupMembersListResponse listGroupMembers(GroupMembersListRequest req) {
        GroupMembersListResponse response = new GroupMembersListResponse();
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group group = groupDAO.findById(groupId);

            if (group == null) {
                response.setRedirectUrl("/groups?error=Group not found");
                return response;
            }

            List<GroupMember> members = groupMemberDAO.getMembersByGroupId(groupId);
            boolean isAdmin = (group.getUserId() == req.getUserId());
            boolean isMember = groupMemberDAO.isUserMember(groupId, req.getUserId());
            String currentUserRole = isAdmin
                    ? GroupRole.ADMIN.getValue()
                    : GroupRole.normalize(groupMemberDAO.getMemberRole(groupId, req.getUserId()));

            if (!isAdmin && !isMember) {
                response.setRedirectUrl("/groups?error=Access denied");
                return response;
            }

            response.setGroup(group);
            response.setMembers(members);
            response.setAdmin(isAdmin);
            response.setMember(isMember);
            response.setCurrentUserId(req.getUserId());
            response.setCurrentUserRole(currentUserRole);
            response.setGroupName(group.getName());
            response.setGroupId(groupId);

            String[] avatarColors = {"#6366f1", "#ec4899", "#f59e0b", "#10b981", "#3b82f6", "#8b5cf6", "#ef4444", "#14b8a6"};
            List<Map<String, Object>> memberDisplayData = new ArrayList<>();
            int colorIndex = 0;
            if (members != null) {
                for (GroupMember member : members) {
                    Map<String, Object> data = new HashMap<>();
                    String username = member.getUser().getUsername();
                    String initials = "";
                    if (username != null && username.length() > 0) {
                        String[] parts = username.split(" ");
                        if (parts.length >= 2) {
                            initials = (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
                        } else {
                            initials = username.substring(0, Math.min(2, username.length())).toUpperCase();
                        }
                    }
                    data.put("username", username);
                    data.put("initials", initials);
                    GroupRole role = member.getRoleEnum();
                    String roleValue = role != null ? role.getValue() : GroupRole.VIEWER.getValue();
                    String roleLabel = role != null ? role.getLabel() : "Viewer";
                    data.put("role", roleValue);
                    data.put("roleKey", roleValue);
                    data.put("roleLabel", roleLabel);
                    data.put("isAdminMember", role == GroupRole.ADMIN);
                    data.put("isEditorMember", role == GroupRole.EDITOR);
                    data.put("isViewerMember", role == GroupRole.VIEWER);
                    data.put("avatarColor", avatarColors[colorIndex % avatarColors.length]);
                    data.put("memberId", member.getUser().getId());
                    colorIndex++;
                    memberDisplayData.add(data);
                }
            }
            response.setMemberDisplayData(memberDisplayData);

            List<Map<String, String>> editableRoleOptions = new ArrayList<>();
            for (GroupRole role : GroupRole.assignableByAdmin()) {
                Map<String, String> option = new HashMap<>();
                option.put("value", role.getValue());
                option.put("label", role.getLabel());
                editableRoleOptions.add(option);
            }
            response.setEditableRoleOptions(editableRoleOptions);

            if (req.getMsg() != null) response.setSuccessMessage(req.getMsg());
            if (req.getError() != null) response.setErrorMessage(req.getError());

            return response;
        } catch (NumberFormatException e) {
            response.setRedirectUrl("/groups?error=Invalid group ID");
            return response;
        }
    }

    public GroupMemberActionResponse executeGroupMemberAction(GroupMemberActionRequest req) {
        try {
            int groupId = Integer.parseInt(req.getGroupIdStr());
            Group group = groupDAO.findById(groupId);

            if (group == null) {
                return new GroupMemberActionResponse("/groups?error=Group not found");
            }

            boolean isAdmin = (group.getUserId() == req.getUserId());

            if ("leaveGroup".equals(req.getAction())) {
                if (isAdmin) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Admin cannot leave the group. Delete the group instead.");
                }
                boolean isMember = groupMemberDAO.isUserMember(groupId, req.getUserId());
                if (!isMember) {
                    return new GroupMemberActionResponse("/groups?error=You are not a member of this group");
                }
                boolean removed = groupMemberDAO.deleteGroupMember(groupId, req.getUserId());
                if (removed) {
                    return new GroupMemberActionResponse("/groups?msg=You have left the group");
                } else {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Failed to leave group");
                }
            }

            if (!isAdmin) {
                return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Only admin can manage roles");
            }

            if ("updateRole".equals(req.getAction())) {
                if (req.getMemberIdStr() == null || req.getNewRole() == null) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Missing parameters");
                }
                GroupRole requestedRole = GroupRole.fromValue(req.getNewRole());
                if (requestedRole == null || !requestedRole.isAssignableByAdmin()) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Invalid role. Must be " + GroupRole.assignableRoleSummary());
                }
                int memberId = Integer.parseInt(req.getMemberIdStr());
                if (memberId == req.getUserId()) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Cannot change your own role");
                }
                GroupRole currentRole = GroupRole.fromValue(groupMemberDAO.getMemberRole(groupId, memberId));
                if (currentRole == GroupRole.ADMIN) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Cannot change admin role");
                }
                boolean updated = groupMemberDAO.updateMemberRole(groupId, memberId, requestedRole.getValue());
                if (updated) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&msg=Role updated successfully");
                } else {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Failed to update role");
                }
            } else if ("removeMember".equals(req.getAction())) {
                if (req.getMemberIdStr() == null) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Missing member ID");
                }
                int memberId = Integer.parseInt(req.getMemberIdStr());
                if (memberId == req.getUserId()) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Cannot remove yourself");
                }
                boolean removed = groupMemberDAO.deleteGroupMember(groupId, memberId);
                if (removed) {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&msg=Member removed successfully");
                } else {
                    return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId + "&error=Failed to remove member");
                }
            }

            return new GroupMemberActionResponse("/groupmembers?groupId=" + groupId);
        } catch (NumberFormatException e) {
            return new GroupMemberActionResponse("/groups?error=Invalid parameters");
        }
    }

    private void sendGroupJoinNotificationToAdmin(int groupId, int joinedUserId) {
        try {
            Integer adminUserId = notificationDAO.getGroupOwnerUserId(groupId);
            if (adminUserId == null) {
                return;
            }
            String joinedUsername = notificationDAO.getUsernameByUserId(joinedUserId);
            String displayName = (joinedUsername != null && !joinedUsername.trim().isEmpty()) ? joinedUsername : "A user";
            notificationDAO.createNotification(
                    adminUserId,
                    "group_member_joined",
                    "New Group Member",
                    displayName + " joined your group.",
                    "/groupmembers?groupId=" + groupId,
                    joinedUserId
            );
        } catch (Exception e) {
            System.err.println("[WARN GroupService] Failed to send group join notification: " + e.getMessage());
        }
    }

    private void sendGroupAnnouncementNotifications(int groupId, int actorUserId, String announcementTitle) {
        try {
            List<Integer> recipients = notificationDAO.getGroupNotificationRecipients(groupId);
            if (recipients == null || recipients.isEmpty()) {
                return;
            }
            String actorUsername = notificationDAO.getUsernameByUserId(actorUserId);
            String displayName = (actorUsername != null && !actorUsername.trim().isEmpty()) ? actorUsername : "Someone";
            String title = "New Group Announcement";
            String message = displayName + " posted a new announcement: " + announcementTitle;
            String link = "/groupannouncement?groupId=" + groupId;
            for (Integer recipientId : recipients) {
                notificationDAO.createNotification(
                        recipientId,
                        "group_announcements",
                        title,
                        message,
                        link,
                        actorUserId
                );
            }
        } catch (Exception e) {
            System.err.println("[WARN GroupService] Failed to send announcement notifications: " + e.getMessage());
        }
    }
}
