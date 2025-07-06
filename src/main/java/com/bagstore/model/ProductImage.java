package com.bagstore.model;

import java.sql.Timestamp;

public class ProductImage {
    private int id;
    private int productId;
    private String imageUrl;
    private boolean isPrimary;
    private String altText;
    private Timestamp createdAt;

    public ProductImage() {
    }

    public ProductImage(int productId, String imageUrl, boolean isPrimary, String altText) {
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.altText = altText;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
    }

    public String getAltText() {
        return altText;
    }

    public void setAltText(String altText) {
        this.altText = altText;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ProductImage{" +
                "id=" + id +
                ", productId=" + productId +
                ", imageUrl='" + imageUrl + '\'' +
                ", isPrimary=" + isPrimary +
                '}';
    }
}
