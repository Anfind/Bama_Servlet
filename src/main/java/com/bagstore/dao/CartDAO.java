package com.bagstore.dao;

import com.bagstore.model.CartItem;
import com.bagstore.model.Product;
import com.bagstore.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartItemsByUserId(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ci.*, p.name as product_name, p.price, p.discount_price, " +
                "p.slug, p.stock_quantity, p.status, c.name as category_name, " +
                "pi.image_url FROM cart_items ci " +
                "JOIN products p ON ci.product_id = p.id " +
                "LEFT JOIN categories c ON p.category_id = c.id " +
                "LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.is_primary = TRUE " +
                "WHERE ci.user_id = ? ORDER BY ci.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                item.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Set product details
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setDiscountPrice(rs.getBigDecimal("discount_price"));
                product.setSlug(rs.getString("slug"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setStatus(rs.getString("status"));
                product.setCategoryName(rs.getString("category_name"));
                product.setMainImageUrl(rs.getString("image_url"));

                item.setProduct(product);
                item.updateSubtotal();
                cartItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItems;
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        // Check if item already exists in cart
        CartItem existingItem = getCartItem(userId, productId);

        if (existingItem != null) {
            // Update quantity
            return updateCartItemQuantity(existingItem.getId(), existingItem.getQuantity() + quantity);
        } else {
            // Add new item
            String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";

            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, userId);
                stmt.setInt(2, productId);
                stmt.setInt(3, quantity);

                return stmt.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        if (quantity <= 0) {
            return removeCartItem(cartItemId);
        }

        String sql = "UPDATE cart_items SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, cartItemId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean removeCartItem(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public CartItem getCartItem(int userId, int productId) {
        String sql = "SELECT * FROM cart_items WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                item.setUpdatedAt(rs.getTimestamp("updated_at"));

                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public int getCartItemCount(int userId) {
        String sql = "SELECT SUM(quantity) as total_count FROM cart_items WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("total_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public double getCartTotal(int userId) {
        String sql = "SELECT SUM(ci.quantity * " +
                "CASE WHEN p.discount_price > 0 THEN p.discount_price ELSE p.price END) as total " +
                "FROM cart_items ci JOIN products p ON ci.product_id = p.id " +
                "WHERE ci.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                BigDecimal result = rs.getBigDecimal("total");
                return result != null ? result.doubleValue() : 0.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }
}
