package com.bagstore.controller;

import com.bagstore.dao.ProductDAO;
import com.bagstore.dao.CategoryDAO;
import com.bagstore.model.Product;
import com.bagstore.model.Category;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
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
                handleProductList(request, response);
                break;
            case "detail":
                handleProductDetail(request, response);
                break;
            case "search":
                handleProductSearch(request, response);
                break;
            case "category":
                handleCategoryProducts(request, response);
                break;
            case "filter":
                handleProductFilter(request, response);
                break;
            case "ajax":
                handleAjaxRequest(request, response);
                break;
            default:
                handleProductList(request, response);
                break;
        }
    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Pagination parameters
            int page = 1;
            int pageSize = 12; // 12 products per page like bama.vn

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

            // Get all active products
            List<Product> allProducts = productDAO.getActiveProducts();

            // Calculate pagination
            int totalProducts = allProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalProducts);

            List<Product> products = allProducts.subList(startIndex, endIndex);

            // Get categories for sidebar
            List<Category> categories = categoryDAO.getAllActiveCategories();

            // Set attributes
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("pageTitle", "Tất cả sản phẩm");

            // Forward to product list JSP
            request.getRequestDispatcher("/views/product/list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách sản phẩm");
        }
    }

    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String slug = request.getParameter("slug");
        String idParam = request.getParameter("id");

        Product product = null;

        try {
            if (slug != null && !slug.isEmpty()) {
                product = productDAO.getProductBySlug(slug);
            } else if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                product = productDAO.getProductById(id);
            }

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
                return;
            }

            // Get related products from same category
            List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategoryId());
            // Remove current product from related list
            final int currentProductId = product.getId();
            relatedProducts.removeIf(p -> p.getId() == currentProductId);
            // Limit to 4 related products
            if (relatedProducts.size() > 4) {
                relatedProducts = relatedProducts.subList(0, 4);
            }

            // Set attributes
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            request.setAttribute("pageTitle", product.getName());

            // Forward to product detail JSP
            request.getRequestDispatcher("/views/product/detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải chi tiết sản phẩm");
        }
    }

    private void handleProductSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        if (keyword == null || keyword.trim().isEmpty()) {
            handleProductList(request, response);
            return;
        }

        try {
            List<Product> products = productDAO.searchProducts(keyword.trim());
            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("searchKeyword", keyword);
            request.setAttribute("pageTitle", "Tìm kiếm: " + keyword);

            request.getRequestDispatcher("/views/product/list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tìm kiếm sản phẩm");
        }
    }

    private void handleCategoryProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdParam = request.getParameter("id");
        String categorySlug = request.getParameter("slug");

        try {
            Category category = null;
            List<Product> products = null;

            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                category = categoryDAO.getCategoryById(categoryId);
                products = productDAO.getProductsByCategory(categoryId);
            } else if (categorySlug != null && !categorySlug.isEmpty()) {
                category = categoryDAO.getCategoryBySlug(categorySlug);
                if (category != null) {
                    products = productDAO.getProductsByCategory(category.getId());
                }
            }

            if (category == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại");
                return;
            }

            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("currentCategory", category);
            request.setAttribute("pageTitle", category.getName());

            request.getRequestDispatcher("/views/product/list.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải sản phẩm theo danh mục");
        }
    }

    private void handleProductFilter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String minPriceParam = request.getParameter("minPrice");
            String maxPriceParam = request.getParameter("maxPrice");
            String categoryIdParam = request.getParameter("categoryId");
            String sortParam = request.getParameter("sort");

            List<Product> products = productDAO.getActiveProducts();

            // Filter by price range
            if (minPriceParam != null && maxPriceParam != null &&
                    !minPriceParam.isEmpty() && !maxPriceParam.isEmpty()) {
                try {
                    BigDecimal minPrice = new BigDecimal(minPriceParam);
                    BigDecimal maxPrice = new BigDecimal(maxPriceParam);
                    products = productDAO.getProductsByPriceRange(minPrice, maxPrice);
                } catch (NumberFormatException e) {
                    // Invalid price format, ignore filter
                }
            }

            // Filter by category
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    products = productDAO.getProductsByCategory(categoryId);
                } catch (NumberFormatException e) {
                    // Invalid category ID, ignore filter
                }
            }

            // Sort products
            if (sortParam != null) {
                switch (sortParam) {
                    case "price_asc":
                        products.sort((p1, p2) -> p1.getFinalPrice().compareTo(p2.getFinalPrice()));
                        break;
                    case "price_desc":
                        products.sort((p1, p2) -> p2.getFinalPrice().compareTo(p1.getFinalPrice()));
                        break;
                    case "name_asc":
                        products.sort((p1, p2) -> p1.getName().compareTo(p2.getName()));
                        break;
                    case "name_desc":
                        products.sort((p1, p2) -> p2.getName().compareTo(p1.getName()));
                        break;
                    case "newest":
                    default:
                        // Already sorted by created_at DESC from DAO
                        break;
                }
            }

            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Lọc sản phẩm");

            request.getRequestDispatcher("/views/product/list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi lọc sản phẩm");
        }
    }

    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String type = request.getParameter("type");

        try {
            switch (type) {
                case "search":
                    String keyword = request.getParameter("q");
                    List<Product> searchResults = productDAO.searchProducts(keyword);
                    response.getWriter().write(objectMapper.writeValueAsString(searchResults));
                    break;

                case "featured":
                    int limit = 8;
                    String limitParam = request.getParameter("limit");
                    if (limitParam != null) {
                        try {
                            limit = Integer.parseInt(limitParam);
                        } catch (NumberFormatException e) {
                            limit = 8;
                        }
                    }
                    List<Product> featured = productDAO.getFeaturedProducts(limit);
                    response.getWriter().write(objectMapper.writeValueAsString(featured));
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
