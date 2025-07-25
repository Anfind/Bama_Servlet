package com.bagstore.dao;

import com.bagstore.model.Order;
import com.bagstore.model.OrderItem;
import com.bagstore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class OrderDAO {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Load order items
                order.setOrderItems(getOrderItemsByOrderId(order.getId()));

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Load order items
                order.setOrderItems(getOrderItemsByOrderId(order.getId()));

                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Order getOrderByNumber(String orderNumber) {
        String sql = "SELECT * FROM orders WHERE order_number = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, orderNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Load order items
                order.setOrderItems(getOrderItemsByOrderId(order.getId()));

                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, order_number, total_amount, status, payment_method, " +
                "payment_status, shipping_address, shipping_phone, shipping_name, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, order.getUserId());
            stmt.setString(2, order.getOrderNumber());
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getPaymentMethod());
            stmt.setString(6, order.getPaymentStatus());
            stmt.setString(7, order.getShippingAddress());
            stmt.setString(8, order.getShippingPhone());
            stmt.setString(9, order.getShippingName());
            stmt.setString(10, order.getNotes());

            int result = stmt.executeUpdate();

            if (result > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    order.setId(generatedKeys.getInt(1));

                    // Create order items
                    if (order.getOrderItems() != null) {
                        for (OrderItem item : order.getOrderItems()) {
                            item.setOrderId(order.getId());
                            createOrderItem(item);
                        }
                    }

                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<Order> findByUserId(int userId, int page, int pageSize, String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ?";

        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }

        sql += " ORDER BY created_at DESC LIMIT ? OFFSET ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, userId);

            if (status != null && !status.isEmpty()) {
                stmt.setString(paramIndex++, status);
            }

            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex++, (page - 1) * pageSize);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setPaymentStatus(rs.getString("payment_status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setShippingPhone(rs.getString("shipping_phone"));
                order.setShippingName(rs.getString("shipping_name"));
                order.setNotes(rs.getString("notes"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public int countByUserId(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";

        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
        }

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, userId);

            if (status != null && !status.isEmpty()) {
                stmt.setString(paramIndex++, status);
            }

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    private List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name as product_name FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setTotal(rs.getBigDecimal("total"));
                item.setProductName(rs.getString("product_name"));
                item.setCreatedAt(rs.getTimestamp("created_at"));

                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    private boolean createOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price, total) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setBigDecimal(4, item.getPrice());
            stmt.setBigDecimal(5, item.getTotal());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public String generateOrderNumber() {
        // Generate order number format: ORD-YYYYMMDD-XXXX
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(new java.util.Date());

        String sql = "SELECT COUNT(*) + 1 as next_number FROM orders WHERE DATE(created_at) = CURDATE()";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                int nextNumber = rs.getInt("next_number");
                return String.format("ORD-%s-%04d", dateStr, nextNumber);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "ORD-" + dateStr + "-0001";
    }
}
