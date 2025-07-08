# BagStore - Ant Build System

## Giới thiệu
Dự án BagStore đã được chuyển đổi từ Maven sang Ant build system để đơn giản hóa quá trình build và deploy.

## Yêu cầu hệ thống
- Java 11 hoặc cao hơn
- Apache Ant 1.10.x
- Apache Tomcat 10.1.x (để deploy)

## Cấu trúc thư mục
```
BagStore/
├── build.xml              # Ant build script
├── build.properties       # Build configuration
├── download-deps.bat      # Script download dependencies
├── lib/                   # JAR dependencies
├── src/main/java/         # Java source code
├── src/main/webapp/       # Web content
├── src/main/resources/    # Resources
├── build/                 # Build output (generated)
└── dist/                  # Distribution files (generated)
```

## Cài đặt và sử dụng

### 1. Download dependencies
```bash
# Windows
download-deps.bat

# Hoặc download thủ công các JAR sau vào thư mục lib/:
- servlet-api-6.0.0.jar
- jsp-api-3.1.0.jar
- jstl-3.0.0.jar
- mysql-connector-java-8.0.33.jar
- jackson-core-2.15.2.jar
- jackson-databind-2.15.2.jar
- jackson-annotations-2.15.2.jar
```

### 2. Build commands

#### Clean build directories
```bash
ant clean
```

#### Compile Java sources
```bash
ant compile
```

#### Create WAR file
```bash
ant war
```

#### Deploy to Tomcat
```bash
ant deploy
```

#### Undeploy from Tomcat
```bash
ant undeploy
```

#### Redeploy
```bash
ant redeploy
```

#### Build all (clean + compile + war)
```bash
ant all
```

#### Show help
```bash
ant help
```

## Cấu hình

### Tomcat Path
Cập nhật đường dẫn Tomcat trong `build.properties`:
```properties
tomcat.home=C:/Program Files/Apache Software Foundation/Tomcat 10.1
```

### Database Configuration
Cập nhật cấu hình database trong `src/main/resources/application.properties`:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/bagstore_db
db.username=root
db.password=
```

## Workflow thông thường

1. **Lần đầu setup:**
   ```bash
   download-deps.bat
   ant all
   ```

2. **Development:**
   ```bash
   # Sau khi thay đổi code
   ant war
   ant deploy
   ```

3. **Production build:**
   ```bash
   ant clean
   ant all
   ```

## Troubleshooting

### Lỗi compilation
- Kiểm tra Java version (phải >= 11)
- Kiểm tra các JAR dependencies trong thư mục `lib/`
- Kiểm tra đường dẫn trong `build.xml`

### Lỗi deployment
- Kiểm tra Tomcat đang chạy
- Kiểm tra đường dẫn Tomcat trong `build.properties`
- Kiểm tra quyền ghi vào thư mục `webapps`

### Lỗi runtime
- Kiểm tra database connection
- Kiểm tra file `web.xml`
- Xem log trong `{tomcat}/logs/catalina.out`

## So sánh với Maven

### Ưu điểm của Ant:
- Đơn giản, dễ hiểu
- Linh hoạt trong cấu hình
- Không cần internet để build (sau khi download deps)
- Control hoàn toàn quá trình build

### Nhược điểm:
- Phải quản lý dependencies thủ công
- Nhiều cấu hình hơn Maven
- Không có dependency resolution tự động

## Migrate từ Maven

1. **Giữ nguyên cấu trúc thư mục Maven**
2. **Tạo `build.xml` và `build.properties`**
3. **Download dependencies vào `lib/`**
4. **Test build:**
   ```bash
   ant clean
   ant war
   ```
5. **Maven đã được loại bỏ hoàn toàn**

## IDE Integration

### VS Code
- Cài đặt extension "Ant Target Runner"
- Mở Command Palette: `Ant: Run Target`

### IntelliJ IDEA
- Import project as "Ant project"
- Add `build.xml` to Ant build files
- Run targets từ Ant tool window

### Eclipse
- Import project as "Existing Project"
- Add `build.xml` to Ant view
- Run targets từ Ant view
