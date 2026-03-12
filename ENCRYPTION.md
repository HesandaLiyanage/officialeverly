# Media Encryption - Technical Documentation

## What This Does

Every photo or video a user uploads to any memory (personal, collaborative, or group) is **encrypted before it hits the disk**. When a user views that photo in the browser, the server reads the encrypted file, decrypts it in memory, and streams the raw image/video bytes back. The user never knows encryption is happening — there's no password prompt, no extra step. It's completely transparent.

This protects against one specific threat: **if someone gains access to the server's file system** (e.g., a stolen hard drive, a compromised backup, an unauthorized SSH session), they see `.enc` files full of random-looking bytes. They can't open them as images. The actual content is only accessible through the running application, which holds the secret needed to decrypt.

---

## Where Files Are Stored

### Before encryption (how it used to work)
```
User uploads "vacation.jpg"
  → Saved as: media_uploads/a3f2c1d4-..._vacation.jpg     (readable image on disk)
```

### After encryption (how it works now)
```
User uploads "vacation.jpg"
  → Saved as: media_uploads/a3f2c1d4-...-.enc              (encrypted binary blob on disk)
```

**Physical disk path:**
```
/Users/hesandaliyanage/Documents/officialeverly/src/main/webapp/media_uploads/
├── 7b3e9f12-4a5c-4d8e-b1f3-9c2a8d6e4f01.enc    ← encrypted photo
├── f1a2b3c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c.enc    ← encrypted video
├── old-file-before-encryption_photo.jpg           ← legacy unencrypted (still works)
└── ...
```

**Relative path stored in DB** (`media_items.file_path`):
```
media_uploads/7b3e9f12-4a5c-4d8e-b1f3-9c2a8d6e4f01.enc
```

The `.enc` extension replaces the old pattern of `{uuid}_{original-filename}.jpg`. The original filename is preserved in the `media_items.original_filename` column for display purposes, but never appears on disk anymore.

---

## The Key System — How It Works Step by Step

There are **three layers**. Understanding why each exists is important.

### Layer 1: The Server Secret (a plain text string)

**Location:** `src/main/resources/config/encryption.properties`
```properties
encryption.server.secret=everly-dev-secret-change-in-production-2024
```

This is just a password string. It's loaded once when the app first needs to encrypt or decrypt something. By itself, it can't encrypt anything — it needs to be turned into a proper cryptographic key first.

**How it becomes a key:**
```
"everly-dev-secret-change-in-production-2024"   (plain string)
        │
        │  PBKDF2WithHmacSHA256
        │  100,000 iterations
        │  Salt: SHA-256 hash of "everly-server-key-salt-v1"
        ▼
   Server Master Key (32 bytes / 256 bits)       (AES key, cached in JVM memory)
```

PBKDF2 is intentionally slow (100,000 rounds) so that brute-forcing the secret from a stolen key is impractical. The salt is deterministic (derived from a fixed string) so the same secret always produces the same master key — this is needed so the app can decrypt files it encrypted in previous sessions.

**The master key is never written to disk or to the database.** It exists only in the JVM's memory while the application is running. When Tomcat restarts, it's re-derived from the secret on first use.

### Layer 2: Per-File Keys (one unique key per uploaded file)

Every single file upload generates a brand new AES-256 key. This key encrypts that one file and nothing else.

**Why not just use the master key directly on every file?**
- If you encrypt thousands of files with the same key, you increase the statistical surface for cryptanalysis.
- If you ever need to re-encrypt a single file (e.g., key rotation), you only need to change one per-file key, not re-encrypt every file on the platform.
- Each file also gets its own random 12-byte IV (initialization vector), so even two identical photos produce completely different encrypted outputs.

**Where the per-file key is stored:**

The per-file key itself is encrypted with the server master key (Layer 1) before being stored:

```
New AES-256 key generated (32 random bytes)     ← the per-file key
        │
        │  Encrypted with Server Master Key (AES-256-GCM)
        │  Produces: encrypted_key bytes + key_iv (12 bytes)
        ▼
Stored in PostgreSQL table `encryption_keys`:
┌──────────────────────────────────────────────────────────────────────┐
│ key_id (UUID)            │ user_id │ encrypted_key (BYTEA) │ iv     │
│ "c4a2f1..."              │ 42      │ [encrypted bytes]     │ [12B]  │
└──────────────────────────────────────────────────────────────────────┘
```

So even if someone dumps the entire database, they get encrypted keys — not the actual keys. To turn those into usable keys, they'd need the server master key, which requires the server secret from `encryption.properties`.

### Layer 3: The Encrypted File

The actual photo/video bytes are encrypted with the per-file key (Layer 2):

```
Raw file bytes (e.g., JPEG data)
        │
        │  Encrypted with Per-File Key (AES-256-GCM)
        │  Random 12-byte IV generated
        │  GCM tag appended (16 bytes, ensures integrity)
        ▼
Written to disk as: media_uploads/{uuid}.enc
```

The IV used for file encryption is stored in the `media_items.encryption_iv` column (BYTEA), so it can be retrieved during decryption.

---

## The Complete Upload Flow

When a user creates or edits a memory and attaches photos, here's exactly what happens in code:

**Java files involved:** `MemoryCreate.java` (new memories) and `MemoryUpdate.java` (editing existing memories). Both follow the identical encryption path.

```
1. User's browser sends multipart POST with file(s)
   └─ Servlet receives javax.servlet.http.Part for each file

2. byte[] fileBytes = readAllBytes(filePart.getInputStream());
   └─ The entire file is read into a byte array in JVM heap memory
   └─ At this point, fileBytes contains the raw JPEG/PNG/MP4 data

3. EncryptionService.FileEncryptionResult encResult = EncryptionService.encryptFile(fileBytes);
   └─ Inside encryptFile():
      a. SecretKey fileKey = generateKey();
         └─ KeyGenerator.getInstance("AES"), init(256) → 32 random bytes
      b. String keyId = UUID.randomUUID().toString();
         └─ e.g., "c4a2f1b3-7d8e-4f5a-a1b2-3c4d5e6f7a8b"
      c. EncryptedData encryptedFile = encrypt(fileBytes, fileKey);
         └─ Cipher.getInstance("AES/GCM/NoPadding")
         └─ Random 12-byte IV generated
         └─ cipher.doFinal(fileBytes) → encrypted bytes (same size + 16 byte GCM tag)
      d. SecretKey masterKey = getServerMasterKey();
         └─ Loads secret from encryption.properties (first time only)
         └─ Derives AES key via PBKDF2 (first time only, then cached)
      e. EncryptedData encryptedFileKey = encryptKey(fileKey, masterKey);
         └─ Encrypts the 32-byte file key with the master key
         └─ Another random 12-byte IV for this encryption
      f. Returns FileEncryptionResult containing:
         - keyId:              "c4a2f1b3-..."
         - encryptedFileData:  [encrypted photo bytes]
         - fileIv:             [12 bytes, for decrypting the file]
         - encryptedKey:       [encrypted per-file key bytes]
         - keyIv:              [12 bytes, for decrypting the per-file key]

4. String uniqueFilename = UUID.randomUUID().toString() + ".enc";
   FileOutputStream writes encResult.getEncryptedFileData() to disk
   └─ File on disk: media_uploads/a3f2c1d4-5b6e-7f8a-9c0d-1e2f3a4b5c6d.enc

5. mediaDAO.storeMediaEncryptionKey(keyId, userId, encryptedKey, keyIv);
   └─ INSERT INTO encryption_keys (key_id, user_id, encrypted_key, iv)
      VALUES ('c4a2f1b3-...', 42, [encrypted key bytes], [12-byte IV])

6. MediaItem built with:
   - filename:           "a3f2c1d4-...-.enc"
   - originalFilename:   "vacation.jpg"          (preserved for UI display)
   - filePath:           "media_uploads/a3f2c1d4-...-.enc"
   - fileSize:           [size of encrypted data on disk]
   - originalFileSize:   [size of raw photo before encryption]
   - mimeType:           "image/jpeg"            (preserved for serving)
   - isEncrypted:        true
   - encryptionKeyId:    "c4a2f1b3-..."          (links to encryption_keys row)

7. mediaDAO.createMediaItem(mediaItem, encResult.getFileIv());
   └─ INSERT INTO media_items (..., is_encrypted, encryption_key_id, encryption_iv, ...)
   └─ encryption_iv stores the 12-byte IV needed to decrypt the file

8. memoryDAO.linkMediaToMemory(memoryId, mediaId);
   └─ INSERT INTO memory_media (memory_id, media_id)
```

After this, `fileBytes` (the raw photo) is garbage collected. Only the encrypted version exists on disk.

---

## The Complete Serve/View Flow

When a user views a memory and the browser requests an image:

**Java file:** `MediaView.java` (mapped to `/viewMedia` and `/viewmedia`)

```
1. Browser requests: GET /viewMedia?id=123

2. Session check: is user logged in? If not → 401.

3. MediaItem mediaItem = mediaDAO.getMediaById(123);
   └─ SELECT ... FROM media_items WHERE media_id = 123
   └─ Returns MediaItem with all fields including:
      - isEncrypted:      true
      - encryptionKeyId:  "c4a2f1b3-..."
      - encryptionIv:     [12 bytes]
      - mimeType:         "image/jpeg"
      - filePath:         "media_uploads/a3f2c1d4-...-.enc"
      - userId:           42  (the uploader)

4. Access control check (runs BEFORE any decryption):
   a. Does the logged-in user own this media?                         → access granted
   b. Is the media in a collaborative memory the user is a member of? → access granted
   c. Is the media part of a public feed post?                        → access granted
   d. Is the media in a group memory and user is a group member?      → access granted
   e. None of the above?                                              → 403 Forbidden

5. if (mediaItem.isEncrypted()) → serveEncryptedFile()
   else                        → serveUnencryptedFile()  (legacy path)

6. serveEncryptedFile():
   a. byte[] encryptedData = Files.readAllBytes(file.toPath());
      └─ Reads the .enc file from disk into memory

   b. MediaDAO.EncryptionKeyData keyData = mediaDAO.getMediaEncryptionKey("c4a2f1b3-...");
      └─ SELECT encrypted_key, iv FROM encryption_keys WHERE key_id = 'c4a2f1b3-...'
      └─ Note: looks up by key_id only, NOT by user_id
         This is critical — in collab/group memories, the viewer is often
         different from the uploader. Access control already happened in step 4.

   c. byte[] decryptedData = EncryptionService.decryptFile(
         encryptedData,          ← encrypted file bytes from disk
         mediaItem.getEncryptionIv(),  ← 12-byte file IV from media_items table
         keyData.getEncryptedKey(),    ← encrypted per-file key from encryption_keys
         keyData.getIv()               ← 12-byte key IV from encryption_keys
      );
      └─ Inside decryptFile():
         i.   Derive server master key from config (cached after first call)
         ii.  Decrypt the per-file key: AES-GCM-decrypt(encryptedKey, keyIv, masterKey) → fileKey
         iii. Decrypt the file data:    AES-GCM-decrypt(encryptedData, fileIv, fileKey) → raw JPEG bytes

   d. response.setContentType("image/jpeg");
      response.setContentLength(decryptedData.length);  ← original file size, not encrypted size
      response.getOutputStream().write(decryptedData);
      └─ Browser receives raw JPEG bytes and renders the image normally
```

---

## Database Tables

### `encryption_keys`

One row per uploaded file. Stores the per-file AES key in encrypted form.

```sql
CREATE TABLE encryption_keys (
    key_id        VARCHAR PRIMARY KEY,   -- UUID, e.g., "c4a2f1b3-7d8e-..."
    user_id       INT NOT NULL,          -- who uploaded the file (FK to users)
    encrypted_key BYTEA NOT NULL,        -- the AES-256 file key, encrypted with server master key
    iv            BYTEA NOT NULL         -- 12-byte IV used when encrypting the file key
);
```

### `media_items` (encryption-related columns only)

```sql
-- These columns already existed in the table; now they're actually populated:
is_encrypted       BOOLEAN DEFAULT TRUE,     -- true for new uploads, false for legacy files
encryption_key_id  VARCHAR,                  -- FK to encryption_keys.key_id
encryption_iv      BYTEA,                    -- 12-byte IV used when encrypting the file data
file_size          BIGINT,                   -- size of the .enc file on disk
original_file_size BIGINT                    -- size of the original unencrypted file
```

### `memory_media` (unchanged, included for context)

```sql
-- Junction table linking memories to their media files
CREATE TABLE memory_media (
    memory_id INT REFERENCES memory(memory_id),
    media_id  INT REFERENCES media_items(media_id)
);
```

This is how all three memory types (personal, collab, group) link to media. The encryption is at the media level, so it automatically covers all of them.

---

## Files Changed

All paths relative to `src/main/java/com/demo/web/`:

| File | What Changed |
|------|-------------|
| **`util/EncryptionService.java`** | Added `getServerMasterKey()` — loads secret from `encryption.properties`, derives AES key via PBKDF2, caches it. Added `encryptFile(byte[])` — generates per-file key, encrypts file, encrypts the key with master key, returns everything in a `FileEncryptionResult`. Added `decryptFile(encryptedData, fileIv, encryptedKey, keyIv)` — reverses the process. Added `FileEncryptionResult` inner class to bundle all outputs. |
| **`controller/Memory/MemoryCreate.java`** | Changed file upload: reads bytes into memory, calls `EncryptionService.encryptFile()`, writes encrypted bytes to disk as `.enc`, stores encrypted key in DB, sets `isEncrypted=true` on the `MediaItem`. Replaced `saveFile()` with `readAllBytes()`. |
| **`controller/Memory/MemoryUpdate.java`** | Identical changes to `MemoryCreate` — the same encryption path for files added when editing a memory. |
| **`controller/Memory/MediaView.java`** | Split `serveFile()` into two paths: `serveEncryptedFile()` reads encrypted data from disk, fetches the encrypted key from DB, calls `EncryptionService.decryptFile()`, streams decrypted bytes. `serveUnencryptedFile()` handles legacy files as before. |
| **`dao/Memory/MediaDAO.java`** | Changed `getMediaEncryptionKey(keyId, userId)` to `getMediaEncryptionKey(keyId)` — removed the `user_id` filter so collab/group memory members can access keys for files uploaded by other users. Access control is handled by `MediaView` before this method is ever called. |
| **`config/encryption.properties`** | New file. Contains `encryption.server.secret` — the single secret that protects all encrypted media. |

---

## Backwards Compatibility

Legacy files (uploaded before this change) have `is_encrypted = false` and `encryption_key_id = null` in the database. `MediaView` checks this flag and serves them directly from disk without any decryption — exactly as before.

New uploads will always be encrypted. There is no migration needed for old files, but they remain unencrypted on disk.

---

## What Could Go Wrong

| Scenario | Impact | Prevention |
|----------|--------|------------|
| **Server secret is lost/changed** | All encrypted media becomes permanently unrecoverable. The per-file keys can't be decrypted without the master key derived from the secret. | Back up `encryption.properties`. Never change the secret without a migration plan. |
| **Database is lost** | Encrypted files on disk are useless — the per-file keys (stored in `encryption_keys`) are gone. | Regular database backups. The `.enc` files and the DB must be backed up together. |
| **Large file upload (e.g., 50MB video)** | The entire file is loaded into JVM heap memory for encryption. A 50MB video becomes a 50MB byte array. | The `@MultipartConfig` already limits files to 50MB per file. Monitor JVM heap usage. |
| **Someone gets the encryption.properties file** | They can derive the master key and decrypt all per-file keys, then decrypt all files. | Restrict file permissions on `encryption.properties` in production. Consider using environment variables instead. |
