package com.bagstore.controller;

import com.bagstore.dao.ProductDAO;
import com.bagstore.model.Product;
import com.bagstore.model.CartItem;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ObjectMapper objectMapper;
    private static final String CART_SESSION_KEY = "cart";

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "view";

        switch (action) {
            case "view":
                handleCartView(request, response);
                break;
            case "count":
                handleCartCount(request, response);
                break;
            case "ajax":
                handleAjaxCartInfo(request, response);
                break;
            default:
                handleCartView(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không được để trống");
            return;
        }

        switch (action) {
            case "add":
                handleAddToCart(request, response);
                break;
            case "update":
                handleUpdateCart(request, response);
                break;
            case "remove":
                handleRemoveFromCart(request, response);
                break;
            case "clear":
                handleClearCart(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
                break;
        }
    }

    private void handleCartView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<CartItem> cartItems = getCartItems(request.getSession());
            BigDecimal totalAmount = calculateTotalAmount(cartItems);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("cartCount", cartItems.size());
            request.setAttribute("pageTitle", "Giỏ hàng");

            request.getRequestDispatcher("/views/cart/view.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải giỏ hàng");
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String productIdParam = request.getParameter("productId");
            String quantityParam = request.getParameter("quantity");
            String color = request.getParameter("color");
            String size = request.getParameter("size");

            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID không được để trống");
                return;
            }

            int productId = Integer.parseInt(productIdParam);
            int quantity = 1;

            if (quantityParam != null && !quantityParam.isEmpty()) {
                quantity = Integer.parseInt(quantityParam);
                if (quantity < 1)
                    quantity = 1;
            }

            Product product = productDAO.getProductById(productId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
                return;
            }

            if (!"ACTIVE".equals(product.getStatus())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Sản phẩm không còn bán");
                return;
            }

            if (product.getStockQuantity() < quantity) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng sản phẩm không đủ");
                return;
            }

            HttpSession session = request.getSession();
            List<CartItem> cartItems = getCartItems(session);

            // Check if product already exists in cart
            boolean found = false;
            for (CartItem item : cartItems) {
                if (item.getProductId() == productId &&
                        (color == null || color.equals(item.getColor())) &&
                        (size == null || size.equals(item.getSize()))) {

                    int newQuantity = item.getQuantity() + quantity;
                    if (newQuantity > product.getStockQuantity()) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng vượt quá tồn kho");
                        return;
                    }

                    item.setQuantity(newQuantity);
                    item.updateSubtotal();
                    found = true;
                    break;
                }
            }

            // If not found, add new item
            if (!found) {
                CartItem newItem = new CartItem();
                newItem.setProductId(productId);
                newItem.setProduct(product);
                newItem.setQuantity(quantity);
                newItem.setPrice(product.getFinalPrice());
                newItem.setColor(color);
                newItem.setSize(size);
                newItem.updateSubtotal();

                cartItems.add(newItem);
            }

            session.setAttribute(CART_SESSION_KEY, cartItems);

            // Handle AJAX vs regular request
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                CartResponse cartResponse = new CartResponse();
                cartResponse.success = true;
                cartResponse.message = "Đã thêm sản phẩm vào giỏ hàng";
                cartResponse.cartCount = cartItems.size();
                cartResponse.totalAmount = calculateTotalAmount(cartItems);

                response.getWriter().write(objectMapper.writeValueAsString(cartResponse));
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi thêm sản phẩm vào giỏ hàng");
        }
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String productIdParam = request.getParameter("productId");
            String quantityParam = request.getParameter("quantity");
            String color = request.getParameter("color");
            String size = request.getParameter("size");

            if (productIdParam == null || quantityParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số bắt buộc");
                return;
            }

            int productId = Integer.parseInt(productIdParam);
            int quantity = Integer.parseInt(quantityParam);

            if (quantity < 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng không hợp lệ");
                return;
            }

            HttpSession session = request.getSession();
            List<CartItem> cartItems = getCartItems(session);

            Iterator<CartItem> iterator = cartItems.iterator();
            boolean found = false;

            while (iterator.hasNext()) {
                CartItem item = iterator.next();
                if (item.getProductId() == productId &&
                        (color == null || color.equals(item.getColor())) &&
                        (size == null || size.equals(item.getSize()))) {

                    if (quantity == 0) {
                        // Remove item if quantity is 0
                        iterator.remove();
                    } else {
                        // Check stock availability
                        Product product = productDAO.getProductById(productId);
                        if (product != null && quantity <= product.getStockQuantity()) {
                            item.setQuantity(quantity);
                            item.updateSubtotal();
                        } else {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số lượng vượt quá tồn kho");
                            return;
                        }
                    }
                    found = true;
                    break;
                }
            }

            if (!found) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không có trong giỏ hàng");
                return;
            }

            session.setAttribute(CART_SESSION_KEY, cartItems);

            // Handle AJAX vs regular request
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                CartResponse cartResponse = new CartResponse();
                cartResponse.success = true;
                cartResponse.message = "Đã cập nhật giỏ hàng";
                cartResponse.cartCount = cartItems.size();
                cartResponse.totalAmount = calculateTotalAmount(cartItems);

                response.getWriter().write(objectMapper.writeValueAsString(cartResponse));
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật giỏ hàng");
        }
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String productIdParam = request.getParameter("productId");
            String color = request.getParameter("color");
            String size = request.getParameter("size");

            if (productIdParam == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID không được để trống");
                return;
            }

            int productId = Integer.parseInt(productIdParam);

            HttpSession session = request.getSession();
            List<CartItem> cartItems = getCartItems(session);

            boolean removed = cartItems.removeIf(item -> item.getProductId() == productId &&
                    (color == null || color.equals(item.getColor())) &&
                    (size == null || size.equals(item.getSize())));

            if (!removed) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không có trong giỏ hàng");
                return;
            }

            session.setAttribute(CART_SESSION_KEY, cartItems);

            // Handle AJAX vs regular request
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                CartResponse cartResponse = new CartResponse();
                cartResponse.success = true;
                cartResponse.message = "Đã xóa sản phẩm khỏi giỏ hàng";
                cartResponse.cartCount = cartItems.size();
                cartResponse.totalAmount = calculateTotalAmount(cartItems);

                response.getWriter().write(objectMapper.writeValueAsString(cartResponse));
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID không hợp lệ");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xóa sản phẩm khỏi giỏ hàng");
        }
    }

    private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            session.removeAttribute(CART_SESSION_KEY);

            // Handle AJAX vs regular request
            String ajaxRequest = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(ajaxRequest)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                CartResponse cartResponse = new CartResponse();
                cartResponse.success = true;
                cartResponse.message = "Đã xóa toàn bộ giỏ hàng";
                cartResponse.cartCount = 0;
                cartResponse.totalAmount = BigDecimal.ZERO;

                response.getWriter().write(objectMapper.writeValueAsString(cartResponse));
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xóa giỏ hàng");
        }
    }

    private void handleCartCount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<CartItem> cartItems = getCartItems(request.getSession());
            int count = cartItems.size();

            response.getWriter().write("{\"count\": " + count + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }

    private void handleAjaxCartInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<CartItem> cartItems = getCartItems(request.getSession());
            BigDecimal totalAmount = calculateTotalAmount(cartItems);

            CartInfo cartInfo = new CartInfo();
            cartInfo.items = cartItems;
            cartInfo.count = cartItems.size();
            cartInfo.totalAmount = totalAmount;

            response.getWriter().write(objectMapper.writeValueAsString(cartInfo));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }

    @SuppressWarnings("unchecked")
    private List<CartItem> getCartItems(HttpSession session) {
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cartItems);
        }
        return cartItems;
    }

    private BigDecimal calculateTotalAmount(List<CartItem> cartItems) {
        return cartItems.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Helper classes for JSON response
    private static class CartResponse {
        public boolean success;
        public String message;
        public int cartCount;
        public BigDecimal totalAmount;
    }

    private static class CartInfo {
        public List<CartItem> items;
        public int count;
        public BigDecimal totalAmount;
    }
}
