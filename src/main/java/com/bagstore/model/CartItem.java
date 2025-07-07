package com.bagstore.model;

import java.sql.Timestamp;

public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Related objects
    private Product product;

    // Additional fields for cart functionality
    private String color;
    private String size;
    private java.math.BigDecimal subtotal;

    public CartItem() {
    }

    public CartItem(int userId, int productId, int quantity) {
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public java.math.BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(java.math.BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public java.math.BigDecimal getPrice() {
        return product != null ? product.getFinalPrice() : java.math.BigDecimal.ZERO;
    }

    public void setPrice(java.math.BigDecimal price) {
        // This method is mainly for compatibility, actual price comes from product
        if (product != null) {
            // Update subtotal when price is set
            this.subtotal = price.multiply(java.math.BigDecimal.valueOf(quantity));
        }
    }

    // Helper method to update subtotal
    public void updateSubtotal() {
        if (product != null) {
            this.subtotal = product.getFinalPrice().multiply(java.math.BigDecimal.valueOf(quantity));
        }
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", userId=" + userId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                '}';
    }
}
