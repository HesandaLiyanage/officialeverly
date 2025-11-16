<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="../public/header.jsp" />
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/landing.css">
</head>
<body>

<!-- Hero Section with Video Background -->
<section class="hero-section">
    <!-- Video Background -->
    <!-- IMPORTANT: Place your video file in one of these locations and uncomment the matching line: -->

    <!-- Option 1: If using Spring Boot's static resources -->
    <video class="hero-video" autoplay muted loop playsinline preload="auto" id="heroVideo">
        <source src="/resources/assets/landing.mp4" type="video/mp4">
    </video>

    <!-- Option 2: If video is in webapp/resources/videos/
    <video class="hero-video" autoplay muted loop playsinline preload="auto" id="heroVideo">
        <source src="${pageContext.request.contextPath}/resources/videos/hero-video.mp4" type="video/mp4">
    </video>
    -->

    <!-- Option 3: If video is in webapp/static/videos/
    <video class="hero-video" autoplay muted loop playsinline preload="auto" id="heroVideo">
        <source src="/static/videos/hero-video.mp4" type="video/mp4">
    </video>
    -->

    <!-- Option 4: External URL (like Google Drive, Vimeo, etc)
    <video class="hero-video" autoplay muted loop playsinline preload="auto" id="heroVideo">
        <source src="https://your-url-here.com/video.mp4" type="video/mp4">
    </video>
    -->

    <div class="hero-overlay"></div>

    <div class="hero-content">
        <h1 class="hero-title">Where Moments Live On</h1>
        <p class="hero-subtitle">Capture, share, and relive your most cherished moments in a secure, collaborative space. Everly is designed with your privacy and memories at its heart.</p>
    </div>
</section>

<!-- Key Features Section -->
<section class="features-section">
    <div class="section-header">
        <h2 class="section-title">Key Features</h2>
        <p class="section-description">Everly offers a suite of features designed to help you preserve and share your family's memories securely and easily.</p>
        <a href="/signup" class="get-started-btn">Get Started</a>
    </div>

    <div class="features-grid">
        <!-- Feature 1: Collaborative Storytelling -->
        <div class="feature-card">
            <div class="feature-image collab-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#F8F9FA"/>
                    <circle cx="60" cy="60" r="20" fill="#9A74D8"/>
                    <rect x="50" y="80" width="20" height="35" fill="#9A74D8"/>
                    <circle cx="100" cy="55" r="22" fill="#EADDFF"/>
                    <rect x="89" y="77" width="22" height="40" fill="#EADDFF"/>
                    <circle cx="140" cy="58" r="21" fill="#9A74D8"/>
                    <rect x="129" y="79" width="22" height="38" fill="#9A74D8"/>
                </svg>
            </div>
            <h3 class="feature-title">Collaborative Storytelling</h3>
            <p class="feature-description">Invite family members to contribute stories, photos, and videos, creating a rich, shared history.</p>
        </div>

        <!-- Feature 2: End-to-End Encryption -->
        <div class="feature-card">
            <div class="feature-image encryption-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#1A1F2E"/>
                    <rect x="60" y="50" width="80" height="60" rx="8" fill="#2D3748" stroke="#4A5568" stroke-width="3"/>
                    <circle cx="100" cy="80" r="15" fill="#9A74D8"/>
                    <rect x="97" y="80" width="6" height="15" fill="#9A74D8"/>
                </svg>
            </div>
            <h3 class="feature-title">End-to-End Encryption</h3>
            <p class="feature-description">Your memories are protected with advanced encryption, ensuring only you and your chosen family members can access them.</p>
        </div>

        <!-- Feature 3: Smart Journaling -->
        <div class="feature-card">
            <div class="feature-image journal-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#F5F5F5"/>
                    <rect x="50" y="30" width="100" height="90" rx="4" fill="#FFFFFF" stroke="#E0E0E0" stroke-width="2"/>
                    <line x1="65" y1="50" x2="120" y2="50" stroke="#9A74D8" stroke-width="2"/>
                    <line x1="65" y1="65" x2="135" y2="65" stroke="#CCCCCC" stroke-width="2"/>
                    <line x1="65" y1="80" x2="130" y2="80" stroke="#CCCCCC" stroke-width="2"/>
                    <line x1="65" y1="95" x2="125" y2="95" stroke="#CCCCCC" stroke-width="2"/>
                </svg>
            </div>
            <h3 class="feature-title">Smart Journaling</h3>
            <p class="feature-description">Easily document daily life and special moments with our intuitive journaling tools, enhanced with smart suggestions.</p>
        </div>

        <!-- Feature 4: Social Sharing with Control -->
        <div class="feature-card">
            <div class="feature-image social-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#FFF5F5"/>
                    <rect x="30" y="30" width="60" height="80" rx="4" fill="#FFFFFF" stroke="#E0E0E0" stroke-width="2"/>
                    <rect x="110" y="30" width="60" height="80" rx="4" fill="#FFFFFF" stroke="#E0E0E0" stroke-width="2"/>
                    <rect x="40" y="40" width="40" height="30" fill="#EADDFF"/>
                    <rect x="120" y="40" width="40" height="30" fill="#EADDFF"/>
                </svg>
            </div>
            <h3 class="feature-title">Social Sharing with Control</h3>
            <p class="feature-description">Share selected memories with friends and family while always maintaining full control over who sees what.</p>
        </div>

        <!-- Feature 5: Event Management -->
        <div class="feature-card">
            <div class="feature-image event-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#F0F9FF"/>
                    <rect x="40" y="30" width="120" height="90" rx="8" fill="#FFFFFF" stroke="#9A74D8" stroke-width="2"/>
                    <rect x="40" y="30" width="120" height="25" fill="#9A74D8"/>
                    <line x1="70" y1="20" x2="70" y2="40" stroke="#9A74D8" stroke-width="3"/>
                    <line x1="130" y1="20" x2="130" y2="40" stroke="#9A74D8" stroke-width="3"/>
                    <rect x="50" y="65" width="20" height="15" fill="#EADDFF"/>
                    <rect x="80" y="65" width="20" height="15" fill="#EADDFF"/>
                    <rect x="110" y="65" width="20" height="15" fill="#EADDFF"/>
                    <rect x="140" y="65" width="20" height="15" fill="#EADDFF"/>
                </svg>
            </div>
            <h3 class="feature-title">Event Management</h3>
            <p class="feature-description">Organize and manage important family events, from birthdays to reunions, with integrated planning tools.</p>
        </div>

        <!-- Feature 6: Storage Sense -->
        <div class="feature-card">
            <div class="feature-image storage-image">
                <svg viewBox="0 0 200 150" xmlns="http://www.w3.org/2000/svg">
                    <rect width="200" height="150" fill="#F5F5F5"/>
                    <rect x="50" y="50" width="100" height="60" rx="8" fill="#9A74D8"/>
                    <rect x="60" y="60" width="80" height="15" fill="#EADDFF"/>
                    <rect x="60" y="80" width="50" height="15" fill="#EADDFF"/>
                    <circle cx="75" cy="72" r="3" fill="#9A74D8"/>
                    <circle cx="75" cy="92" r="3" fill="#9A74D8"/>
                </svg>
            </div>
            <h3 class="feature-title">Storage Sense</h3>
            <p class="feature-description">Keep track of your storage usage and optimize your memory collection with our intelligent storage management features.</p>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials-section">
    <h2 class="section-title">Testimonials</h2>

    <div class="testimonials-grid">
        <!-- Testimonial 1 -->
        <div class="testimonial-card">
            <div class="testimonial-image">
                <svg viewBox="0 0 300 220" xmlns="http://www.w3.org/2000/svg">
                    <rect width="300" height="220" fill="#FFF0F5"/>
                    <rect x="90" y="60" width="120" height="140" rx="8" fill="#FFFFFF" stroke="#E0E0E0" stroke-width="3"/>
                    <rect x="100" y="70" width="100" height="70" fill="#EADDFF"/>
                    <circle cx="135" cy="90" r="8" fill="#9A74D8"/>
                    <circle cx="165" cy="90" r="8" fill="#9A74D8"/>
                    <path d="M 145 110 Q 150 115 155 110" stroke="#9A74D8" stroke-width="2" fill="none"/>
                </svg>
            </div>
            <p class="testimonial-text">"Everly has transformed how we share and preserve our family stories. It's secure, easy to use, and brings us closer together."</p>
            <p class="testimonial-author">- Sarah M.</p>
        </div>

        <!-- Testimonial 2 -->
        <div class="testimonial-card">
            <div class="testimonial-image">
                <svg viewBox="0 0 300 220" xmlns="http://www.w3.org/2000/svg">
                    <rect width="300" height="220" fill="#F0F4F8"/>
                    <circle cx="100" cy="100" r="30" fill="#EADDFF"/>
                    <rect x="85" y="130" width="30" height="50" fill="#EADDFF"/>
                    <circle cx="150" cy="110" r="35" fill="#9A74D8"/>
                    <rect x="133" y="145" width="34" height="60" fill="#9A74D8"/>
                    <circle cx="210" cy="105" r="32" fill="#EADDFF"/>
                    <rect x="194" y="137" width="32" height="55" fill="#EADDFF"/>
                </svg>
            </div>
            <p class="testimonial-text">"I love the peace of mind knowing our memories are safe and private. The collaborative features are fantastic for involving everyone in our family history."</p>
            <p class="testimonial-author">- David L.</p>
        </div>

        <!-- Testimonial 3 -->
        <div class="testimonial-card">
            <div class="testimonial-image">
                <svg viewBox="0 0 300 220" xmlns="http://www.w3.org/2000/svg">
                    <rect width="300" height="220" fill="#FFF9E6"/>
                    <circle cx="150" cy="90" r="35" fill="#9A74D8"/>
                    <circle cx="135" cy="85" r="5" fill="#FFFFFF"/>
                    <circle cx="165" cy="85" r="5" fill="#FFFFFF"/>
                    <path d="M 140 100 Q 150 105 160 100" stroke="#FFFFFF" stroke-width="2" fill="none"/>
                    <rect x="130" y="125" width="40" height="60" fill="#9A74D8"/>
                    <rect x="90" y="160" width="35" height="4" fill="#EADDFF" rx="2"/>
                    <rect x="175" y="160" width="35" height="4" fill="#EADDFF" rx="2"/>
                </svg>
            </div>
            <p class="testimonial-text">"The journaling feature is a game-changer. It helps me capture the everyday moments I used to forget, creating a beautiful tapestry of our lives."</p>
            <p class="testimonial-author">- Emily R.</p>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <h2 class="cta-title">Start Preserving Your Memories today</h2>
    <a href="/signup" class="cta-button-large">Sign Up Now</a>
</section>

<jsp:include page="../public/footer.jsp" />

<script>
    // Multiple attempts to ensure video plays
    document.addEventListener('DOMContentLoaded', function() {
        const video = document.getElementById('heroVideo');

        if (video) {
            // Log video source for debugging
            console.log('Video element found');
            console.log('Video src:', video.querySelector('source').src);

            // Attempt 1: Direct play
            video.muted = true; // Ensure muted
            video.play().then(function() {
                console.log('Video playing successfully');
            }).catch(function(error) {
                console.log('Autoplay failed, trying manual trigger:', error);

                // Attempt 2: Play on user interaction
                document.body.addEventListener('click', function playOnClick() {
                    video.play();
                    document.body.removeEventListener('click', playOnClick);
                }, { once: true });

                // Attempt 3: Play on any scroll
                window.addEventListener('scroll', function playOnScroll() {
                    video.play();
                    window.removeEventListener('scroll', playOnScroll);
                }, { once: true });
            });

            // Check if video loaded
            video.addEventListener('loadeddata', function() {
                console.log('Video loaded successfully');
            });

            video.addEventListener('error', function(e) {
                console.error('Video error:', e);
                console.error('Video error code:', video.error ? video.error.code : 'unknown');
            });
        } else {
            console.error('Video element not found');
        }
    });

    // Also try on window load
    window.addEventListener('load', function() {
        const video = document.getElementById('heroVideo');
        if (video && video.paused) {
            video.play().catch(function(error) {
                console.log('Window load play attempt failed:', error);
            });
        }
    });
</script>

</body>
</html>