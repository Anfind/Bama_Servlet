<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - BagStore</title>
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
                        Giỏ hàng <span id="cart-count" class="bg-bama-orange text-white text-xs rounded-full px-2 py-1 ml-1">${sessionScope.cartItemCount > 0 ? sessionScope.cartItemCount : 0}</span>
                    </a>
                </nav>
            </div>
        </div>
    </header>

    <!-- Breadcrumb -->
    <div class="bg-gray-100 py-4">
        <div class="container mx-auto px-4">
            <nav class="text-sm">
                <ol class="list-none p-0 inline-flex">
                    <li class="flex items-center">
                        <a href="${pageContext.request.contextPath}/" class="text-bama-orange hover:underline">Trang chủ</a>
                        <i class="fas fa-chevron-right mx-2 text-gray-400"></i>
                    </li>
                    <li class="flex items-center">
                        <a href="${pageContext.request.contextPath}/cart" class="text-bama-orange hover:underline">Giỏ hàng</a>
                        <i class="fas fa-chevron-right mx-2 text-gray-400"></i>
                    </li>
                    <li class="text-gray-500">Thanh toán</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Checkout Form -->
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold mb-6 text-bama-dark">Thông tin giao hàng</h2>
                
                <form id="checkoutForm" action="${pageContext.request.contextPath}/order" method="post">
                    <input type="hidden" name="action" value="place">
                    
                    <!-- Customer Information -->
                    <div class="mb-6">
                        <h3 class="text-lg font-semibold mb-4 text-gray-800">Thông tin khách hàng</h3>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="fullName" class="block text-sm font-medium text-gray-700 mb-2">Họ và tên *</label>
                                <input type="text" id="fullName" name="fullName" required
                                       value="${sessionScope.user != null ? sessionScope.user.fullName : ''}"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                            </div>
                            
                            <div>
                                <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại *</label>
                                <input type="tel" id="phone" name="phone" required
                                       value="${sessionScope.user != null ? sessionScope.user.phone : ''}"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email *</label>
                            <input type="email" id="email" name="email" required
                                   value="${sessionScope.user != null ? sessionScope.user.email : ''}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                        </div>
                    </div>

                    <!-- Shipping Address -->
                    <div class="mb-6">
                        <h3 class="text-lg font-semibold mb-4 text-gray-800">Địa chỉ giao hàng</h3>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                            <div>
                                <label for="province" class="block text-sm font-medium text-gray-700 mb-2">Tỉnh/Thành phố *</label>
                                <select id="province" name="province" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                                    <option value="">Chọn tỉnh/thành phố</option>
                                    <option value="Hà Nội">Hà Nội</option>
                                    <option value="TP. Hồ Chí Minh">TP. Hồ Chí Minh</option>
                                    <option value="Đà Nẵng">Đà Nẵng</option>
                                    <option value="Hải Phòng">Hải Phòng</option>
                                    <option value="Cần Thơ">Cần Thơ</option>
                                    <!-- Add more provinces as needed -->
                                </select>
                            </div>
                            
                            <div>
                                <label for="district" class="block text-sm font-medium text-gray-700 mb-2">Quận/Huyện *</label>
                                <select id="district" name="district" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                                    <option value="">Chọn quận/huyện</option>
                                </select>
                            </div>
                            
                            <div>
                                <label for="ward" class="block text-sm font-medium text-gray-700 mb-2">Phường/Xã *</label>
                                <select id="ward" name="ward" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                                    <option value="">Chọn phường/xã</option>
                                </select>
                            </div>
                        </div>
                        
                        <div>
                            <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ cụ thể *</label>
                            <input type="text" id="address" name="address" required
                                   placeholder="Số nhà, tên đường..."
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div class="mb-6">
                        <h3 class="text-lg font-semibold mb-4 text-gray-800">Phương thức thanh toán</h3>
                        
                        <div class="space-y-3">
                            <div class="flex items-center">
                                <input type="radio" id="cod" name="paymentMethod" value="COD" checked
                                       class="w-4 h-4 text-bama-orange bg-gray-100 border-gray-300 focus:ring-bama-orange">
                                <label for="cod" class="ml-2 text-sm font-medium text-gray-900">
                                    Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                            
                            <div class="flex items-center">
                                <input type="radio" id="bank" name="paymentMethod" value="BANK_TRANSFER"
                                       class="w-4 h-4 text-bama-orange bg-gray-100 border-gray-300 focus:ring-bama-orange">
                                <label for="bank" class="ml-2 text-sm font-medium text-gray-900">
                                    Chuyển khoản ngân hàng
                                </label>
                            </div>
                            
                            <div class="flex items-center">
                                <input type="radio" id="momo" name="paymentMethod" value="MOMO"
                                       class="w-4 h-4 text-bama-orange bg-gray-100 border-gray-300 focus:ring-bama-orange">
                                <label for="momo" class="ml-2 text-sm font-medium text-gray-900">
                                    Ví điện tử MoMo
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Order Notes -->
                    <div class="mb-6">
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">Ghi chú đơn hàng</label>
                        <textarea id="notes" name="notes" rows="3"
                                  placeholder="Ghi chú về đơn hàng, ví dụ: thời gian hay chỉ dẫn địa điểm giao hàng chi tiết hơn."
                                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent"></textarea>
                    </div>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="bg-white rounded-lg shadow-md p-6 h-fit">
                <h2 class="text-2xl font-bold mb-6 text-bama-dark">Đơn hàng của bạn</h2>
                
                <!-- Cart Items -->
                <div class="space-y-4 mb-6">
                    <c:choose>
                        <c:when test="${not empty sessionScope.cart}">
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <div class="flex items-center space-x-4 p-4 border border-gray-200 rounded-lg">
                                    <img src="${pageContext.request.contextPath}/images/products/${item.product.mainImage}" 
                                         alt="${item.product.name}" 
                                         class="w-16 h-16 object-cover rounded-lg">
                                    <div class="flex-1">
                                        <h4 class="font-semibold text-gray-800">${item.product.name}</h4>
                                        <p class="text-sm text-gray-600">Số lượng: ${item.quantity}</p>
                                        <p class="text-bama-orange font-bold">
                                            <fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8">
                                <i class="fas fa-shopping-cart text-4xl text-gray-300 mb-4"></i>
                                <p class="text-gray-500">Giỏ hàng trống</p>
                                <a href="${pageContext.request.contextPath}/products" 
                                   class="inline-block mt-4 bg-bama-orange text-white px-6 py-2 rounded-lg hover:bg-orange-600 transition">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Order Totals -->
                <c:if test="${not empty sessionScope.cart}">
                    <div class="border-t pt-4 space-y-2">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Tạm tính:</span>
                            <span class="font-semibold">
                                <fmt:formatNumber value="${sessionScope.cartTotal}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                        
                        <div class="flex justify-between">
                            <span class="text-gray-600">Phí vận chuyển:</span>
                            <span class="font-semibold">
                                <c:choose>
                                    <c:when test="${sessionScope.cartTotal >= 500000}">
                                        <span class="text-green-600">Miễn phí</span>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber value="30000" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="flex justify-between text-lg font-bold text-bama-dark border-t pt-2">
                            <span>Tổng cộng:</span>
                            <span class="text-bama-orange">
                                <c:set var="shippingFee" value="${sessionScope.cartTotal >= 500000 ? 0 : 30000}"/>
                                <fmt:formatNumber value="${sessionScope.cartTotal + shippingFee}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                    </div>

                    <!-- Place Order Button -->
                    <div class="mt-6">
                        <button type="submit" form="checkoutForm" 
                                class="w-full bg-bama-orange text-white py-3 px-6 rounded-lg font-bold text-lg hover:bg-orange-600 transition duration-300 transform hover:scale-105">
                            <i class="fas fa-credit-card mr-2"></i>Đặt hàng
                        </button>
                        
                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/cart" 
                               class="text-bama-orange hover:underline">
                                <i class="fas fa-arrow-left mr-1"></i>Quay lại giỏ hàng
                            </a>
                        </div>
                    </div>
                </c:if>
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

    <!-- Notification -->
    <div id="notification" class="fixed top-4 right-4 z-50 hidden">
        <div class="bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg">
            <div class="flex items-center">
                <i class="fas fa-check-circle mr-2"></i>
                <span id="notification-message"></span>
            </div>
        </div>
    </div>

    <script>
        // Form validation and submission
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate required fields
            const requiredFields = ['fullName', 'phone', 'email', 'province', 'district', 'ward', 'address'];
            let isValid = true;
            
            requiredFields.forEach(field => {
                const input = document.getElementById(field);
                if (!input.value.trim()) {
                    input.classList.add('border-red-500');
                    isValid = false;
                } else {
                    input.classList.remove('border-red-500');
                }
            });
            
            if (!isValid) {
                showNotification('Vui lòng điền đầy đủ thông tin bắt buộc!', 'error');
                return;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            // Submit form
            fetch(this.action, {
                method: 'POST',
                body: new FormData(this)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đặt hàng thành công!', 'success');
                    setTimeout(() => {
                        window.location.href = data.redirect || '${pageContext.request.contextPath}/order?action=success&orderId=' + data.orderId;
                    }, 1500);
                } else {
                    showNotification(data.message || 'Có lỗi xảy ra, vui lòng thử lại!', 'error');
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });
        
        // Address selection cascading
        document.getElementById('province').addEventListener('change', function() {
            const province = this.value;
            const districtSelect = document.getElementById('district');
            const wardSelect = document.getElementById('ward');
            
            // Clear district and ward options
            districtSelect.innerHTML = '<option value="">Chọn quận/huyện</option>';
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            
            if (province) {
                // Simulate loading districts (in real app, this would be an API call)
                setTimeout(() => {
                    const districts = getDistrictsForProvince(province);
                    districts.forEach(district => {
                        const option = document.createElement('option');
                        option.value = district;
                        option.textContent = district;
                        districtSelect.appendChild(option);
                    });
                }, 100);
            }
        });
        
        document.getElementById('district').addEventListener('change', function() {
            const district = this.value;
            const wardSelect = document.getElementById('ward');
            
            // Clear ward options
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            
            if (district) {
                // Simulate loading wards (in real app, this would be an API call)
                setTimeout(() => {
                    const wards = getWardsForDistrict(district);
                    wards.forEach(ward => {
                        const option = document.createElement('option');
                        option.value = ward;
                        option.textContent = ward;
                        wardSelect.appendChild(option);
                    });
                }, 100);
            }
        });
        
        // Mock data for address selection
        function getDistrictsForProvince(province) {
            const districtMap = {
                'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Tây Hồ', 'Long Biên', 'Cầu Giấy', 'Đống Đa', 'Hai Bà Trưng', 'Hoàng Mai'],
                'TP. Hồ Chí Minh': ['Quận 1', 'Quận 2', 'Quận 3', 'Quận 4', 'Quận 5', 'Quận 6', 'Quận 7', 'Quận 8', 'Quận 9', 'Quận 10'],
                'Đà Nẵng': ['Hải Châu', 'Thanh Khê', 'Sơn Trà', 'Ngũ Hành Sơn', 'Liên Chiểu'],
                'Hải Phòng': ['Hồng Bàng', 'Ngô Quyền', 'Lê Chân', 'Hải An', 'Kiến An'],
                'Cần Thơ': ['Ninh Kiều', 'Ô Môn', 'Bình Thuỷ', 'Cái Răng', 'Thốt Nốt']
            };
            return districtMap[province] || [];
        }
        
        function getWardsForDistrict(district) {
            // Simplified mock data - in real app, this would vary by district
            return ['Phường 1', 'Phường 2', 'Phường 3', 'Phường 4', 'Phường 5'];
        }
        
        // Notification function
        function showNotification(message, type = 'success') {
            const notification = document.getElementById('notification');
            const messageEl = document.getElementById('notification-message');
            const notificationDiv = notification.querySelector('div');
            
            messageEl.textContent = message;
            
            if (type === 'error') {
                notificationDiv.className = 'bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg';
                notificationDiv.querySelector('i').className = 'fas fa-exclamation-circle mr-2';
            } else {
                notificationDiv.className = 'bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg';
                notificationDiv.querySelector('i').className = 'fas fa-check-circle mr-2';
            }
            
            notification.classList.remove('hidden');
            
            setTimeout(() => {
                notification.classList.add('hidden');
            }, 5000);
        }
        
        // Check if cart is empty and redirect
        <c:set var="isCartEmpty" value="${empty sessionScope.cart}"/>
        var isCartEmpty = <c:out value="${isCartEmpty}"/>;
        if (isCartEmpty) {
            setTimeout(function() {
                window.location.href = '<c:out value="${pageContext.request.contextPath}"/>' + '/cart';
            }, 3000);
        }
    </script>
</body>
</html>
