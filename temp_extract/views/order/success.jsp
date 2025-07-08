<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - BagStore</title>
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
<body class="bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-md sticky top-0 z-50">
        <div class="container mx-auto px-4">
            <div class="flex items-center justify-between h-16">
                <a href="${pageContext.request.contextPath}/" class="text-2xl font-bold text-bama-orange">
                    <i class="fas fa-shopping-bag mr-2"></i>BagStore
                </a>
                
                <nav class="hidden md:flex space-x-8">
                    <a href="${pageContext.request.contextPath}/" class="text-gray-700 hover:text-bama-orange transition">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/products" class="text-gray-700 hover:text-bama-orange transition">Sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/cart" class="text-gray-700 hover:text-bama-orange transition">
                        Giỏ hàng <span id="cart-count" class="bg-bama-orange text-white text-xs rounded-full px-2 py-1 ml-1">0</span>
                    </a>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-16">
        <div class="max-w-2xl mx-auto text-center">
            <!-- Success Icon -->
            <div class="mb-8">
                <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-check text-4xl text-green-500"></i>
                </div>
                <h1 class="text-3xl font-bold text-bama-dark mb-2">Đặt hàng thành công!</h1>
                <p class="text-gray-600">Cảm ơn bạn đã mua sắm tại BagStore</p>
            </div>

            <!-- Order Information -->
            <div class="bg-white rounded-lg shadow-md p-6 mb-8">
                <h2 class="text-xl font-semibold mb-4 text-bama-dark">Thông tin đơn hàng</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-left">
                    <div>
                        <p class="text-sm text-gray-600">Mã đơn hàng:</p>
                        <p class="font-semibold text-bama-orange">#${order.orderCode}</p>
                    </div>
                    
                    <div>
                        <p class="text-sm text-gray-600">Ngày đặt hàng:</p>
                        <p class="font-semibold">
                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </p>
                    </div>
                    
                    <div>
                        <p class="text-sm text-gray-600">Tổng tiền:</p>
                        <p class="font-semibold text-bama-orange text-lg">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                        </p>
                    </div>
                    
                    <div>
                        <p class="text-sm text-gray-600">Phương thức thanh toán:</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'COD'}">Thanh toán khi nhận hàng</c:when>
                                <c:when test="${order.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                <c:when test="${order.paymentMethod == 'MOMO'}">Ví điện tử MoMo</c:when>
                                <c:otherwise>${order.paymentMethod}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <div class="md:col-span-2">
                        <p class="text-sm text-gray-600">Địa chỉ giao hàng:</p>
                        <p class="font-semibold">${order.shippingAddress}</p>
                    </div>
                </div>
            </div>

            <!-- Next Steps -->
            <div class="bg-blue-50 border border-blue-200 rounded-lg p-6 mb-8">
                <h3 class="text-lg font-semibold text-blue-800 mb-3">
                    <i class="fas fa-info-circle mr-2"></i>Bước tiếp theo
                </h3>
                <div class="text-left space-y-2 text-blue-700">
                    <p><i class="fas fa-envelope mr-2"></i>Chúng tôi đã gửi email xác nhận đến địa chỉ của bạn</p>
                    <p><i class="fas fa-phone mr-2"></i>Nhân viên sẽ liên hệ để xác nhận đơn hàng trong 24h</p>
                    <p><i class="fas fa-truck mr-2"></i>Đơn hàng sẽ được giao trong 2-5 ngày làm việc</p>
                    <p><i class="fas fa-bell mr-2"></i>Bạn sẽ nhận được thông báo khi đơn hàng được giao</p>
                </div>
            </div>

            <!-- Payment Instructions (if needed) -->
            <c:if test="${order.paymentMethod == 'BANK_TRANSFER'}">
                <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-8">
                    <h3 class="text-lg font-semibold text-yellow-800 mb-3">
                        <i class="fas fa-university mr-2"></i>Thông tin chuyển khoản
                    </h3>
                    <div class="text-left space-y-2 text-yellow-700">
                        <p><strong>Ngân hàng:</strong> Vietcombank</p>
                        <p><strong>Số tài khoản:</strong> 1234567890</p>
                        <p><strong>Chủ tài khoản:</strong> CONG TY BAGSTORE</p>
                        <p><strong>Số tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/></p>
                        <p><strong>Nội dung:</strong> ${order.orderCode}</p>
                        <p class="text-sm text-yellow-600 mt-3">
                            <i class="fas fa-exclamation-triangle mr-1"></i>
                            Vui lòng chuyển khoản trong 24h để đơn hàng được xử lý
                        </p>
                    </div>
                </div>
            </c:if>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="${pageContext.request.contextPath}/order?action=track&orderId=${order.id}" 
                   class="bg-bama-orange text-white px-6 py-3 rounded-lg font-semibold hover:bg-orange-600 transition">
                    <i class="fas fa-search mr-2"></i>Theo dõi đơn hàng
                </a>
                
                <a href="${pageContext.request.contextPath}/products" 
                   class="bg-gray-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-gray-600 transition">
                    <i class="fas fa-shopping-bag mr-2"></i>Tiếp tục mua sắm
                </a>
                
                <a href="${pageContext.request.contextPath}/" 
                   class="border border-bama-orange text-bama-orange px-6 py-3 rounded-lg font-semibold hover:bg-bama-orange hover:text-white transition">
                    <i class="fas fa-home mr-2"></i>Về trang chủ
                </a>
            </div>

            <!-- Contact Support -->
            <div class="mt-12 text-center">
                <p class="text-gray-600 mb-4">Cần hỗ trợ? Liên hệ với chúng tôi</p>
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
    </div>

    <!-- Footer -->
    <footer class="bg-bama-dark text-white py-12 mt-16">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div>
                    <h3 class="text-xl font-bold mb-4">BagStore</h3>
                    <p class="text-gray-300">Chuyên cung cấp túi xách, balo chất lượng cao với thiết kế đẹp và giá cả hợp lý.</p>
                </div>
                
                <div>
                    <h4 class="text-lg font-semibold mb-4">Liên kết nhanh</h4>
                    <ul class="space-y-2">
                        <li><a href="${pageContext.request.contextPath}/" class="text-gray-300 hover:text-white transition">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/products" class="text-gray-300 hover:text-white transition">Sản phẩm</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Về chúng tôi</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Liên hệ</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="text-lg font-semibold mb-4">Hỗ trợ</h4>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Chính sách đổi trả</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Chính sách bảo mật</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">Hướng dẫn mua hàng</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-white transition">FAQ</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="text-lg font-semibold mb-4">Liên hệ</h4>
                    <div class="space-y-2 text-gray-300">
                        <p><i class="fas fa-map-marker-alt mr-2"></i>123 Đường ABC, Quận XYZ, TP.HCM</p>
                        <p><i class="fas fa-phone mr-2"></i>(028) 1234 5678</p>
                        <p><i class="fas fa-envelope mr-2"></i>info@bagstore.com</p>
                    </div>
                </div>
            </div>
            
            <div class="border-t border-gray-600 mt-8 pt-8 text-center text-gray-300">
                <p>&copy; 2024 BagStore. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Confetti animation for success page
        function createConfetti() {
            const colors = ['#ff6b35', '#ffd700', '#32cd32', '#ff69b4', '#00bfff'];
            const confettiCount = 50;
            
            for (let i = 0; i < confettiCount; i++) {
                setTimeout(() => {
                    const confetti = document.createElement('div');
                    confetti.style.position = 'fixed';
                    confetti.style.top = '-10px';
                    confetti.style.left = Math.random() * 100 + 'vw';
                    confetti.style.width = '10px';
                    confetti.style.height = '10px';
                    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                    confetti.style.pointerEvents = 'none';
                    confetti.style.zIndex = '9999';
                    confetti.style.borderRadius = '50%';
                    
                    document.body.appendChild(confetti);
                    
                    const animation = confetti.animate([
                        { transform: 'translateY(0px) rotate(0deg)', opacity: 1 },
                        { transform: 'translateY(100vh) rotate(360deg)', opacity: 0 }
                    ], {
                        duration: 3000 + Math.random() * 2000,
                        easing: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)'
                    });
                    
                    animation.onfinish = () => {
                        confetti.remove();
                    };
                }, i * 100);
            }
        }
        
        // Start confetti animation on page load
        window.addEventListener('load', createConfetti);
    </script>
</body>
</html>
