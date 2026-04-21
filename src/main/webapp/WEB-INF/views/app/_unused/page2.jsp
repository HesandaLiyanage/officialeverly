<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Form Input Cheat Sheet</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background: #f8fafc;
        }

        h1, h2 {
            color: #1e293b;
        }

        .section {
            background: #ffffff;
            border: 1px solid #dbeafe;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
            color: #334155;
        }

        input, select, textarea {
            width: 100%;
            max-width: 500px;
            padding: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
        }

        textarea {
            resize: vertical;
        }

        .inline-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .inline-group label {
            display: inline;
            font-weight: normal;
            margin-left: 4px;
        }

        .checkbox-group, .radio-group {
            margin-top: 8px;
        }

        .btn {
            background: #2563eb;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        code {
            background: #f1f5f9;
            padding: 2px 6px;
            border-radius: 6px;
        }

        pre {
            background: #0f172a;
            color: #e2e8f0;
            padding: 16px;
            border-radius: 10px;
            overflow-x: auto;
        }
    </style>
</head>
<body>

<h1>JSP Form Input Cheat Sheet</h1>

<%-- ============================================================
     SECTION 1: BIG FORM EXAMPLE
     Most common and important input types
     You can copy only the fields you need
     ============================================================ --%>
<div class="section">
    <h2>Section 1: Common Form Inputs</h2>

    <form action="saveData" method="post" enctype="multipart/form-data">

        <%-- Text Input --%>
        <div class="form-group">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" placeholder="Enter full name" />
        </div>

        <%-- Email Input --%>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Enter email address" />
        </div>

        <%-- Password Input --%>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" />
        </div>

        <%-- Phone Number --%>
        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" placeholder="e.g. 0771234567" maxlength="10" />
        </div>

        <%-- Number Input --%>
        <div class="form-group">
            <label for="age">Age</label>
            <input type="number" id="age" name="age" min="0" max="120" />
        </div>

        <%-- Date Input --%>
        <div class="form-group">
            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" />
        </div>

        <%-- Time Input --%>
        <div class="form-group">
            <label for="appointmentTime">Appointment Time</label>
            <input type="time" id="appointmentTime" name="appointmentTime" />
        </div>

        <%-- Datetime Local --%>
        <div class="form-group">
            <label for="meetingDateTime">Meeting Date & Time</label>
            <input type="datetime-local" id="meetingDateTime" name="meetingDateTime" />
        </div>

        <%-- Dropdown / Select --%>
        <div class="form-group">
            <label for="department">Department</label>
            <select id="department" name="department">
                <option value="">-- Select Department --</option>
                <option value="IT">IT</option>
                <option value="HR">HR</option>
                <option value="FINANCE">Finance</option>
                <option value="MARKETING">Marketing</option>
            </select>
        </div>

        <%-- Another Dropdown Example --%>
        <div class="form-group">
            <label for="country">Country</label>
            <select id="country" name="country">
                <option value="">-- Select Country --</option>
                <option value="Sri Lanka">Sri Lanka</option>
                <option value="India">India</option>
                <option value="USA">USA</option>
                <option value="UK">UK</option>
            </select>
        </div>

        <%-- Radio Buttons --%>
        <div class="form-group">
            <label>Gender</label>
            <div class="radio-group inline-group">
                <div>
                    <input type="radio" id="male" name="gender" value="Male" />
                    <label for="male">Male</label>
                </div>
                <div>
                    <input type="radio" id="female" name="gender" value="Female" />
                    <label for="female">Female</label>
                </div>
                <div>
                    <input type="radio" id="other" name="gender" value="Other" />
                    <label for="other">Other</label>
                </div>
            </div>
        </div>

        <%-- Checkboxes --%>
        <div class="form-group">
            <label>Skills</label>
            <div class="checkbox-group inline-group">
                <div>
                    <input type="checkbox" id="java" name="skills" value="Java" />
                    <label for="java">Java</label>
                </div>
                <div>
                    <input type="checkbox" id="jsp" name="skills" value="JSP" />
                    <label for="jsp">JSP</label>
                </div>
                <div>
                    <input type="checkbox" id="sql" name="skills" value="SQL" />
                    <label for="sql">SQL</label>
                </div>
                <div>
                    <input type="checkbox" id="js" name="skills" value="JavaScript" />
                    <label for="js">JavaScript</label>
                </div>
            </div>
        </div>

        <%-- Single Checkbox --%>
        <div class="form-group">
            <label>
                <input type="checkbox" id="termsAccepted" name="termsAccepted" value="true" />
                I accept the terms and conditions
            </label>
        </div>

        <%-- Textarea --%>
        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" rows="4" placeholder="Enter address"></textarea>
        </div>

        <%-- NIC Input --%>
        <div class="form-group">
            <label for="nic">NIC</label>
            <input type="text" id="nic" name="nic" placeholder="Old or new NIC" />
        </div>

        <%-- File Upload --%>
        <div class="form-group">
            <label for="documentFile">Upload Document</label>
            <input type="file" id="documentFile" name="documentFile" />
        </div>

        <%-- Image Upload --%>
        <div class="form-group">
            <label for="profileImage">Profile Image</label>
            <input type="file" id="profileImage" name="profileImage" accept="image/*" />
        </div>

        <%-- Hidden Field --%>
        <input type="hidden" name="recordId" value="123" />

        <%-- Submit / Reset Buttons --%>
        <div class="form-group">
            <button type="submit" class="btn">Submit</button>
            <button type="reset" class="btn" style="background:#64748b;">Reset</button>
        </div>

    </form>
</div>


<%-- ============================================================
     SECTION 2: WHAT SQL COLUMN TYPES TO USE
     Suggested common SQL types for each form input
     ============================================================ --%>
<div class="section">
    <h2>Section 2: Suggested SQL Column Types</h2>

    <pre>
fullName           -> VARCHAR(100)
email              -> VARCHAR(150)
password           -> VARCHAR(255)
phone              -> VARCHAR(15)
age                -> INT
dob                -> DATE
appointmentTime    -> TIME
meetingDateTime    -> DATETIME / TIMESTAMP
department         -> ENUM('IT','HR','FINANCE','MARKETING')
country            -> VARCHAR(50) 
gender             -> ENUM('Male','Female','Other')
skills             -> VARCHAR(255) / separate table recommended
termsAccepted      -> BOOLEAN
address            -> TEXT
nic                -> VARCHAR(12)
documentFile       -> VARCHAR(255)   // usually save file path or file name
profileImage       -> VARCHAR(255)   // usually save image path or file name
recordId           -> INT / BIGINT
    </pre>
</div>


<%-- ============================================================
     SECTION 3: NOTES ABOUT WHICH SQL TYPES TO CHOOSE
     ============================================================ --%>
<div class="section">
    <h2>Section 3: Notes</h2>

    <p><strong>Text fields</strong> like name, email, phone usually go as <code>VARCHAR</code>.</p>
    <p><strong>Long text</strong> like address, description, comments usually go as <code>TEXT</code>.</p>
    <p><strong>Dropdowns</strong> can use <code>ENUM</code> if the values are fixed and small.</p>
    <p><strong>Radio buttons</strong> also usually use <code>ENUM</code> or <code>VARCHAR</code>.</p>
    <p><strong>Checkbox single value</strong> like accepted/not accepted usually uses <code>BOOLEAN</code>.</p>
    <p><strong>Multiple checkboxes</strong> can be saved as a comma-separated <code>VARCHAR</code>, but the better way is a <strong>separate table</strong>.</p>
    <p><strong>Date input</strong> uses <code>DATE</code>.</p>
    <p><strong>Time input</strong> uses <code>TIME</code>.</p>
    <p><strong>Date and time together</strong> uses <code>DATETIME</code> or <code>TIMESTAMP</code>.</p>
    <p><strong>File uploads</strong> usually do not store the full file inside the DB in beginner projects. Usually you save the <strong>file path or file name</strong> in a <code>VARCHAR</code> column.</p>
</div>


<%-- ============================================================
     SECTION 4: EXAMPLE SQL CREATE TABLE
     This is just an example table matching the form above
     ============================================================ --%>
<div class="section">
    <h2>Section 4: Example SQL Table</h2>

    <pre>
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(150),
    password VARCHAR(255),
    phone VARCHAR(15),
    age INT,
    dob DATE,
    appointment_time TIME,
    meeting_datetime DATETIME,
    department ENUM('IT','HR','FINANCE','MARKETING'),
    country VARCHAR(50),
    gender ENUM('Male','Female','Other'),
    skills VARCHAR(255),
    terms_accepted BOOLEAN,
    address TEXT,
    nic VARCHAR(12),
    document_file VARCHAR(255),
    profile_image VARCHAR(255)
);
    </pre>
</div>

</body>
</html>
