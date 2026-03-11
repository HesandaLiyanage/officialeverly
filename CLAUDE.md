# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Everly is a Java web application for preserving personal memories, journals, autographs, and social sharing. It runs on **Tomcat 9** with **Java 17**, uses **JSP/JSTL** for views, **PostgreSQL** for the database, and **Maven** for builds.

## Build & Run

```bash
# Build WAR file
./mvnw clean package

# Build without tests (no tests exist yet)
./mvnw clean package -DskipTests

# Deploy: copy target/demo-1.0-SNAPSHOT.war to Tomcat's webapps/ directory
```

Database config is loaded from `src/main/resources/config/db.properties` (create from the template in `DatabaseUtil.java` defaults). Connection params are also in `WEB-INF/web.xml` context-params.

## Architecture

### Routing

- **`FrontControllerServlet`** (`src/main/java/com/demo/web/middleware/`) — maps `/` and handles all URL routing. It maintains two maps:
  - `routeToJsp`: routes that forward directly to a JSP (no data needed)
  - `routeToController`: routes that forward to a view controller servlet (needs data fetching)
- **`web.xml`** (`src/main/webapp/WEB-INF/`) — registers all servlets and their URL patterns. Every new servlet must be registered here.
- **`AuthenticationFilter`** (`src/main/java/com/demo/web/filter/`) — intercepts all requests, checks session validity, redirects unauthenticated users to login. Public paths are whitelisted in the filter's `init()` method.

### Layer Structure (feature-folder based)

Code is organized by **feature domain**, not by layer. Each feature folder contains its own controller, DAO, and model classes:

```
src/main/java/com/demo/web/
├── controller/           # Servlets (one per action)
│   ├── Auth/             # Login, Signup, Google OAuth, Logout
│   ├── Memory/           # CRUD + collaborative memories, media, recaps
│   ├── Journals/         # CRUD + recycle bin, streaks
│   ├── Autographs/       # CRUD + share links, entries
│   ├── Groups/           # CRUD + invites, announcements, members
│   ├── Events/           # CRUD + voting
│   ├── Feed/             # Posts, profiles, follow, block, comments
│   ├── Notifications/    # List, count, preferences
│   ├── Vault/            # Password-protected storage
│   ├── Settings/         # Profile, subscription, devices, deactivation
│   └── _unused/          # Deprecated servlets (do not use)
├── dao/                  # Data access (same feature subfolders)
├── model/                # POJOs (same feature subfolders)
├── filter/               # AuthenticationFilter
├── middleware/            # FrontControllerServlet
└── util/                 # DatabaseUtil, SessionUtil, PasswordUtil, ValidationUtil, EncryptionService
```

### Views

JSPs mirror the same feature-folder structure as Java code:

```
src/main/webapp/
├── views/public/              # Landing, login, signup, password reset (no auth)
├── views/app/                 # Authenticated app pages
│   ├── Admin/                 # Admin dashboard, users, settings, analytics
│   ├── Autographs/            # Add, view, edit, write, share autographs
│   ├── Feed/                  # Profiles, followers, following, blocked users
│   ├── Journals/              # List, view, edit, write journals, trash mgmt
│   ├── Notifications/         # Notifications list
│   ├── Settings/              # Account, subscription, privacy, devices, storage
│   ├── Vault/                 # Setup, entries, password, vault memories/journals
│   ├── _unused/               # Deprecated JSPs
│   └── dashboard.jsp          # Main dashboard (general, not feature-specific)
├── WEB-INF/views/app/         # Protected JSPs (not directly accessible via URL)
│   ├── Events/                # Create, edit, dashboard, event info
│   ├── Feed/                  # Public feed, posts, comments, profile setup
│   ├── Groups/                # Create, edit, dashboard, members, announcements
│   └── Memory/                # Create, edit, view, collab, recap
├── resources/css/             # Per-feature CSS files
└── resources/assets/          # Static images, video
```

### Database

- **PostgreSQL** via JDBC (no ORM). All DAOs use `DatabaseUtil.getConnection()` for raw connections.
- Schema migrations live in `src/main/resources/database/migrations/`
- Seed data in `src/main/resources/database/data.sql`

### Controller Naming Convention

Controllers follow the pattern `{Feature}{Action}.java`:
- **View/List controllers**: `MemoriesList`, `JournalView`, `FeedView` — handle GET, fetch data, forward to JSP
- **Action controllers**: `MemoryCreate`, `MemoryUpdate`, `MemoryDelete` — handle POST, perform action, redirect

### Adding a New Feature

1. Create model class in `model/{Feature}/`
2. Create DAO class in `dao/{Feature}/`
3. Create controller servlet(s) in `controller/{Feature}/`
4. Register servlet + mapping in `WEB-INF/web.xml`
5. Add route in `FrontControllerServlet.init()` (JSP or controller route)
6. If public, add path to `AuthenticationFilter.publicPaths`
7. Create JSP in `views/app/{Feature}/` or `WEB-INF/views/app/{Feature}/`

### Key Utilities

- **`DatabaseUtil`** — PostgreSQL connection management, loads config from `db.properties`
- **`SessionUtil`** — Session validation against database
- **`PasswordUtil`** — Password hashing
- **`ValidationUtil`** — Input validation
- **`EncryptionService`** — Data encryption for sensitive content

### Conventions

- Servlet packaging uses `javax.servlet` (not Jakarta) — this is a Java EE / Tomcat 9 project
- WAR packaging (not Spring Boot)
- No dependency injection framework — manual instantiation throughout
- `_unused/` folders contain deprecated code that should not be referenced
