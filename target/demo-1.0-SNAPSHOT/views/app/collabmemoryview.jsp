<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/collabmemoryviewer.css">
</head>
<body>

<div class="memory-viewer-wrapper">
    <div class="memory-viewer-container">

        <!-- Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-album" id="prevAlbum">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <h1 class="memory-title" id="memoryTitle">Collab Vacation Album</h1>
            <button class="nav-btn next-album" id="nextAlbum">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Collaborators Bar -->
        <div class="collaborators-bar">
            <div class="collaborators-list" id="collaboratorsList"></div>
            <button class="see-all-btn" id="seeAllBtn">See All</button>
        </div>

        <!-- Photo Viewer -->
        <div class="photo-viewer">
            <button class="arrow-btn left-arrow" id="prevPhoto">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
            </button>

            <div class="photo-container" id="photoContainer">
                <img src="" alt="Memory Photo" id="mainPhoto" class="main-photo">
            </div>

            <button class="arrow-btn right-arrow" id="nextPhoto">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
        </div>

        <!-- Photo Info -->
        <div class="photo-info">
            <div class="info-left">
                <p class="photo-date" id="photoDate"></p>
                <p class="photo-description" id="photoDescription"></p>
            </div>
        </div>

        <!-- Interactions -->
        <div class="interactions-bar">
            <button class="interaction-btn like-btn" id="likeBtn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
                <span id="likeCount">23</span>
            </button>
            <button class="interaction-btn comment-btn" id="commentBtn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <span id="commentCount">5</span>
            </button>
            <button class="interaction-btn share-btn" id="shareBtn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                    <polyline points="17 6 23 6 23 12"></polyline>
                </svg>
                <span id="shareCount">2</span>
            </button>
        </div>

        <!-- Comments -->
        <div class="comments-section" id="commentsSection">
            <h3 class="comments-title">Comments</h3>
            <div class="comments-list" id="commentsList"></div>
            <div class="comment-input-container">
                <div class="comment-avatar"></div>
                <input type="text" class="comment-input" placeholder="Add a comment..." id="commentInput">
                <button class="send-comment-btn" id="sendCommentBtn">➤</button>
            </div>
        </div>
    </div>
</div>

<!-- Collaborators Popup -->
<div class="modal-overlay" id="collabModal">
    <div class="modal-box">
        <h2>Collaborators</h2>
        <div class="modal-collab-list" id="modalCollabList"></div>
        <div class="add-collab">
            <input type="text" id="newCollabName" placeholder="Enter name to add">
            <button id="addCollabBtn">Add</button>
        </div>
        <button class="close-modal-btn" id="closeModalBtn">Close</button>
    </div>
</div>

<jsp:include page="../public/footer.jsp" />

<script>
    class CollabMemoryViewer {
        constructor() {
            this.albums = this.getAlbums();
            this.currentAlbumIndex = 0;
            this.currentPhotoIndex = 0;
            this.isLiked = false;

            // ✅ Updated collaborator avatars (real people photos from Unsplash)
            this.collaborators = [
                { id: 1, name: "Emma", avatar: "https://images.unsplash.com/photo-1595152772835-219674b2a8a6?w=100" },
                { id: 2, name: "Liam", avatar: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100" },
                { id: 3, name: "Olivia", avatar: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100" },
                { id: 4, name: "Noah", avatar: "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?w=100" },
                { id: 5, name: "Sophia", avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100" },
            ];

            this.initElements();
            this.attachListeners();
            this.loadAlbum(0);
            this.renderCollaborators();
        }

        getAlbums() {
            return [
                {
                    id: 1,
                    title: "Collab Vacation Album",
                    photos: [
                        {
                            url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
                            date: "Aug 10, 2023",
                            location: "Malibu, CA",
                            description: "Team trip to the beach! Collaboration, fun, and sunshine ☀️",
                            likes: 20,
                            comments: [{ author: "Emma", time: "2d", text: "Such great memories!" }],
                            shares: 2
                        },
                        {
                            url: "https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=1200",
                            date: "Aug 12, 2023",
                            location: "Los Angeles, CA",
                            description: "City night lights and laughter 🌃✨",
                            likes: 30,
                            comments: [{ author: "Liam", time: "1d", text: "That skyline was stunning!" }],
                            shares: 4
                        },
                        {
                            url: "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1200",
                            date: "Aug 14, 2023",
                            location: "Santa Monica, CA",
                            description: "Last day at the pier 🎡 unforgettable!",
                            likes: 25,
                            comments: [{ author: "Olivia", time: "3h", text: "We should go again soon!" }],
                            shares: 3
                        }
                    ]
                }
            ];
        }

        initElements() {
            this.titleEl = document.getElementById("memoryTitle");
            this.photoEl = document.getElementById("mainPhoto");
            this.dateEl = document.getElementById("photoDate");
            this.descEl = document.getElementById("photoDescription");
            this.likeBtn = document.getElementById("likeBtn");
            this.likeCount = document.getElementById("likeCount");
            this.commentCount = document.getElementById("commentCount");
            this.shareCount = document.getElementById("shareCount");
            this.commentsList = document.getElementById("commentsList");
            this.commentInput = document.getElementById("commentInput");
            this.seeAllBtn = document.getElementById("seeAllBtn");
            this.modal = document.getElementById("collabModal");
            this.modalList = document.getElementById("modalCollabList");
            this.newCollabName = document.getElementById("newCollabName");
        }

        attachListeners() {
            document.getElementById("prevAlbum").onclick = () => this.loadAlbum(this.currentAlbumIndex - 1);
            document.getElementById("nextAlbum").onclick = () => this.loadAlbum(this.currentAlbumIndex + 1);
            document.getElementById("prevPhoto").onclick = () => this.loadPhoto(this.currentPhotoIndex - 1);
            document.getElementById("nextPhoto").onclick = () => this.loadPhoto(this.currentPhotoIndex + 1);
            this.likeBtn.onclick = () => this.toggleLike();
            document.getElementById("sendCommentBtn").onclick = () => this.addComment();
            this.commentInput.addEventListener("keypress", e => { if (e.key === "Enter") this.addComment(); });
            this.seeAllBtn.onclick = () => this.openModal();
            document.getElementById("closeModalBtn").onclick = () => this.closeModal();
            document.getElementById("addCollabBtn").onclick = () => this.addCollaborator();
        }

        loadAlbum(index) {
            if (index < 0 || index >= this.albums.length) return;
            this.currentAlbumIndex = index;
            const album = this.albums[index];
            this.titleEl.textContent = album.title;
            this.loadPhoto(0);
        }

        loadPhoto(index) {
            const album = this.albums[this.currentAlbumIndex];
            if (index < 0 || index >= album.photos.length) return;
            this.currentPhotoIndex = index;
            const photo = album.photos[index];
            this.photoEl.src = photo.url;
            this.dateEl.textContent = `${photo.date} · ${photo.location}`;
            this.descEl.textContent = photo.description;
            this.likeCount.textContent = photo.likes;
            this.commentCount.textContent = photo.comments.length;
            this.shareCount.textContent = photo.shares;
            this.renderComments(photo.comments);
        }

        renderComments(comments) {
            this.commentsList.innerHTML = comments.length
                ? comments.map(c => `
                <div class="comment-item">
                    <div class="comment-avatar"></div>
                    <div class="comment-content">
                        <div class="comment-header">
                            <span class="comment-author">${c.author}</span>
                            <span class="comment-time">${c.time}</span>
                        </div>
                        <p class="comment-text">${c.text}</p>
                    </div>
                </div>
            `).join("")
                : '<p class="no-comments">No comments yet.</p>';
        }

        toggleLike() {
            this.isLiked = !this.isLiked;
            const photo = this.albums[this.currentAlbumIndex].photos[this.currentPhotoIndex];
            photo.likes += this.isLiked ? 1 : -1;
            this.likeCount.textContent = photo.likes;
            this.likeBtn.classList.toggle("liked", this.isLiked);
        }

        addComment() {
            const text = this.commentInput.value.trim();
            if (!text) return;
            const photo = this.albums[this.currentAlbumIndex].photos[this.currentPhotoIndex];
            photo.comments.push({ author: "You", time: "Just now", text });
            this.commentInput.value = "";
            this.renderComments(photo.comments);
            this.commentCount.textContent = photo.comments.length;
        }

        renderCollaborators() {
            const preview = this.collaborators.slice(0, 4).map(c => `
            <div class="collab-avatar" title="${c.name}" style="background-image:url('${c.avatar}')"></div>
        `).join("");
            document.getElementById("collaboratorsList").innerHTML = preview;
        }

        openModal() {
            this.modal.style.display = "flex";
            this.renderModalList();
        }

        closeModal() {
            this.modal.style.display = "none";
        }

        renderModalList() {
            this.modalList.innerHTML = this.collaborators.map(c => `
            <div class="modal-collab-item">
                <div class="collab-avatar" style="background-image:url('${c.avatar}')"></div>
                <span>${c.name}</span>
                <button onclick="viewer.removeCollaborator(${c.id})">Remove</button>
            </div>
        `).join("");
        }

        addCollaborator() {
            const name = this.newCollabName.value.trim();
            if (!name) return;
            const newId = this.collaborators.length + 1;
            this.collaborators.push({ id: newId, name, avatar: "https://source.unsplash.com/40x40/?portrait&" + name });
            this.newCollabName.value = "";
            this.renderCollaborators();
            this.renderModalList();
        }

        removeCollaborator(id) {
            this.collaborators = this.collaborators.filter(c => c.id !== id);
            this.renderCollaborators();
            this.renderModalList();
        }
    }

    let viewer;
    document.addEventListener("DOMContentLoaded", () => viewer = new CollabMemoryViewer());
</script>

</body>
</html>
