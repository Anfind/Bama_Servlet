# Hướng Dẫn Setup Database BagStore

## 📄 File Database Duy Nhất

Toàn bộ database setup đã được gộp vào **1 file duy nhất**:
```
database/bagstore_db.sql
```

## 🗃️ Nội dung file bao gồm:

1. **Tạo database và bảng** - Schema hoàn chỉnh
2. **Dữ liệu mẫu** - 15 sản phẩm với 5 categories
3. **Tài khoản người dùng** - Admin và user accounts
4. **Ảnh sản phẩm** - Tất cả dùng ảnh balo.png
5. **Kiểm tra kết quả** - Validation queries

## 🚀 Cách chạy:

### Bước 1: Mở MySQL
```bash
mysql -u root -p
```

### Bước 2: Chạy script
```sql
SOURCE C:/An/Bama_Servlet/database/bagstore_db.sql;
```

**Hoặc import bằng MySQL Workbench:**
- File → Open SQL Script
- Chọn `database/bagstore_db.sql`
- Execute All

## 🔐 Tài khoản đăng nhập:

### Admin Account:
- **Username**: `admin`
- **Email**: `admin@bagstore.com`
- **Password**: `admin123`

### User Accounts:
- **Username**: `user1` | **Email**: `user1@bagstore.com` | **Password**: `admin123`
- **Username**: `user2` | **Email**: `user2@bagstore.com` | **Password**: `admin123`

## 🖼️ Hình ảnh sản phẩm:

- Tất cả 15 sản phẩm đều sử dụng **ảnh balo.png**
- File ảnh đã được copy vào: `src/main/webapp/images/products/balo.png`
- Để thay đổi ảnh sau này, chỉ cần thay thế file `balo.png`

## 📊 Dữ liệu mẫu:

- **5 Categories**: Balo công sở, Balo học sinh, Túi xách nữ, Túi đeo chéo, Phụ kiện
- **15 Products**: Đa dạng các loại sản phẩm với giá từ 50k đến 1.5M
- **15 Product Images**: Tất cả đều link đến `/BagStore/images/products/balo.png`
- **3 Users**: 1 admin + 2 user thường

## ✅ Kiểm tra kết quả:

Sau khi chạy script, bạn sẽ thấy output:
```
Categories Created: 5
Products Created: 15  
Product Images Created: 15
Users Created: 3
```

## 🌐 Test Website:

1. Start Tomcat
2. Access: `http://localhost:8080/BagStore/`
3. Login với tài khoản admin hoặc user
4. Tất cả sản phẩm sẽ hiển thị với ảnh balo của bạn

**Perfect setup với 1 file duy nhất! 🎉**
