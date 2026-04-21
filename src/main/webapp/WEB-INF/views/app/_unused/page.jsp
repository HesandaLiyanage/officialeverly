<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Codecheck Cheat Sheet</title>
</head>
<body>

<%-- ============================================================
     SECTION 1: FIELD VALUE THRESHOLD LABELS  (JSP / JSTL)
     Scenario: You stored a numeric value (e.g. salary, budget,
     transaction amount) in the DB. On the view page, show a
     label based on how big the number is.
     ============================================================ --%>

<%-- --- 1A: Single threshold — show "High Value" if > 100,000 --- --%>
<c:choose>
    <c:when test="${amount > 100000}">
        <span class="tag high">High Value</span>
    </c:when>
    <c:otherwise>
        <span class="tag normal">Normal</span>
    </c:otherwise>
</c:choose>

<%-- --- 1B: Multi-tier threshold (budget / salary / any number) --- --%>
<c:choose>
    <c:when test="${amount >= 500000}">
        <span>Very High</span>
    </c:when>
    <c:when test="${amount >= 300000}">
        <span>High</span>
    </c:when>
    <c:when test="${amount >= 100000}">
        <span>Medium</span>
    </c:when>
    <c:otherwise>
        <span>Low</span>
    </c:otherwise>
</c:choose>

<%-- --- 1C: Age-based label (from Task: add age field) --- --%>
<c:choose>
    <c:when test="${customer.age >= 60}">
        <span>Senior</span>
    </c:when>
    <c:when test="${customer.age >= 18}">
        <span>Adult</span>
    </c:when>
    <c:otherwise>
        <span>Minor</span>
    </c:otherwise>
</c:choose>

<%-- --- 1D: Age validation — show error if age is invalid in JSP --- --%>
<c:if test="${customer.age < 0 || customer.age > 120}">
    <span class="error">Invalid age</span>
</c:if>

<%-- ============================================================
     SECTION 2: DATE FIELD — DISPLAY & VALIDATION  (JSP / JSTL)
     Scenario: You stored a registration date. Show it on
     profile page. Also prevent future dates.
     ============================================================ --%>

<%-- --- 2A: Display a stored date on the profile page --- --%>
<p>Date of Registration:
    <fmt:formatDate value="${company.registeredDate}" pattern="dd MMM yyyy" />
</p>

<%-- --- 2B: Show warning if the stored date is in the future (server-side check) --- --%>
<%@ page import="java.util.Date" %>
<%
    // In a real servlet, do this check before forwarding.
    // Here as a JSP scriptlet fallback:
    java.util.Date regDate = (java.util.Date) request.getAttribute("registeredDate");
    boolean isFutureDate = regDate != null && regDate.after(new java.util.Date());
    request.setAttribute("isFutureDate", isFutureDate);
%>
<c:if test="${isFutureDate}">
    <span class="error">Registration date cannot be a future date.</span>
</c:if>

<%-- ============================================================
     SECTION 3: TABLE COLUMN — DISPLAY RETRIEVED FIELD
     Scenario: Task 1 type. You added a new column to DB and
     need to show it in a table on the frontend.
     ============================================================ --%>

<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Phone</th>
        <th>Age</th>
        <th>Registered Date</th>
        <th>Budget</th>
        <th>Budget Level</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${itemList}">
        <tr>
            <td>${item.name}</td>
            <td>${item.phone}</td>
            <td>${item.age}</td>
            <td><fmt:formatDate value="${item.registeredDate}" pattern="dd MMM yyyy" /></td>
            <td>${item.budget}</td>
            <td>
                <c:choose>
                    <c:when test="${item.budget > 300000}">
                        <span>High</span>
                    </c:when>
                    <c:otherwise>
                        <span>Low</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<%-- ============================================================
     SECTION 4: JAVASCRIPT VALIDATIONS
     All client-side. Call validateForm() on form submit.
     Each function returns true (valid) or false (invalid).
     ============================================================ --%>

<script>

    // ---------------------------------------------------------------
    // 4A: Phone Number Validation
    // Rule: 10 digits, must start with 07
    // ---------------------------------------------------------------
    function validatePhone(phone) {
        var pattern = /^07\d{8}$/;
        if (!pattern.test(phone)) {
            alert("Phone number must be 10 digits and start with 07.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4B: Phone with Country Code (split field)
    // Rule: country code from dropdown + 9-digit local number
    // ---------------------------------------------------------------
    function validateSplitPhone(countryCode, localNumber) {
        var localPattern = /^\d{9}$/;
        if (!countryCode || countryCode === "") {
            alert("Please select a country code.");
            return false;
        }
        if (!localPattern.test(localNumber)) {
            alert("Local number must be exactly 9 digits.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4C: Image File Type Validation
    // Rule: only jpg, jpeg, png, gif allowed
    // ---------------------------------------------------------------
    function validateImageFile(input) {
        var allowedTypes = ["image/jpeg", "image/png", "image/gif", "image/webp"];
        var file = input.files[0];
        if (!file) {
            alert("Please select a file.");
            return false;
        }
        if (!allowedTypes.includes(file.type)) {
            alert("Only image files (JPG, PNG, GIF) are allowed.");
            return false;
        }
        return true;
    }
    
    // ---------------------------------------------------------------
    // 4D: PDF File Type Validation
    // Rule: only PDF allowed
    // ---------------------------------------------------------------
    function validatePdfFile(input) {
        var file = input.files[0];
        if (!file) {
            alert("Please select a file.");
            return false;
        }
        if (file.type !== "application/pdf") {
            alert("Only PDF files are allowed.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4E: Vehicle Chassis Number Validation
    // Rule: first char = letter, last char = letter, middle = digits
    // Example valid: A12345B
    // ---------------------------------------------------------------
    function validateChassisNumber(chassis) {
        var pattern = /^[A-Za-z]\d+[A-Za-z]$/;
        if (!pattern.test(chassis)) {
            alert("Chassis number: first and last characters must be letters, middle must be digits. e.g. A12345B");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4F: Age Validation
    // Rule: must be a positive integer, reasonable range (0-120)
    // ---------------------------------------------------------------
    function validateAge(age) {
        var ageInt = parseInt(age, 10);
        if (isNaN(ageInt) || ageInt < 0 || ageInt > 120) {
            alert("Age must be a number between 0 and 120.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4G: Future Date Prevention
    // Rule: selected date must not be after today
    // ---------------------------------------------------------------
    function validateNotFutureDate(dateValue) {
        var selected = new Date(dateValue);
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        if (selected > today) {
            alert("Date cannot be in the future.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4H: Numeric Threshold Check (JS version of the JSTL logic above)
    // Rule: if value > threshold, label as High, else Low
    // ---------------------------------------------------------------
    function getBudgetLabel(amount) {
        if (amount >= 500000) return "Very High";
        if (amount >= 300000) return "High";
        if (amount >= 100000) return "Medium";
        return "Low";
    }

    // Show label inline next to an input field dynamically
    function showBudgetLabel(inputId, labelId) {
        var amount = parseFloat(document.getElementById(inputId).value);
        var label = getBudgetLabel(amount);
        document.getElementById(labelId).textContent = label;
    }

    // ---------------------------------------------------------------
    // 4I: "High Value" tag — show if field > 100,000
    // ---------------------------------------------------------------
    function checkHighValue(inputId, tagId) {
        var value = parseFloat(document.getElementById(inputId).value);
        var tag = document.getElementById(tagId);
        if (value > 100000) {
            tag.style.display = "inline";
            tag.textContent = "High Value";
        } else {
            tag.style.display = "none";
        }
    }

    // ---------------------------------------------------------------
    // 4J: Email Validation (common extra task)
    // ---------------------------------------------------------------
    function validateEmail(email) {
        var pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!pattern.test(email)) {
            alert("Please enter a valid email address.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4K: NIC Validation (Sri Lanka)
    // Rule: old format = 9 digits + V/X, new format = 12 digits
    // ---------------------------------------------------------------
    function validateNIC(nic) {
        var oldPattern = /^\d{9}[VvXx]$/;
        var newPattern = /^\d{12}$/;
        if (!oldPattern.test(nic) && !newPattern.test(nic)) {
            alert("Invalid NIC. Use 9 digits + V/X (old) or 12 digits (new).");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4L: Required / Not Empty
    // ---------------------------------------------------------------
    function validateRequired(value, fieldName) {
        if (!value || value.trim() === "") {
            alert(fieldName + " is required.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4M: Min / Max Length
    // ---------------------------------------------------------------
    function validateLength(value, min, max, fieldName) {
        if (value.length < min || value.length > max) {
            alert(fieldName + " must be between " + min + " and " + max + " characters.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4N: Numbers Only (no letters)
    // ---------------------------------------------------------------
    function validateNumbersOnly(value, fieldName) {
        var pattern = /^\d+$/;
        if (!pattern.test(value)) {
            alert(fieldName + " must contain numbers only.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4O: Letters Only (no numbers or special chars)
    // ---------------------------------------------------------------
    function validateLettersOnly(value, fieldName) {
        var pattern = /^[A-Za-z\s]+$/;
        if (!pattern.test(value)) {
            alert(fieldName + " must contain letters only.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4P: URL Validation
    // ---------------------------------------------------------------
    function validateURL(url) {
        var pattern = /^(https?:\/\/)[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$/;
        if (!pattern.test(url)) {
            alert("Please enter a valid URL (must start with http:// or https://).");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // 4Q: File Size Limit (e.g. max 2MB)
    // ---------------------------------------------------------------
    function validateFileSize(input, maxMB) {
        var file = input.files[0];
        if (!file) return true;
        var maxBytes = maxMB * 1024 * 1024;
        if (file.size > maxBytes) {
            alert("File size must be less than " + maxMB + "MB.");
            return false;
        }
        return true;
    }

    // ---------------------------------------------------------------
    // COMBINED EXAMPLE — how to wire all of this into a form submit
    // ---------------------------------------------------------------
    function validateForm() {
        var name    = document.getElementById("name").value;
        var phone   = document.getElementById("phone").value;
        var age     = document.getElementById("age").value;
        var regDate = document.getElementById("registeredDate").value;
        var nic     = document.getElementById("nic").value;
        var chassis = document.getElementById("chassisNumber").value;
        var fileInput = document.getElementById("fileUpload");

        if (!validateRequired(name, "Name"))           return false;
        if (!validateLettersOnly(name, "Name"))        return false;
        if (!validatePhone(phone))                     return false;
        if (!validateAge(age))                         return false;
        if (!validateNotFutureDate(regDate))           return false;
        if (!validateNIC(nic))                         return false;
        if (!validateChassisNumber(chassis))           return false;
        if (!validatePdfFile(fileInput))               return false;

        return true;
    }

</script>

<%-- ============================================================
     SECTION 5: FORM EXAMPLES WITH HTML + INPUT FIELDS
     These are the input fields for the tasks above.
     Swap IDs and names to match your actual form.
     ============================================================ --%>

<%-- --- Full Example Form (adapt to your actual form) --- --%>
<form action="save" method="post" onsubmit="return validateForm();" enctype="multipart/form-data">

    <%-- Name field --%>
    <label>Name:</label>
    <input type="text" id="name" name="name" />

    <%-- Age field --%>
    <label>Age:</label>
    <input type="number" id="age" name="age" />

    <%-- Phone (single field, starts with 07, 10 digits) --%>
    <label>Phone:</label>
    <input type="text" id="phone" name="phone" maxlength="10" />

    <%-- Phone (split field: country code dropdown + 9 digits) --%>
    <label>Country Code:</label>
    <select id="countryCode" name="countryCode">
        <option value="">-- Select --</option>
        <option value="+94">+94 (Sri Lanka)</option>
        <option value="+1">+1 (USA)</option>
        <option value="+44">+44 (UK)</option>
        <option value="+91">+91 (India)</option>
    </select>
    <input type="text" id="localNumber" name="localNumber" maxlength="9" placeholder="9 digit number" />

    <%-- Date of Registration (no future dates) --%>
    <label>Date of Registration:</label>
    <input type="date" id="registeredDate" name="registeredDate" />

    <%-- NIC --%>
    <label>NIC:</label>
    <input type="text" id="nic" name="nic" />

    <%-- Vehicle Chassis Number --%>
    <label>Chassis Number:</label>
    <input type="text" id="chassisNumber" name="chassisNumber" placeholder="e.g. A12345B" />

    <%-- Budget with live label --%>
    <label>Budget:</label>
    <input type="number" id="budget" name="budget"
           oninput="checkHighValue('budget', 'budgetTag'); showBudgetLabel('budget', 'budgetLevel')" />
    <span id="budgetTag" style="display:none; color:red; font-weight:bold;"></span>
    <span id="budgetLevel"></span>

    <%-- Image upload --%>
    <label>Profile Image:</label>
    <input type="file" id="imageUpload" name="imageUpload"
           onchange="validateImageFile(this)" accept="image/*" />

    <%-- PDF upload --%>
    <label>Document (PDF only):</label>
    <input type="file" id="fileUpload" name="fileUpload"
           onchange="validatePdfFile(this)" accept=".pdf" />

    <button type="submit">Submit</button>
</form>

<%-- ============================================================
     SECTION 6: BACKEND REGEX VALIDATION (JAVA - SERVER SIDE)
     This shows how regex is actually handled in backend (Servlet/Service layer).
     Note: This is NOT JSP logic — just included here for reference.
     ============================================================ --%>

<%-- Example: Sri Lankan NIC validation using regex in backend --%>

<%
    /*
    private boolean isValidSriLankanNic(String nic) {
        if (nic == null) return false;
        String value = nic.trim();
        return value.matches("^(?:\\d{9}[VvXx]|\\d{12})$");
    }
    
    if (!isValidSriLankanNic(nic)) {
        return MemoryCreateResponse.error("NIC format is wrong", 400);
    }
    */
%>


<%-- ============================================================
     SECTION 7: COMMON REGEX PATTERNS (CHEAT SHEET)
     These are useful patterns + what they do.
     ============================================================ --%>

<%
    /*
    
    1. Only Numbers
    Regex: ^\\d+$
    Meaning: Only digits (0–9), any length
    Examples: 123, 99999 ✔ | 12a ❌
    
    
    2. Only Letters (A-Z, a-z)
    Regex: ^[A-Za-z]+$
    Meaning: Only alphabet characters
    Examples: Hello ✔ | Hello123 ❌
    
    
    3. Letters + Spaces
    Regex: ^[A-Za-z\\s]+$
    Meaning: Letters and spaces only
    Examples: John Doe ✔ | John123 ❌
    
    
    4. Exact Length (e.g., exactly 10 digits)
    Regex: ^\\d{10}$
    Meaning: Must be exactly 10 numbers
    Examples: 0712345678 ✔ | 07123 ❌
    
    
    5. Range Length (e.g., 5 to 10 characters)
    Regex: ^.{5,10}$
    Meaning: Any character, length between 5 and 10
    Examples: Hello ✔ | Hi ❌
    
    
    6. Starts With Specific Value
    Regex: ^07\\d{8}$
    Meaning: Must start with 07 and total 10 digits
    Examples: 0771234567 ✔ | 0812345678 ❌
    
    
    7. Ends With Specific Character
    Regex: ^\\d{9}[VvXx]$
    Meaning: 9 digits + ends with V/X
    Examples: 123456789V ✔ | 123456789A ❌
    
    
    8. Sri Lankan NIC (Old + New)
    Regex: ^(?:\\d{9}[VvXx]|\\d{12})$
    Meaning:
    - Old NIC → 9 digits + V/X
    - New NIC → 12 digits
    Examples:
    123456789V ✔
    200012345678 ✔
    12345 ❌
    
    
    9. Email (Basic)
    Regex: ^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$
    Meaning: Basic email validation
    Examples: test@gmail.com ✔ | test@ ❌
    
    
    10. Alphanumeric Only
    Regex: ^[A-Za-z0-9]+$
    Meaning: Letters + numbers only (no symbols)
    Examples: abc123 ✔ | abc@123 ❌
    
    
    */
%>

</body>
</html>
