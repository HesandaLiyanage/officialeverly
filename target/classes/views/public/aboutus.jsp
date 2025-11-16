<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Everly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headercomponents.css">
    <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="header.css">
    <link rel="stylesheet" href="footer.css">
    <style>
        /* Modern About Us Page Styles - Matching Privacy Policy */
        body {
            font-family: 'Epilogue', Arial, sans-serif;
            background-color: #f9fafb;
            color: #1f2937;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Modern Hero Section */
        .hero {
            position: relative;
            text-align: center;
            margin: 40px 0;
            width: 100%;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            background-color: #e0e7ff;
        }

        .hero-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            display: block;
        }

        .hero-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #1e3a8a;
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.85);
            border-radius: 12px;
            backdrop-filter: blur(5px);
        }

        .hero-text h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .hero-text p {
            font-size: 1.1rem;
            font-weight: 400;
            margin: 0;
        }

        /* Modern Section Styling */
        .differentiators {
            width: 100%;
            margin: 40px 0;
            text-align: left;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .differentiators h2 {
            font-size: 1.6rem;
            font-weight: 600;
            color: #1e40af;
            margin-top: 0;
            margin-bottom: 1.2rem;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid #e0e7ff;
        }

        .desc {
            color: #4b5563;
            font-size: 1rem;
            line-height: 1.7;
        }

        .desc strong {
            color: #1f2937;
        }

        /* Modern CTA/Contact Section */
        .cta {
            text-align: center;
            background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
            padding: 40px 20px;
            border-radius: 16px;
            margin: 40px 0;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .cta h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1e40af;
            margin-bottom: 1.5rem;
        }

        .cta form {
            max-width: 600px;
            margin: 0 auto;
        }

        .cta input,
        .cta textarea {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 15px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-family: 'Epilogue', Arial, sans-serif;
            font-size: 1rem;
            background-color: #ffffff;
            transition: border-color 0.2s ease;
            box-sizing: border-box;
        }

        .cta input:focus,
        .cta textarea:focus {
            outline: none;
            border-color: #6366f1;
        }

        .cta-btn {
            display: inline-block;
            text-decoration: none;
            background-color: #6366f1;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.2s ease;
            box-shadow: 0 4px 6px rgba(99, 102, 241, 0.3);
        }

        .cta-btn:hover {
            background-color: #4f46e5;
            transform: translateY(-2px);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .hero-text h1 {
                font-size: 2rem;
            }

            .hero-text p {
                font-size: 1rem;
            }

            .differentiators {
                padding: 20px;
            }

            .differentiators h2 {
                font-size: 1.4rem;
            }
        }
    </style>
</head>
<body>

<!-- Main Content -->
<main class="container">

    <!-- Hero Section -->
    <div class="hero">
        <img src="https://via.placeholder.com/1200x400?text=About+Everly" alt="About Us Banner" class="hero-img">
        <div class="hero-text">
            <h1>About Us</h1>
            <p>At Everly, we're dedicated to preserving your cherished memories with the utmost privacy and security.</p>
        </div>
    </div>

    <!-- Our Mission -->
    <div class="differentiators">
        <h2>Our Mission</h2>
        <div class="desc">
            Our mission is to empower families and individuals to capture, preserve, and share their memories in a safe and collaborative environment. We believe that every story deserves to be told and protected, and we're committed to providing a platform that honors this belief.
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
            In today's digital age, our memories are scattered across various platforms, often vulnerable to security breaches and privacy concerns. Existing solutions lack the privacy and collaborative features needed to truly preserve and share memories securely. Everly addresses this challenge by providing a privacy-first platform with collaborative storytelling features, ensuring your memories are safe, organized, and accessible only to those you choose.
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
            <input type="text" placeholder="Your Name" required>
            <input type="email" placeholder="Your Email" required>
            <textarea placeholder="Your Message" rows="5" required></textarea>
            <button type="submit" class="cta-btn">Send Message</button>
        </form>
    </div>

</main>

<!-- Include Footer -->
<%@ include file="footer.jsp" %>

</body>
</html>