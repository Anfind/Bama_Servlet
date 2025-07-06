package com.bagstore.dao;

import com.bagstore.model.Category;
import com.bagstore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public boolean createCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, slug, image_url, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getSlug());
            pstmt.setString(4, category.getImageUrl());
            pstmt.setString(5, category.getStatus());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Category getCategoryBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE slug = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, slug);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting category by slug: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    public List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 'ACTIVE' ORDER BY name ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting active categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, slug = ?, image_url = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getSlug());
            pstmt.setString(4, category.getImageUrl());
            pstmt.setString(5, category.getStatus());
            pstmt.setInt(6, category.getId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isSlugExists(String slug) {
        return getCategoryBySlug(slug) != null;
    }

    public boolean isSlugExists(String slug, int excludeId) {
        String sql = "SELECT id FROM categories WHERE slug = ? AND id != ?";

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

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setSlug(rs.getString("slug"));
        category.setImageUrl(rs.getString("image_url"));
        category.setStatus(rs.getString("status"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
}
