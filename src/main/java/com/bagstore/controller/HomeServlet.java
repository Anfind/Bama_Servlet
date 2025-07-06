package com.bagstore.controller;

import com.bagstore.dao.CategoryDAO;
import com.bagstore.dao.ProductDAO;
import com.bagstore.model.Category;
import com.bagstore.model.Product;
import com.bagstore.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = { "/", "/home" })
public class HomeServlet extends HttpServlet {

    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        // Initialize database connection if not already done
        DatabaseConnection.initialize(getServletContext());

        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get active categories for navigation
            List<Category> categories = categoryDAO.getActiveCategories();
            request.setAttribute("categories", categories);

            // Get featured products (limit to 8)
            List<Product> featuredProducts = productDAO.getFeaturedProducts(8);
            request.setAttribute("featuredProducts", featuredProducts);

            // Forward to home page
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in HomeServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Có lỗi xảy ra khi tải trang chủ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
