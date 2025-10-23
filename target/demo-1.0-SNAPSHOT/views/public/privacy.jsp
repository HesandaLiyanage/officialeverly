<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Privacy Policy - Everly</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/headercomponents.css">
  <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="header.css">
  <link rel="stylesheet" href="footer.css">
  <style>
    /* Modern Privacy Page Specific Styles */
    body {
      font-family: 'Epilogue', Arial, sans-serif; /* Use the imported font */
      background-color: #f9fafb; /* Light grey background */
      color: #1f2937; /* Darker text for better contrast */
    }

    .container {
      max-width: 1000px; /* Limit content width */
      margin: 0 auto; /* Center content */
      padding: 0 20px; /* Add side padding */
    }

    /* Modern Hero Section */
    .hero {
      position: relative;
      text-align: center;
      margin: 40px 0; /* Consistent top/bottom margin */
      width: 100%; /* Full width container */
      border-radius: 16px; /* More modern rounded corners */
      overflow: hidden;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08); /* Subtle shadow */
      background-color: #e0e7ff; /* Light blue background */
    }

    .hero-img {
      width: 100%; /* Make image full width */
      height: 250px; /* Fixed height for consistency */
      object-fit: cover; /* Cover the area */
      display: block; /* Remove inline spacing */
    }

    .hero-text {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%); /* Center text */
      color: #1e3a8a; /* Darker blue text */
      text-align: center; /* Center text */
      padding: 20px; /* Add padding */
      background: rgba(255, 255, 255, 0.85); /* Semi-transparent white background */
      border-radius: 12px; /* Match container */
      backdrop-filter: blur(5px); /* Frosted glass effect */
    }

    .hero-text h1 {
      font-size: 2.5rem; /* Larger, modern heading */
      font-weight: 700;
      margin-bottom: 0.5rem;
    }

    .hero-text p {
      font-size: 1.1rem;
      font-weight: 400;
      margin: 0; /* Remove default margin */
    }

    /* Modern Section Styling */
    .differentiators {
      width: 100%; /* Full width */
      margin: 40px 0; /* Consistent vertical spacing */
      text-align: left; /* Left align text */
      padding: 30px; /* Add padding inside */
      background-color: #ffffff; /* White background */
      border-radius: 16px; /* Modern rounded corners */
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); /* Soft shadow */
    }

    .differentiators h2 {
      font-size: 1.6rem; /* Modern heading size */
      font-weight: 600;
      color: #1e40af; /* Blue heading */
      margin-top: 0; /* Remove top margin */
      margin-bottom: 1.2rem; /* Space below heading */
      padding-bottom: 0.8rem; /* Space under heading */
      border-bottom: 2px solid #e0e7ff; /* Light blue border */
    }

    .desc {
      color: #4b5563; /* Muted text color */
      font-size: 1rem;
      line-height: 1.7; /* Better readability */
    }

    .desc ul {
      margin-top: 10px;
      padding-left: 20px;
    }

    .desc li {
      margin-bottom: 0.5rem; /* Space between list items */
    }

    .desc strong {
      color: #1f2937; /* Darker color for emphasis */
    }

    /* Modern CTA Section */
    .cta {
      text-align: center;
      background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%); /* Gradient background */
      padding: 40px 20px;
      border-radius: 16px;
      margin: 40px 0; /* Consistent spacing */
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); /* Soft shadow */
    }

    .cta h2 {
      font-size: 1.5rem;
      font-weight: 600;
      color: #1e40af;
      margin-bottom: 0.5rem;
    }

    .cta p {
      font-size: 1rem;
      color: #4b5563;
      margin-bottom: 1.5rem;
    }

    .cta a {
      display: inline-block; /* Make link block-like */
      text-decoration: none;
      background-color: #6366f1; /* Modern purple button */
      color: white;
      padding: 12px 30px;
      border-radius: 8px; /* Slightly less rounded */
      font-size: 1rem;
      font-weight: 500;
      transition: background-color 0.2s ease, transform 0.2s ease; /* Smooth hover */
      box-shadow: 0 4px 6px rgba(99, 102, 241, 0.3); /* Button shadow */
    }

    .cta a:hover {
      background-color: #4f46e5; /* Darker purple on hover */
      transform: translateY(-2px); /* Lift effect */
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
      .hero-text h1 {
        font-size: 2rem; /* Smaller heading on mobile */
      }

      .hero-text p {
        font-size: 1rem;
      }

      .differentiators {
        padding: 20px; /* Less padding on mobile */
      }

      .differentiators h2 {
        font-size: 1.4rem; /* Smaller heading */
      }
    }
  </style>
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


</main>

<!-- Include Footer -->
<%@ include file="footer.jsp" %>

</body>
</html>