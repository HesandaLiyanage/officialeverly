<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Privacy Policy - Everly</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headercomponents.css"> <!-- Reuse your existing CSS -->
  <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="header.css">
  <link rel="stylesheet" href="footer.css">
</head>
<body>

<!-- Main Content -->
<main class="container">

  <!-- Hero Section (Adapted for Privacy Policy) -->
  <div class="hero">
    <img src="https://via.placeholder.com/1200x400?text=Privacy+Policy" alt="Privacy Policy Banner" class="hero-img">
    <div class="hero-text">
      <h1>Privacy Policy</h1>
      <p>At Everly, we are committed to protecting your privacy and ensuring the security of your personal information.</p>
    </div>
  </div>

  <!-- Introduction -->
  <div class="differentiators">
    <div class="desc">
      This Privacy Policy explains how we collect, use, and safeguard your data when you use our services. We encourage you to read this policy carefully to understand our practices regarding your information and how we handle it.
    </div>
  </div>

  <!-- Section 1: Information We Collect -->
  <div class="differentiators">
    <h2>1. Information We Collect</h2>
    <div class="desc">
      We collect various types of information to provide and improve our services. This includes:
      <ul style="margin-top: 10px; padding-left: 20px;">
        <li><strong>Personal Information:</strong> Such as your name, email address, and any other information you provide when creating an account or contacting us.</li>
        <li><strong>Usage Data:</strong> Information about how you use our services, including the features you access, the content you create, and the interactions you have with other users.</li>
        <li><strong>Device Information:</strong> Information about the device you use to access our services, such as the device type, operating system, and unique device identifiers.</li>
      </ul>
    </div>
  </div>

  <!-- Section 2: How We Use Your Information -->
  <div class="differentiators">
    <h2>2. How We Use Your Information</h2>
    <div class="desc">
      We use the information we collect for the following purposes:
      <ul style="margin-top: 10px; padding-left: 20px;">
        <li><strong>To Provide and Improve Our Services:</strong> To deliver the features and functionality of Everly, personalize your experience, and enhance our services based on your usage.</li>
        <li><strong>To Communicate with You:</strong> To respond to your inquiries, provide support, and send you important updates and notifications about our services.</li>
        <li><strong>To Ensure Security:</strong> To protect the security of your account and our services, and to prevent fraud and abuse.</li>
        <li><strong>To Comply with Legal Obligations:</strong> To meet any applicable legal or regulatory requirements.</li>
      </ul>
    </div>
  </div>

  <!-- Section 3: Data Storage and Security -->
  <div class="differentiators">
    <h2>3. Data Storage and Security</h2>
    <div class="desc">
      We take the security of your data seriously and implement robust measures to protect it from unauthorized access, use, or disclosure. These measures include:
      <ul style="margin-top: 10px; padding-left: 20px;">
        <li><strong>End-to-End Encryption:</strong> All data stored on Everly is encrypted using end-to-end encryption, ensuring that only you and those you explicitly share with can access your information.</li>
        <li><strong>Secure Storage:</strong> We store your data on secure servers with restricted access, employing industry-standard security protocols to safeguard your information.</li>
        <li><strong>Regular Security Audits:</strong> We conduct regular security audits and assessments to identify and address potential vulnerabilities.</li>
      </ul>
    </div>
  </div>

  <!-- Section 4: Data Sharing and Disclosure -->
  <div class="differentiators">
    <h2>4. Data Sharing and Disclosure</h2>
    <div class="desc">
      We do not share your personal information with third parties except in the following limited circumstances:
      <ul style="margin-top: 10px; padding-left: 20px;">
        <li><strong>With Your Consent:</strong> We may share your information with third parties if you explicitly consent to such sharing.</li>
        <li><strong>To Comply with Legal Obligations:</strong> We may disclose your information if required by law or in response to valid legal requests.</li>
        <li><strong>To Protect Our Rights:</strong> We may share your information if necessary to protect our rights, property, or safety, or the rights, property, or safety of others.</li>
      </ul>
    </div>
  </div>

  <!-- Section 5: Your Rights and Control -->
  <div class="differentiators">
    <h2>5. Your Rights and Control</h2>
    <div class="desc">
      You have certain rights regarding your personal information, including:
      <ul style="margin-top: 10px; padding-left: 20px;">
        <li><strong>Access and Correction:</strong> You can access and update your account information at any time.</li>
        <li><strong>Deletion:</strong> You can request the deletion of your account and associated data.</li>
        <li><strong>Data Portability:</strong> You can request a copy of your data in a structured, machine-readable format.</li>
        <li><strong>Opt-Out:</strong> You can opt-out of receiving promotional communications from us.</li>
      </ul>
    </div>
  </div>

  <!-- Download PDF Link -->
  <div class="cta">
    <a href="#" style="color: #555; text-decoration: none; font-size: 14px;">Download Privacy Policy (PDF)</a>
  </div>

</main>

<!-- Include Footer -->
<%@ include file="footer.jsp" %>

</body>
</html>