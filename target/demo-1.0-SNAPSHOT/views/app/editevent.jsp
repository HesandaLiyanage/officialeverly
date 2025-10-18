<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/events.css">

<div class="container create-event-container">
    <h1>Edit Event</h1>

    <form id="eventForm">
        <!-- Event Title -->
        <div class="form-group">
            <label for="eventTitle">Event Title</label>
            <input type="text" id="eventTitle" placeholder="Enter event title" required />
        </div>

        <!-- Event Type -->
        <div class="form-group">
            <label for="eventType">Event Type</label>
            <select id="eventType" required>
                <option value="" disabled selected>Select event type</option>
                <option value="concert">Concert</option>
                <option value="conference">Conference</option>
                <option value="workshop">Workshop</option>
                <option value="meetup">Meetup</option>
            </select>
        </div>

        <!-- Date -->
        <div class="form-group">
            <label for="eventDate">Date</label>
            <input type="text" id="eventDate" placeholder="Select date" readonly />
            <span class="calendar-icon">📅</span>
        </div>

        <!-- Location -->
        <div class="form-group">
            <label for="location">Location</label>
            <input type="text" id="location" placeholder="Enter location" required />
        </div>

        <!-- Description -->
        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" rows="5" placeholder="Enter event description"></textarea>
        </div>

        <!-- Upload Image -->
        <div class="upload-box">
            <h3>Upload Image or Cover Photo</h3>
            <p>Drag and drop or click to upload</p>
            <button type="button" class="upload-btn">Upload</button>
            <input type="file" id="imageUpload" accept="image/*" style="display: none;" />
        </div>

        <!-- Select Group -->
        <div class="form-group">
            <label for="groupSelect">Select the group</label>
            <select id="groupSelect" required>
                <option value="" disabled selected>Select the group you want to assign</option>
                <option value="group1">Group A</option>
                <option value="group2">Group B</option>
                <option value="group3">Group C</option>
            </select>
        </div>

        <!-- Add Tags -->
        <div class="form-group">
            <label for="tags">Add Tags</label>
            <input type="text" id="tags" placeholder="Enter tags" />
        </div>

        <!-- Buttons -->
        <div class="form-actions">
            <button type="submit" class="btn-create">Create New Event</button>
            <button type="button" class="btn-cancel">Cancel</button>
        </div>
    </form>
</div>

<script>
    // Upload functionality
    document.querySelector('.upload-btn').addEventListener('click', function() {
        document.getElementById('imageUpload').click();
    });

    document.getElementById('imageUpload').addEventListener('change', function(e) {
        if (e.target.files.length > 0) {
            alert('File selected: ' + e.target.files[0].name);
        }
    });

    // Simulate date input
    document.getElementById('eventDate').addEventListener('focus', function() {
        this.value = new Date().toISOString().split('T')[0];
    });

    // Optional: Form submission handling
    document.getElementById('eventForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Event created successfully!');
        // Add your AJAX or redirect logic here
    });
</script>

<jsp:include page="../public/footer.jsp"/>