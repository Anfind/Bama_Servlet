package com.bagstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private BigDecimal discountPrice;
    private int categoryId;
    private int stockQuantity;
    private String status;
    private String slug;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Related objects
    private Category category;
    private List<ProductImage> images;

    // Additional fields for display
    private String mainImageUrl;
    private String categoryName;

    public Product() {
    }

    public Product(String name, String description, BigDecimal price, int categoryId, String slug) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.categoryId = categoryId;
        this.slug = slug;
        this.status = "ACTIVE";
        this.discountPrice = BigDecimal.ZERO;
        this.stockQuantity = 0;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(BigDecimal discountPrice) {
        this.discountPrice = discountPrice;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    // Helper methods
    public boolean hasDiscount() {
        return discountPrice != null && discountPrice.compareTo(BigDecimal.ZERO) > 0;
    }

    public BigDecimal getEffectivePrice() {
        return hasDiscount() ? discountPrice : price;
    }

    public BigDecimal getDiscountPercentage() {
        if (!hasDiscount() || price.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }
        return price.subtract(discountPrice)
                .multiply(BigDecimal.valueOf(100))
                .divide(price, 0, java.math.RoundingMode.HALF_UP);
    }

    public boolean isInStock() {
        return stockQuantity > 0 && "ACTIVE".equals(status);
    }

    public String getPrimaryImageUrl() {
        if (images != null && !images.isEmpty()) {
            return images.stream()
                    .filter(ProductImage::isPrimary)
                    .findFirst()
                    .map(ProductImage::getImageUrl)
                    .orElse(images.get(0).getImageUrl());
        }
        return "assets/images/products/no-image.jpg";
    }

    // Helper method to get final price (with discount)
    public BigDecimal getFinalPrice() {
        if (discountPrice != null && discountPrice.compareTo(BigDecimal.ZERO) > 0) {
            return discountPrice;
        }
        return price;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", discountPrice=" + discountPrice +
                ", slug='" + slug + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
