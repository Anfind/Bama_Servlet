package com.bagstore.controller;

import com.bagstore.dao.ProductDAO;
import com.bagstore.dao.CategoryDAO;
import com.bagstore.dao.UserDAO;
import com.bagstore.model.Product;
import com.bagstore.model.Category;
import com.bagstore.model.User;
import com.bagstore.model.Order;
import com.bagstore.util.StringUtil;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.IOException;
import java.io.File;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private UserDAO userDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        userDAO = new UserDAO();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login&returnUrl=" +
                    request.getRequestURL() + "?" + request.getQueryString());
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/dashboard";

        switch (pathInfo) {
            case "/dashboard":
                handleDashboard(request, response);
                break;
            case "/products":
                handleProducts(request, response);
                break;
            case "/products/add":
                handleAddProductForm(request, response);
                break;
            case "/products/edit":
                handleEditProductForm(request, response);
                break;
            case "/categories":
                handleCategories(request, response);
                break;
            case "/categories/add":
                handleAddCategoryForm(request, response);
                break;
            case "/categories/edit":
                handleEditCategoryForm(request, response);
                break;
            case "/orders":
                handleOrders(request, response);
                break;
            case "/orders/detail":
                handleOrderDetail(request, response);
                break;
            case "/users":
                handleUsers(request, response);
                break;
            case "/settings":
                handleSettings(request, response);
                break;
            default:
                handleDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin authentication
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            return;
        }

        switch (pathInfo) {
            case "/products/create":
                handleCreateProduct(request, response);
                break;
            case "/products/update":
                handleUpdateProduct(request, response);
                break;
            case "/products/delete":
                handleDeleteProduct(request, response);
                break;
            case "/categories/create":
                handleCreateCategory(request, response);
                break;
            case "/categories/update":
                handleUpdateCategory(request, response);
                break;
            case "/categories/delete":
                handleDeleteCategory(request, response);
                break;
            case "/orders/update-status":
                handleUpdateOrderStatus(request, response);
                break;
            case "/users/update-status":
                handleUpdateUserStatus(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                break;
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get statistics for dashboard
            List<Product> products = productDAO.getAllProducts();
            List<Category> categories = categoryDAO.getAllCategories();
            List<User> users = userDAO.getAllUsers();

            // Calculate statistics
            int totalProducts = products.size();
            int activeProducts = (int) products.stream().filter(p -> "ACTIVE".equals(p.getStatus())).count();
            int totalCategories = categories.size();
            int totalUsers = users.size();
            int totalOrders = 0; // You need to implement OrderDAO

            // Recent products (last 10)
            List<Product> recentProducts = products.stream()
                    .sorted((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()))
                    .limit(10)
                    .toList();

            // Low stock products (stock < 10)
            List<Product> lowStockProducts = products.stream()
                    .filter(p -> p.getStockQuantity() < 10)
                    .limit(10)
                    .toList();

            // Set attributes
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("recentProducts", recentProducts);
            request.setAttribute("lowStockProducts", lowStockProducts);
            request.setAttribute("pageTitle", "Admin Dashboard");

            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải dashboard");
        }
    }

    private void handleProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");
            String search = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String statusFilter = request.getParameter("status");

            List<Product> products = productDAO.getAllProducts();

            // Apply filters
            if (search != null && !search.trim().isEmpty()) {
                products = products.stream()
                        .filter(p -> p.getName().toLowerCase().contains(search.toLowerCase()) ||
                                p.getDescription().toLowerCase().contains(search.toLowerCase()))
                        .toList();
            }

            if (categoryFilter != null && !categoryFilter.isEmpty() && !"all".equals(categoryFilter)) {
                try {
                    int categoryId = Integer.parseInt(categoryFilter);
                    products = products.stream()
                            .filter(p -> p.getCategoryId() == categoryId)
                            .toList();
                } catch (NumberFormatException e) {
                    // Ignore invalid category filter
                }
            }

            if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                products = products.stream()
                        .filter(p -> statusFilter.equals(p.getStatus()))
                        .toList();
            }

            // Pagination
            int page = 1;
            int pageSize = 20;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1)
                        page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalProducts);

            List<Product> paginatedProducts = products.subList(startIndex, endIndex);

            // Get categories for filter dropdown
            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("products", paginatedProducts);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("searchKeyword", search);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("pageTitle", "Quản lý sản phẩm");

            request.getRequestDispatcher("/views/admin/products.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách sản phẩm");
        }
    }

    private void handleAddProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Thêm sản phẩm mới");

            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải form thêm sản phẩm");
        }
    }

    private void handleEditProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
                return;
            }

            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
                return;
            }

            List<Category> categories = categoryDAO.getAllActiveCategories();

            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Chỉnh sửa sản phẩm");

            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải form chỉnh sửa sản phẩm");
        }
    }

    private void handleCreateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form data
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceParam = request.getParameter("price");
            String discountPriceParam = request.getParameter("discountPrice");
            String categoryIdParam = request.getParameter("categoryId");
            String stockParam = request.getParameter("stockQuantity");
            String status = request.getParameter("status");

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                    description == null || description.trim().isEmpty() ||
                    priceParam == null || priceParam.trim().isEmpty() ||
                    categoryIdParam == null || categoryIdParam.trim().isEmpty() ||
                    stockParam == null || stockParam.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                handleAddProductForm(request, response);
                return;
            }

            // Parse and validate numeric fields
            BigDecimal price = new BigDecimal(priceParam);
            BigDecimal discountPrice = BigDecimal.ZERO;
            if (discountPriceParam != null && !discountPriceParam.trim().isEmpty()) {
                discountPrice = new BigDecimal(discountPriceParam);
            }
            int categoryId = Integer.parseInt(categoryIdParam);
            int stockQuantity = Integer.parseInt(stockParam);

            // Create product object
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description.trim());
            product.setPrice(price);
            product.setDiscountPrice(discountPrice);
            product.setCategoryId(categoryId);
            product.setStockQuantity(stockQuantity);
            product.setStatus(status != null ? status : "ACTIVE");
            product.setSlug(StringUtil.generateSlug(name));
            product.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            product.setUpdatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            // Handle image upload
            List<String> imageUrls = handleImageUpload(request);

            // Save product
            boolean success = productDAO.createProduct(product);

            if (success && !imageUrls.isEmpty()) {
                // Save product images (you need to implement this)
                // productDAO.addProductImages(product.getId(), imageUrls);
            }

            if (success) {
                request.getSession().setAttribute("success", "Thêm sản phẩm thành công");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm sản phẩm");
                handleAddProductForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ");
            handleAddProductForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm sản phẩm");
            handleAddProductForm(request, response);
        }
    }

    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
                return;
            }

            int productId = Integer.parseInt(idParam);
            Product existingProduct = productDAO.getProductById(productId);

            if (existingProduct == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
                return;
            }

            // Get form data and update product
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceParam = request.getParameter("price");
            String discountPriceParam = request.getParameter("discountPrice");
            String categoryIdParam = request.getParameter("categoryId");
            String stockParam = request.getParameter("stockQuantity");
            String status = request.getParameter("status");

            existingProduct.setName(name.trim());
            existingProduct.setDescription(description.trim());
            existingProduct.setPrice(new BigDecimal(priceParam));
            existingProduct.setDiscountPrice(discountPriceParam != null && !discountPriceParam.trim().isEmpty()
                    ? new BigDecimal(discountPriceParam)
                    : BigDecimal.ZERO);
            existingProduct.setCategoryId(Integer.parseInt(categoryIdParam));
            existingProduct.setStockQuantity(Integer.parseInt(stockParam));
            existingProduct.setStatus(status != null ? status : "ACTIVE");
            existingProduct.setSlug(StringUtil.generateSlug(name));
            existingProduct.setUpdatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            // Handle image upload
            List<String> newImageUrls = handleImageUpload(request);

            // Update product
            boolean success = productDAO.updateProduct(existingProduct);

            if (success && !newImageUrls.isEmpty()) {
                // Update product images (you need to implement this)
                // productDAO.updateProductImages(productId, newImageUrls);
            }

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật sản phẩm thành công");
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật sản phẩm");
                handleEditProductForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật sản phẩm");
            handleEditProductForm(request, response);
        }
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ");
                return;
            }

            int productId = Integer.parseInt(idParam);
            boolean success = productDAO.deleteProduct(productId);

            if (success) {
                request.getSession().setAttribute("success", "Xóa sản phẩm thành công");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa sản phẩm");
            }

            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa sản phẩm");
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void handleCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Category> categories = categoryDAO.getAllCategories();

            // Add product count for each category
            for (Category category : categories) {
                List<Product> products = productDAO.getProductsByCategory(category.getId());
                category.setProductCount(products.size());
            }

            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Quản lý danh mục");

            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách danh mục");
        }
    }

    private void handleAddCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Thêm danh mục mới");
        request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
    }

    private void handleEditCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ");
                return;
            }

            int categoryId = Integer.parseInt(idParam);
            Category category = categoryDAO.getCategoryById(categoryId);

            if (category == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại");
                return;
            }

            request.setAttribute("category", category);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Chỉnh sửa danh mục");

            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải form chỉnh sửa danh mục");
        }
    }

    private void handleCreateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên danh mục không được để trống");
                handleAddCategoryForm(request, response);
                return;
            }

            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            category.setSlug(StringUtil.generateSlug(name));
            category.setStatus(status != null ? status : "ACTIVE");
            category.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            category.setUpdatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            boolean success = categoryDAO.createCategory(category);

            if (success) {
                request.getSession().setAttribute("success", "Thêm danh mục thành công");
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm danh mục");
                handleAddCategoryForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm danh mục");
            handleAddCategoryForm(request, response);
        }
    }

    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ");
                return;
            }

            int categoryId = Integer.parseInt(idParam);
            Category category = categoryDAO.getCategoryById(categoryId);

            if (category == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Danh mục không tồn tại");
                return;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String status = request.getParameter("status");

            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            category.setSlug(StringUtil.generateSlug(name));
            category.setStatus(status != null ? status : "ACTIVE");
            category.setUpdatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            boolean success = categoryDAO.updateCategory(category);

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật danh mục thành công");
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật danh mục");
                handleEditCategoryForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật danh mục");
            handleEditCategoryForm(request, response);
        }
    }

    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID danh mục không hợp lệ");
                return;
            }

            int categoryId = Integer.parseInt(idParam);

            // Check if category has products
            List<Product> products = productDAO.getProductsByCategory(categoryId);
            if (!products.isEmpty()) {
                request.getSession().setAttribute("error", "Không thể xóa danh mục đang có sản phẩm");
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                return;
            }

            boolean success = categoryDAO.deleteCategory(categoryId);

            if (success) {
                request.getSession().setAttribute("success", "Xóa danh mục thành công");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa danh mục");
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa danh mục");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }

    private void handleOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // This would get orders from OrderDAO
            List<Order> orders = new ArrayList<>(); // orderDAO.getAllOrders();

            request.setAttribute("orders", orders);
            request.setAttribute("pageTitle", "Quản lý đơn hàng");

            request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách đơn hàng");
        }
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderNumber = request.getParameter("orderNumber");
            if (orderNumber == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ");
                return;
            }

            // This would get order from OrderDAO
            Order order = null; // orderDAO.getOrderByNumber(orderNumber);

            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đơn hàng không tồn tại");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng " + orderNumber);

            request.getRequestDispatcher("/views/admin/order-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải chi tiết đơn hàng");
        }
    }

    private void handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderNumber = request.getParameter("orderNumber");
            String newStatus = request.getParameter("status");

            if (orderNumber == null || newStatus == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số bắt buộc");
                return;
            }

            // This would update order status via OrderDAO
            boolean success = true; // orderDAO.updateOrderStatus(orderNumber, newStatus);

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật trạng thái đơn hàng thành công");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái");
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void handleUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<User> users = userDAO.getAllUsers();

            request.setAttribute("users", users);
            request.setAttribute("pageTitle", "Quản lý người dùng");

            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải danh sách người dùng");
        }
    }

    private void handleUpdateUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idParam = request.getParameter("id");
            String status = request.getParameter("status");

            if (idParam == null || status == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số bắt buộc");
                return;
            }

            int userId = Integer.parseInt(idParam);
            boolean success = userDAO.updateUserStatus(userId, status);

            if (success) {
                request.getSession().setAttribute("success", "Cập nhật trạng thái người dùng thành công");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái");
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void handleSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "Cài đặt hệ thống");
        request.getRequestDispatcher("/views/admin/settings.jsp").forward(request, response);
    }

    private List<String> handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
        List<String> imageUrls = new ArrayList<>();

        try {
            // Get the upload directory
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator
                    + "products";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Process uploaded files
            for (Part part : request.getParts()) {
                String fileName = extractFileName(part);
                if (fileName != null && !fileName.isEmpty()) {
                    // Generate unique filename
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    String filePath = uploadPath + File.separator + uniqueFileName;

                    part.write(filePath);

                    // Store relative URL
                    String imageUrl = "/uploads/products/" + uniqueFileName;
                    imageUrls.add(imageUrl);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Log error but don't fail the whole operation
        }

        return imageUrls;
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");

        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}
