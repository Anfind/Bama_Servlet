package com.bagstore.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigUtil {
    private static Properties properties;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        properties = new Properties();
        try (InputStream input = ConfigUtil.class.getClassLoader()
                .getResourceAsStream("application.properties")) {

            if (input != null) {
                properties.load(input);
                System.out.println("Application properties loaded successfully");
            } else {
                System.err.println("application.properties file not found");
            }

        } catch (IOException e) {
            System.err.println("Error loading application properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static String getProperty(String key) {
        return properties.getProperty(key);
    }

    public static String getProperty(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    public static int getIntProperty(String key, int defaultValue) {
        try {
            String value = properties.getProperty(key);
            return value != null ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            System.err.println("Invalid integer value for property: " + key);
            return defaultValue;
        }
    }

    public static boolean getBooleanProperty(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        return value != null ? Boolean.parseBoolean(value) : defaultValue;
    }

    // Database specific getters
    public static String getDatabaseUrl() {
        return getProperty("db.url");
    }

    public static String getDatabaseUsername() {
        return getProperty("db.username");
    }

    public static String getDatabasePassword() {
        return getProperty("db.password");
    }

    public static String getDatabaseDriver() {
        return getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
    }

    // Application specific getters
    public static String getAppName() {
        return getProperty("app.name", "BagStore");
    }

    public static String getAppVersion() {
        return getProperty("app.version", "1.0.0");
    }

    public static int getSessionTimeout() {
        return getIntProperty("app.session.timeout", 30);
    }

    public static long getMaxUploadSize() {
        return getIntProperty("upload.max.size", 10485760); // 10MB default
    }

    public static String getUploadTempDir() {
        return getProperty("upload.temp.dir", "/tmp/bagstore-uploads");
    }
}
