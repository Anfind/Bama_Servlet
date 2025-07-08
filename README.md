# BagStore E-commerce Application

BagStore là một ứng dụng web thương mại điện tử hoàn chỉnh để bán túi xách và phụ kiện. Ứng dụng được xây dựng bằng Java Servlets, JSP và cơ sở dữ liệu MySQL.

## ✨ Tính Năng

- 🔐 Xác thực người dùng (đăng nhập/đăng ký)
- 📦 Danh mục sản phẩm với phân loại
- 🛒 Chức năng giỏ hàng
- 📋 Quản lý đơn hàng
- 👨‍💼 Trang quản trị cho quản lý sản phẩm
- 📁 Upload file cho hình ảnh sản phẩm
- 📱 Thiết kế web responsive

## 🛠️ Công Nghệ Sử Dụng

- **Backend**: Java Servlets, JSP
- **Database**: MySQL 8.0+
- **Frontend**: HTML, CSS, JavaScript, Bootstrap
- **Build Tool**: Apache Ant
- **Server**: Apache Tomcat 10.1
- **Libraries**: 
  - Jackson 2.15.2 (JSON processing)
  - BCrypt 0.4 (password hashing)
  - JSTL 3.0.0 (JSP Standard Tag Library)
  - MySQL Connector/J 8.0.33

## 🚀 Hướng Dẫn Cài Đặt Nhanh

### 1. Kiểm Tra Môi Trường
```bash
# Chạy script kiểm tra môi trường
check-env.bat
```

### 2. Tải Dependencies
```bash
# Tự động tải tất cả JAR files cần thiết
download-deps.bat
```

### 3. Cấu Hình Database
- Tạo database: `bagstore_db`
- Import schema: `database/bagstore_db.sql`
- Cập nhật thông tin kết nối trong `src/main/webapp/META-INF/context.xml`

### 4. Build và Deploy
```bash
# Build nhanh
build.bat

# Hoặc sử dụng Ant
ant all
```

### 5. Chạy Application
- Khởi động Tomcat
- Truy cập: http://localhost:8080/BagStore/

## 📁 Cấu Trúc Project

```
BagStore/
├── 🔧 build.xml              # Ant build script
├── ⚙️ build.properties       # Cấu hình build
├── 📥 download-deps.bat      # Script tải dependencies
├── 🚀 build.bat             # Script build nhanh
├── 🔍 check-env.bat         # Kiểm tra môi trường
├── 📖 HUONG-DAN-CHAY.md     # Hướng dẫn chi tiết
├── src/main/
│   ├── java/com/bagstore/
│   │   ├── controller/      # Servlet controllers
│   │   ├── dao/            # Data Access Objects
│   │   ├── model/          # Entity classes
│   │   └── util/           # Utility classes
│   ├── resources/          # Configuration files
│   └── webapp/
│       ├── css/            # Stylesheets
│       ├── js/             # JavaScript files
│       ├── images/         # Static images
│       ├── views/          # JSP pages
│       ├── META-INF/       # Context configuration
│       └── WEB-INF/        # Web configuration
├── lib/                    # JAR dependencies
├── build/                  # Build output
├── database/              # SQL schema
```

## 📋 Yêu Cầu Hệ Thống

- ☕ **Java JDK 11+** (khuyến nghị JDK 17)
- 🐜 **Apache Ant 1.10+**
- 🐱 **Apache Tomcat 10.1**
- 🐬 **MySQL Server 8.0+**

## 🔧 Build Commands

```bash
# Kiểm tra môi trường
check-env.bat

# Tải dependencies
download-deps.bat

# Build nhanh (all-in-one)
build.bat

# Hoặc từng bước với Ant
ant clean          # Dọn dẹp
ant compile        # Compile source
ant war           # Tạo WAR file
ant deploy        # Deploy to Tomcat
ant all           # Clean + Compile + WAR
```

## 🌐 Endpoints Chính

- `🏠 /` - Trang chủ
- `📦 /products` - Danh sách sản phẩm
- `🔐 /auth/login` - Đăng nhập
- `📝 /auth/register` - Đăng ký
- `🛒 /cart` - Giỏ hàng
- `👨‍💼 /admin/dashboard` - Trang quản trị
- `📁 /upload` - Upload file

## 👨‍💼 Tài Khoản Admin Mặc Định

- **Email**: admin@bagstore.com
- **Password**: admin123

## 📚 Tài Liệu Chi Tiết

Xem file `HUONG-DAN-CHAY.md` để có hướng dẫn chi tiết về:
- Cài đặt môi trường
- Cấu hình database
- Troubleshooting
- Build và deployment

## 🆘 Hỗ Trợ

Nếu gặp vấn đề:
1. Chạy `check-env.bat` để kiểm tra môi trường
2. Xem Tomcat logs: `%CATALINA_HOME%\logs\`
3. Kiểm tra `HUONG-DAN-CHAY.md` cho troubleshooting

## 📄 License

Dự án này được cấp phép theo MIT License.

---
**Made with ❤️ for learning purposes**
