<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headercomponents.css"> <!-- We'll use your existing CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="header.css">
    <link rel="stylesheet" href="footer.css">
</head>
<body>

<!-- Main Content -->
<main class="container">

    <!-- Hero Section (Adapted for About Us) -->
    <div class="hero">
        <div class="hero-text">
            <div class="diff-grid">
                <h1>About Us</h1>
                <p>At Everly, we’re dedicated to preserving your cherished memories with the utmost privacy and security.</p>
            </div>
        </div>

        <!-- Our Mission -->
        <div class="differentiators">
            <h2>Our Mission</h2>
            <div class="desc">
                Our mission is to empower families and individuals to capture, preserve, and share their memories in a safe and collaborative environment. We believe that every story deserves to be told and protected, and we’re committed to providing a platform that honors this belief.
            </div>
        </div>

        <!-- Our Values -->
        <div class="differentiators">
            <h2>Our Values</h2>
            <div class="desc">
                <strong>Privacy First:</strong> We prioritize your privacy and security above all else. Our platform uses end-to-end encryption to ensure your memories remain private and secure.<br><br>
                <strong>Collaborative Storytelling:</strong> We believe that memories are best shared and enriched through collaboration. Our platform allows families to contribute to stories together, creating a shared legacy.<br><br>
                <strong>Ethical Design:</strong> We are committed to ethical design principles, ensuring our platform is transparent, user-centric, and respects your data and privacy.<br><br>
                <strong>Innovation:</strong> We continuously strive to innovate and improve our platform, providing new and exciting ways to capture and preserve your memories.
            </div>
        </div>

        <!-- The Problem We're Solving -->
        <div class="differentiators">
            <h2>The Problem We're Solving</h2>
            <div class="desc">
                In today’s digital age, our memories are scattered across various platforms, often vulnerable to security breaches and privacy concerns. Existing solutions lack the privacy and collaborative features needed to truly preserve and share memories securely. Everly addresses this challenge by providing a privacy-first platform with collaborative storytelling features, ensuring your memories are safe, organized, and accessible only to those you choose.
            </div>
        </div>

        <!-- Our Approach -->
        <div class="differentiators">
            <h2>Our Approach</h2>
            <div class="desc">
                Everly is built on a foundation of privacy, security, and collaboration. Our platform uses end-to-end encryption to protect your memories, ensuring they are only accessible to you and those you invite. We offer collaborative storytelling features, allowing families to contribute to stories together, creating a shared legacy. Our smart journaling tools help you capture and organize your memories effortlessly, making it easy to preserve your most important moments.
            </div>
        </div>

        <!-- Key Features and Benefits -->
        <div class="differentiators">
            <h2>Key Features and Benefits</h2>
            <div class="desc">
                <strong>End-to-End Encryption:</strong> Your memories are protected with the highest level of security, ensuring they remain private and secure.<br><br>
                <strong>Collaborative Storytelling:</strong> Invite family members to contribute to stories, creating a shared legacy of memories.<br><br>
                <strong>Smart Journaling:</strong> Easily capture and organize your memories with our intuitive journaling tools.<br><br>
                <strong>Privacy-First Design:</strong> We prioritize your privacy and security, ensuring your data is protected and used ethically.<br><br>
                <strong>Secure Sharing:</strong> Control who can access your memories, ensuring they are shared only with those you choose.
            </div>
        </div>

        <!-- Contact Us -->
        <div class="cta">
            <h2>Contact Us</h2>
            <form>
                <input type="text" placeholder="Your Name" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;">
                <input type="email" placeholder="Your Email" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;">
                <textarea placeholder="Your Message" rows="5" style="width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 5px;"></textarea>
                <button type="submit" class="cta-btn">Send Message</button>
            </form>
        </div>

</main>

<!-- Include Footer -->
<%@ include file="footer.jsp" %>

</body>
</html>