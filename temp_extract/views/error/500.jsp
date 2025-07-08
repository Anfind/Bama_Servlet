<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi hệ thống - BagStore</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'bama-orange': '#ff6b35',
                        'bama-dark': '#2c3e50'
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white shadow-md">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between h-16">
                <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-bama-orange">
                    <i class="fas fa-shopping-bag mr-2"></i>BagStore
                </a>
                
                <nav class="hidden md:flex space-x-8">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-bama-orange transition">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/products" class="text-gray-700 hover:text-bama-orange transition">Sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/cart" class="text-gray-700 hover:text-bama-orange transition">Giỏ hàng</a>
                </nav>
                
                <div class="md:hidden">
                    <button class="text-gray-700 hover:text-bama-orange">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center px-4 py-16">
        <div class="text-center max-w-lg mx-auto">
            <!-- 500 Animation -->
            <div class="mb-8">
                <div class="relative inline-block">
                    <div class="text-9xl font-bold text-red-500 opacity-20">500</div>
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="w-32 h-32 bg-red-500 rounded-full flex items-center justify-center animate-pulse">
                            <i class="fas fa-exclamation-triangle text-white text-4xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error Message -->
            <h1 class="text-4xl font-bold text-bama-dark mb-4">Oops! Có lỗi xảy ra</h1>
            <p class="text-gray-600 text-lg mb-8">
                Máy chủ gặp sự cố không mong muốn và không thể hoàn thành yêu cầu của bạn. Chúng tôi đang nỗ lực khắc phục.
            </p>

            <!-- Error Details (for development) -->
            <c:if test="${not empty error}">
                <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-8 text-left">
                    <h3 class="text-red-800 font-semibold mb-2">Chi tiết lỗi:</h3>
                    <p class="text-red-700 text-sm font-mono break-all">${error}</p>
                </div>
            </c:if>

            <!-- What to do -->
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-6 mb-8">
                <h3 class="text-blue-800 font-semibold mb-3">
                    <i class="fas fa-lightbulb mr-2"></i>Bạn có thể thử:
                </h3>
                <ul class="text-blue-700 text-sm text-left space-y-2">
                    <li><i class="fas fa-redo mr-2"></i>Tải lại trang sau vài giây</li>
                    <li><i class="fas fa-arrow-left mr-2"></i>Quay lại trang trước đó</li>
                    <li><i class="fas fa-home mr-2"></i>Về trang chủ và thử lại</li>
                    <li><i class="fas fa-phone mr-2"></i>Liên hệ hỗ trợ nếu vấn đề vẫn tiếp tục</li>
                </ul>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
                <button onclick="location.reload()" 
                        class="bg-bama-orange text-white px-8 py-3 rounded-lg font-semibold hover:bg-orange-600 transition transform hover:scale-105">
                    <i class="fas fa-redo mr-2"></i>Tải lại trang
                </button>
                
                <a href="${pageContext.request.contextPath}/" 
                   class="border border-bama-orange text-bama-orange px-8 py-3 rounded-lg font-semibold hover:bg-bama-orange hover:text-white transition">
                    <i class="fas fa-home mr-2"></i>Về trang chủ
                </a>
                
                <button onclick="history.back()" 
                        class="bg-gray-500 text-white px-8 py-3 rounded-lg font-semibold hover:bg-gray-600 transition">
                    <i class="fas fa-arrow-left mr-2"></i>Quay lại
                </button>
            </div>

            <!-- Error ID (for support) -->
            <div class="text-sm text-gray-500 mb-8">
                <p>Mã lỗi: <span class="font-mono bg-gray-100 px-2 py-1 rounded">${errorId != null ? errorId : 'ERR-' += Math.floor(Math.random() * 100000)}</span></p>
                <p>Thời gian: <span id="errorTime"></span></p>
            </div>

            <!-- Support Contact -->
            <div class="border-t border-gray-200 pt-8">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Cần hỗ trợ ngay?</h3>
                <div class="bg-white rounded-lg shadow-md p-6">
                    <p class="text-gray-600 mb-4">Đội ngũ hỗ trợ của chúng tôi sẵn sàng giúp bạn</p>
                    <div class="flex justify-center space-x-6">
                        <a href="tel:02812345678" class="flex items-center text-bama-orange hover:underline">
                            <i class="fas fa-phone mr-2"></i>(028) 1234 5678
                        </a>
                        <a href="mailto:support@bagstore.com" class="flex items-center text-bama-orange hover:underline">
                            <i class="fas fa-envelope mr-2"></i>support@bagstore.com
                        </a>
                        <a href="#" class="flex items-center text-bama-orange hover:underline">
                            <i class="fab fa-facebook-messenger mr-2"></i>Chat trực tuyến
                        </a>
                    </div>
                </div>
            </div>

            <!-- Status Updates -->
            <div class="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                <h4 class="text-yellow-800 font-semibold mb-2">
                    <i class="fas fa-info-circle mr-2"></i>Cập nhật trạng thái hệ thống
                </h4>
                <p class="text-yellow-700 text-sm">
                    Hệ thống đang hoạt động bình thường. Nếu bạn gặp lỗi này, có thể do tải cao hoặc bảo trì định kỳ.
                </p>
                <a href="#" class="text-yellow-800 hover:underline text-sm font-medium">
                    Xem trang trạng thái hệ thống →
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-bama-dark text-white py-8">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <h3 class="text-lg font-bold mb-4">BagStore</h3>
                    <p class="text-gray-300 text-sm">Chuyên cung cấp túi xách, balo chất lượng cao với thiết kế đẹp và giá cả hợp lý.</p>
                </div>
                
                <div>
                    <h4 class="text-md font-semibold mb-4">Liên kết nhanh</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="${pageContext.request.contextPath}/" class="text-gray-300 hover:text-white transition">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/products" class="text-gray-300 hover:text-white transition">Sản phẩm</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Về chúng tôi</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Liên hệ</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="text-md font-semibold mb-4">Hỗ trợ</h4>
                    <ul class="space-y-2 text-sm">
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Chính sách đổi trả</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Chính sách bảo mật</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Hướng dẫn mua hàng</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">FAQ</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="border-t border-gray-600 mt-6 pt-6 text-center text-gray-300 text-sm">
                <p>&copy; 2024 BagStore. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Set error time
        document.getElementById('errorTime').textContent = new Date().toLocaleString('vi-VN');
        
        // Auto-reload after 10 seconds
        let countdown = 10;
        const countdownInterval = setInterval(() => {
            countdown--;
            if (countdown <= 0) {
                clearInterval(countdownInterval);
                location.reload();
            }
        }, 1000);
        
        // Add some error animation effects
        document.addEventListener('DOMContentLoaded', function() {
            // Glitch effect for the error number
            const errorNumber = document.querySelector('.text-9xl');
            setInterval(() => {
                errorNumber.style.transform = 'skew(' + (Math.random() * 2 - 1) + 'deg)';
                setTimeout(() => {
                    errorNumber.style.transform = 'skew(0deg)';
                }, 100);
            }, 3000);
            
            // Random error particles
            createErrorParticles();
        });
        
        function createErrorParticles() {
            const colors = ['#ef4444', '#f97316', '#eab308'];
            
            for (let i = 0; i < 15; i++) {
                setTimeout(() => {
                    const particle = document.createElement('div');
                    particle.style.position = 'fixed';
                    particle.style.width = '4px';
                    particle.style.height = '4px';
                    particle.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    particle.style.borderRadius = '50%';
                    particle.style.pointerEvents = 'none';
                    particle.style.zIndex = '1';
                    particle.style.left = Math.random() * 100 + 'vw';
                    particle.style.top = '-10px';
                    particle.style.opacity = '0.8';
                    
                    document.body.appendChild(particle);
                    
                    const animation = particle.animate([
                        { 
                            transform: 'translateY(0px) rotate(0deg)', 
                            opacity: 0.8 
                        },
                        { 
                            transform: 'translateY(100vh) rotate(360deg)', 
                            opacity: 0 
                        }
                    ], {
                        duration: 3000 + Math.random() * 2000,
                        easing: 'linear'
                    });
                    
                    animation.onfinish = () => {
                        particle.remove();
                    };
                }, i * 200);
            }
        }
        
        // Restart error particles every 5 seconds
        setInterval(createErrorParticles, 5000);
        
        // Report error to analytics (if available)
        if (typeof gtag !== 'undefined') {
            gtag('event', 'exception', {
                'description': 'Server Error 500',
                'fatal': false
            });
        }
    </script>
</body>
</html>
