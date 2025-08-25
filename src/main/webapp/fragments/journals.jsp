<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Journals Page</title>
  <link rel="stylesheet" href="main.css">
</head>
<body>
<div class="journals-page">
  <!-- Header -->
  <div class="journals-header">
    <h1>Journals</h1>
    <div class="search-bar">
      <div class="search-logo">🔍</div>
      <input type="text" placeholder="Search journals..." />
    </div>
  </div>

  <!-- Filters -->
  <div class="filters">
    <div class="filter-box">
      <div class="filter-logo">🏷️</div>
      <span>Tags</span>
    </div>
    <div class="filter-box">
      <div class="filter-logo">👥</div>
      <span>Friends</span>
    </div>
    <div class="filter-box">
      <div class="filter-logo">⏰</div>
      <span>Time</span>
    </div>
  </div>

  <!-- Journal entries -->
  <div class="journal-entries">
    <div class="journal-entry" style="background-image: url('https://via.placeholder.com/300x176');">
      <div class="journal-text">
        <h2>Journal Title 1</h2>
        <p>This is a short description of the journal entry.</p>
      </div>
    </div>
    <div class="journal-entry" style="background-image: url('https://via.placeholder.com/300x176');">
      <div class="journal-text">
        <h2>Journal Title 2</h2>
        <p>Another description of a different journal entry.</p>
      </div>
    </div>
    <!-- Add more journal entries as needed -->
  </div>

  <div class="journal-actions">
    <button class="add-journal-btn">Add a Journal Entry</button>
    <button class="vault-btn">Vault</button>
  </div>

</div>
</body>
</html>
