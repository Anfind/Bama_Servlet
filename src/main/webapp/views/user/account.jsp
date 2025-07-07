<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản của tôi - BagStore</title>
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
                    <li class="text-gray-500">Tài khoản của tôi</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
            <!-- Sidebar -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <!-- User Info -->
                    <div class="text-center mb-6">
                        <div class="w-20 h-20 bg-bama-orange rounded-full flex items-center justify-center mx-auto mb-3">
                            <i class="fas fa-user text-white text-2xl"></i>
                        </div>
                        <h3 class="font-semibold text-gray-800">${sessionScope.user.fullName}</h3>
                        <p class="text-sm text-gray-600">${sessionScope.user.email}</p>
                    </div>
                    
                    <!-- Navigation Menu -->
                    <nav class="space-y-2">
                        <a href="${pageContext.request.contextPath}/user?section=profile" 
                           class="flex items-center px-4 py-3 rounded-lg ${param.section == 'profile' || empty param.section ? 'bg-bama-orange text-white' : 'text-gray-700 hover:bg-gray-100'} transition">
                            <i class="fas fa-user w-5 h-5 mr-3"></i>
                            Thông tin cá nhân
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/user?section=orders" 
                           class="flex items-center px-4 py-3 rounded-lg ${param.section == 'orders' ? 'bg-bama-orange text-white' : 'text-gray-700 hover:bg-gray-100'} transition">
                            <i class="fas fa-shopping-cart w-5 h-5 mr-3"></i>
                            Đơn hàng của tôi
                            <c:if test="${userOrderCount > 0}">
                                <span class="ml-auto bg-blue-500 text-white text-xs px-2 py-1 rounded-full">${userOrderCount}</span>
                            </c:if>
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/user?section=addresses" 
                           class="flex items-center px-4 py-3 rounded-lg ${param.section == 'addresses' ? 'bg-bama-orange text-white' : 'text-gray-700 hover:bg-gray-100'} transition">
                            <i class="fas fa-map-marker-alt w-5 h-5 mr-3"></i>
                            Sổ địa chỉ
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/user?section=wishlist" 
                           class="flex items-center px-4 py-3 rounded-lg ${param.section == 'wishlist' ? 'bg-bama-orange text-white' : 'text-gray-700 hover:bg-gray-100'} transition">
                            <i class="fas fa-heart w-5 h-5 mr-3"></i>
                            Sản phẩm yêu thích
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/user?section=password" 
                           class="flex items-center px-4 py-3 rounded-lg ${param.section == 'password' ? 'bg-bama-orange text-white' : 'text-gray-700 hover:bg-gray-100'} transition">
                            <i class="fas fa-lock w-5 h-5 mr-3"></i>
                            Đổi mật khẩu
                        </a>
                        
                        <div class="border-t pt-4 mt-4">
                            <a href="${pageContext.request.contextPath}/auth?action=logout" 
                               class="flex items-center px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition">
                                <i class="fas fa-sign-out-alt w-5 h-5 mr-3"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </nav>
                </div>
            </div>

            <!-- Content Area -->
            <div class="lg:col-span-3">
                <!-- Profile Section -->
                <c:if test="${param.section == 'profile' || empty param.section}">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-2xl font-bold text-bama-dark">Thông tin cá nhân</h2>
                            <button id="editProfileBtn" class="bg-bama-orange text-white px-4 py-2 rounded-lg hover:bg-orange-600 transition">
                                <i class="fas fa-edit mr-2"></i>Chỉnh sửa
                            </button>
                        </div>
                        
                        <form id="profileForm" action="${pageContext.request.contextPath}/user" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Họ và tên</label>
                                    <input type="text" name="fullName" value="${sessionScope.user.fullName}" disabled
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                                    <input type="email" name="email" value="${sessionScope.user.email}" disabled
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                                    <input type="tel" name="phone" value="${sessionScope.user.phone}" disabled
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Giới tính</label>
                                    <select name="gender" disabled
                                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">
                                        <option value="">Chọn giới tính</option>
                                        <option value="male" ${sessionScope.user.gender == 'male' ? 'selected' : ''}>Nam</option>
                                        <option value="female" ${sessionScope.user.gender == 'female' ? 'selected' : ''}>Nữ</option>
                                        <option value="other" ${sessionScope.user.gender == 'other' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Ngày sinh</label>
                                    <input type="date" name="dateOfBirth" value="${sessionScope.user.dateOfBirth}" disabled
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">
                                </div>
                                
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Ngày tham gia</label>
                                    <input type="text" value="<fmt:formatDate value='${sessionScope.user.createdAt}' pattern='dd/MM/yyyy'/>" disabled
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100 text-gray-600">
                                </div>
                            </div>
                            
                            <div class="mt-6">
                                <label class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ</label>
                                <textarea name="address" rows="3" disabled
                                          placeholder="Nhập địa chỉ của bạn"
                                          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent disabled:bg-gray-100">${sessionScope.user.address}</textarea>
                            </div>
                            
                            <div id="profileActions" class="mt-6 hidden">
                                <div class="flex gap-4">
                                    <button type="submit" class="bg-green-500 text-white px-6 py-2 rounded-lg hover:bg-green-600 transition">
                                        <i class="fas fa-save mr-2"></i>Lưu thay đổi
                                    </button>
                                    <button type="button" id="cancelEditBtn" class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition">
                                        <i class="fas fa-times mr-2"></i>Hủy
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </c:if>

                <!-- Orders Section -->
                <c:if test="${param.section == 'orders'}">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-2xl font-bold text-bama-dark">Đơn hàng của tôi</h2>
                            <div class="flex space-x-2">
                                <select class="px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="PENDING">Chờ xử lý</option>
                                    <option value="CONFIRMED">Đã xác nhận</option>
                                    <option value="PROCESSING">Đang chuẩn bị</option>
                                    <option value="SHIPPING">Đang giao hàng</option>
                                    <option value="DELIVERED">Đã giao hàng</option>
                                    <option value="CANCELLED">Đã hủy</option>
                                </select>
                            </div>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty userOrders}">
                                <div class="space-y-4">
                                    <c:forEach var="order" items="${userOrders}">
                                        <div class="border border-gray-200 rounded-lg p-6 hover:shadow-lg transition">
                                            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-4">
                                                <div>
                                                    <h3 class="text-lg font-semibold text-bama-dark">Đơn hàng #${order.orderCode}</h3>
                                                    <p class="text-sm text-gray-600">Đặt hàng: <fmt:formatDate value="${order.createdAt}" pattern="HH:mm dd/MM/yyyy"/></p>
                                                </div>
                                                
                                                <div class="mt-2 md:mt-0 flex items-center space-x-4">
                                                    <span class="px-3 py-1 rounded-full text-sm font-medium
                                                        <c:choose>
                                                            <c:when test='${order.status == "PENDING"}'>bg-yellow-100 text-yellow-800</c:when>
                                                            <c:when test='${order.status == "CONFIRMED"}'>bg-blue-100 text-blue-800</c:when>
                                                            <c:when test='${order.status == "PROCESSING"}'>bg-purple-100 text-purple-800</c:when>
                                                            <c:when test='${order.status == "SHIPPING"}'>bg-orange-100 text-orange-800</c:when>
                                                            <c:when test='${order.status == "DELIVERED"}'>bg-green-100 text-green-800</c:when>
                                                            <c:when test='${order.status == "CANCELLED"}'>bg-red-100 text-red-800</c:when>
                                                            <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test='${order.status == "PENDING"}'>Chờ xử lý</c:when>
                                                            <c:when test='${order.status == "CONFIRMED"}'>Đã xác nhận</c:when>
                                                            <c:when test='${order.status == "PROCESSING"}'>Đang chuẩn bị</c:when>
                                                            <c:when test='${order.status == "SHIPPING"}'>Đang giao hàng</c:when>
                                                            <c:when test='${order.status == "DELIVERED"}'>Đã giao hàng</c:when>
                                                            <c:when test='${order.status == "CANCELLED"}'>Đã hủy</c:when>
                                                            <c:otherwise>${order.status}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    
                                                    <span class="text-lg font-bold text-bama-orange">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                    </span>
                                                </div>
                                            </div>
                                            
                                            <!-- Order Items -->
                                            <div class="space-y-3 mb-4">
                                                <c:forEach var="item" items="${order.items}" varStatus="status">
                                                    <c:if test="${status.index < 2}">
                                                        <div class="flex items-center space-x-4">
                                                            <img src="${pageContext.request.contextPath}/images/products/${item.product.mainImage}" 
                                                                 alt="${item.product.name}" 
                                                                 class="w-16 h-16 object-cover rounded-lg">
                                                            <div class="flex-1">
                                                                <h4 class="font-medium text-gray-800">${item.product.name}</h4>
                                                                <p class="text-sm text-gray-600">Số lượng: ${item.quantity}</p>
                                                            </div>
                                                            <div class="text-right">
                                                                <p class="font-semibold text-gray-800">
                                                                    <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                                
                                                <c:if test="${fn:length(order.items) > 2}">
                                                    <p class="text-sm text-gray-500 italic">
                                                        và ${fn:length(order.items) - 2} sản phẩm khác...
                                                    </p>
                                                </c:if>
                                            </div>
                                            
                                            <!-- Action Buttons -->
                                            <div class="flex flex-wrap gap-2">
                                                <a href="${pageContext.request.contextPath}/order?action=track&orderId=${order.id}" 
                                                   class="bg-bama-orange text-white px-4 py-2 rounded-lg text-sm hover:bg-orange-600 transition">
                                                    <i class="fas fa-search mr-1"></i>Theo dõi
                                                </a>
                                                
                                                <c:if test="${order.status == 'PENDING'}">
                                                    <button onclick="cancelOrder('${order.id}')" 
                                                            class="bg-red-500 text-white px-4 py-2 rounded-lg text-sm hover:bg-red-600 transition">
                                                        <i class="fas fa-times mr-1"></i>Hủy đơn
                                                    </button>
                                                </c:if>
                                                
                                                <c:if test="${order.status == 'DELIVERED'}">
                                                    <button class="bg-green-500 text-white px-4 py-2 rounded-lg text-sm hover:bg-green-600 transition">
                                                        <i class="fas fa-redo mr-1"></i>Mua lại
                                                    </button>
                                                    
                                                    <button class="bg-blue-500 text-white px-4 py-2 rounded-lg text-sm hover:bg-blue-600 transition">
                                                        <i class="fas fa-star mr-1"></i>Đánh giá
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <div class="flex justify-center mt-8">
                                        <nav class="flex space-x-2">
                                            <c:if test="${currentPage > 1}">
                                                <a href="?section=orders&page=${currentPage - 1}" 
                                                   class="px-3 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">Trước</a>
                                            </c:if>
                                            
                                            <c:forEach var="i" begin="1" end="${totalPages}">
                                                <a href="?section=orders&page=${i}" 
                                                   class="px-3 py-2 border rounded-lg ${i == currentPage ? 'bg-bama-orange text-white border-bama-orange' : 'border-gray-300 hover:bg-gray-50'}">${i}</a>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="?section=orders&page=${currentPage + 1}" 
                                                   class="px-3 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">Sau</a>
                                            </c:if>
                                        </nav>
                                    </div>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-12">
                                    <i class="fas fa-shopping-cart text-4xl text-gray-300 mb-4"></i>
                                    <h3 class="text-lg font-semibold text-gray-600 mb-2">Chưa có đơn hàng nào</h3>
                                    <p class="text-gray-500 mb-6">Hãy khám phá và mua sắm những sản phẩm tuyệt vời của chúng tôi!</p>
                                    <a href="${pageContext.request.contextPath}/products" 
                                       class="bg-bama-orange text-white px-6 py-3 rounded-lg hover:bg-orange-600 transition">
                                        <i class="fas fa-shopping-bag mr-2"></i>Mua sắm ngay
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Other sections (addresses, wishlist, password) would go here -->
                <!-- For brevity, I'll add placeholders -->
                
                <c:if test="${param.section == 'addresses'}">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-2xl font-bold text-bama-dark mb-6">Sổ địa chỉ</h2>
                        <div class="text-center py-12">
                            <i class="fas fa-map-marker-alt text-4xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500">Tính năng đang được phát triển...</p>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${param.section == 'wishlist'}">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-2xl font-bold text-bama-dark mb-6">Sản phẩm yêu thích</h2>
                        <div class="text-center py-12">
                            <i class="fas fa-heart text-4xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500">Tính năng đang được phát triển...</p>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${param.section == 'password'}">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-2xl font-bold text-bama-dark mb-6">Đổi mật khẩu</h2>
                        <div class="text-center py-12">
                            <i class="fas fa-lock text-4xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500">Tính năng đang được phát triển...</p>
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

    <script>
        // Profile editing functionality
        const editBtn = document.getElementById('editProfileBtn');
        const cancelBtn = document.getElementById('cancelEditBtn');
        const profileForm = document.getElementById('profileForm');
        const profileActions = document.getElementById('profileActions');
        
        if (editBtn) {
            editBtn.addEventListener('click', function() {
                const inputs = profileForm.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"], input[type="date"], select, textarea');
                inputs.forEach(input => {
                    if (input.name !== 'email') { // Keep email readonly
                        input.disabled = false;
                    }
                });
                
                editBtn.style.display = 'none';
                profileActions.classList.remove('hidden');
            });
        }
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                const inputs = profileForm.querySelectorAll('input[type="text"], input[type="email"], input[type="tel"], input[type="date"], select, textarea');
                inputs.forEach(input => {
                    input.disabled = true;
                });
                
                editBtn.style.display = 'inline-block';
                profileActions.classList.add('hidden');
                
                // Reset form to original values
                profileForm.reset();
            });
        }
        
        // Cancel order function
        function cancelOrder(orderId) {
            if (confirm('Bạn có chắc chắn muốn hủy đơn hàng này?')) {
                fetch('${pageContext.request.contextPath}/order', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=cancel&orderId=' + orderId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Đã hủy đơn hàng thành công!', 'success');
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        showNotification(data.message || 'Có lỗi xảy ra, vui lòng thử lại!', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra, vui lòng thử lại!', 'error');
                });
            }
        }
        
        // Notification function
        function showNotification(message, type = 'success') {
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 z-50 max-w-sm';
            notification.innerHTML = '<div class="' + (type === 'success' ? 'bg-green-500' : 'bg-red-500') + ' text-white px-6 py-3 rounded-lg shadow-lg"><div class="flex items-center"><i class="fas ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle') + ' mr-2"></i><span>' + message + '</span></div></div>';
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 5000);
        }
    </script>
</body>
</html>
