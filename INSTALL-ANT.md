# Hướng dẫn cài đặt Apache Ant

## Cách 1: Cài đặt bằng Chocolatey (Khuyến nghị)
```bash
# Cài đặt Chocolatey (nếu chưa có)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Cài đặt Ant
choco install ant
```

## Cách 2: Cài đặt thủ công

### 1. Download Apache Ant
- Truy cập: https://ant.apache.org/bindownload.cgi
- Download file: apache-ant-1.10.14-bin.zip

### 2. Giải nén
- Giải nén vào thư mục: `C:\Program Files\Apache Ant\`
- Hoặc: `C:\tools\apache-ant-1.10.14\`

### 3. Cấu hình Environment Variables
**Windows:**
1. Mở System Properties → Advanced → Environment Variables
2. Thêm biến mới:
   - Variable name: `ANT_HOME`
   - Variable value: `C:\Program Files\Apache Ant\apache-ant-1.10.14`
3. Thêm vào PATH:
   - Edit biến `PATH`
   - Thêm: `%ANT_HOME%\bin`

### 4. Kiểm tra cài đặt
```bash
ant -version
```

## Cách 3: Sử dụng SDKMAN (Linux/Mac)
```bash
# Cài đặt SDKMAN
curl -s "https://get.sdkman.io" | bash

# Cài đặt Ant
sdk install ant
```

## Cách 4: Portable (không cần cài đặt)
1. Download và giải nén Ant
2. Tạo file `ant.bat` trong thư mục project:
```batch
@echo off
set ANT_HOME=C:\path\to\apache-ant-1.10.14
set PATH=%ANT_HOME%\bin;%PATH%
ant %*
```

## Yêu cầu hệ thống
- Java 8 hoặc cao hơn
- Windows 10/11, Linux, hoặc macOS

## Kiểm tra sau khi cài đặt
```bash
# Kiểm tra version
ant -version

# Liệt kê targets có sẵn
ant -p

# Chạy target mặc định
ant

# Chạy target cụ thể
ant clean
ant compile
ant war
```

## Troubleshooting

### "ant is not recognized"
- Kiểm tra ANT_HOME và PATH
- Restart terminal/command prompt
- Kiểm tra Java đã cài đặt chưa

### "JAVA_HOME is not set"
- Cài đặt Java JDK
- Set JAVA_HOME environment variable

### Permission denied
- Chạy với quyền Administrator
- Kiểm tra quyền truy cập thư mục

---

**Sau khi cài đặt Ant thành công, chạy:**
```bash
cd C:\An\Bama_Servlet
download-deps.bat
ant all
```
