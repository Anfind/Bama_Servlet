package com.bagstore.util;

import jakarta.servlet.ServletContext;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static ServletContext servletContext;

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Initialize the database connection with ServletContext
     * Call this method from ServletContextListener or first servlet init
     */
    public static void initialize(ServletContext context) {
        servletContext = context;
    }

    public static Connection getConnection() throws SQLException {
        String url, username, password;

        if (servletContext != null) {
            // First try to read from web.xml context parameters
            url = servletContext.getInitParameter("db.url");
            username = servletContext.getInitParameter("db.username");
            password = servletContext.getInitParameter("db.password");

            // If not found in web.xml, fallback to properties file
            if (url == null || username == null || password == null) {
                url = ConfigUtil.getDatabaseUrl();
                username = ConfigUtil.getDatabaseUsername();
                password = ConfigUtil.getDatabasePassword();
                System.out.println("Using database configuration from application.properties");
            } else {
                System.out.println("Using database configuration from web.xml");
            }
        } else {
            // Fallback to properties file if ServletContext not available
            url = ConfigUtil.getDatabaseUrl();
            username = ConfigUtil.getDatabaseUsername();
            password = ConfigUtil.getDatabasePassword();
            System.out.println("Warning: ServletContext not available, using properties file");
        }

        // Final fallback to hardcoded values
        if (url == null || username == null || password == null) {
            url = "jdbc:mysql://localhost:3306/bagstore_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            username = "root";
            password = "210506";
            System.out.println("Warning: Using hardcoded database configuration");
        }

        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            System.out.println("Database connection established successfully");
            return connection;
        } catch (SQLException e) {
            System.err.println("Failed to establish database connection: " + e.getMessage());
            throw e;
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed");
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
}
