package com.demo.web.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

public class DatabaseUtil {
    private static Properties dbProperties;
    private static boolean initialized = false;

    static {
        loadDatabaseProperties();
        loadDatabaseDriver();
    }

    /**
     * Initialize database utility with servlet context
     * This method can be called from filters or listeners
     */
    public static void initialize(javax.servlet.ServletContext context) {
        if (!initialized) {
            loadDatabaseProperties();
            loadDatabaseDriver();
            initialized = true;
        }
    }

    /**
     * Load database properties from example, local resource, env, and system overrides.
     */
    private static void loadDatabaseProperties() {
        dbProperties = new Properties();

        setDefaultProperties();
        loadPropertiesFromResource("config/db.properties.example");
        loadPropertiesFromResource("config/db.properties");
        loadPropertiesFromResource("config/db.local.properties");
        loadPropertiesFromEnvironment();

        if (isPlaceholder(dbProperties.getProperty("db.password"))) {
            System.err.println("WARNING: Database password is still using a placeholder value.");
        }
    }

    /**
     * Set default database properties for development
     */
    private static void setDefaultProperties() {
        dbProperties = new Properties();
        dbProperties.setProperty("db.driver", "org.postgresql.Driver");
        dbProperties.setProperty("db.url", "jdbc:postgresql://localhost:5432/everly");
        dbProperties.setProperty("db.username", "postgres");
        dbProperties.setProperty("db.password", "CHANGE_ME");
    }

    private static void loadPropertiesFromResource(String resourcePath) {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream(resourcePath)) {
            if (input == null) {
                return;
            }
            dbProperties.load(input);
            System.out.println("Database properties loaded from " + resourcePath);
        } catch (IOException e) {
            System.err.println("Error loading " + resourcePath + ": " + e.getMessage());
        }
    }

    private static void loadPropertiesFromEnvironment() {
        Map<String, String> envToProperty = new LinkedHashMap<>();
        envToProperty.put("EVERLY_DB_DRIVER", "db.driver");
        envToProperty.put("EVERLY_DB_URL", "db.url");
        envToProperty.put("EVERLY_DB_USERNAME", "db.username");
        envToProperty.put("EVERLY_DB_PASSWORD", "db.password");

        for (Map.Entry<String, String> entry : envToProperty.entrySet()) {
            String value = System.getenv(entry.getKey());
            if (value != null && !value.isBlank()) {
                dbProperties.setProperty(entry.getValue(), value);
            }
        }

        applySystemPropertyOverride("everly.db.driver", "db.driver");
        applySystemPropertyOverride("everly.db.url", "db.url");
        applySystemPropertyOverride("everly.db.username", "db.username");
        applySystemPropertyOverride("everly.db.password", "db.password");
    }

    private static void applySystemPropertyOverride(String systemKey, String propertyKey) {
        String value = System.getProperty(systemKey);
        if (value != null && !value.isBlank()) {
            dbProperties.setProperty(propertyKey, value);
        }
    }

    private static boolean isPlaceholder(String value) {
        return value == null || value.isBlank() || "CHANGE_ME".equalsIgnoreCase(value);
    }

    /**
     * Load PostgreSQL JDBC driver
     */
    private static void loadDatabaseDriver() {
        try {
            String driverClass = dbProperties.getProperty("db.driver");
            Class.forName(driverClass);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL JDBC Driver not found. Add postgresql jar to classpath", e);
        }
    }

    /**
     * Get database connection
     */
    public static Connection getConnection() throws SQLException {
        String url = dbProperties.getProperty("db.url");
        String username = dbProperties.getProperty("db.username");
        String password = dbProperties.getProperty("db.password");

        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Test database connection
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get database URL (for debugging)
     */
    public static String getDatabaseUrl() {
        return dbProperties.getProperty("db.url");
    }
}

// End of file - make sure this closing brace is present
