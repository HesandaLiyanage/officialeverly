<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Groups - Everly</title>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/groups.css">

</head>
<body>
<!-- Include Header -->
<jsp:include page="../public/header2.jsp"/>

<!-- Main Content -->
<main class="main-content">
  <div class="content-container">
    <div class="header-section">
      <h1>Groups</h1>
      <button class="add-btn">+</button>
    </div>

    <!-- Groups List -->
    <div class="groups-list">
      <!-- Family Memories Group -->
      <a href="groupmemories.jsp?groupId=1" class="group-item">
        <div class="group-info">
          <h2 class="group-title">Family Memories</h2>
          <p class="group-meta">5 members · Last memory added 2 weeks ago</p>
        </div>
        <div class="group-images">
          <div class="image-placeholder peach"></div>
          <div class="image-card family-photo"></div>
          <div class="image-placeholder beige"></div>
        </div>
      </a>

      <!-- Highschool Friends Group -->
      <a href="groupmemories.jsp?groupId=2" class="group-item">
        <div class="group-info">
          <h2 class="group-title">Highschool Friends</h2>
          <p class="group-meta">22 members · Last memory added 1 week ago</p>
        </div>
        <div class="group-images single">
          <div class="image-card beach-photo"></div>
        </div>
      </a>

      <!-- Uni Friends Group -->
      <a href="groupmemories.jsp?groupId=3" class="group-item">
        <div class="group-info">
          <h2 class="group-title">Uni Friends</h2>
          <p class="group-meta">25 members · Last memory added 3 days ago</p>
        </div>
        <div class="group-images single">
          <div class="image-card balloons-photo"></div>
        </div>
      </a>

      <!-- Roomies Group -->
      <a href="groupmemories.jsp?groupId=4" class="group-item">
        <div class="group-info">
          <h2 class="group-title">Roomies</h2>
          <p class="group-meta">10 members · Last memory added 1 month ago</p>
        </div>
        <div class="group-images single">
          <div class="image-card roomies-photo"></div>
        </div>
      </a>
    </div>
  </div>
</main>

<!-- Include Footer -->
<jsp:include page="../public/footer.jsp"/>
</body>
</html>