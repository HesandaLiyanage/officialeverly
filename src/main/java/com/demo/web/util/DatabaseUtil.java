package com.demo.web.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
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
     * Load database properties from db.properties file
     */
    private static void loadDatabaseProperties() {
        dbProperties = new Properties();
        InputStream input = null;

        try {
            // Try multiple locations for the properties file
            input = DatabaseUtil.class.getClassLoader().getResourceAsStream("config/db.properties");

            if (input == null) {
                input = DatabaseUtil.class.getResourceAsStream("/config/db.properties");
            }

            if (input == null) {
                input = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties");
            }

            if (input == null) {
                // Fallback to default values for development
                System.err.println("WARNING: db.properties not found, using default values");
                setDefaultProperties();
                return;
            }

            dbProperties.load(input);
            System.out.println("Database properties loaded successfully");

        } catch (IOException e) {
            System.err.println("Error loading database properties, using defaults");
            setDefaultProperties();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Set default database properties for development
     */
    private static void setDefaultProperties() {
        dbProperties = new Properties();
        dbProperties.setProperty("db.driver", "org.postgresql.Driver");
        dbProperties.setProperty("db.url", "jdbc:postgresql://localhost:5432/your_database_name");
        dbProperties.setProperty("db.username", "postgres");
        dbProperties.setProperty("db.password", "password");
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