package com.bagstore.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        // Initialize database connection with ServletContext
        DatabaseConnection.initialize(context);

        // Log application startup
        System.out.println("BagStore application started successfully");
        System.out.println("Database URL: " + context.getInitParameter("db.url"));
        System.out.println("Database Username: " + context.getInitParameter("db.username"));

        // Test database connection
        if (DatabaseConnection.testConnection()) {
            System.out.println("Database connection test: SUCCESS");
        } else {
            System.err.println("Database connection test: FAILED");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("BagStore application is shutting down");
    }
}
