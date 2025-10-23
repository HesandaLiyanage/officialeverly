<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/memoryviewer.css">
    <style>
        /* Floating Action Buttons Container */
        .floating-buttons-memory-viewer {
            position: fixed;
            bottom: 30px; /* Adjusted for footer space */
            right: 30px; /* Adjusted for page margin */
            display: flex;
            flex-direction: column;
            gap: 12px;
            z-index: 1000; /* Ensure it's above other content */
        }

        /* Floating Button Base Style */
        .floating-btn-memory-viewer {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 24px;
            border: none;
            border-radius: 24px;
            font-family: "Plus Jakarta Sans", sans-serif;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            white-space: nowrap;
            box-shadow: 0 4px 14px rgba(154, 116, 216, 0.35); /* Default shadow */
        }

        .floating-btn-memory-viewer:hover {
            transform: translateY(-2px);
        }

        .floating-btn-memory-viewer:active {
            transform: translateY(0);
        }

        /* Edit Button Specific Style */
        .floating-btn-memory-viewer.edit-btn {
            background: #9A74D8; /* Primary purple */
            color: #ffffff;
        }

        .floating-btn-memory-viewer.edit-btn:hover {
            background: #8a64c8; /* Darker purple on hover */
            box-shadow: 0 6px 20px rgba(154, 116, 216, 0.45);
        }

        /* Delete Button Specific Style */
        .floating-btn-memory-viewer.delete-btn {
            background: #EADDFF; /* Light purple */
            color: #9A74D8; /* Purple text */
        }

        .floating-btn-memory-viewer.delete-btn:hover {
            background: #FFFFFF; /* White on hover */
            color: #8a64c8; /* Darker purple text on hover */
            box-shadow: 0 6px 20px rgba(234, 221, 255, 0.6);
        }
    </style>
</head>
<body>
<div class="memory-viewer-wrapper">
    <div class="memory-viewer-container">
        <!-- Navigation Header -->
        <div class="viewer-header">
            <button class="nav-btn prev-album" id="prevAlbum">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="15 18 9 12 15 6"></polyline>
                </svg>
                Previous
            </button>
            <h1 class="memory-title" id="memoryTitle">Family Vacation 2023</h1>
            <button class="nav-btn next-album" id="nextAlbum">
                Next
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"></polyline>
                </svg>
            </button>
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
                <p class="photo-date" id="photoDate">July 15, 2023 · Santa Monica, CA</p>
                <p class="photo-description" id="photoDescription">
                    Beach day with the besties! Sun, sand, and endless laughter. Couldn't ask for a better day with my favorite people. #beachday #friends #summer
                </p>
            </div>
        </div>
        <!-- Interactions Bar -->
        <div class="interactions-bar">
            <button class="interaction-btn like-btn" id="likeBtn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                </svg>
                <span id="likeCount">23</span>
            </button>
            <%--            <button class="interaction-btn comment-btn" id="commentBtn">--%>
            <%--                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">--%>
            <%--                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>--%>
            <%--                </svg>--%>
            <%--                <span id="commentCount">5</span>--%>
            <%--            </button>--%>
            <button class="interaction-btn share-btn" id="shareBtn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline>
                    <polyline points="17 6 23 6 23 12"></polyline>
                </svg>
                <span id="shareCount">2</span>
            </button>
        </div>
        <!-- Comments Section -->
        <div class="comments-section" id="commentsSection">
            <h3 class="comments-title">Comments</h3>
            <div class="comments-list" id="commentsList">
                <!-- Comments will be dynamically loaded -->
            </div>
            <div class="comment-input-container">
                <div class="comment-avatar"></div>
                <input type="text" class="comment-input" placeholder="Add a comment..." id="commentInput">
                <%--                <button class="send-comment-btn" id="sendCommentBtn">--%>
                <%--                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">--%>
                <%--                        <line x1="22" y1="2" x2="11" y2="13"></line>--%>
                <%--                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>--%>
                <%--                    </svg>--%>
                <%--                </button>--%>
            </div>
        </div>
    </div>
</div>

<!-- Floating Action Buttons -->
<div class="floating-buttons-memory-viewer">
    <a href="/editmemory" class="floating-btn-memory-viewer edit-btn">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
        </svg>
        Edit Memory
    </a>
    <button class="floating-btn-memory-viewer delete-btn" onclick="confirmDelete()">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 6h18"></path>
            <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
            <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
        </svg>
        Delete Memory
    </button>
</div>

<jsp:include page="../public/footer.jsp" />
<script>
    // Memory Viewer Application
    class MemoryViewer {
        constructor() {
            this.albums = this.getAlbums();
            this.currentAlbumIndex = 0;
            this.currentPhotoIndex = 0;
            this.isLiked = false;
            this.initializeElements();
            this.attachEventListeners();
            this.loadAlbum(this.currentAlbumIndex);
        }
        getAlbums() {
            return [
                {
                    id: 1,
                    title: "Family Vacation 2023",
                    photos: [
                        {
                            url: "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=1200",
                            date: "July 15, 2023",
                            location: "Santa Monica, CA",
                            description: "Beach day with the besties! Sun, sand, and endless laughter. Couldn't ask for a better day with my favorite people. #beachday #friends #summer",
                            likes: 23,
                            comments: [
                                { author: "Olivia Carter", time: "2d", text: "Looks like you guys had an amazing time! Wish I could have been there." },
                                { author: "Liam Turner", time: "1d", text: "The beach looks so beautiful! Great shot!" }
                            ],
                            shares: 2
                        },
                        {
                            url: " https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
                            date: "July 15, 2023",
                            location: "Santa Monica, CA",
                            description: "Sunset views that take your breath away. Perfect ending to a perfect day.",
                            likes: 31,
                            comments: [
                                { author: "Emma Wilson", time: "1d", text: "Stunning sunset! 🌅" }
                            ],
                            shares: 4
                        },
                        {
                            url: " https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200",
                            date: "July 16, 2023",
                            location: "Santa Monica, CA",
                            description: "Morning walks on the pier. The calm before the crowds.",
                            likes: 18,
                            comments: [],
                            shares: 1
                        }
                    ]
                },
                {
                    id: 2,
                    title: "Sarah's Birthday Party",
                    photos: [
                        {
                            url: " https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=1200",
                            date: "May 20, 2023",
                            location: "Home",
                            description: "Celebrating another year of amazing memories! Happy birthday to the best friend anyone could ask for! 🎉🎂",
                            likes: 45,
                            comments: [
                                { author: "Sarah Johnson", time: "3d", text: "Thank you so much! Best party ever! ❤️" },
                                { author: "Mike Davis", time: "3d", text: "Great party! Thanks for having us!" }
                            ],
                            shares: 3
                        },
                        {
                            url: " https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=1200",
                            date: "May 20, 2023",
                            location: "Home",
                            description: "The cake was almost too beautiful to eat. Almost.",
                            likes: 52,
                            comments: [
                                { author: "Lisa Chen", time: "2d", text: "That cake looks incredible! 🎂" }
                            ],
                            shares: 5
                        }
                    ]
                },
                {
                    id: 3,
                    title: "Weekend Getaway",
                    photos: [
                        {
                            url: " https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
                            date: "April 8, 2023",
                            location: "Mountain Resort",
                            description: "Sometimes you just need to escape to the mountains. Fresh air, beautiful views, and great company.",
                            likes: 28,
                            comments: [
                                { author: "Jack Thompson", time: "5d", text: "Looks like an amazing getaway!" }
                            ],
                            shares: 2
                        }
                    ]
                }
            ];
        }
        initializeElements() {
            this.titleEl = document.getElementById('memoryTitle');
            this.photoEl = document.getElementById('mainPhoto');
            this.dateEl = document.getElementById('photoDate');
            this.descriptionEl = document.getElementById('photoDescription');
            this.likeBtn = document.getElementById('likeBtn');
            this.likeCountEl = document.getElementById('likeCount');
            this.commentCountEl = document.getElementById('commentCount');
            this.shareCountEl = document.getElementById('shareCount');
            this.commentsListEl = document.getElementById('commentsList');
            this.commentInput = document.getElementById('commentInput');
        }
        attachEventListeners() {
            // Album navigation
            document.getElementById('prevAlbum').addEventListener('click', () => this.previousAlbum());
            document.getElementById('nextAlbum').addEventListener('click', () => this.nextAlbum());
            // Photo navigation
            document.getElementById('prevPhoto').addEventListener('click', () => this.previousPhoto());
            document.getElementById('nextPhoto').addEventListener('click', () => this.nextPhoto());
            // Keyboard navigation
            document.addEventListener('keydown', (e) => {
                if (e.key === 'ArrowLeft') this.previousPhoto();
                if (e.key === 'ArrowRight') this.nextPhoto();
            });
            // Interactions
            this.likeBtn.addEventListener('click', () => this.toggleLike());
            document.getElementById('sendCommentBtn').addEventListener('click', () => this.addComment());
            this.commentInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') this.addComment();
            });
        }
        loadAlbum(index) {
            if (index < 0 || index >= this.albums.length) return;
            this.currentAlbumIndex = index;
            this.currentPhotoIndex = 0;
            const album = this.albums[index];
            this.titleEl.textContent = album.title;
            this.titleEl.style.animation = 'fadeInUp 0.5s ease';
            this.loadPhoto(0);
        }
        loadPhoto(index) {
            const album = this.albums[this.currentAlbumIndex];
            if (index < 0 || index >= album.photos.length) return;
            this.currentPhotoIndex = index;
            const photo = album.photos[index];
            // Fade out
            this.photoEl.style.opacity = '0';
            setTimeout(() => {
                this.photoEl.src = photo.url;
                this.dateEl.textContent = `${photo.date} · ${photo.location}`;
                this.descriptionEl.textContent = photo.description;
                this.likeCountEl.textContent = photo.likes;
                this.commentCountEl.textContent = photo.comments.length;
                this.shareCountEl.textContent = photo.shares;
                this.isLiked = false;
                this.likeBtn.classList.remove('liked');
                this.renderComments(photo.comments);
                // Fade in
                this.photoEl.style.opacity = '1';
            }, 300);
        }
        renderComments(comments) {
            if (comments.length === 0) {
                this.commentsListEl.innerHTML = '<p class="no-comments">No comments yet. Be the first to comment!</p>';
                return;
            }
            this.commentsListEl.innerHTML = comments.map(comment => `
            <div class="comment-item">
                <div class="comment-avatar"></div>
                <div class="comment-content">
                    <div class="comment-header">
                        <span class="comment-author">${comment.author}</span>
                        <span class="comment-time">${comment.time}</span>
                    </div>
                    <p class="comment-text">${comment.text}</p>
                </div>
            </div>
        `).join('');
        }
        previousAlbum() {
            if (this.currentAlbumIndex > 0) {
                this.loadAlbum(this.currentAlbumIndex - 1);
            }
        }
        nextAlbum() {
            if (this.currentAlbumIndex < this.albums.length - 1) {
                this.loadAlbum(this.currentAlbumIndex + 1);
            }
        }
        previousPhoto() {
            const album = this.albums[this.currentAlbumIndex];
            if (this.currentPhotoIndex > 0) {
                this.loadPhoto(this.currentPhotoIndex - 1);
            }
        }
        nextPhoto() {
            const album = this.albums[this.currentAlbumIndex];
            if (this.currentPhotoIndex < album.photos.length - 1) {
                this.loadPhoto(this.currentPhotoIndex + 1);
            }
        }
        toggleLike() {
            this.isLiked = !this.isLiked;
            const album = this.albums[this.currentAlbumIndex];
            const photo = album.photos[this.currentPhotoIndex];
            if (this.isLiked) {
                photo.likes++;
                this.likeBtn.classList.add('liked');
            } else {
                photo.likes--;
                this.likeBtn.classList.remove('liked');
            }
            this.likeCountEl.textContent = photo.likes;
        }
        addComment() {
            const text = this.commentInput.value.trim();
            if (!text) return;
            const album = this.albums[this.currentAlbumIndex];
            const photo = album.photos[this.currentPhotoIndex];
            const newComment = {
                author: "You",
                time: "Just now",
                text: text
            };
            photo.comments.push(newComment);
            this.commentCountEl.textContent = photo.comments.length;
            this.renderComments(photo.comments);
            this.commentInput.value = '';
        }
    }
    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', () => {
        new MemoryViewer();
    });

    // Confirmation function for delete button
    function confirmDelete() {
        if (confirm("Are you sure you want to delete this memory? This action cannot be undone.")) {
            // Replace with your actual delete logic
            alert("Delete action initiated (placeholder).");
            // Example: window.location.href = '/deletememory?id=' + currentMemoryId;
        }
    }
</script>
</body>
</html>