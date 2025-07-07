package com.bagstore.controller;

import com.bagstore.dao.ProductDAO;
import com.bagstore.dao.UserDAO;
import com.bagstore.model.Product;
import com.bagstore.model.User;
import com.bagstore.model.CartItem;
import com.bagstore.model.Order;
import com.bagstore.model.OrderItem;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class OrderServlet extends HttpServlet {
    private ProductDAO productDAO;
    private UserDAO userDAO;
    private ObjectMapper objectMapper;
    private static final String CART_SESSION_KEY = "cart";

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        userDAO = new UserDAO();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null)
            action = "checkout";

        switch (action) {
            case "checkout":
                handleCheckoutPage(request, response);
                break;
            case "history":
                handleOrderHistory(request, response);
                break;
            case "detail":
                handleOrderDetail(request, response);
                break;
            case "track":
                handleOrderTracking(request, response);
                break;
            case "success":
                handleOrderSuccess(request, response);
                break;
            default:
                handleCheckoutPage(request, response);
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
            case "place":
                handlePlaceOrder(request, response);
                break;
            case "update_status":
                handleUpdateOrderStatus(request, response);
                break;
            case "cancel":
                handleCancelOrder(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
                break;
        }
    }

    private void handleCheckoutPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();

            // Check if user is logged in
            User user = (User) session.getAttribute("user");
            if (user == null) {
                // Redirect to login with return URL
                String returnUrl = request.getContextPath() + "/order?action=checkout";
                response.sendRedirect(request.getContextPath() + "/auth?action=login&returnUrl=" + returnUrl);
                return;
            }

            // Get cart items
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);

            if (cartItems == null || cartItems.isEmpty()) {
                request.setAttribute("error", "Giỏ hàng của bạn đang trống");
                request.getRequestDispatcher("/views/cart/view.jsp").forward(request, response);
                return;
            }

            // Validate cart items and update prices
            List<CartItem> validCartItems = new ArrayList<>();
            for (CartItem item : cartItems) {
                Product product = productDAO.getProductById(item.getProductId());
                if (product != null && "ACTIVE".equals(product.getStatus()) &&
                        product.getStockQuantity() >= item.getQuantity()) {

                    // Update price in case it changed
                    item.setProduct(product);
                    item.setPrice(product.getFinalPrice());
                    item.updateSubtotal();
                    validCartItems.add(item);
                } else {
                    // Product unavailable or insufficient stock
                    request.setAttribute("error", "Sản phẩm '" + item.getProduct().getName() + "' không còn đủ hàng");
                }
            }

            if (validCartItems.isEmpty()) {
                request.setAttribute("error", "Không có sản phẩm nào khả dụng trong giỏ hàng");
                request.getRequestDispatcher("/views/cart/view.jsp").forward(request, response);
                return;
            }

            // Calculate totals
            BigDecimal subtotal = validCartItems.stream()
                    .map(CartItem::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal shippingFee = calculateShippingFee(subtotal);
            BigDecimal totalAmount = subtotal.add(shippingFee);

            // Set attributes for checkout page
            request.setAttribute("user", user);
            request.setAttribute("cartItems", validCartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("pageTitle", "Thanh toán");

            request.getRequestDispatcher("/views/order/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải trang thanh toán");
        }
    }

    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();

            // Check if user is logged in
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập để đặt hàng");
                return;
            }

            // Get form data
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() ||
                    phone == null || phone.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    address == null || address.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                handleCheckoutPage(request, response);
                return;
            }

            // Get cart items
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute(CART_SESSION_KEY);

            if (cartItems == null || cartItems.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giỏ hàng trống");
                return;
            }

            // Create order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderNumber(generateOrderNumber());
            order.setFullName(fullName.trim());
            order.setPhone(phone.trim());
            order.setEmail(email.trim());
            order.setAddress(address.trim());
            order.setCity(city != null ? city.trim() : "");
            order.setDistrict(district != null ? district.trim() : "");
            order.setWard(ward != null ? ward.trim() : "");
            order.setPaymentMethod(paymentMethod);
            order.setNotes(notes != null ? notes.trim() : "");
            order.setStatus("PENDING");
            order.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));

            // Calculate totals
            BigDecimal subtotal = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();

            for (CartItem cartItem : cartItems) {
                Product product = productDAO.getProductById(cartItem.getProductId());
                if (product == null || !"ACTIVE".equals(product.getStatus())) {
                    request.setAttribute("error", "Sản phẩm không còn khả dụng");
                    handleCheckoutPage(request, response);
                    return;
                }

                if (product.getStockQuantity() < cartItem.getQuantity()) {
                    request.setAttribute("error", "Sản phẩm '" + product.getName() + "' không đủ số lượng");
                    handleCheckoutPage(request, response);
                    return;
                }

                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(product.getId());
                orderItem.setProductName(product.getName());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(product.getFinalPrice());
                orderItem.setColor(cartItem.getColor());
                orderItem.setSize(cartItem.getSize());
                orderItem.setSubtotal(product.getFinalPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())));

                orderItems.add(orderItem);
                subtotal = subtotal.add(orderItem.getSubtotal());
            }

            BigDecimal shippingFee = calculateShippingFee(subtotal);
            BigDecimal totalAmount = subtotal.add(shippingFee);

            order.setSubtotal(subtotal);
            order.setShippingFee(shippingFee);
            order.setTotalAmount(totalAmount);
            order.setOrderItems(orderItems);

            // Save order to database (simulate - you need to implement OrderDAO)
            // boolean orderSaved = orderDAO.createOrder(order);
            boolean orderSaved = true; // Simulated success

            if (orderSaved) {
                // Update product stock (simulate - you need to implement this)
                // for (OrderItem item : orderItems) {
                // productDAO.updateStock(item.getProductId(), -item.getQuantity());
                // }

                // Clear cart
                session.removeAttribute(CART_SESSION_KEY);

                // Store order info in session for success page
                session.setAttribute("placedOrder", order);

                response.sendRedirect(request.getContextPath() + "/order?action=success");

            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại.");
                handleCheckoutPage(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi đặt hàng");
        }
    }

    private void handleOrderSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            Order order = (Order) session.getAttribute("placedOrder");

            if (order == null) {
                // No order in session, redirect to home
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Remove order from session to prevent refresh issues
            session.removeAttribute("placedOrder");

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Đặt hàng thành công");

            request.getRequestDispatcher("/views/order/success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải trang thành công");
        }
    }

    private void handleOrderHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/auth?action=login");
                return;
            }

            // Get user's orders (simulate - you need to implement OrderDAO)
            List<Order> orders = new ArrayList<>(); // orderDAO.getOrdersByUserId(user.getId());

            request.setAttribute("orders", orders);
            request.setAttribute("pageTitle", "Lịch sử đơn hàng");

            request.getRequestDispatcher("/views/order/history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải lịch sử đơn hàng");
        }
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderNumber = request.getParameter("orderNumber");
            if (orderNumber == null || orderNumber.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ");
                return;
            }

            // Get order details (simulate - you need to implement OrderDAO)
            Order order = null; // orderDAO.getOrderByNumber(orderNumber);

            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đơn hàng không tồn tại");
                return;
            }

            // Check if user has permission to view this order
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null || (user.getId() != order.getUserId() && !"ADMIN".equals(user.getRole()))) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem đơn hàng này");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng " + orderNumber);

            request.getRequestDispatcher("/views/order/detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải chi tiết đơn hàng");
        }
    }

    private void handleOrderTracking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String orderNumber = request.getParameter("orderNumber");
            if (orderNumber == null || orderNumber.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Mã đơn hàng không hợp lệ\"}");
                return;
            }

            // Get order status (simulate - you need to implement OrderDAO)
            // Order order = orderDAO.getOrderByNumber(orderNumber);
            Order order = null;

            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Đơn hàng không tồn tại\"}");
                return;
            }

            OrderTrackingResponse trackingResponse = new OrderTrackingResponse();
            trackingResponse.orderNumber = order.getOrderNumber();
            trackingResponse.status = order.getStatus();
            trackingResponse.statusText = getStatusText(order.getStatus());
            trackingResponse.createdAt = order.getCreatedAt().toString();
            trackingResponse.estimatedDelivery = "3-5 ngày làm việc";

            response.getWriter().write(objectMapper.writeValueAsString(trackingResponse));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi server\"}");
        }
    }

    private void handleUpdateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin only functionality
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền thực hiện");
            return;
        }

        try {
            String orderNumber = request.getParameter("orderNumber");
            String newStatus = request.getParameter("status");

            if (orderNumber == null || newStatus == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số bắt buộc");
                return;
            }

            // Update order status (simulate - you need to implement OrderDAO)
            // boolean updated = orderDAO.updateOrderStatus(orderNumber, newStatus);
            boolean updated = true;

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật trạng thái");
        }
    }

    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String orderNumber = request.getParameter("orderNumber");
            if (orderNumber == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn hàng không hợp lệ");
                return;
            }

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
                return;
            }

            // Cancel order logic (simulate - you need to implement OrderDAO)
            // boolean cancelled = orderDAO.cancelOrder(orderNumber, user.getId());
            boolean cancelled = true;

            if (cancelled) {
                response.sendRedirect(request.getContextPath() + "/order?action=history");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Không thể hủy đơn hàng");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hủy đơn hàng");
        }
    }

    private BigDecimal calculateShippingFee(BigDecimal subtotal) {
        // Free shipping for orders over 500,000 VND
        if (subtotal.compareTo(new BigDecimal("500000")) >= 0) {
            return BigDecimal.ZERO;
        }
        // Standard shipping fee
        return new BigDecimal("30000");
    }

    private String generateOrderNumber() {
        return "BAG" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
    }

    private String getStatusText(String status) {
        switch (status) {
            case "PENDING":
                return "Chờ xác nhận";
            case "CONFIRMED":
                return "Đã xác nhận";
            case "PROCESSING":
                return "Đang xử lý";
            case "SHIPPED":
                return "Đang giao hàng";
            case "DELIVERED":
                return "Đã giao hàng";
            case "CANCELLED":
                return "Đã hủy";
            default:
                return "Không xác định";
        }
    }

    // Helper class for JSON response
    private static class OrderTrackingResponse {
        public String orderNumber;
        public String status;
        public String statusText;
        public String createdAt;
        public String estimatedDelivery;
    }
}
