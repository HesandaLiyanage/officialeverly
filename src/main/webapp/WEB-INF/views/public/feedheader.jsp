<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Momento Header</title>
    <style>
        /* ===== HEADER ===== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Poppins", sans-serif;
        }

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

        .nav-links {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .nav-links a {
            color: #555;
            font-weight: 500;
            transition: 0.3s;
            text-decoration: none;
            font-size: 0.95em;
        }

        .nav-links a:hover {
            color: #9A74D8;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: #f0eef6;
            border-radius: 30px;
            padding: 8px 15px;
            width: 280px;
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
            gap: 12px;
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

        @media (max-width: 900px) {
            header {
                flex-direction: column;
                gap: 15px;
                padding: 15px 20px;
            }

            .nav-links {
                gap: 15px;
                flex-wrap: wrap;
                justify-content: center;
            }

            .search-box {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<header>
    <div class="logo">Momento</div>

    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="explore.jsp">Explore</a>
        <a href="feed.jsp">Feed</a>
        <a href="memories.jsp">Memories</a>
    </div>

    <div class="search-box">
        <input type="text" placeholder="Search memories...">
    </div>

    <div class="header-buttons">
        <button onclick="window.location.href='profile.jsp'">Profile</button>
        <button onclick="exitFeed()">Exit</button>
    </div>
</header>

<script>
    function exitFeed() {
        window.location.href = "index.jsp";
    }
</script>
</body>
</html>
