<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../public/header2.jsp"/>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/events.css">

<div class="event-detail-container">
    <!-- Banner Image -->
    <div class="event-banner">
        <img src="https://via.placeholder.com/1200x400?text=Summer+Music+Festival" alt="Event Banner" />
    </div>

    <!-- Event Info -->
    <div class="event-info">
        <span>July 15, 2023 · Concert · Uni Friends</span>
    </div>

    <!-- Event Description -->
    <div class="event-description">
        <p>The Summer Music Festival was an unforgettable experience. The energy of the crowd, the incredible performances, and the overall atmosphere were electric. From the opening act to the headliner, every moment was filled with excitement and joy. The food was delicious, and the after-party was the perfect way to end the night. I can’t wait for next year’s festival!</p>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <a href="memories.jsp" class="btn-primary">Go to the Memory</a>
        <div class="secondary-actions">
            <a href="editevent.jsp" class="btn-secondary">Edit</a>
            <a href="deleteevent.jsp" class="btn-secondary btn-delete">Delete</a>
        </div>
    </div>
</div>

<jsp:include page="../public/footer.jsp"/>