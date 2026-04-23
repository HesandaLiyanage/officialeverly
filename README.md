# Everly (Second-Year Group Project)

Everly is a Java web application for managing private/collaborative memories, sharing selected memories to a public feed, journaling, vault/recycle features, groups/events, and admin tooling.

This repository contains the web/backend codebase built with a classic Java WAR stack and a manually wired layered architecture.

## Tech Stack
- **Backend/Web:** Java 17, Servlets, JSP, JSTL, Tomcat (WAR deployment)
- **Data Access:** JDBC
- **Database:** PostgreSQL
- **Build:** Maven
- **Frontend scripting:** TypeScript/JavaScript modules under `src/main/webapp/resources/ts`
- **JSON tooling:** Gson, org.json

> Note: A small Kotlin mobile companion app was also built for this project; this repository is focused on the web/backend implementation.

---

## Architecture (Spring-style layering, manually wired)

The project follows a Spring Boot-like separation of concerns, implemented directly with Servlets + `web.xml` + custom middleware.

### Core layers
- **Controller layer:** Extracts HTTP params, builds DTOs, delegates to services
- **Service layer:** Business logic, validations, orchestration, security flows
- **DAO layer:** SQL queries and result mapping
- **Model/DTO layer:** Data contracts and entities

### Routing and request handling
- **Front Controller:** `src/main/java/com/demo/web/middleware/FrontControllerServlet.java`
  - Central route map for JSP routes and controller forwards
  - Handles both static JSP dispatch and feature controller dispatch
- **Authentication Filter:** `src/main/java/com/demo/web/filter/AuthenticationFilter.java`
  - Guards non-public endpoints
  - Skips static resources
  - Uses DB-backed session validation before allowing protected requests

### Session model
- **Session utility:** `src/main/java/com/demo/web/util/SessionUtil.java`
- **Session DAO:** `src/main/java/com/demo/web/dao/Auth/userSessionDAO.java`

Sessions are persisted in `user_sessions` with device metadata, expiry, and active-state management.

---

## Security and Encryption (Implemented)

Primary encryption logic is in:
- `src/main/java/com/demo/web/util/EncryptionService.java`
- Used by memory/media workflows in `src/main/java/com/demo/web/service/MemoryService.java`

### What is implemented

#### 1) Auth password hashing
- Utility: `PasswordUtil`
- Algorithm: `SHA-256` with per-user random salt (stored salt + hash comparison)

#### 2) Key derivation for encryption keys
- PBKDF2 algorithm: `PBKDF2WithHmacSHA256`
- Iteration count: **100000**
- Salt length: **32 bytes**
- AES key size: **256-bit**

#### 3) Symmetric encryption mode
- Cipher: **AES/GCM/NoPadding**
- IV length: **12 bytes**
- Auth tag length: **16 bytes**

#### 4) User master key lifecycle
- On signup/setup, a user master key is generated and encrypted using a password-derived key
- Encrypted key + derivation salt are stored in user records/metadata
- Master key can be unlocked after authentication for protected operations

#### 5) Media-at-rest encryption pipeline
In `MemoryService.processMediaUploads(...)`:
1. Read uploaded file bytes
2. Generate a unique per-file key
3. Encrypt file bytes with per-file key (AES-GCM)
4. Encrypt per-file key with server master key
5. Persist encrypted file payload on disk
6. Persist encryption key metadata + IVs in DB
7. Persist media metadata and memory linkage

#### 6) Decryption/stream flow
When serving media, service checks access permissions first, then decrypts using stored metadata and server master key.

### Chunking support
- Utility methods for chunk split/combine and chunk encrypt/decrypt are implemented in `EncryptionService`:
  - `splitFile(...)`, `combineChunks(...)`
  - `encryptFileInChunks(...)`, `decryptFileChunks(...)`

The current primary upload runtime path encrypts media as full file payloads per item via `encryptFile(...)`, while chunk APIs are available for chunked strategies.

---

## Feed and Sharing Model

Feed logic is in `src/main/java/com/demo/web/service/FeedService.java`.

Implemented behavior includes:
- Creating feed posts from existing memories
- Creating a new memory and then posting it to feed (two-step flow)
- Blocking-aware feed filtering
- Post engagement flows (likes/comments/saves/reports)
- Notifications integration

Current discovery behavior in DAO/service:
- Feed posts are loaded for discovery with randomized ordering (`ORDER BY RANDOM()` in `FeedPostDAO.findAllPosts()`)
- Blocked profiles are filtered out
- Recommended users come from follow graph logic with fallback random suggestions
- Engagement metrics (like counts/current-user liked state) are resolved per post

---

## Major Feature Modules

- **Authentication + sessions**
- **Memories** (normal, collaborative, group-linked)
- **Media encryption and secure streaming**
- **Public feed** (profiles, posts, likes, comments, follows, blocks, saves, reports)
- **Groups + events + polls/voting**
- **Journals + streaks**
- **Vault + recycle/restore flows**
- **Notifications + preferences**
- **Admin dashboards/content/user controls**

---

## Repository Structure (high level)

```text
src/main/java/com/demo/web/
  controller/        # HTTP endpoints (Servlet controllers)
  service/           # Business logic
  dao/               # JDBC data access
  dto/               # Request/response DTOs
  model/             # Domain models
  middleware/        # FrontController
  filter/            # Authentication filter
  util/              # Encryption, DB utils, session utils, helpers

src/main/resources/
  config/            # *.example templates; local secrets stay untracked
  database/          # schema/data/migrations

src/main/webapp/
  WEB-INF/views/     # JSP views
  resources/         # css/js/ts/assets
```

---

## Setup and Run

### 1) Prerequisites
- JDK 17+
- Maven 3.8+
- PostgreSQL 13+
- Apache Tomcat 9+

### 2) Database setup
Use the migration scripts under `src/main/resources/database/`.

Alternative:
- Check `src/main/resources/database/` and apply schema/migrations in order.

### 3) Configure DB connection
Create one of these local files from the example template:
- `src/main/resources/config/db.properties`
- `src/main/resources/config/db.local.properties`

Start from:
- `src/main/resources/config/db.properties.example`

Environment variables are also supported:
- `EVERLY_DB_DRIVER`
- `EVERLY_DB_URL`
- `EVERLY_DB_USERNAME`
- `EVERLY_DB_PASSWORD`

### 4) Configure encryption secret
Create one of these local files from the example template:
- `src/main/resources/config/encryption.properties`
- `src/main/resources/config/encryption.local.properties`

Start from:
- `src/main/resources/config/encryption.properties.example`

Set a strong value for:
- `encryption.server.secret`

Environment variable override:
- `EVERLY_ENCRYPTION_SERVER_SECRET`

> If this secret changes unexpectedly, previously encrypted media keys will not decrypt.

### 5) Build WAR
```bash
mvn clean package
```

WAR artifact will be generated under `target/`.

### 6) Deploy to Tomcat
- Deploy generated WAR to Tomcat
- Start server and open app in browser

---

## Key Implementation Files

- Front controller routing:
  - `src/main/java/com/demo/web/middleware/FrontControllerServlet.java`
- Auth filter:
  - `src/main/java/com/demo/web/filter/AuthenticationFilter.java`
- Encryption core:
  - `src/main/java/com/demo/web/util/EncryptionService.java`
- Memory service (upload/encrypt/decrypt/access checks):
  - `src/main/java/com/demo/web/service/MemoryService.java`
- Feed service:
  - `src/main/java/com/demo/web/service/FeedService.java`
- Session persistence:
  - `src/main/java/com/demo/web/dao/Auth/userSessionDAO.java`

---

## Notes
- This project intentionally uses manual servlet wiring and explicit route/filter orchestration to demonstrate core Java web architecture without framework autoconfiguration.
- Some `_unused` views/controllers are preserved for experimentation/testing history.
