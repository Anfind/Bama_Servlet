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

-- Insert sample data

-- Insert admin user (password: admin123)
INSERT INTO users (username, email, password, full_name, role) VALUES 
('admin', 'admin@bagstore.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQlYIZYV7XhLjNlKgQKdN1HjGNbp.S', 'Administrator', 'ADMIN'),
('user1', 'user1@test.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQlYIZYV7XhLjNlKgQKdN1HjGNbp.S', 'Nguyen Van A', 'USER');

-- Insert categories
INSERT INTO categories (name, description, slug) VALUES 
('Balo Học Sinh', 'Balo dành cho học sinh, sinh viên', 'balo-hoc-sinh'),
('Balo Công Sở', 'Balo dành cho công việc văn phòng', 'balo-cong-so'),
('Túi Xách Nữ', 'Túi xách thời trang cho nữ', 'tui-xach-nu'),
('Túi Đeo Chéo', 'Túi đeo chéo tiện lợi', 'tui-deo-cheo'),
('Phụ Kiện', 'Các phụ kiện balo, túi xách', 'phu-kien');

-- Insert sample products
INSERT INTO products (name, description, price, discount_price, category_id, stock_quantity, slug) VALUES 
('Balo BAMA Mesh Fabric Backpack MF101', 'Balo học sinh với chất liệu lưới thoáng khí, thiết kế hiện đại', 450000, 399000, 1, 50, 'balo-bama-mesh-fabric-mf101'),
('Balo BAMA New Basic Backpack NB102', 'Balo basic với thiết kế đơn giản, phù hợp đi học đi làm', 380000, 0, 2, 30, 'balo-bama-new-basic-nb102'),
('Túi BAMA STARDUST Mini Bag', 'Túi mini thời trang với họa tiết stardust độc đáo', 320000, 280000, 3, 25, 'tui-bama-stardust-mini'),
('Mesh Fabric Cross Bag MF301', 'Túi đeo chéo mesh fabric tiện lợi', 250000, 0, 4, 40, 'mesh-fabric-cross-bag-mf301'),
('BAMA Keychain', 'Móc khóa BAMA cao cấp', 50000, 35000, 5, 100, 'bama-keychain');

-- Insert product images
INSERT INTO product_images (product_id, image_url, is_primary, alt_text) VALUES 
(1, 'assets/images/products/mf101-1.jpg', TRUE, 'Balo BAMA MF101 màu đen'),
(1, 'assets/images/products/mf101-2.jpg', FALSE, 'Balo BAMA MF101 chi tiết'),
(2, 'assets/images/products/nb102-1.jpg', TRUE, 'Balo BAMA NB102 màu xám'),
(3, 'assets/images/products/stardust-1.jpg', TRUE, 'Túi BAMA Stardust Mini'),
(4, 'assets/images/products/crossbag-1.jpg', TRUE, 'Túi đeo chéo MF301'),
(5, 'assets/images/products/keychain-1.jpg', TRUE, 'Móc khóa BAMA');

-- Create indexes for better performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_cart_user ON cart_items(user_id);
