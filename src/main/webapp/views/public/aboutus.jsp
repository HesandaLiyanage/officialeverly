<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <jsp:include page="../public/header.jsp" />
    <html>

    <head>
        <title>About Us - Everly</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/content-page.css">
    </head>

    <body>

        <div class="content-page">

            <!-- Hero Banner -->
            <section class="content-hero">
                <div class="content-hero-inner">
                    <h1 class="fade-in">About Everly</h1>
                    <p class="fade-in">We're dedicated to preserving your cherished memories with the utmost privacy and
                        security — because every story deserves to live on.</p>
                </div>
            </section>

            <!-- Content Sections -->
            <div class="content-container">
                <div class="content-sections">

                    <!-- Our Mission -->
                    <div class="content-card fade-in">
                        <h2>
                            <span class="section-icon purple">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#7C3AED"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10" />
                                    <circle cx="12" cy="12" r="6" />
                                    <circle cx="12" cy="12" r="2" />
                                </svg>
                            </span>
                            Our Mission
                        </h2>
                        <div class="card-text">
                            Our mission is to empower families and individuals to capture, preserve, and share their
                            memories in a safe and collaborative environment. We believe that every story deserves to be
                            told and protected, and we're committed to providing a platform that honors this belief.
                        </div>
                    </div>

                    <!-- Our Values -->
                    <div class="content-card fade-in">
                        <h2>
                            <span class="section-icon green">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#059669"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path
                                        d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                                </svg>
                            </span>
                            Our Values
                        </h2>
                        <ul class="value-list">
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Privacy First</h4>
                                    <p>We prioritize your privacy and security above all else. Our platform uses
                                        end-to-end encryption to ensure your memories remain private and secure.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                        <circle cx="9" cy="7" r="4" />
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Collaborative Storytelling</h4>
                                    <p>We believe that memories are best shared and enriched through collaboration. Our
                                        platform allows families to contribute to stories together, creating a shared
                                        legacy.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Ethical Design</h4>
                                    <p>We are committed to ethical design principles, ensuring our platform is
                                        transparent, user-centric, and respects your data and privacy.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <polygon
                                            points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Innovation</h4>
                                    <p>We continuously strive to innovate and improve our platform, providing new and
                                        exciting ways to capture and preserve your memories.</p>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <!-- The Problem We're Solving -->
                    <div class="content-card fade-in">
                        <h2>
                            <span class="section-icon orange">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#D97706"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10" />
                                    <line x1="12" y1="8" x2="12" y2="12" />
                                    <line x1="12" y1="16" x2="12.01" y2="16" />
                                </svg>
                            </span>
                            The Problem We're Solving
                        </h2>
                        <div class="card-text">
                            In today's digital age, our memories are scattered across various platforms, often
                            vulnerable to security breaches and privacy concerns. Existing solutions lack the privacy
                            and collaborative features needed to truly preserve and share memories securely. Everly
                            addresses this challenge by providing a privacy-first platform with collaborative
                            storytelling features, ensuring your memories are safe, organized, and accessible only to
                            those you choose.
                        </div>
                    </div>

                    <!-- Our Approach -->
                    <div class="content-card fade-in">
                        <h2>
                            <span class="section-icon blue">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2563EB"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
                                </svg>
                            </span>
                            Our Approach
                        </h2>
                        <div class="card-text">
                            Everly is built on a foundation of privacy, security, and collaboration. Our platform uses
                            end-to-end encryption to protect your memories, ensuring they are only accessible to you and
                            those you invite. We offer collaborative storytelling features, allowing families to
                            contribute to stories together, creating a shared legacy. Our smart journaling tools help
                            you capture and organize your memories effortlessly, making it easy to preserve your most
                            important moments.
                        </div>
                    </div>

                    <!-- Key Features and Benefits -->
                    <div class="content-card fade-in">
                        <h2>
                            <span class="section-icon pink">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#DB2777"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 2L2 7l10 5 10-5-10-5z" />
                                    <path d="M2 17l10 5 10-5" />
                                    <path d="M2 12l10 5 10-5" />
                                </svg>
                            </span>
                            Key Features & Benefits
                        </h2>
                        <ul class="value-list">
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>End-to-End Encryption</h4>
                                    <p>Your memories are protected with the highest level of security, ensuring they
                                        remain private and secure.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                        <circle cx="9" cy="7" r="4" />
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Collaborative Storytelling</h4>
                                    <p>Invite family members to contribute to stories, creating a shared legacy of
                                        memories.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                        <polyline points="14 2 14 8 20 8" />
                                        <line x1="16" y1="13" x2="8" y2="13" />
                                        <line x1="16" y1="17" x2="8" y2="17" />
                                        <polyline points="10 9 9 9 8 9" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Smart Journaling</h4>
                                    <p>Easily capture and organize your memories with our intuitive journaling tools.
                                    </p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Privacy-First Design</h4>
                                    <p>We prioritize your privacy and security, ensuring your data is protected and used
                                        ethically.</p>
                                </div>
                            </li>
                            <li class="value-item">
                                <span class="value-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="#7C3AED" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="18" cy="5" r="3" />
                                        <circle cx="6" cy="12" r="3" />
                                        <circle cx="18" cy="19" r="3" />
                                        <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
                                        <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
                                    </svg>
                                </span>
                                <div class="value-content">
                                    <h4>Secure Sharing</h4>
                                    <p>Control who can access your memories, ensuring they are shared only with those
                                        you choose.</p>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <!-- Contact Us -->
                    <div class="contact-card fade-in">
                        <h2>Get in Touch</h2>
                        <p class="contact-subtitle">Have a question or feedback? We'd love to hear from you.</p>
                        <form class="contact-form">
                            <div class="form-row">
                                <input type="text" placeholder="Your Name" required>
                                <input type="email" placeholder="Your Email" required>
                            </div>
                            <textarea placeholder="Your Message" rows="5" required></textarea>
                            <button type="submit" class="contact-submit">Send Message</button>
                        </form>
                    </div>

                </div>
            </div>

        </div>

        <jsp:include page="../public/footer.jsp" />

        <script>
            // Scroll-triggered fade-in animations
            document.addEventListener('DOMContentLoaded', function () {
                var observer = new IntersectionObserver(function (entries) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.style.animationPlayState = 'running';
                            observer.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.1, rootMargin: '0px 0px -30px 0px' });

                document.querySelectorAll('.fade-in').forEach(function (el, i) {
                    el.style.animationPlayState = 'paused';
                    el.style.animationDelay = (i * 0.08) + 's';
                    observer.observe(el);
                });
            });
        </script>

    </body>

    </html>