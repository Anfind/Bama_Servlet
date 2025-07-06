package com.bagstore.dao;

import com.bagstore.model.Product;
import com.bagstore.model.Category;
import com.bagstore.model.ProductImage;
import com.bagstore.util.DatabaseConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public boolean createProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, discount_price, category_id, stock_quantity, status, slug) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setBigDecimal(3, product.getPrice());
            pstmt.setBigDecimal(4, product.getDiscountPrice());
            pstmt.setInt(5, product.getCategoryId());
            pstmt.setInt(6, product.getStockQuantity());
            pstmt.setString(7, product.getStatus());
            pstmt.setString(8, product.getSlug());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        product.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error creating product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Product getProductById(int id) {
        String sql = "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setImages(getProductImages(id));
                    return product;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Product getProductBySlug(String slug) {
        String sql = "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.slug = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, slug);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setImages(getProductImages(product.getId()));
                    return product;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting product by slug: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> getAllProducts() {
        return getProducts("SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id ORDER BY p.created_at DESC", null);
    }

    public List<Product> getActiveProducts() {
        return getProducts("SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' " +
                "ORDER BY p.created_at DESC", null);
    }

    public List<Product> getFeaturedProducts(int limit) {
        return getProducts("SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' " +
                "ORDER BY p.created_at DESC LIMIT ?", limit);
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return getProducts("SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.category_id = ? " +
                "AND p.status = 'ACTIVE' ORDER BY p.created_at DESC", categoryId);
    }

    public List<Product> searchProducts(String keyword) {
        return getProducts("SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' " +
                "AND (p.name LIKE ? OR p.description LIKE ?) ORDER BY p.created_at DESC",
                "%" + keyword + "%");
    }

    public List<Product> getProductsByPriceRange(BigDecimal minPrice, BigDecimal maxPrice) {
        String sql = "SELECT p.*, c.name as category_name FROM products p " +
                "LEFT JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' " +
                "AND ((p.discount_price > 0 AND p.discount_price BETWEEN ? AND ?) " +
                "OR (p.discount_price = 0 AND p.price BETWEEN ? AND ?)) " +
                "ORDER BY p.created_at DESC";

        List<Product> products = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBigDecimal(1, minPrice);
            pstmt.setBigDecimal(2, maxPrice);
            pstmt.setBigDecimal(3, minPrice);
            pstmt.setBigDecimal(4, maxPrice);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setImages(getProductImages(product.getId()));
                    products.add(product);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting products by price range: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, discount_price = ?, " +
                "category_id = ?, stock_quantity = ?, status = ?, slug = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setBigDecimal(3, product.getPrice());
            pstmt.setBigDecimal(4, product.getDiscountPrice());
            pstmt.setInt(5, product.getCategoryId());
            pstmt.setInt(6, product.getStockQuantity());
            pstmt.setString(7, product.getStatus());
            pstmt.setString(8, product.getSlug());
            pstmt.setInt(9, product.getId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isSlugExists(String slug) {
        return getProductBySlug(slug) != null;
    }

    public boolean isSlugExists(String slug, int excludeId) {
        String sql = "SELECT id FROM products WHERE slug = ? AND id != ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, slug);
            pstmt.setInt(2, excludeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            System.err.println("Error checking slug exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private List<Product> getProducts(String sql, Object parameter) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (parameter != null) {
                if (parameter instanceof Integer) {
                    pstmt.setInt(1, (Integer) parameter);
                } else if (parameter instanceof String) {
                    String param = (String) parameter;
                    if (param.contains("%")) {
                        pstmt.setString(1, param);
                        pstmt.setString(2, param);
                    } else {
                        pstmt.setString(1, param);
                    }
                }
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = mapResultSetToProduct(rs);
                    product.setImages(getProductImages(product.getId()));
                    products.add(product);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting products: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    private List<ProductImage> getProductImages(int productId) {
        List<ProductImage> images = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_primary DESC, id ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ProductImage image = new ProductImage();
                    image.setId(rs.getInt("id"));
                    image.setProductId(rs.getInt("product_id"));
                    image.setImageUrl(rs.getString("image_url"));
                    image.setPrimary(rs.getBoolean("is_primary"));
                    image.setAltText(rs.getString("alt_text"));
                    image.setCreatedAt(rs.getTimestamp("created_at"));
                    images.add(image);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting product images: " + e.getMessage());
            e.printStackTrace();
        }
        return images;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setDiscountPrice(rs.getBigDecimal("discount_price"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setStatus(rs.getString("status"));
        product.setSlug(rs.getString("slug"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Set category if available
        String categoryName = rs.getString("category_name");
        if (categoryName != null) {
            Category category = new Category();
            category.setId(product.getCategoryId());
            category.setName(categoryName);
            product.setCategory(category);
        }

        return product;
    }
}
