-- Create database
CREATE DATABASE IF NOT EXISTS bagstore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bagstore_db;

-- Create users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    slug VARCHAR(100) UNIQUE NOT NULL,
    image_url VARCHAR(255),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount_price DECIMAL(10, 2) DEFAULT 0,
    category_id INT NOT NULL,
    stock_quantity INT DEFAULT 0,
    status ENUM('ACTIVE', 'INACTIVE', 'OUT_OF_STOCK') DEFAULT 'ACTIVE',
    slug VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Create product_images table
CREATE TABLE product_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    alt_text VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create cart_items table
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- Create orders table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPING', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    payment_method ENUM('COD', 'BANK_TRANSFER', 'CREDIT_CARD') DEFAULT 'COD',
    payment_status ENUM('PENDING', 'PAID', 'FAILED') DEFAULT 'PENDING',
    shipping_address TEXT NOT NULL,
    shipping_phone VARCHAR(20) NOT NULL,
    shipping_name VARCHAR(100) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ============================================================================
-- SAMPLE DATA - Dữ liệu mẫu hoàn chỉnh
-- ============================================================================

-- Tạo categories mẫu
INSERT INTO categories (name, description, slug, image_url, status, created_at, updated_at) VALUES
('Balo công sở', 'Balo phù hợp cho công sở và làm việc', 'balo-cong-so', '/BagStore/images/categories/balo-cong-so.svg', 'ACTIVE', NOW(), NOW()),
('Balo học sinh', 'Balo dành cho học sinh, sinh viên', 'balo-hoc-sinh', '/BagStore/images/categories/balo-hoc-sinh.svg', 'ACTIVE', NOW(), NOW()),
('Túi xách nữ', 'Túi xách thời trang cho nữ', 'tui-xach-nu', '/BagStore/images/categories/tui-xach-nu.svg', 'ACTIVE', NOW(), NOW()),
('Túi đeo chéo', 'Túi đeo chéo tiện lợi', 'tui-deo-cheo', '/BagStore/images/categories/tui-deo-cheo.svg', 'ACTIVE', NOW(), NOW()),
('Phụ kiện', 'Các phụ kiện đi kèm', 'phu-kien', '/BagStore/images/categories/phu-kien.svg', 'ACTIVE', NOW(), NOW());

-- Tạo products mẫu
INSERT INTO products (name, description, price, discount_price, category_id, stock_quantity, status, slug, created_at, updated_at) VALUES
-- Balo công sở
('Balo Laptop Dell Professional', 'Balo laptop cao cấp phù hợp cho công sở', 850000, 750000, 1, 50, 'ACTIVE', 'balo-laptop-dell-professional', NOW(), NOW()),
('Balo Công Sở Samsonite Pro', 'Balo công sở chuyên nghiệp với nhiều ngăn tiện lợi', 1200000, 0, 1, 30, 'ACTIVE', 'balo-cong-so-samsonite-pro', NOW(), NOW()),
('Balo Thông Minh Xiaomi', 'Balo thông minh với cổng USB tích hợp', 650000, 550000, 1, 40, 'ACTIVE', 'balo-thong-minh-xiaomi', NOW(), NOW()),

-- Balo học sinh
('Balo Học Sinh Stardust', 'Balo học sinh màu sắc trẻ trung', 320000, 280000, 2, 100, 'ACTIVE', 'balo-hoc-sinh-stardust', NOW(), NOW()),
('Balo Nữ Sinh Đáng Yêu', 'Balo dành cho nữ sinh với thiết kế dễ thương', 280000, 0, 2, 80, 'ACTIVE', 'balo-nu-sinh-dang-yeu', NOW(), NOW()),
('Balo Thể Thao Nike', 'Balo thể thao năng động cho học sinh', 450000, 400000, 2, 60, 'ACTIVE', 'balo-the-thao-nike', NOW(), NOW()),

-- Túi xách nữ
('Túi Xách Nữ Cao Cấp MF101', 'Túi xách nữ thiết kế sang trọng', 890000, 750000, 3, 25, 'ACTIVE', 'tui-xach-nu-cao-cap-mf101', NOW(), NOW()),
('Túi Xách Công Sở Nữ', 'Túi xách phù hợp cho công sở và dạo phố', 650000, 0, 3, 35, 'ACTIVE', 'tui-xach-cong-so-nu', NOW(), NOW()),
('Túi Xách Da Thật Premium', 'Túi xách da thật cao cấp', 1500000, 1350000, 3, 15, 'ACTIVE', 'tui-xach-da-that-premium', NOW(), NOW()),

-- Túi đeo chéo
('Túi Đeo Chéo Nam Crossbag', 'Túi đeo chéo tiện lợi cho nam', 320000, 280000, 4, 70, 'ACTIVE', 'tui-deo-cheo-nam-crossbag', NOW(), NOW()),
('Túi Đeo Chéo Nữ Mini', 'Túi đeo chéo nhỏ gọn cho nữ', 250000, 0, 4, 90, 'ACTIVE', 'tui-deo-cheo-nu-mini', NOW(), NOW()),
('Túi Đeo Chéo Thể Thao', 'Túi đeo chéo dành cho hoạt động thể thao', 180000, 150000, 4, 120, 'ACTIVE', 'tui-deo-cheo-the-thao', NOW(), NOW()),

-- Phụ kiện
('Móc Khóa Da Cao Cấp', 'Móc khóa da thật thiết kế đẹp', 85000, 65000, 5, 200, 'ACTIVE', 'moc-khoa-da-cao-cap', NOW(), NOW()),
('Ví Da Nam Slim', 'Ví da nam mỏng gọn tiện lợi', 220000, 0, 5, 150, 'ACTIVE', 'vi-da-nam-slim', NOW(), NOW()),
('Thắt Lưng Da Thật', 'Thắt lưng da thật cao cấp', 350000, 300000, 5, 80, 'ACTIVE', 'that-lung-da-that', NOW(), NOW());

-- Thêm ảnh balo cho tất cả sản phẩm (sử dụng ảnh balo của bạn)
INSERT INTO product_images (product_id, image_url, is_primary, alt_text, created_at)
SELECT 
    id,
    '/BagStore/images/products/balo.png',
    1,
    CONCAT(name, ' - Ảnh chính'),
    NOW()
FROM products 
WHERE status = 'ACTIVE';

-- Tạo user admin và user thường (password: admin123 cho tất cả)
INSERT INTO users (username, email, password, full_name, phone, address, role, created_at, updated_at) VALUES
('admin', 'admin@bagstore.com', '$2a$12$LQv3c1yqBwlVHdaQfnUTKOXlMhKWKCTXJCgIL5RyM1Y7ZY5qxZQkS', 'Administrator', '0705777760', 'TP.HCM', 'ADMIN', NOW(), NOW()),
('user1', 'user1@bagstore.com', '$2a$12$LQv3c1yqBwlVHdaQfnUTKOXlMhKWKCTXJCgIL5RyM1Y7ZY5qxZQkS', 'Nguyễn Văn A', '0901234567', 'Quận 1, TP.HCM', 'USER', NOW(), NOW()),
('user2', 'user2@bagstore.com', '$2a$12$LQv3c1yqBwlVHdaQfnUTKOXlMhKWKCTXJCgIL5RyM1Y7ZY5qxZQkS', 'Trần Thị B', '0902345678', 'Quận 3, TP.HCM', 'USER', NOW(), NOW());

-- Create indexes for better performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_cart_user ON cart_items(user_id);

-- ============================================================================
-- KIỂM TRA KẾT QUẢ
-- ============================================================================

-- Kiểm tra số lượng dữ liệu đã tạo
SELECT 'Categories Created' as Info, COUNT(*) as Count FROM categories;
SELECT 'Products Created' as Info, COUNT(*) as Count FROM products;
SELECT 'Product Images Created' as Info, COUNT(*) as Count FROM product_images;
SELECT 'Users Created' as Info, COUNT(*) as Count FROM users;

-- Hiển thị danh sách sản phẩm với ảnh
SELECT 
    p.id,
    p.name,
    p.price,
    p.discount_price,
    c.name as category_name,
    pi.image_url,
    p.status
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.is_primary = 1
ORDER BY p.id;

-- ============================================================================
-- THÔNG TIN TÁI KHOẢN ĐĂNG NHẬP
-- ============================================================================

-- ADMIN ACCOUNT:
-- Username: admin
-- Email: admin@bagstore.com  
-- Password: admin123

-- USER ACCOUNTS:
-- Username: user1 | Email: user1@bagstore.com | Password: admin123
-- Username: user2 | Email: user2@bagstore.com | Password: admin123

-- ============================================================================
-- HOÀN TẤT THIẾT LẬP
-- ============================================================================

-- Database setup completed successfully!
-- Tất cả sản phẩm sẽ hiển thị với ảnh balo.png
-- Bạn có thể thay đổi ảnh sau bằng cách copy file ảnh vào:
-- src/main/webapp/images/products/balo.png
-- hoặc
-- webapps/BagStore/images/products/balo.png

COMMIT;
