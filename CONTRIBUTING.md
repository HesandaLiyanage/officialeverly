# Contributing

Thanks for your interest in contributing.

## Development setup
1. Install JDK 17+, Maven, PostgreSQL, and Tomcat 9+.
2. Configure database settings in `src/main/resources/config/db.properties`.
3. Configure encryption secret in `src/main/resources/config/encryption.properties`.
4. Build the project:
   ```bash
   mvn clean package
   ```

## Branching
- Create a feature branch from main.
- Use clear branch names (example: `feature/memory-nic-validation`).

## Pull requests
- Keep PRs focused and reasonably small.
- Include a short summary of what changed and why.
- Mention DB migration impact when relevant.
- Add screenshots for UI changes where possible.

## Code style
- Preserve existing project structure: `controller -> service -> dao -> model/dto`.
- Keep business validation in service layer, DB operations in DAO.
- Avoid committing secrets, local configs, and generated artifacts.
