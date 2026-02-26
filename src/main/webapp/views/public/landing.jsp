<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <jsp:include page="../public/header.jsp" />
    <html>

    <head>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/landing.css">
    </head>

    <body>

        <!-- Hero Section with Video Background -->
        <section class="hero-section">
            <video class="hero-video" autoplay muted loop playsinline preload="auto" id="heroVideo">
                <source src="/resources/assets/landing.mp4" type="video/mp4">
            </video>

            <div class="hero-overlay"></div>

            <div class="hero-content">
                <h1 class="hero-title">Where Moments Live On</h1>
                <p class="hero-subtitle">Capture, share, and relive your most cherished moments in a secure,
                    collaborative space. Everly is designed with your privacy and memories at its heart.</p>
            </div>
        </section>

        <!-- Key Features Section -->
        <section class="features-section">
            <div class="section-header fade-in-up">
                <h2 class="section-title">Key Features</h2>
                <p class="section-description">Everly offers a suite of features designed to help you preserve and share
                    your family's memories securely and easily.</p>
                <a href="/signup" class="get-started-btn">Get Started</a>
            </div>

            <div class="features-grid">
                <!-- Feature 1: Collaborative Storytelling -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#F5F3FF" />
                            <!-- Connected people network -->
                            <circle cx="200" cy="120" r="28" fill="#7C3AED" opacity="0.15" />
                            <circle cx="200" cy="120" r="18" fill="#7C3AED" opacity="0.3" />
                            <circle cx="200" cy="120" r="10" fill="#7C3AED" />
                            <circle cx="120" cy="180" r="22" fill="#7C3AED" opacity="0.15" />
                            <circle cx="120" cy="180" r="14" fill="#7C3AED" opacity="0.3" />
                            <circle cx="120" cy="180" r="8" fill="#7C3AED" />
                            <circle cx="280" cy="180" r="22" fill="#7C3AED" opacity="0.15" />
                            <circle cx="280" cy="180" r="14" fill="#7C3AED" opacity="0.3" />
                            <circle cx="280" cy="180" r="8" fill="#7C3AED" />
                            <!-- Connection lines -->
                            <line x1="200" y1="130" x2="130" y2="172" stroke="#7C3AED" stroke-width="1.5"
                                opacity="0.25" />
                            <line x1="200" y1="130" x2="270" y2="172" stroke="#7C3AED" stroke-width="1.5"
                                opacity="0.25" />
                            <line x1="138" y1="180" x2="262" y2="180" stroke="#7C3AED" stroke-width="1.5" opacity="0.15"
                                stroke-dasharray="4 4" />
                        </svg>
                    </div>
                    <h3 class="feature-title">Collaborative Storytelling</h3>
                    <p class="feature-description">Invite family members to contribute stories, photos, and videos,
                        creating a rich, shared history.</p>
                </div>

                <!-- Feature 2: End-to-End Encryption -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#F0FDF4" />
                            <!-- Shield -->
                            <path d="M200 80 L250 105 L250 160 Q250 200 200 225 Q150 200 150 160 L150 105 Z"
                                fill="#059669" opacity="0.1" stroke="#059669" stroke-width="1.5" opacity="0.3" />
                            <path d="M200 100 L235 118 L235 155 Q235 185 200 205 Q165 185 165 155 L165 118 Z"
                                fill="#059669" opacity="0.12" />
                            <!-- Lock icon inside -->
                            <rect x="188" y="148" width="24" height="20" rx="3" fill="#059669" opacity="0.6" />
                            <path d="M194 148 L194 140 Q194 132 200 132 Q206 132 206 140 L206 148" fill="none"
                                stroke="#059669" stroke-width="2.5" opacity="0.6" />
                            <circle cx="200" cy="158" r="2.5" fill="white" />
                        </svg>
                    </div>
                    <h3 class="feature-title">End-to-End Encryption</h3>
                    <p class="feature-description">Your memories are protected with advanced encryption, ensuring only
                        you and your chosen family members can access them.</p>
                </div>

                <!-- Feature 3: Smart Journaling -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#FFF7ED" />
                            <!-- Notebook -->
                            <rect x="140" y="65" width="130" height="175" rx="6" fill="white" stroke="#EA580C"
                                stroke-width="1.5" opacity="0.35" />
                            <rect x="140" y="65" width="130" height="175" rx="6" fill="#EA580C" opacity="0.04" />
                            <!-- Spine -->
                            <line x1="165" y1="65" x2="165" y2="240" stroke="#EA580C" stroke-width="1.5"
                                opacity="0.2" />
                            <!-- Lines -->
                            <line x1="180" y1="100" x2="250" y2="100" stroke="#EA580C" stroke-width="2" opacity="0.35"
                                stroke-linecap="round" />
                            <line x1="180" y1="122" x2="245" y2="122" stroke="#F97316" stroke-width="1.5" opacity="0.2"
                                stroke-linecap="round" />
                            <line x1="180" y1="142" x2="240" y2="142" stroke="#F97316" stroke-width="1.5" opacity="0.2"
                                stroke-linecap="round" />
                            <line x1="180" y1="162" x2="235" y2="162" stroke="#F97316" stroke-width="1.5" opacity="0.2"
                                stroke-linecap="round" />
                            <line x1="180" y1="182" x2="248" y2="182" stroke="#F97316" stroke-width="1.5" opacity="0.2"
                                stroke-linecap="round" />
                            <!-- Pen -->
                            <line x1="265" y1="85" x2="245" y2="210" stroke="#EA580C" stroke-width="2" opacity="0.3"
                                stroke-linecap="round" />
                            <circle cx="244" cy="214" r="2.5" fill="#EA580C" opacity="0.4" />
                        </svg>
                    </div>
                    <h3 class="feature-title">Smart Journaling</h3>
                    <p class="feature-description">Easily document daily life and special moments with our intuitive
                        journaling tools, enhanced with smart suggestions.</p>
                </div>

                <!-- Feature 4: Social Sharing with Control -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#EFF6FF" />
                            <!-- Share network -->
                            <circle cx="200" cy="150" r="20" fill="#2563EB" opacity="0.15" />
                            <circle cx="200" cy="150" r="12" fill="#2563EB" opacity="0.25" />
                            <circle cx="200" cy="150" r="6" fill="#2563EB" />
                            <!-- Outer nodes -->
                            <circle cx="135" cy="105" r="10" fill="#2563EB" opacity="0.15" />
                            <circle cx="135" cy="105" r="5" fill="#2563EB" opacity="0.4" />
                            <circle cx="265" cy="105" r="10" fill="#2563EB" opacity="0.15" />
                            <circle cx="265" cy="105" r="5" fill="#2563EB" opacity="0.4" />
                            <circle cx="135" cy="195" r="10" fill="#2563EB" opacity="0.15" />
                            <circle cx="135" cy="195" r="5" fill="#2563EB" opacity="0.4" />
                            <circle cx="265" cy="195" r="10" fill="#2563EB" opacity="0.15" />
                            <circle cx="265" cy="195" r="5" fill="#2563EB" opacity="0.4" />
                            <!-- Connection lines -->
                            <line x1="195" y1="140" x2="140" y2="110" stroke="#2563EB" stroke-width="1.2"
                                opacity="0.2" />
                            <line x1="205" y1="140" x2="260" y2="110" stroke="#2563EB" stroke-width="1.2"
                                opacity="0.2" />
                            <line x1="195" y1="160" x2="140" y2="190" stroke="#2563EB" stroke-width="1.2"
                                opacity="0.2" />
                            <line x1="205" y1="160" x2="260" y2="190" stroke="#2563EB" stroke-width="1.2"
                                opacity="0.2" />
                        </svg>
                    </div>
                    <h3 class="feature-title">Social Sharing with Control</h3>
                    <p class="feature-description">Share selected memories with friends and family while always
                        maintaining full control over who sees what.</p>
                </div>

                <!-- Feature 5: Event Management -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#FDF2F8" />
                            <!-- Calendar -->
                            <rect x="130" y="85" width="140" height="135" rx="8" fill="white" stroke="#DB2777"
                                stroke-width="1.5" opacity="0.3" />
                            <rect x="130" y="85" width="140" height="35" rx="8" fill="#DB2777" opacity="0.1" />
                            <!-- Calendar pins -->
                            <line x1="165" y1="78" x2="165" y2="95" stroke="#DB2777" stroke-width="2.5"
                                stroke-linecap="round" opacity="0.35" />
                            <line x1="235" y1="78" x2="235" y2="95" stroke="#DB2777" stroke-width="2.5"
                                stroke-linecap="round" opacity="0.35" />
                            <!-- Grid squares -->
                            <rect x="146" y="135" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="176" y="135" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="206" y="135" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="236" y="135" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="146" y="162" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="176" y="162" width="22" height="18" rx="3" fill="#DB2777" opacity="0.15" />
                            <rect x="206" y="162" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="236" y="162" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="146" y="189" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="176" y="189" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <rect x="206" y="189" width="22" height="18" rx="3" fill="#DB2777" opacity="0.06" />
                            <!-- Star on selected date -->
                            <circle cx="187" cy="171" r="4" fill="#DB2777" opacity="0.5" />
                        </svg>
                    </div>
                    <h3 class="feature-title">Event Management</h3>
                    <p class="feature-description">Organize and manage important family events, from birthdays to
                        reunions, with integrated planning tools.</p>
                </div>

                <!-- Feature 6: Storage Sense -->
                <div class="feature-card fade-in-up">
                    <div class="feature-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#F5F3FF" />
                            <!-- Cloud shape -->
                            <ellipse cx="200" cy="130" rx="55" ry="35" fill="#7C3AED" opacity="0.08" />
                            <ellipse cx="165" cy="140" rx="35" ry="25" fill="#7C3AED" opacity="0.08" />
                            <ellipse cx="235" cy="140" rx="35" ry="25" fill="#7C3AED" opacity="0.08" />
                            <ellipse cx="200" cy="148" rx="60" ry="22" fill="#7C3AED" opacity="0.08" />
                            <!-- Upload arrow -->
                            <line x1="200" y1="175" x2="200" y2="210" stroke="#7C3AED" stroke-width="2" opacity="0.35"
                                stroke-linecap="round" />
                            <polyline points="188,188 200,175 212,188" fill="none" stroke="#7C3AED" stroke-width="2"
                                opacity="0.35" stroke-linecap="round" stroke-linejoin="round" />
                            <!-- Storage bar -->
                            <rect x="155" y="225" width="90" height="6" rx="3" fill="#7C3AED" opacity="0.1" />
                            <rect x="155" y="225" width="55" height="6" rx="3" fill="#7C3AED" opacity="0.3" />
                        </svg>
                    </div>
                    <h3 class="feature-title">Storage Sense</h3>
                    <p class="feature-description">Keep track of your storage usage and optimize your memory collection
                        with our intelligent storage management features.</p>
                </div>
            </div>
        </section>

        <!-- Testimonials Section -->
        <section class="testimonials-section">
            <h2 class="section-title fade-in-up">Testimonials</h2>

            <div class="testimonials-grid">
                <!-- Testimonial 1 -->
                <div class="testimonial-card fade-in-up">
                    <div class="testimonial-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#F5F3FF" />
                            <!-- Subtle pattern -->
                            <circle cx="320" cy="60" r="80" fill="#7C3AED" opacity="0.03" />
                            <circle cx="80" cy="240" r="60" fill="#7C3AED" opacity="0.03" />
                            <!-- Quote mark -->
                            <text x="120" y="115" font-family="Georgia, serif" font-size="80" fill="#7C3AED"
                                opacity="0.12">"</text>
                            <!-- Avatar circle -->
                            <circle cx="200" cy="170" r="36" fill="#7C3AED" opacity="0.08" />
                            <circle cx="200" cy="170" r="28" fill="#7C3AED" opacity="0.1" />
                            <!-- Person silhouette -->
                            <circle cx="200" cy="160" r="10" fill="#7C3AED" opacity="0.25" />
                            <ellipse cx="200" cy="185" rx="14" ry="8" fill="#7C3AED" opacity="0.2" />
                            <!-- Stars -->
                            <circle cx="172" cy="225" r="3" fill="#7C3AED" opacity="0.2" />
                            <circle cx="186" cy="225" r="3" fill="#7C3AED" opacity="0.2" />
                            <circle cx="200" cy="225" r="3" fill="#7C3AED" opacity="0.2" />
                            <circle cx="214" cy="225" r="3" fill="#7C3AED" opacity="0.2" />
                            <circle cx="228" cy="225" r="3" fill="#7C3AED" opacity="0.12" />
                        </svg>
                    </div>
                    <p class="testimonial-text">"Everly has transformed how we share and preserve our family stories.
                        It's secure, easy to use, and brings us closer together."</p>
                    <p class="testimonial-author">— Sarah M.</p>
                </div>

                <!-- Testimonial 2 -->
                <div class="testimonial-card fade-in-up">
                    <div class="testimonial-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#EFF6FF" />
                            <!-- Subtle pattern -->
                            <circle cx="80" cy="60" r="70" fill="#2563EB" opacity="0.03" />
                            <circle cx="320" cy="240" r="70" fill="#2563EB" opacity="0.03" />
                            <!-- Quote mark -->
                            <text x="120" y="115" font-family="Georgia, serif" font-size="80" fill="#2563EB"
                                opacity="0.1">"</text>
                            <!-- Avatar circle -->
                            <circle cx="200" cy="170" r="36" fill="#2563EB" opacity="0.06" />
                            <circle cx="200" cy="170" r="28" fill="#2563EB" opacity="0.08" />
                            <!-- Person silhouette -->
                            <circle cx="200" cy="160" r="10" fill="#2563EB" opacity="0.2" />
                            <ellipse cx="200" cy="185" rx="14" ry="8" fill="#2563EB" opacity="0.15" />
                            <!-- Stars -->
                            <circle cx="172" cy="225" r="3" fill="#2563EB" opacity="0.2" />
                            <circle cx="186" cy="225" r="3" fill="#2563EB" opacity="0.2" />
                            <circle cx="200" cy="225" r="3" fill="#2563EB" opacity="0.2" />
                            <circle cx="214" cy="225" r="3" fill="#2563EB" opacity="0.2" />
                            <circle cx="228" cy="225" r="3" fill="#2563EB" opacity="0.2" />
                        </svg>
                    </div>
                    <p class="testimonial-text">"I love the peace of mind knowing our memories are safe and private. The
                        collaborative features are fantastic for involving everyone in our family history."</p>
                    <p class="testimonial-author">— David L.</p>
                </div>

                <!-- Testimonial 3 -->
                <div class="testimonial-card fade-in-up">
                    <div class="testimonial-image">
                        <svg viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
                            <rect width="400" height="300" fill="#FFF7ED" />
                            <!-- Subtle pattern -->
                            <circle cx="320" cy="60" r="70" fill="#EA580C" opacity="0.03" />
                            <circle cx="80" cy="240" r="70" fill="#EA580C" opacity="0.03" />
                            <!-- Quote mark -->
                            <text x="120" y="115" font-family="Georgia, serif" font-size="80" fill="#EA580C"
                                opacity="0.1">"</text>
                            <!-- Avatar circle -->
                            <circle cx="200" cy="170" r="36" fill="#EA580C" opacity="0.06" />
                            <circle cx="200" cy="170" r="28" fill="#EA580C" opacity="0.08" />
                            <!-- Person silhouette -->
                            <circle cx="200" cy="160" r="10" fill="#EA580C" opacity="0.2" />
                            <ellipse cx="200" cy="185" rx="14" ry="8" fill="#EA580C" opacity="0.15" />
                            <!-- Stars -->
                            <circle cx="172" cy="225" r="3" fill="#EA580C" opacity="0.2" />
                            <circle cx="186" cy="225" r="3" fill="#EA580C" opacity="0.2" />
                            <circle cx="200" cy="225" r="3" fill="#EA580C" opacity="0.2" />
                            <circle cx="214" cy="225" r="3" fill="#EA580C" opacity="0.2" />
                            <circle cx="228" cy="225" r="3" fill="#EA580C" opacity="0.12" />
                        </svg>
                    </div>
                    <p class="testimonial-text">"The journaling feature is a game-changer. It helps me capture the
                        everyday moments I used to forget, creating a beautiful tapestry of our lives."</p>
                    <p class="testimonial-author">— Emily R.</p>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <h2 class="cta-title fade-in-up">Start Preserving Your Memories Today</h2>
            <a href="/signup" class="cta-button-large fade-in-up">Sign Up Now</a>
        </section>

        <jsp:include page="../public/footer.jsp" />

        <script>
            // Video autoplay handling
            document.addEventListener('DOMContentLoaded', function () {
                const video = document.getElementById('heroVideo');

                if (video) {
                    video.muted = true;
                    video.play().then(function () {
                        console.log('Video playing successfully');
                    }).catch(function (error) {
                        console.log('Autoplay failed, trying manual trigger:', error);

                        document.body.addEventListener('click', function playOnClick() {
                            video.play();
                            document.body.removeEventListener('click', playOnClick);
                        }, { once: true });

                        window.addEventListener('scroll', function playOnScroll() {
                            video.play();
                            window.removeEventListener('scroll', playOnScroll);
                        }, { once: true });
                    });

                    video.addEventListener('error', function (e) {
                        console.error('Video error:', e);
                    });
                }

                // Scroll-triggered fade-in animations
                const observerOptions = {
                    threshold: 0.15,
                    rootMargin: '0px 0px -40px 0px'
                };

                const observer = new IntersectionObserver(function (entries) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.style.animationDelay = (entry.target.dataset.delay || '0') + 's';
                            entry.target.classList.add('fade-in-up');
                            entry.target.style.animationPlayState = 'running';
                            observer.unobserve(entry.target);
                        }
                    });
                }, observerOptions);

                // Observe all animated elements
                document.querySelectorAll('.fade-in-up').forEach(function (el, index) {
                    el.style.animationPlayState = 'paused';
                    el.dataset.delay = (index % 3) * 0.12;
                    observer.observe(el);
                });
            });

            // Also try video on window load
            window.addEventListener('load', function () {
                const video = document.getElementById('heroVideo');
                if (video && video.paused) {
                    video.play().catch(function (error) {
                        console.log('Window load play attempt failed:', error);
                    });
                }
            });
        </script>

    </body>

    </html>