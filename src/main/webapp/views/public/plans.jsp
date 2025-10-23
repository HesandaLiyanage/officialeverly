<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Plans | Everly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/headercomponents.css">
</head>
<body>
<jsp:include page="header.jsp" />
<div class="plans-section">
    <h1>Choose the plan that’s right for you</h1>

    <div class="plan-grid">
        <!-- Basic Plan -->
        <div class="plan-card">
            <h3>Basic</h3>
            <h2>Free <span>/month</span></h2>
            <a href="/login" class="cta-btn">Get started</a>
            <ul>
                <li>20GB storage</li>
                <li>Advanced Privacy Features</li>
            </ul>
        </div>

        <!-- Premium Plan -->
        <div class="plan-card">
            <h3>Premium</h3>
            <h2>$2.99 <span>/month</span></h2>
            <button class="cta-btn">Choose plan</button>
            <ul>
                <li>250GB storage</li>
                <li>Themes</li>
                <li>No Ads</li>
                <li>Smart journaling</li>
            </ul>
        </div>

        <!-- Pro Plan -->
        <div class="plan-card">
            <h3>Pro</h3>
            <h2>$5.99 <span>/month</span></h2>
            <button class="cta-btn">Choose plan</button>
            <ul>
                <li>1TB storage</li>
                <li>Themes</li>
                <li>No Ads</li>
                <li>AI features</li>
                <li>Beta Testing</li>
            </ul>
        </div>
    </div>

    <!-- FAQ Section -->
    <section class="faq">
        <h2>Frequently Asked Questions</h2>

        <details>
            <summary>What is Everly?</summary>
            <p>Everly is a privacy-first digital memory platform for families and individuals to preserve memories with collaborative storytelling and end-to-end encryption.</p>
        </details>

        <details>
            <summary>How does collaborative storytelling work?</summary>
            <p>Multiple family members can contribute photos, stories, and messages in one secure shared space.</p>
        </details>

        <details>
            <summary>What is end-to-end encryption?</summary>
            <p>End-to-end encryption ensures your data is protected and only accessible by authorized users.</p>
        </details>
    </section>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>
