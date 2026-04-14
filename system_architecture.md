# System Architecture Diagram

## Everly System Architecture

```mermaid
flowchart TD
    A["User Browser"] --> B["JSP Pages / HTML / CSS / JavaScript"]
    B --> C["HTTP Requests"]
    C --> D["web.xml + Servlet Mappings"]
    D --> E["AuthenticationFilter"]
    E --> F["FrontControllerServlet"]

    F --> G["Static JSP Views"]
    F --> H["Feature Controllers / Servlets"]

    H --> I["Auth Controllers"]
    H --> J["Memory Controllers"]
    H --> K["Feed Controllers"]
    H --> L["Autograph Controllers"]
    H --> M["Journal Controllers"]
    H --> N["Group Controllers"]
    H --> O["Event Controllers"]
    H --> P["Admin Controllers"]
    H --> Q["Settings / Notifications / Vault Controllers"]
    H --> R["API Servlets"]

    I --> S["Service Layer"]
    J --> S
    K --> S
    L --> S
    M --> S
    N --> S
    O --> S
    P --> S
    Q --> S
    R --> S

    S --> T["DAO Layer"]
    T --> U["DatabaseUtil / JDBC"]
    U --> V["PostgreSQL Database"]

    S --> W["Utility Layer"]
    W --> X["SessionUtil"]
    W --> Y["ValidationUtil"]
    W --> Z["PasswordUtil"]
    W --> AA["EncryptionService"]
    W --> AB["VaultUtil"]

    J --> AC["Memory JSP Views"]
    K --> AD["Feed JSP Views"]
    L --> AE["Autograph JSP Views"]
    M --> AF["Journal JSP Views"]
    N --> AG["Group JSP Views"]
    O --> AH["Event JSP Views"]
    P --> AI["Admin JSP Views"]
    Q --> AJ["Settings / Notifications / Vault JSP Views"]

    V --> AK["Memory Data"]
    V --> AL["Feed Data"]
    V --> AM["Autograph Data"]
    V --> AN["Journal Data"]
    V --> AO["Group Data"]
    V --> AP["Event Data"]
    V --> AQ["User / Admin Data"]
```

## Main Layers

1. Presentation Layer
   Browser-based UI built with JSP, CSS, and JavaScript under `src/main/webapp/WEB-INF/views`.

2. Routing and Request Handling
   Requests pass through `web.xml`, `AuthenticationFilter`, and `FrontControllerServlet`, then go to the relevant feature servlet/controller.

3. Application Layer
   Business logic is handled by services in `src/main/java/com/demo/web/service`.

4. Data Access Layer
   DAO classes in `src/main/java/com/demo/web/dao` handle SQL and database operations through JDBC.

5. Data Layer
   PostgreSQL stores application data for users, memories, feed posts, autographs, journals, groups, events, admin data, and related records.

## Feature Modules Included

- Authentication
- Memories
- Feed
- Autographs
- Journals
- Groups
- Events
- Admin Panel
- Settings
- Notifications
- Vault
- API Endpoints

## Request Flow Summary

1. User interacts with a JSP page in the browser.
2. Request is mapped through `web.xml`.
3. `AuthenticationFilter` checks protected access.
4. `FrontControllerServlet` routes the request.
5. Feature controller/servlet handles the request.
6. Service layer applies business logic.
7. DAO layer performs database operations.
8. Response is returned to a JSP view or API response.
