<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <jsp:include page="header.jsp" />
    <meta charset="UTF-8">
    <title>Why Everly?</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/headercomponents.css">
</head>
<body>

<div class="main-section">

    <!-- Hero Section -->
    <section class="hero">
        <img src="${pageContext.request.contextPath}/resources/assets/father.svg" alt="Family photo" class="hero-img">
        <div class="hero-text">
            <h1>Why Everly?</h1>
            <p>Discover why Everly is the trusted choice for preserving your family’s precious memories.</p>
        </div>
    </section>

    <!-- Key Differentiators -->
    <section class="differentiators">
        <h2>Key Differentiators</h2>
        <p class="desc">Everly stands out from other digital memory platforms with its unique features and commitment to user privacy.</p>

        <div class="diff-grid">
            <div class="diff-item">
                <h3>Privacy-First Design</h3>
                <p>Your memories are yours only. Everly’s privacy-first approach ensures complete control over your data and content visibility.</p>
            </div>
            <div class="diff-item">
                <h3>Collaborative Storytelling</h3>
                <p>Share memories with family members in one secure platform for a rich, shared history.</p>
            </div>
            <div class="diff-item">
                <h3>Smart Journaling & Autographs</h3>
                <p>Capture every moment effortlessly with smart journaling tools, personally tagging special stories.</p>
            </div>
            <div class="diff-item">
                <h3>End-to-End Encryption</h3>
                <p>Your memories are protected with strong encryption, ensuring only authorized users can access them.</p>
            </div>
        </div>
    </section>

    <!-- User Groups Section -->
    <section class="user-groups">
        <h2>Benefits for Different User Groups</h2>
        <p class="desc">Whether you’re a family, an individual, or a dedicated memory keeper, Everly offers tailored benefits to meet your needs.</p>

        <div class="group-grid">
            <div class="group-item">
                <img src="${pageContext.request.contextPath}/resources/assets/families.svg" alt="Family" class="group-img">
                <h3>Families</h3>
                <p>Bring generations together by storing and sharing life’s precious moments securely.</p>
            </div>
            <div class="group-item">
                <img src="${pageContext.request.contextPath}/resources/assets/individuals.svg" alt="Individual" class="group-img">
                <h3>Individuals</h3>
                <p>Preserve your journey and celebrate your experiences with ease.</p>
            </div>
            <div class="group-item">
                <img src="${pageContext.request.contextPath}/resources/assets/keepers.svg" alt="Memory keepers" class="group-img">
                <h3>Memory Keepers</h3>
                <p>Organize, curate, and preserve stories for your loved ones, ensuring they’re treasured forever.</p>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta">
        <h2>Ready to Start Preserving Your Memories?</h2>
        <p>Join Everly today and experience the difference of a privacy-first digital memory platform.</p>
        <a href="${pageContext.request.contextPath}/login" class="cta-btn">Get Started</a>
    </section>
</div>

<footer>
    <jsp:include page="footer.jsp" />
</footer>


</body>
</html>
