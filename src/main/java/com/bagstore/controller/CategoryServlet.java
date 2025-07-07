package com.bagstore.controller;

import com.bagstore.dao.CategoryDAO;
import com.bagstore.dao.ProductDAO;
import com.bagstore.model.Category;
import com.bagstore.model.Product;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;
    private ProductDAO productDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
        productDAO = new ProductDAO();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "list":
                handleCategoryList(request, response);
                break;
            case "detail":
                handleCategoryDetail(request, response);
                break;
            case "ajax":
                handleAjaxRequest(request, response);
                break;
            default:
                handleCategoryList(request, response);
                break;
        }
    }

    private void handleCategoryList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all active categories
            List<Category> categories = categoryDAO.getAllActiveCategories();

            // For each category, get product count and some sample products
            for (Category category : categories) {
                List<Product> categoryProducts = productDAO.getProductsByCategory(category.getId());
                category.setProductCount(categoryProducts.size());

                // Set featured products for display (first 4 products)
                if (categoryProducts.size() > 4) {
                    category.setFeaturedProducts(categoryProducts.subList(0, 4));
                } else {
                    category.setFeaturedProducts(categoryProducts);
                }
            }

            // Set attributes
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Danh mục sản phẩm");

            // Forward to category list JSP
            request.getRequestDispatcher("/views/category/list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách danh mục");
        }
    }

    private void handleCategoryDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String slug = request.getParameter("slug");
        String idParam = request.getParameter("id");

        Category category = null;

        try {
            if (slug != null && !slug.isEmpty()) {
                category = categoryDAO.getCategoryBySlug(slug);
            } else if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                category = categoryDAO.getCategoryById(id);
            }

            if (category == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại");
                return;
            }

            // Get products in this category with pagination
            int page = 1;
            int pageSize = 12;

            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1)
                        page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            List<Product> allProducts = productDAO.getProductsByCategory(category.getId());

            // Calculate pagination
            int totalProducts = allProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalProducts);

            List<Product> products = allProducts.subList(startIndex, endIndex);

            // Get all categories for sidebar
            List<Category> categories = categoryDAO.getAllActiveCategories();

            // Set attributes
            request.setAttribute("category", category);
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("pageTitle", category.getName());

            // Forward to category detail JSP (use product list with category context)
            request.getRequestDispatcher("/views/category/detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải chi tiết danh mục");
        }
    }

    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");

        try {
            switch (type) {
                case "all":
                    List<Category> allCategories = categoryDAO.getAllActiveCategories();
                    response.getWriter().write(objectMapper.writeValueAsString(allCategories));
                    break;

                case "with_products":
                    List<Category> categoriesWithProducts = categoryDAO.getAllActiveCategories();
                    for (Category category : categoriesWithProducts) {
                        List<Product> products = productDAO.getProductsByCategory(category.getId());
                        category.setProductCount(products.size());
                    }
                    response.getWriter().write(objectMapper.writeValueAsString(categoriesWithProducts));
                    break;

                case "featured":
                    // Get categories that have featured products
                    List<Category> featuredCategories = categoryDAO.getAllActiveCategories();
                    featuredCategories.removeIf(cat -> {
                        List<Product> products = productDAO.getProductsByCategory(cat.getId());
                        return products.isEmpty();
                    });

                    // Limit to 6 categories for featured display
                    if (featuredCategories.size() > 6) {
                        featuredCategories = featuredCategories.subList(0, 6);
                    }

                    response.getWriter().write(objectMapper.writeValueAsString(featuredCategories));
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid request type\"}");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
}
