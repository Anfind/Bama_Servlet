<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang không tìm thấy - BagStore</title>
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
            <!-- 404 Animation -->
            <div class="mb-8">
                <div class="relative inline-block">
                    <div class="text-9xl font-bold text-bama-orange opacity-20">404</div>
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="w-32 h-32 bg-bama-orange rounded-full flex items-center justify-center animate-bounce">
                            <i class="fas fa-search text-white text-4xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Error Message -->
            <h1 class="text-4xl font-bold text-bama-dark mb-4">Oops! Trang không tìm thấy</h1>
            <p class="text-gray-600 text-lg mb-8">
                Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thời không khả dụng.
            </p>

            <!-- Search Box -->
            <div class="mb-8">
                <div class="relative max-w-md mx-auto">
                    <input type="text" 
                           placeholder="Tìm kiếm sản phẩm..." 
                           class="w-full px-4 py-3 pl-12 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center">
                        <i class="fas fa-search text-gray-400"></i>
                    </div>
                    <button class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <i class="fas fa-arrow-right text-bama-orange hover:text-orange-600 transition"></i>
                    </button>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
                <a href="${pageContext.request.contextPath}/" 
                   class="bg-bama-orange text-white px-8 py-3 rounded-lg font-semibold hover:bg-orange-600 transition transform hover:scale-105">
                    <i class="fas fa-home mr-2"></i>Về trang chủ
                </a>
                
                <a href="${pageContext.request.contextPath}/products" 
                   class="border border-bama-orange text-bama-orange px-8 py-3 rounded-lg font-semibold hover:bg-bama-orange hover:text-white transition">
                    <i class="fas fa-shopping-bag mr-2"></i>Xem sản phẩm
                </a>
                
                <button onclick="history.back()" 
                        class="bg-gray-500 text-white px-8 py-3 rounded-lg font-semibold hover:bg-gray-600 transition">
                    <i class="fas fa-arrow-left mr-2"></i>Quay lại
                </button>
            </div>

            <!-- Helpful Links -->
            <div class="border-t border-gray-200 pt-8">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Có thể bạn đang tìm:</h3>
                <div class="grid grid-cols-2 sm:grid-cols-3 gap-4">
                    <a href="${pageContext.request.contextPath}/products?category=handbags" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-hand-holding mr-1"></i>Túi xách tay
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=backpacks" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-backpack mr-1"></i>Balo
                    </a>
                    <a href="${pageContext.request.contextPath}/products?category=wallets" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-wallet mr-1"></i>Ví
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=newest" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-star mr-1"></i>Mới nhất
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sort=bestseller" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-fire mr-1"></i>Bán chạy
                    </a>
                    <a href="${pageContext.request.contextPath}/products?sale=true" 
                       class="text-bama-orange hover:underline text-sm">
                        <i class="fas fa-percent mr-1"></i>Khuyến mãi
                    </a>
                </div>
            </div>

            <!-- Contact Info -->
            <div class="mt-8 p-6 bg-white rounded-lg shadow-md">
                <h3 class="text-lg font-semibold text-gray-800 mb-3">Cần hỗ trợ?</h3>
                <p class="text-gray-600 mb-4">Liên hệ với chúng tôi nếu bạn cần giúp đỡ</p>
                <div class="flex justify-center space-x-6">
                    <a href="tel:02812345678" class="flex items-center text-bama-orange hover:underline">
                        <i class="fas fa-phone mr-2"></i>(028) 1234 5678
                    </a>
                    <a href="mailto:support@bagstore.com" class="flex items-center text-bama-orange hover:underline">
                        <i class="fas fa-envelope mr-2"></i>support@bagstore.com
                    </a>
                </div>
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
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            // Floating animation for the search icon
            const searchIcon = document.querySelector('.animate-bounce');
            
            // Add search functionality
            const searchInput = document.querySelector('input[type="text"]');
            const searchButton = document.querySelector('.fa-arrow-right').parentElement;
            
            searchButton.addEventListener('click', function() {
                const query = searchInput.value.trim();
                if (query) {
                    window.location.href = '${pageContext.request.contextPath}/products?search=' + encodeURIComponent(query);
                }
            });
            
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const query = this.value.trim();
                    if (query) {
                        window.location.href = '${pageContext.request.contextPath}/products?search=' + encodeURIComponent(query);
                    }
                }
            });
            
            // Add some random floating elements
            createFloatingElements();
        });
        
        function createFloatingElements() {
            const colors = ['#ff6b35', '#ffd700', '#32cd32', '#ff69b4'];
            
            for (let i = 0; i < 10; i++) {
                setTimeout(() => {
                    const element = document.createElement('div');
                    element.style.position = 'fixed';
                    element.style.width = '6px';
                    element.style.height = '6px';
                    element.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    element.style.borderRadius = '50%';
                    element.style.pointerEvents = 'none';
                    element.style.zIndex = '1';
                    element.style.left = Math.random() * 100 + 'vw';
                    element.style.top = '100vh';
                    element.style.opacity = '0.7';
                    
                    document.body.appendChild(element);
                    
                    const animation = element.animate([
                        { transform: 'translateY(0px)', opacity: 0.7 },
                        { transform: 'translateY(-100vh)', opacity: 0 }
                    ], {
                        duration: 8000 + Math.random() * 4000,
                        easing: 'linear'
                    });
                    
                    animation.onfinish = () => {
                        element.remove();
                    };
                }, i * 800);
            }
        }
        
        // Restart floating elements every 10 seconds
        setInterval(createFloatingElements, 10000);
    </script>
</body>
</html>
