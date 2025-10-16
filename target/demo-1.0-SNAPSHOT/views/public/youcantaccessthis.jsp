<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="header.jsp" />


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin="" />
    <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?display=swap&family=Manrope:wght@400;500;700;800&family=Noto+Sans:wght@400;500;700;900"
    />
    <title>Stitch Design</title>
    <link rel="icon" type="image/x-icon" href="data:image/x-icon;base64," />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Manrope, "Noto Sans", sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
        }

        .container {
            position: relative;
            display: flex;
            min-height: 100vh;
            width: 100%;
            flex-direction: column;
            overflow-x: hidden;
        }

        .layout-container {
            display: flex;
            height: 100%;
            flex-grow: 1;
            flex-direction: column;
        }

        .content-wrapper {
            padding: 20px 160px;
            display: flex;
            flex: 1;
            justify-content: center;
        }

        .layout-content-container {
            display: flex;
            flex-direction: column;
            max-width: 960px;
            flex: 1;
        }

        .hero-section {
            padding: 0;
        }

        .hero-inner {
            padding: 12px 16px;
        }

        .hero-background {
            background-image: linear-gradient(0deg, rgba(0, 0, 0, 0.4) 0%, rgba(0, 0, 0, 0) 25%),
            url("https://lh3.googleusercontent.com/aida-public/AB6AXuCBuH4H2RzDTi2n6IMUsrMrkcdbWN7ObHr1G-sFbG1E-M2AfGWZ4Z-3UUU06M0Kko7hAy_hRGS_2o2kD45XpO3FdRnKDhIbUxDqvVCMnRmZvdUcVOC8knm-_mSmutGym515YOIRrus58h4_syqGDVgi5S3KfR6oXzV1k5Q9bzvw6-2P0IljNOEGL3bPl8G_U8-Kge8FUCj_ePqtZ9IwNYZwzvD9uxgRWt6rxQbFkGOSHZ56Cg0Q2lEibkQs6IZ89OcRxERJtsX648k");
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            overflow: hidden;
            background-color: #f8fafc;
            border-radius: 8px;
            min-height: 320px;
        }

        .dots-container {
            display: flex;
            justify-content: center;
            gap: 8px;
            padding: 20px;
        }

        .dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background-color: #f8fafc;
        }

        .dot.inactive {
            opacity: 0.5;
        }

        .heading {
            color: #0e171b;
            font-size: 28px;
            font-weight: 700;
            line-height: 1.2;
            padding: 20px 16px 12px;
            text-align: center;
            letter-spacing: -0.015em;
        }

        .button-container {
            display: flex;
            padding: 12px 16px;
            justify-content: center;
        }

        .get-started-btn {
            display: flex;
            min-width: 84px;
            max-width: 480px;
            cursor: pointer;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-radius: 8px;
            height: 48px;
            padding: 0 20px;
            background-color: #19a2e6;
            color: #f8fafc;
            font-size: 16px;
            font-weight: 700;
            line-height: 1.5;
            letter-spacing: 0.015em;
            text-decoration: none;
            border: none;
        }

        .get-started-btn:hover {
            background-color: #1589c7;
        }

        .get-started-btn span {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        @media (max-width: 1200px) {
            .content-wrapper {
                padding: 20px 80px;
            }
        }

        @media (max-width: 768px) {
            .content-wrapper {
                padding: 20px 20px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="layout-container">
        <div class="content-wrapper">
            <div class="layout-content-container">
                <div class="hero-section">
                    <div class="hero-inner">
                        <div class="hero-background">
                            <div class="dots-container">
                                <div class="dot"></div>
                                <div class="dot inactive"></div>
                                <div class="dot inactive"></div>
                                <div class="dot inactive"></div>
                                <div class="dot inactive"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <h2 class="heading">
                    Your memories, your rules - secure, emotional, and beautifully organized.
                </h2>
                <div class="button-container">
                    <a href="${pageContext.request.contextPath}/login" class="get-started-btn">
                        <span>Get Started</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>


<jsp:include page="footer.jsp" />