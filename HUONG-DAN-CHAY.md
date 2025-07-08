# Hướng Dẫn Chạy BagStore Application

## Yêu Cầu Hệ Thống

### 1. Cài Đặt Java Development Kit (JDK)
- **JDK 11 hoặc cao hơn** (khuyến nghị JDK 17)
- Thiết lập biến môi trường `JAVA_HOME`
- Thêm `%JAVA_HOME%\bin` vào PATH

### 2. Cài Đặt Apache Ant
- Download từ: https://ant.apache.org/bindownload.cgi
- Giải nén và thiết lập biến môi trường `ANT_HOME`
- Thêm `%ANT_HOME%\bin` vào PATH
- Kiểm tra: `ant -version`

### 3. Cài Đặt Apache Tomcat 10.1
- Download từ: https://tomcat.apache.org/download-10.cgi
- Giải nén vào thư mục `C:\Program Files\Apache Software Foundation\Tomcat 10.1\`
- Hoặc thay đổi đường dẫn trong `build.properties`

### 4. Cài Đặt MySQL Database
- Cài MySQL Server
- Tạo database: `bagstore_db`
- Import schema từ file: `database/bagstore_db.sql`
- Cấu hình username/password trong `src/main/webapp/META-INF/context.xml`

## Hướng Dẫn Chạy

### Bước 1: Download Dependencies
```bash
# Chạy script tự động tải JAR files
download-deps.bat
```

### Bước 2: Cấu Hình Database
1. Mở file `src/main/webapp/META-INF/context.xml`
2. Thay đổi thông tin database:
```xml
<Resource name="jdbc/BagStoreDB"
          username="your_username"
          password="your_password"
          url="jdbc:mysql://localhost:3306/bagstore_db?useSSL=false&amp;serverTimezone=UTC"/>
```

### Bước 3: Cấu Hình Tomcat Path (nếu cần)
1. Mở file `build.properties`
2. Thay đổi đường dẫn Tomcat:
```properties
tomcat.home=C:/Your/Tomcat/Path
```

### Bước 4: Build và Deploy
```bash
# Cách 1: Sử dụng script đơn giản
build.bat

# Cách 2: Sử dụng Ant command
ant clean compile war deploy

# Hoặc build tất cả
ant all
```

### Bước 5: Khởi Động Tomcat
```bash
# Windows
C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin\startup.bat

# Hoặc
%CATALINA_HOME%\bin\startup.bat
```

### Bước 6: Truy Cập Application
- **Home Page**: http://localhost:8080/BagStore/
- **Products**: http://localhost:8080/BagStore/products
- **Login**: http://localhost:8080/BagStore/auth/login
- **Admin**: http://localhost:8080/BagStore/admin/dashboard

## Troubleshooting

### Lỗi Compilation
```bash
# Kiểm tra JAVA_HOME
echo %JAVA_HOME%

# Kiểm tra Ant
ant -version

# Clean và build lại
ant clean
ant compile
```

### Lỗi Database Connection
1. Kiểm tra MySQL service đã chạy
2. Kiểm tra thông tin kết nối trong `context.xml`
3. Đảm bảo database `bagstore_db` đã được tạo
4. Import schema từ `database/bagstore_db.sql`

### Lỗi Deploy
1. Kiểm tra Tomcat đã chạy
2. Kiểm tra đường dẫn trong `build.properties`
3. Đảm bảo có quyền ghi vào thư mục Tomcat webapps

### Lỗi HTTP 404
1. Đảm bảo file WAR đã được deploy
2. Kiểm tra Tomcat logs: `%CATALINA_HOME%\logs\catalina.out`
3. Restart Tomcat

### Lỗi HTTP 500
1. Kiểm tra Tomcat logs để xem chi tiết lỗi
2. Kiểm tra database connection
3. Đảm bảo tất cả JAR dependencies đã có trong `WEB-INF/lib`

## Cấu Trúc Project

```
BagStore/
├── build.xml              # Ant build script
├── build.properties       # Build configuration  
├── download-deps.bat      # Auto download dependencies
├── build.bat             # Quick build script
├── src/main/
│   ├── java/             # Java source code
│   ├── webapp/           # Web resources (JSP, CSS, JS)
│   └── resources/        # Configuration files
├── lib/                  # JAR dependencies
├── build/                # Build output
└── database/            # SQL schema
```

## Build Targets Available

- `ant clean` - Xóa build artifacts
- `ant compile` - Compile Java source
- `ant war` - Tạo WAR file
- `ant deploy` - Deploy to Tomcat
- `ant all` - Clean + Compile + WAR
- `ant undeploy` - Remove from Tomcat

## Support

Nếu gặp vấn đề, hãy kiểm tra:
1. Tomcat logs: `%CATALINA_HOME%\logs\`
2. Build output từ Ant command
3. Database connection status
4. JAR dependencies trong `lib/` folder

**Happy Coding! 🚀**
