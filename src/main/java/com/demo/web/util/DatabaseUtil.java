package com.demo.web.util;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    private static String DB_URL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;

    public static void initialize(ServletContext context) {
        DB_URL = context.getInitParameter("db.url");
        DB_USERNAME = context.getInitParameter("db.username");
        DB_PASSWORD = context.getInitParameter("db.password");

        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("PostgreSQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}