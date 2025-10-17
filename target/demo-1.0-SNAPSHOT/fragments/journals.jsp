<%@ page import="java.util.*" %>
<%
  // ----- Simulated Journal Entries -----
  class Journal {
    String title, date, tag, image;
    Journal(String title, String date, String tag, String image) {
      this.title = title;
      this.date = date;
      this.tag = tag;
      this.image = image;
    }
  }

  List<Journal> journals = new ArrayList<>();
  journals.add(new Journal("July 21st - Birthday party", "July 15, 2024", "#vacation", "images/journal1.jpg"));
  journals.add(new Journal("July 31st", "June 22, 2024", "#travel", "images/journal2.jpg"));
  journals.add(new Journal("June 30", "May 10, 2024", "#family", "images/journal3.jpg"));
  journals.add(new Journal("March 20", "April 5, 2024", "#adventure", "images/journal4.jpg"));
  journals.add(new Journal("March 21st", "March 18, 2024", "#city", "images/journal5.jpg"));
  journals.add(new Journal("Art Exhibition", "February 2, 2024", "#art", "images/journal6.jpg"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Journals</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/journal.css">
</head>
<body>
<jsp:include page="/fragments/header2.jsp" />
<div class="journals-page">

  <!-- ===== Left Side (Main Content) ===== -->
  <div class="main-content">

    <div class="journals-header">
      <h1>Journals</h1>
    </div>

    <!-- Search Bar -->
    <div class="search-bar">
      <span class="search-logo">🔍</span>
      <input type="text" id="searchInput" placeholder="Search journals" onkeyup="searchJournals()">
    </div>

    <!-- Filters -->
    <div class="filters">
      <div class="filter-box" onclick="sortByDate()">Sort: Date ▼</div>
      <div class="filter-box" onclick="filterTags()">Filter: Tags ▼</div>
      <div class="filter-box" onclick="toggleView()">View: Grid ▼</div>
    </div>

    <!-- Pinned Journals -->
    <h2 class="pinned-header">Pinned Journals</h2>
    <div class="journal-entries" id="journalList">
      <% for (Journal j : journals) { %>
      <div class="journal-entry" style="background-image:url('<%= j.image %>');">
        <h2><%= j.title %></h2>
        <p><%= j.date %> · <%= j.tag %></p>
      </div>
      <% } %>
    </div>

    <!-- Buttons -->
    <div class="journal-actions">
      <button class="add-journal-btn">Add a Journal Entry</button>
      <button class="vault-btn">Vault</button>
    </div>
  </div>

  <!-- ===== Right Side (Sidebar) ===== -->
  <div class="sidebar">

    <!-- Streak Section -->
    <div class="sidebar-section">
      <h2>Streak 🔥</h2>
      <div class="streak-container">
        <div class="streak-icon">🔥</div>
        <div class="streak-info">
          <p class="streak-label">Journal</p>
          <p class="streak-days">36 days</p>
        </div>
      </div>
    </div>

    <!-- Milestones -->
    <div class="sidebar-section">
      <h2>Milestones</h2>
      <div class="milestone-item">
        <div class="milestone-icon">📅</div>
        <div class="milestone-content">
          <p class="milestone-title">Two Weeks</p>
        </div>
      </div>
      <div class="milestone-item">
        <div class="milestone-icon">📅</div>
        <div class="milestone-content">
          <p class="milestone-title">One Month</p>
        </div>
      </div>
      <div class="milestone-item">
        <div class="milestone-icon">📅</div>
        <div class="milestone-content">
          <p class="milestone-title">Three Months</p>
        </div>
      </div>
      <div class="milestone-item">
        <div class="milestone-icon">📅</div>
        <div class="milestone-content">
          <p class="milestone-title">Six Months</p>
        </div>
      </div>
      <div class="milestone-item">
        <div class="milestone-icon">📅</div>
        <div class="milestone-content">
          <p class="milestone-title">One Year</p>
        </div>
      </div>
    </div>

    <!-- Favourites -->
    <div class="sidebar-section">
      <h2>Favourites</h2>
      <div class="favourite-item">
        <div class="favourite-icon">📘</div>
        <div class="favourite-content">
          <p class="favourite-title">July 6th</p>
          <p class="favourite-subtitle">36 days</p>
        </div>
      </div>
      <div class="favourite-item">
        <div class="favourite-icon">📘</div>
        <div class="favourite-content">
          <p class="favourite-title">Two Weeks</p>
        </div>
      </div>
      <div class="favourite-item">
        <div class="favourite-icon">📘</div>
        <div class="favourite-content">
          <p class="favourite-title">One Month</p>
        </div>
      </div>
      <div class="favourite-item">
        <div class="favourite-icon">📘</div>
        <div class="favourite-content">
          <p class="favourite-title">Three Months</p>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- Simple JS for interactions -->
<script>
  function searchJournals() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const entries = document.querySelectorAll(".journal-entry");
    entries.forEach(entry => {
      const text = entry.textContent.toLowerCase();
      entry.style.display = text.includes(input) ? "flex" : "none";
    });
  }

  function sortByDate() {
    alert("Sorting by Date (Demo)");
  }

  function filterTags() {
    alert("Filtering Tags (Demo)");
  }

  function toggleView() {
    alert("Toggling View (Demo)");
  }
</script>
<jsp:include page="/fragments/footer.jsp" />
</body>
</html>
