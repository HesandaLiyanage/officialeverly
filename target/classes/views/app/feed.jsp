<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Momento Feed</title>
    <style>
        /* ===== GENERAL ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Poppins", sans-serif;
        }

        body {
            background-color: #f7f5fb;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        /* ===== HEADER ===== */
        header {
            background-color: #fff;
            border-bottom: 1px solid #ddd;
            padding: 15px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            font-size: 1.8em;
            font-weight: 600;
            color: #9A74D8;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: #f0eef6;
            border-radius: 30px;
            padding: 8px 15px;
            width: 300px;
        }

        .search-box input {
            border: none;
            outline: none;
            background: none;
            flex: 1;
            font-size: 0.9em;
        }

        .header-buttons {
            display: flex;
            gap: 15px;
        }

        .header-buttons button {
            background-color: #9A74D8;
            border: none;
            color: #fff;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: 0.3s;
            font-weight: 500;
        }

        .header-buttons button:hover {
            background-color: #845cc2;
        }

        /* ===== MAIN FEED LAYOUT ===== */
        .feed-container {
            display: flex;
            justify-content: center;
            padding: 30px 50px;
            gap: 30px;
        }

        /* ===== LEFT FEED (POSTS) ===== */
        .feed-left {
            flex: 2.2;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .post {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            padding: 15px;
        }

        .post-header {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .post-header img {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }

        .post-header h3 {
            font-size: 1em;
            color: #333;
        }

        .post img.main {
            width: 100%;
            border-radius: 10px;
            margin-top: 10px;
        }

        .post p {
            margin: 10px 0;
            font-size: 0.95em;
            color: #555;
        }

        .post-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
        }

        .post-actions button {
            background: none;
            border: none;
            cursor: pointer;
            color: #9A74D8;
            font-weight: 500;
            transition: 0.2s;
        }

        .post-actions button:hover {
            color: #845cc2;
        }

        /* ===== RIGHT SIDEBAR ===== */
        .feed-right {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .sidebar-box {
            background: #fff;
            border-radius: 15px;
            padding: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .sidebar-box h3 {
            font-size: 1.1em;
            color: #9A74D8;
            margin-bottom: 10px;
        }

        .suggestion, .ad {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .suggestion img, .ad img {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            object-fit: cover;
            margin-right: 10px;
        }

        .suggestion span, .ad span {
            font-size: 0.9em;
            color: #444;
        }

        .post-btn {
            background-color: #9A74D8;
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 10px;
            width: 100%;
            cursor: pointer;
            font-weight: 500;
            transition: 0.3s;
        }

        .post-btn:hover {
            background-color: #845cc2;
        }

        @media (max-width: 900px) {
            .feed-container {
                flex-direction: column;
                padding: 20px;
            }
            .feed-right {
                order: -1;
            }
        }
    </style>
</head>
<body>
<!-- ===== HEADER ===== -->
<header>
    <jsp:include page="../public/feedheader.jsp" />


</header>

<!-- ===== MAIN FEED CONTENT ===== -->
<div class="feed-container">
    <!-- LEFT: POSTS -->
    <div class="feed-left" id="feedLeft"></div>

    <!-- RIGHT: SIDEBAR -->
    <div class="feed-right">
        <div class="sidebar-box">
            <h3>Suggested for You</h3>
            <div id="suggestions"></div>
        </div>
        <div class="sidebar-box">
            <h3>Sponsored Ads</h3>
            <div id="ads"></div>
        </div>
        <button class="post-btn" onclick="createPost()">Create Post</button>
    </div>
</div>

<!-- ===== JS SCRIPT ===== -->
<script>
    // Mock posts
    const posts = [
        {
            user: "Emily Watson",
            avatar: "https://randomuser.me/api/portraits/women/65.jpg",
            image: "https://images.unsplash.com/photo-1503264116251-35a269479413?w=800",
            caption: "A peaceful day by the beach 🌊 #serenity",
            likes: 23,
            comments: 5
        },
        {
            user: "Michael Lee",
            avatar: "https://randomuser.me/api/portraits/men/43.jpg",
            image: "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800",
            caption: "Hiking through the misty mountains 🏔️",
            likes: 42,
            comments: 9
        },
        {
            user: "Sophia Martinez",
            avatar: "https://randomuser.me/api/portraits/women/72.jpg",
            image: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800",
            caption: "Sunset vibes never get old 💜",
            likes: 58,
            comments: 11
        }
    ];

    const suggestions = [
        { name: "Liam Brown", img: "https://randomuser.me/api/portraits/men/21.jpg" },
        { name: "Olivia Davis", img: "https://randomuser.me/api/portraits/women/46.jpg" },
        { name: "Ethan Wilson", img: "https://randomuser.me/api/portraits/men/19.jpg" }
    ];

    const ads = [
        { title: "Capture your moments — Canon Cameras", img: "https://images.unsplash.com/photo-1504215680853-026ed2a45def?w=400" },
        { title: "Travel Deals up to 40% off!", img: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400" }
    ];

    // Load posts dynamically
    const feed = document.getElementById("feedLeft");
    posts.forEach((p, i) => {
        const div = document.createElement("div");
        div.className = "post";
        div.innerHTML = `
                <div class="post-header">
                    <img src="${p.avatar}">
                    <h3>${p.user}</h3>
                </div>
                <p>${p.caption}</p>
                <img src="${p.image}" class="main">
                <div class="post-actions">
                    <button onclick="likePost(${i})">❤️ Like (<span id='like-${i}'>${p.likes}</span>)</button>
                    <button>💬 Comments (${p.comments})</button>
                </div>
            `;
        feed.appendChild(div);
    });

    // Load suggestions
    const suggestionBox = document.getElementById("suggestions");
    suggestions.forEach(s => {
        suggestionBox.innerHTML += `
                <div class="suggestion">
                    <img src="${s.img}">
                    <span>${s.name}</span>
                </div>`;
    });

    // Load ads
    const adBox = document.getElementById("ads");
    ads.forEach(a => {
        adBox.innerHTML += `
                <div class="ad">
                    <img src="${a.img}">
                    <span>${a.title}</span>
                </div>`;
    });

    // Like functionality
    function likePost(index) {
        posts[index].likes++;
        document.getElementById(`like-${index}`).innerText = posts[index].likes;
    }

    // Exit Feed
    function exitFeed() {
        window.location.href = "index.jsp";
    }

    // Create post mock
    function createPost() {
        alert("Post creation feature coming soon!");
    }
</script>
</body>
</html>
