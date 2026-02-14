# Everly — Full Architectural Design Document

> **Last Updated:** February 14, 2026  
> **Stack:** Java Servlets (Jakarta EE), JSP, PostgreSQL, JDBC

---

## Table of Contents

1. [High-Level Architecture](#1-high-level-architecture)
2. [Request Lifecycle](#2-request-lifecycle)
3. [Core Infrastructure Files](#3-core-infrastructure-files)
4. [Feature 1 — Memories](#4-feature-1--memories)
5. [Feature 2 — Journals](#5-feature-2--journals)
6. [Feature 3 — Autographs](#6-feature-3--autographs)
7. [Feature 4 — Events](#7-feature-4--events)
8. [Feature 5 — Feed (Public Social Feed)](#8-feature-5--feed-public-social-feed)
9. [Feature 6 — Groups](#9-feature-6--groups)
10. [Additional Logic (Non-CRUD)](#10-additional-logic-non-crud)

---

## 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT (Browser)                        │
│                    JSP Pages + JavaScript                       │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTP Request
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                     web.xml Configuration                       │
│              (Servlet Mappings + Filter Mappings)                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   AuthenticationFilter (/*}                     │
│         Checks session validity via SessionUtil                 │
│     Public paths bypass → Protected paths require login         │
│              File: filter/AuthenticationFilter.java             │
└────────────────────────────┬────────────────────────────────────┘
                             │ (if authenticated)
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              FrontControllerServlet (mapped to /)               │
│    Routes URLs to either JSP views or View Controllers          │
│       File: middleware/FrontControllerServlet.java               │
└──────────┬──────────────────────────────┬───────────────────────┘
           │                              │
     Static JSP Route              Controller Route
     (no data needed)             (data fetching needed)
           │                              │
           ▼                              ▼
┌──────────────────┐        ┌──────────────────────────┐
│   JSP View File  │        │   ViewController Servlet │
│  (direct render) │        │  (fetches data, sets     │
│                  │        │   request attrs, then    │
│                  │        │   forwards to JSP)       │
└──────────────────┘        └────────────┬─────────────┘
                                         │
                                         ▼
                            ┌──────────────────────────┐
                            │     Service Layer         │
                            │  (Business logic,         │
                            │   ownership checks)       │
                            └────────────┬─────────────┘
                                         │
                                         ▼
                            ┌──────────────────────────┐
                            │       DAO Layer           │
                            │  (SQL queries via JDBC)   │
                            └────────────┬─────────────┘
                                         │
                                         ▼
                            ┌──────────────────────────┐
                            │   DatabaseUtil.java       │
                            │  (Connection management)  │
                            └────────────┬─────────────┘
                                         │
                                         ▼
                            ┌──────────────────────────┐
                            │     PostgreSQL Database   │
                            └──────────────────────────┘
```

### Layer Responsibilities

| Layer | Purpose | Location |
|-------|---------|----------|
| **Filter** | Authentication gate — blocks unauthenticated access | `filter/AuthenticationFilter.java` |
| **FrontController** | URL-to-resource routing (JSP or ViewController) | `middleware/FrontControllerServlet.java` |
| **ViewController** | GET handlers — loads data then forwards to JSP | `controller/{Feature}/{Feature}ViewController.java` |
| **Action Servlet** | POST handlers — Create/Update/Delete operations | `controller/{Feature}/Create*.java`, etc. |
| **Service** | Business logic, ownership verification | `service/*.java` |
| **DAO** | Raw SQL queries, ResultSet mapping | `dao/*.java` |
| **Model** | POJOs with getters/setters | `model/*.java` |
| **Util** | Database connections, encryption, sessions, passwords | `util/*.java` |

---

## 2. Request Lifecycle

### Example: User navigates to `/memories`

```
1. Browser → GET /memories
2. web.xml → AuthenticationFilter intercepts (mapped to /*)
3. AuthenticationFilter → SessionUtil.isValidSession(req) checks session
4. If invalid → redirect to /login
5. If valid → chain.doFilter() passes through
6. FrontControllerServlet (mapped to /) catches the request
7. handleRequest() checks path "/memories"
8. Special route match → forwards to /memoriesview (internal)
9. web.xml maps /memoriesview → MemoriesServlet.class
10. MemoriesServlet.doGet() runs:
    a. Gets user_id from session
    b. Calls memoryDAO.getMemoriesByUserId(userId)
    c. For each memory, calls mediaDAO.getMediaByMemoryId(memoryId)
    d. Sets request attributes ("memories", "cover_X")
    e. Forwards to /views/app/memories.jsp
11. JSP renders HTML response to browser
```

### Example: User creates a memory (POST)

```
1. Browser → POST /createMemory (form with multipart data)
2. AuthenticationFilter → validates session
3. FrontControllerServlet → POST route match → forwards to /createMemoryServlet
4. web.xml maps /createMemoryServlet → CreateMemoryServlet.class
5. CreateMemoryServlet.doPost() runs:
    a. Gets user_id from session
    b. Reads form params (title, description, groupId)
    c. Creates Memory object, calls memoryDAO.createMemory(memory)
    d. Processes uploaded files (multipart):
       - Encrypts file with EncryptionService
       - Saves encrypted file to disk (media_uploads/)
       - Creates MediaItem, calls mediaDAO.createMediaItem(mediaItem, iv)
       - Stores encryption key via mediaDAO.storeMediaEncryptionKey()
       - Links media to memory via memoryDAO.linkMediaToMemory()
    e. Redirects to /memoryview?id=X or /memories
```

---

## 3. Core Infrastructure Files

### 3.1 Configuration

| File | Purpose |
|------|---------|
| `WEB-INF/web.xml` | All servlet declarations, servlet-mappings, filter-mappings, multipart configs, context params |
| `resources/config/db.properties` | Database connection URL, username, password |

### 3.2 Filter & Middleware

| File | Class | Purpose |
|------|-------|---------|
| `filter/AuthenticationFilter.java` | `AuthenticationFilter` | Intercepts all requests (`/*`). Maintains a `publicPaths` set. Validates session via `SessionUtil.isValidSession()`. Redirects unauthenticated users to `/login`. |
| `middleware/FrontControllerServlet.java` | `FrontControllerServlet` | Mapped to `/`. Contains two maps: `routeToJsp` (static pages) and `routeToController` (data-fetching pages). Also has hardcoded special routes for `/memories`, `/memoryview`, `/editmemory`, etc. |

### 3.3 Utility Classes

| File | Class | Key Methods |
|------|-------|-------------|
| `util/DatabaseUtil.java` | `DatabaseUtil` | `getConnection()` — returns JDBC Connection from db.properties |
| `util/SessionUtil.java` | `SessionUtil` | `isValidSession(req)` — validates session against database |
| `util/EncryptionService.java` | `EncryptionService` | AES encryption/decryption for media files |
| `util/PasswordUtil.java` | `PasswordUtil` | Password hashing and verification |

### 3.4 Service Layer

| File | Class | Purpose |
|------|-------|---------|
| `service/AuthService.java` | `AuthService` | `isValidSession()`, `getUserId()`, `getSession()` — wraps SessionUtil |
| `service/MemoryService.java` | `MemoryService` | `getMemoriesByUserId()`, `getMemoryById(id, userId)` with ownership check |
| `service/JournalService.java` | `JournalService` | `getJournalsByUserId()`, `getJournalById(id, userId)`, streak helpers |
| `service/AutographService.java` | `AutographService` | `getAutographsByUserId()`, `getAutographById(id, userId)` |
| `service/EventService.java` | `EventService` | `getAllEvents()`, `getUpcomingEvents()`, `getPastEvents()`, `getEventByIdWithPermission()` |
| `service/GroupService.java` | `GroupService` | `getGroupsByUserId()`, `getGroupById(id, userId)` |

---

## 4. Feature 1 — Memories

### Model: `model/Memory.java`

| Field | Type | Description |
|-------|------|-------------|
| `memoryId` | `int` | Primary key |
| `title` | `String` | Memory title |
| `description` | `String` | Memory description |
| `userId` | `int` | Owner user ID |
| `groupId` | `Integer` | Nullable — if set, this is a group memory |
| `coverMediaId` | `Integer` | Cover image media ID |
| `isPublic` | `boolean` | Public visibility flag |
| `isCollaborative` | `boolean` | Collaborative memory flag |
| `collabShareKey` | `String` | Share key for collab invite links |
| `shareKey` | `String` | Link sharing key |
| `createdTimestamp` | `Timestamp` | Creation time |

### Model: `model/MediaItem.java`

| Field | Type | Description |
|-------|------|-------------|
| `mediaId` | `int` | Primary key |
| `userId` | `int` | Uploader user ID |
| `fileName`, `filePath`, `fileType` | `String` | File metadata |
| `encryptionKeyId` | `String` | Reference to encryption key |

### DAO: `dao/memoryDAO.java`

| Method | Description |
|--------|-------------|
| `createMemory(Memory)` | INSERT into memories table, returns generated ID |
| `getMemoryById(int)` | SELECT by ID |
| `getMemoriesByUserId(int)` | SELECT all (non-vault) for user |
| `getMemoriesByGroupId(int)` | SELECT all for a group |
| `updateMemory(Memory)` | UPDATE title, description, etc. |
| `deleteMemory(int)` | DELETE by ID |
| `linkMediaToMemory(memoryId, mediaId)` | INSERT into memory_media junction |
| `unlinkMediaFromMemory(memoryId, mediaId)` | DELETE from memory_media |
| `setCoverMedia(memoryId, mediaId)` | UPDATE cover_media_id |
| `moveToVault(memoryId, userId)` | Set is_vault = true |
| `getCollabMemoriesByUserId(int)` | SELECT collaborative memories |
| `createCollabMemory(Memory)` | INSERT with is_collaborative = true |
| `setCollabShareKey(memoryId, key)` | UPDATE collab_share_key |

### DAO: `dao/MediaDAO.java`

| Method | Description |
|--------|-------------|
| `createMediaItem(MediaItem, iv)` | INSERT media record + encryption IV |
| `storeMediaEncryptionKey(keyId, userId, encKey, iv)` | INSERT into encryption_keys |
| `getMediaById(int)` | SELECT media by ID |
| `getMediaByMemoryId(int)` | SELECT all media for a memory |
| `getMediaByUserId(int)` | SELECT all media for a user |
| `deleteMediaItem(int)` | DELETE media record |
| `getMediaEncryptionKey(keyId, userId)` | SELECT encryption key for decryption |

---

### 4.1 CREATE Memory

```
Route:  POST /createMemory
Mapped: FrontController → /createMemoryServlet
Servlet: controller/Memory/CreateMemoryServlet.java
```

**Flow:**
1. `doPost()` gets `user_id` from session
2. Reads form params: `title`, `description`, `groupId`
3. Creates `Memory` object → `memoryDAO.createMemory(memory)` → returns generated `memoryId`
4. Iterates over file parts (`request.getParts()`):
   - Generates unique filename (UUID)
   - Encrypts file via `EncryptionService`
   - Saves encrypted bytes to `media_uploads/` directory
   - Creates `MediaItem` → `mediaDAO.createMediaItem(item, iv)`
   - Stores encryption key → `mediaDAO.storeMediaEncryptionKey()`
   - Links media → `memoryDAO.linkMediaToMemory(memoryId, mediaId)`
5. Sets first media as cover → `memoryDAO.setCoverMedia()`
6. Redirects to `/memoryview?id=X`

**Files involved:**
- `controller/Memory/CreateMemoryServlet.java` — main handler
- `dao/memoryDAO.java` — `createMemory()`, `linkMediaToMemory()`, `setCoverMedia()`
- `dao/MediaDAO.java` — `createMediaItem()`, `storeMediaEncryptionKey()`
- `util/EncryptionService.java` — file encryption
- `model/Memory.java`, `model/MediaItem.java` — data models

### 4.2 READ Memory (List)

```
Route:  GET /memories
Mapped: FrontController → /memoriesview
Servlet: controller/Memory/MemoriesServlet.java
View:   views/app/memories.jsp
```

**Flow:**
1. `doGet()` gets `user_id` from session
2. `memoryDAO.getMemoriesByUserId(userId)` → `List<Memory>`
3. For each memory: `mediaDAO.getMediaByMemoryId(memoryId)` → sets cover URL as request attribute
4. Sets `request.setAttribute("memories", memories)`
5. Forwards to `memories.jsp`

### 4.3 READ Memory (Single View)

```
Route:  GET /memoryview?id=X
Mapped: FrontController → /memoryViewServlet
Servlet: controller/Memory/MemoryViewServlet.java
View:   views/app/memoryview.jsp
```

**Flow:**
1. `doGet()` parses `id` param, gets `user_id` from session
2. `memoryDAO.getMemoryById(memoryId)` → `Memory`
3. Checks access: owner check + group membership check via `groupMemberDAO.isUserMember()`
4. `mediaDAO.getMediaByMemoryId(memoryId)` → `List<MediaItem>`
5. Sets attributes: `memory`, `mediaItems`, `isGroupMemory`, `canEdit`, `userRole`, `isAdmin`
6. Forwards to `memoryview.jsp`

### 4.4 UPDATE Memory

```
Route:  GET /editmemory?id=X → loads edit form
Mapped: FrontController → /editMemoryServlet
Servlet: controller/Memory/EditMemoryServlet.java (GET - loads form)
View:   views/app/editmemory.jsp

Route:  POST /updatememory
Mapped: FrontController → /updateMemoryServlet
Servlet: controller/Memory/UpdateMemoryServlet.java (POST - saves changes)
```

**GET Flow (load form):**
1. Fetches memory, checks permissions (owner or group editor/admin)
2. Fetches existing media items
3. Forwards to `editmemory.jsp`

**POST Flow (save changes):**
1. Reads updated title, description
2. Handles new file uploads (encrypt → save → create MediaItem → link)
3. Handles media removals (`remove_media_X` params → `memoryDAO.unlinkMediaFromMemory()` + `mediaDAO.deleteMediaItem()`)
4. `memoryDAO.updateMemory(memory)`
5. Redirects to `/memoryview?id=X`

### 4.5 DELETE Memory

```
Route:  POST /deletememory?id=X
Mapped: FrontController → /deleteMemoryServlet
Servlet: controller/Memory/DeleteMemoryServlet.java
```

**Flow:**
1. Fetches memory, checks permissions (owner or group admin/editor)
2. Gets all media items → deletes physical files from disk
3. Deletes media records: `mediaDAO.deleteMediaItem()`
4. Deletes memory: `memoryDAO.deleteMemory(memoryId)` (cascades junction table)
5. Redirects to `/memories` or `/groupmemories?groupId=X`

---

## 5. Feature 2 — Journals

### Model: `model/Journal.java`

| Field | Type | Description |
|-------|------|-------------|
| `journalId` | `int` | Primary key |
| `title` | `String` | Auto-generated date title (e.g., "14th February 2026") |
| `content` | `String` | JSON containing `htmlContent` + `decorations` |
| `userId` | `int` | Owner user ID |
| `journalPic` | `String` | Optional image |

### Model: `model/JournalStreak.java`

Tracks daily journaling streaks (current streak, longest streak, last entry date).

### DAO: `dao/JournalDAO.java`

| Method | Description |
|--------|-------------|
| `createJournal(Journal)` | INSERT new journal |
| `findById(int)` | SELECT by ID |
| `findByUserId(int)` | SELECT all (non-vault) for user |
| `getJournalCount(int)` | COUNT for user |
| `updateJournal(Journal)` | UPDATE title, content |
| `deleteJournalToRecycleBin(journalId, userId)` | Soft delete → moves to recycle_bin table |
| `restoreJournalFromRecycleBin(recycleBinId, userId)` | Restore from recycle bin |
| `moveToVault(journalId, userId)` | Move to vault |

### DAO: `dao/JournalStreakDAO.java`

| Method | Description |
|--------|-------------|
| `getStreakByUserId(int)` | Get current streak info |
| `updateStreakOnNewEntry(userId, date)` | Increment streak on journal creation |
| `checkAndUpdateStreakStatus(userId)` | Reset streak if day missed |

### ViewController: `controller/Journals/JournalViewController.java`

Mapped to `/journalsview` in web.xml. Routes by `action` param:
- **No action** → `handleListJournals()` → `journals.jsp`
- **`action=view&id=X`** → `handleViewJournal()` → `journalview.jsp`
- **`action=edit&id=X`** → `handleEditJournal()` → `editjournal.jsp`

Uses `AuthService` + `JournalService` for session validation and data fetching.

### 5.1 CREATE Journal

```
Route:  POST /createjournal
Servlet: controller/Journals/CreateJournalServlet.java
```

**Flow:**
1. Gets `content` (HTML) and `decorations` (JSON) from form
2. Auto-generates title from current date via `generateDateTitle()`
3. Combines into JSON via `buildCompleteJournalContent()`
4. `journalDAO.createJournal(journal)` → saves to DB
5. `streakDAO.updateStreakOnNewEntry(userId, today)` → updates streak
6. Redirects to `/journals`

### 5.2 READ Journals

```
Route:  GET /journals → JournalViewController → handleListJournals()
Route:  GET /journalview?id=X → JournalViewController → handleViewJournal()
```

**List Flow:** `journalService.getJournalsByUserId()` + streak info → `journals.jsp`  
**View Flow:** `journalService.getJournalById(id, userId)` (ownership check) → `journalview.jsp`

### 5.3 UPDATE Journal

```
Route:  GET /editjournal?id=X → JournalViewController → handleEditJournal() → editjournal.jsp
Route:  POST /editjournal
Servlet: controller/Journals/EditJournalServlet.java
```

**POST Flow:** Reads updated content/decorations → `journalDAO.updateJournal(journal)` → redirects to `/journalview?id=X`

### 5.4 DELETE Journal

```
Route:  POST /deletejournal
Servlet: controller/Journals/DeleteJournalServlet.java
```

**Flow:** Soft-deletes to recycle bin via `journalDAO.deleteJournalToRecycleBin()` → redirects to `/journals`

---

## 6. Feature 3 — Autographs

### Model: `model/autograph.java`

| Field | Type | Description |
|-------|------|-------------|
| `autographId` | `int` | Primary key |
| `title` | `String` | Book title |
| `description` | `String` | Description |
| `userId` | `int` | Owner user ID |
| `autographPicUrl` | `String` | Cover image filename |
| `shareToken` | `String` | Token for sharing autograph books |

### Model: `model/AutographEntry.java`

Individual entries/signatures written inside an autograph book.

### DAO: `dao/autographDAO.java`

| Method | Description |
|--------|-------------|
| `createAutograph(autograph)` | INSERT new autograph book |
| `findById(int)` | SELECT by ID |
| `findByUserId(int)` | SELECT all for user |
| `updateAutograph(autograph)` | UPDATE title, description, cover |
| `deleteAutograph(int)` | Hard DELETE |
| `deleteAutographToRecycleBin(id, userId)` | Soft delete to recycle bin |
| `restoreAutographFromRecycleBin(binId, userId)` | Restore |
| `getOrCreateShareToken(int)` | Generate/get share token |
| `getAutographByShareToken(String)` | Lookup by share token |

### ViewController: `controller/Autographs/AutographViewController.java`

Mapped to `/autographsview`. Routes by `action` param:
- **No action** → `handleListAutographs()` → `autographcontent.jsp`
- **`action=view&id=X`** → `handleViewAutograph()` → `viewautograph.jsp`
- **`action=edit&id=X`** → `handleEditAutograph()` → `editautograph.jsp`

### 6.1 CREATE Autograph

```
Route:  POST /addautographservlet
Servlet: controller/Autographs/AddAutographServlet.java
```

**Flow:**
1. Gets `bookTitle`, `description`, cover image (`Part`)
2. Saves cover image to `dbimages/` directory
3. Creates `autograph` object → `autographDAO.createAutograph()`
4. Redirects to `/autographs`

### 6.2 READ Autographs

```
Route:  GET /autographs → AutographViewController → handleListAutographs()
Route:  GET /autographview?id=X → AutographViewController → handleViewAutograph()
```

Uses `AutographService` which wraps `autographDAO` with ownership checks.

### 6.3 UPDATE Autograph

```
Route:  GET /editautograph?id=X → AutographViewController → handleEditAutograph()
Route:  POST /updateautograph
Servlet: controller/Autographs/UpdateAutographServlet.java
```

**POST Flow:** Reads updated fields + optional new cover image → `autographDAO.updateAutograph()` → redirects

### 6.4 DELETE Autograph

```
Route:  POST /deleteautograph
Servlet: controller/Autographs/DeleteAutographServlet.java
```

**Flow:** Soft-deletes via `autographDAO.deleteAutographToRecycleBin()` → redirects to `/autographs`

---

## 7. Feature 4 — Events

### Model: `model/Event.java`

| Field | Type | Description |
|-------|------|-------------|
| `eventId` | `int` | Primary key |
| `title` | `String` | Event title |
| `description` | `String` | Event description |
| `eventDate` | `Timestamp` | When the event occurs |
| `location` | `String` | Event location |
| `groupId` | `int` | Associated group |
| `eventPicUrl` | `String` | Event cover image |

### DAO: `dao/EventDAO.java`

| Method | Description |
|--------|-------------|
| `createEvent(Event)` | INSERT, returns generated ID |
| `findById(int)` | SELECT by ID |
| `findByGroupId(int)` | SELECT all events for a group |
| `findByUserId(int)` | SELECT all events for groups user created |
| `findUpcomingEventsByUserId(int)` | SELECT future events |
| `findPastEventsByUserId(int)` | SELECT past events |
| `updateEvent(Event)` | UPDATE event details |
| `deleteEvent(int)` | DELETE event |
| `isUserGroupAdmin(int)` | Check if user owns any groups |

### ViewController: `controller/Events/EventViewController.java`

Mapped to `/eventsview`. Routes by `action` param:
- **No action** → `handleListEvents()` → `eventdashboard.jsp`
- **`action=create`** → `handleCreateEvent()` → `createevent.jsp`
- **`action=edit&event_id=X`** → `handleEditEvent()` → `editevent.jsp`

Uses `EventService` which wraps `EventDAO` + `GroupDAO` for permission checks.

### 7.1 CREATE Event

```
Route:  POST /saveEvent
Servlet: controller/Events/CreateEventServlet.java (multipart-config in web.xml)
```

**Flow:**
1. Reads form: title, description, date, location, groupId, event image
2. Validates user owns the group
3. Saves event image to uploads
4. `eventDAO.createEvent(event)` → returns generated ID
5. Redirects to `/events`

### 7.2 READ Events

```
Route:  GET /events → EventViewController → handleListEvents()
```

Fetches: `allEvents`, `upcomingEvents`, `pastEvents` counts → `eventdashboard.jsp`

### 7.3 UPDATE Event

```
Route:  GET /editevent?event_id=X → EventViewController → handleEditEvent()
Route:  POST /updateEvent
Servlet: controller/Events/UpdateEventServlet.java (multipart-config)
```

**POST Flow:** Reads updated fields, validates group ownership, handles image upload → `eventDAO.updateEvent()` → redirects

### 7.4 DELETE Event

```
Route:  POST /deleteEvent
Servlet: controller/Events/DeleteEventServlet.java
```

**Flow:** Validates ownership → `eventDAO.deleteEvent(eventId)` → redirects to `/events`

---

## 8. Feature 5 — Feed (Public Social Feed)

### Models

| Model | File | Key Fields |
|-------|------|------------|
| `FeedProfile` | `model/FeedProfile.java` | `feedProfileId`, `userId`, `feedUsername`, `displayName`, `bio`, `profilePicUrl` |
| `FeedPost` | `model/FeedPost.java` | `postId`, `feedProfileId`, `memoryId`, `caption`, `likeCount`, `mediaItems` |
| `FeedComment` | `model/FeedComment.java` | `commentId`, `postId`, `feedProfileId`, `content`, `parentCommentId` |
| `FeedFollow` | `model/FeedFollow.java` | `followId`, `followerProfileId`, `followingProfileId` |

### DAOs

| DAO | Key Methods |
|-----|-------------|
| `FeedProfileDAO` | `findByUserId()`, `findByUsername()`, `createProfile()`, `updateProfile()`, `deleteByUserId()` |
| `FeedPostDAO` | `createPost()`, `findById()`, `findAllPosts()`, `findByFeedProfileId()`, `deletePost()`, `isMemoryPosted()` |
| `FeedCommentDAO` | Add/delete/like/unlike comments, get replies |
| `FeedFollowDAO` | Follow/unfollow, get followers/following lists, recommended users |
| `FeedPostLikeDAO` | `likePost()`, `unlikePost()`, `toggleLike()`, `getLikeCount()`, `hasLikedPost()` |
| `SavedPostDAO` | Bookmark/unbookmark posts |

### 8.1 Feed Profile Setup

```
Route:  GET /feed → FeedViewController checks for profile
        If no profile → redirects to /feedWelcome → /feedProfileSetup
Route:  POST /feedProfileSetupServlet
Servlet: controller/FeedProfileSetupServlet.java
```

**Flow:** User sets username, display name, bio, profile pic → `feedProfileDAO.createProfile()` → redirect to `/feed`

### 8.2 CREATE Post

```
Route:  GET /createPost → CreatePostServlet.doGet() → shows memory selector
Route:  POST /createPostServlet
Servlet: controller/Feed/CreatePostServlet.java
```

**GET Flow:** Fetches user's memories, checks which are already posted → `selectMemoryForPost.jsp`  
**POST Flow:** Reads `memoryId`, `caption` → creates `FeedPost` → `feedPostDAO.createPost()` → redirects to `/feed`

### 8.3 READ Feed

```
Route:  GET /feed
Servlet: controller/Feed/FeedViewController.java
View:   views/app/publicfeed.jsp
```

**Flow:**
1. Checks for `FeedProfile` in session (or DB fallback)
2. `feedPostDAO.findAllPosts()` → all posts (FYP-style random)
3. For each post: loads media via `mediaDAO.getMediaByMemoryId()`, loads like data
4. `feedFollowDAO.getRecommendedUsers()` → sidebar suggestions
5. Forwards to `publicfeed.jsp`

### 8.4 Post Interactions (AJAX)

| Action | Servlet | Endpoint |
|--------|---------|----------|
| **Like/Unlike Post** | `Feed/PostLikeServlet.java` | `POST /postLike` (`@WebServlet`) |
| **Add Comment** | `Feed/FeedCommentServlet.java` | `POST /feedComments?action=add` |
| **Delete Comment** | `Feed/FeedCommentServlet.java` | `POST /feedComments?action=delete` |
| **Like Comment** | `Feed/FeedCommentServlet.java` | `POST /feedComments?action=like` |
| **Get Replies** | `Feed/FeedCommentServlet.java` | `POST /feedComments?action=getReplies` |
| **Follow/Unfollow** | `Feed/FollowServlet.java` | `POST /followUser` |
| **Save/Unsave Post** | `Feed/SavePostServlet.java` | `POST /savePost` |

All return JSON responses for AJAX consumption.

### 8.5 Feed Profile CRUD

| Operation | Route | Servlet |
|-----------|-------|---------|
| **View own profile** | `GET /publicprofile` | `Feed/FeedProfileViewController.java` → `publicprofile.jsp` |
| **Edit profile form** | `GET /feededitprofile` | `Feed/EditFeedProfileViewController.java` → `editpublicprofile.jsp` |
| **Update profile** | `POST /updateFeedProfile` | `Feed/UpdateFeedProfileServlet.java` |
| **View followers** | `GET /followers` | `Feed/FollowersViewController.java` |
| **View following** | `GET /following` | `Feed/FollowersViewController.java` |

---

## 9. Feature 6 — Groups

### Models

| Model | File | Key Fields |
|-------|------|------------|
| `Group` | `model/Group.java` | `groupId`, `name`, `description`, `userId` (owner), `groupUrl`, `groupPicUrl` |
| `GroupMember` | `model/GroupMember.java` | `groupId`, `userId`, `role` (admin/editor/viewer) |
| `GroupInvite` | `model/GroupInvite.java` | `inviteId`, `groupId`, `token`, `expiresAt` |
| `GroupAnnouncement` | `model/GroupAnnouncement.java` | `id`, `groupId`, `title`, `content`, `createdBy` |

### DAOs

| DAO | Key Methods |
|-----|-------------|
| `GroupDAO` | `createGroup()`, `findById()`, `findByUserId()`, `findGroupsByMemberId()`, `updateGroup()`, `deleteGroup()`, `getMemberCount()` |
| `GroupMemberDAO` | `isUserMember()`, `getMemberRole()`, `addMember()`, `removeMember()` |
| `GroupInviteDAO` | `createInvite()`, `findByToken()`, `isValidInvite()` |
| `GroupAnnouncementDAO` | CRUD for group announcements |

### ViewController: `controller/Groups/GroupViewController.java`

Mapped to `/groupsview`. Routes:
- **No action** → `handleListGroups()` → `groupdashboard.jsp`
- **`action=memories&groupId=X`** → `handleGroupMemories()` → `groupmemories.jsp`
- **`action=edit&groupId=X`** → `handleEditGroup()` → `editgroup.jsp`

### 9.1 CREATE Group

```
Route:  POST /creategroupservlet
Servlet: controller/Groups/CreateGroupServlet.java
```

### 9.2 READ Groups

```
Route:  GET /groups → GroupViewController → handleListGroups()
Route:  GET /groupmemories?groupId=X → GroupViewController → handleGroupMemories()
Route:  GET /groupmembers?groupId=X → GroupMembersServlet
```

### 9.3 UPDATE Group

```
Route:  GET /editgroup?groupId=X → GroupViewController → handleEditGroup()
Route:  POST /editgroupservlet
Servlet: controller/Groups/EditGroupServlet.java
```

### 9.4 DELETE Group

```
Route:  POST /deletegroupservlet
Servlet: controller/Groups/DeleteGroupServlet.java
```

Validates owner → `groupDAO.deleteGroup()` (cascading deletes members, invites, etc.)

### 9.5 Group Member Management

| Operation | Servlet | Endpoint |
|-----------|---------|----------|
| **View members** | `GroupMembersServlet.java` | `GET /groupmembers?groupId=X` |
| **Remove member** | `RemoveMemberServlet.java` | `POST /removememberservlet` |
| **Leave group** | `GroupMembersServlet.java` | `POST /groupmembersservlet?action=leaveGroup` |
| **Generate invite** | `GenerateInviteLinkServlet.java` | `POST /group/invite/generate` |
| **Join via invite** | `InviteServlet.java` | `GET /invite/{token}` |

### 9.6 Group Announcements

| Operation | Servlet | Endpoint |
|-----------|---------|----------|
| **List announcements** | `GroupAnnouncementServlet.java` | `GET /groupannouncement?groupId=X` |
| **Create announcement** | `CreateAnnouncementServlet.java` | `POST /createannouncementservlet` |
| **View announcement** | `ViewAnnouncementServlet.java` | `GET /viewannouncement?id=X` |

---

## 10. Additional Logic (Non-CRUD)

### 10.1 Media Encryption & Viewing

```
Servlet: controller/ViewMediaServlet.java
Route:   GET /viewMedia?mediaId=X
```

All uploaded media is AES-encrypted at rest. `ViewMediaServlet`:
1. Looks up `MediaItem` via `mediaDAO.getMediaById()`
2. Retrieves encryption key from `mediaDAO.getMediaEncryptionKey()`
3. Decrypts the master key using server's master password
4. Reads encrypted file, decrypts with media-specific key
5. Streams decrypted bytes to browser with correct `Content-Type`

### 10.2 Collaborative Memories

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| `CollabMemoriesServlet` | `/collabmemoriesview` | List collab memories for user |
| `CollabMemoryViewServlet` | `/collabmemoryviewservlet` | View single collab memory |
| `GenerateShareLinkServlet` | `/generateCollabShareLink` | Generate collab invite link |
| `JoinCollabServlet` | `/memoryinvite` | Join via collab share key |
| `LeaveCollabServlet` | `/leavecollab` | Leave collaborative memory |
| `RemoveCollabMemberServlet` | `/removecollabmember` | Owner removes a member |

Uses `MemoryMemberDAO` to track members in the `memory_member` table.

### 10.3 Vault System

Protected storage requiring a separate vault password.

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| `VaultSetupServlet` | `/vaultSetup` | Initial vault password creation |
| `VaultEntryServlet` | `/vaultentries` | Vault password verification |
| `VaultMemoriesServlet` | `/vaultmemories` | List vault memories |
| `VaultJournalsServlet` | `/vaultjournals` | List vault journals |
| `MoveToVaultServlet` | POST `/moveToVault` | Move memory/journal to vault |
| `ChangeVaultPasswordServlet` | POST | Change vault password |

Uses `VaultDAO` for vault password hash storage/verification.

### 10.4 Recycle Bin / Trash Management

| Servlet | Purpose |
|---------|---------|
| `Journals/RecycleBinServlet` | List items in recycle bin |
| `Journals/RestoreJournalServlet` | Restore journal from bin |
| `Autographs/RestoreAutographServlet` | Restore autograph from bin |
| `Journals/TrashManagementServlet` | Permanently delete or restore trash items |

Uses `RecycleBinDAO` for managing soft-deleted items.

### 10.5 Authentication & Session Management

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| `LoginServlet` | `POST /loginservlet` | Email/password login, creates session |
| `GoogleLoginServlet` | `GET /googlelogin` | Initiates Google OAuth flow |
| `GoogleCallback` | `GET /googlecallback` | Handles Google OAuth callback |
| `signupservlet` | `POST /signupservlet` | User registration |
| `LogoutServlet` | `/logoutservlet` | Invalidates session |
| `LinkedDevicesServlet` | `/linkeddevicesservlet` | Manage active sessions |

Uses `userDAO` for user CRUD and `userSessionDAO` for session persistence in database.

### 10.6 Profile Management

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| `editprofileservlet` | `POST /editprofileservlet` | Update user profile details |
| `ProfilePictureServlet` | | Handle profile picture uploads |
| `ProfileImageServlet` | | Serve profile images |

### 10.7 Link Sharing

| Servlet | Endpoint | Purpose |
|---------|----------|---------|
| `ShareAccessServlet` | | Handle shared memory link access |
| `MediaUploadServlet` | | Standalone media upload endpoint |

---

## Appendix: Complete File Index

### Controllers (`controller/`)

| Subdirectory | Files |
|-------------|-------|
| `Memory/` | `CreateMemoryServlet`, `MemoriesServlet`, `MemoryViewServlet`, `EditMemoryServlet`, `UpdateMemoryServlet`, `DeleteMemoryServlet`, `CollabMemoriesServlet`, `CollabMemoryViewServlet`, `GenerateShareLinkServlet`, `JoinCollabServlet`, `LeaveCollabServlet`, `RemoveCollabMemberServlet` |
| `Journals/` | `CreateJournalServlet`, `EditJournalServlet`, `DeleteJournalServlet`, `JournalViewController`, `RecycleBinServlet`, `RestoreJournalServlet`, `TrashManagementServlet` |
| `Autographs/` | `AddAutographServlet`, `UpdateAutographServlet`, `DeleteAutographServlet`, `AutographViewController`, `WriteAutographServlet`, `RestoreAutographServlet` |
| `Events/` | `CreateEventServlet`, `UpdateEventServlet`, `DeleteEventServlet`, `EventViewController` |
| `Feed/` | `FeedViewController`, `CreatePostServlet`, `FeedCommentServlet`, `CommentsViewController`, `PostLikeServlet`, `FollowServlet`, `FollowersViewController`, `FeedProfileViewController`, `EditFeedProfileViewController`, `UpdateFeedProfileServlet`, `SavePostServlet` |
| `Groups/` | `CreateGroupServlet`, `EditGroupServlet`, `DeleteGroupServlet`, `GroupViewController`, `GroupMembersServlet`, `RemoveMemberServlet`, `InviteServlet`, `GenerateInviteLinkServlet`, `GroupAnnouncementServlet`, `CreateAnnouncementServlet`, `ViewAnnouncementServlet`, `GroupProfileServlet` |
| `Settings/` | `LinkedDevicesViewController`, `EditProfileViewController` |
| Root | `LoginServlet`, `LogoutServlet`, `signupservlet`, `GoogleLoginServlet`, `GoogleCallback`, `editprofileservlet`, `FeedProfileSetupServlet`, `ViewMediaServlet`, `MediaUploadServlet`, `VaultSetupServlet`, `VaultEntryServlet`, `VaultMemoriesServlet`, `VaultJournalsServlet`, `MoveToVaultServlet`, `ChangeVaultPasswordServlet`, `LinkedDevicesServlet`, `ShareAccessServlet`, `ProfileImageServlet`, `ProfilePictureServlet`, `DebugServlet`, `MainServlet` |

### Models (`model/`)

`Memory`, `MediaItem`, `MediaShare`, `MemoryMember`, `Journal`, `JournalStreak`, `autograph`, `AutographEntry`, `AutographActivity`, `Event`, `Group`, `GroupMember`, `GroupInvite`, `GroupAnnouncement`, `FeedProfile`, `FeedPost`, `FeedComment`, `FeedFollow`, `user`, `UserSession`, `EncryptionKey`, `RecycleBinItem`

### DAOs (`dao/`)

`memoryDAO`, `MediaDAO`, `MemoryMemberDAO`, `JournalDAO`, `JournalStreakDAO`, `autographDAO`, `AutographEntryDAO`, `AutographActivityDAO`, `EventDAO`, `GroupDAO`, `GroupMemberDAO`, `GroupInviteDAO`, `GroupAnnouncementDAO`, `FeedPostDAO`, `FeedProfileDAO`, `FeedCommentDAO`, `FeedFollowDAO`, `FeedPostLikeDAO`, `SavedPostDAO`, `userDAO`, `userSessionDAO`, `VaultDAO`, `RecycleBinDAO`

### Services (`service/`)

`AuthService`, `MemoryService`, `JournalService`, `AutographService`, `EventService`, `GroupService`, `ProfileService`, `LinkedDeviceService`, `UserService`
