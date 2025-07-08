<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi đơn hàng - BagStore</title>
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
                    <li class="text-gray-500">Theo dõi đơn hàng</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold text-bama-dark mb-8 text-center">Theo dõi đơn hàng</h1>

        <!-- Search Form -->
        <c:if test="${empty order}">
            <div class="max-w-md mx-auto mb-8">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-xl font-semibold mb-4 text-center">Tra cứu đơn hàng</h2>
                    
                    <form action="${pageContext.request.contextPath}/order" method="get">
                        <input type="hidden" name="action" value="track">
                        
                        <div class="mb-4">
                            <label for="orderCode" class="block text-sm font-medium text-gray-700 mb-2">Mã đơn hàng</label>
                            <input type="text" id="orderCode" name="orderCode" required
                                   placeholder="Nhập mã đơn hàng (VD: ORD123456)"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                        </div>
                        
                        <div class="mb-6">
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email (tùy chọn)</label>
                            <input type="email" id="email" name="email"
                                   placeholder="Email đặt hàng"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-bama-orange focus:border-transparent">
                        </div>
                        
                        <button type="submit" 
                                class="w-full bg-bama-orange text-white py-2 px-4 rounded-lg font-semibold hover:bg-orange-600 transition">
                            <i class="fas fa-search mr-2"></i>Tra cứu
                        </button>
                    </form>
                </div>
            </div>
        </c:if>

        <!-- Order Details -->
        <c:if test="${not empty order}">
            <div class="max-w-4xl mx-auto">
                <!-- Order Header -->
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
                        <div>
                            <h2 class="text-2xl font-bold text-bama-dark mb-2">Đơn hàng #${order.orderCode}</h2>
                            <p class="text-gray-600">Đặt hàng lúc: <fmt:formatDate value="${order.createdAt}" pattern="HH:mm dd/MM/yyyy"/></p>
                        </div>
                        
                        <div class="mt-4 md:mt-0">
                            <span class="px-4 py-2 rounded-full text-sm font-semibold
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
                        </div>
                    </div>
                    
                    <!-- Order Progress -->
                    <div class="mb-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="flex items-center">
                                <div class="w-8 h-8 rounded-full bg-green-500 flex items-center justify-center text-white text-sm">
                                    <i class="fas fa-check"></i>
                                </div>
                                <div class="ml-3">
                                    <p class="font-semibold text-sm">Đặt hàng</p>
                                    <p class="text-xs text-gray-500"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM HH:mm"/></p>
                                </div>
                            </div>
                            
                            <div class="flex-1 mx-4">
                                <div class="h-1 bg-gray-200 rounded">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING'}">
                                            <div class="h-1 bg-green-500 rounded" style="width: 25%"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-1 bg-green-500 rounded" style="width: 100%"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="flex items-center">
                                <div class="w-8 h-8 rounded-full ${order.status == 'PENDING' ? 'bg-gray-300' : 'bg-green-500'} flex items-center justify-center text-white text-sm">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING'}"><i class="fas fa-clock"></i></c:when>
                                        <c:otherwise><i class="fas fa-check"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ml-3">
                                    <p class="font-semibold text-sm">Xác nhận</p>
                                    <p class="text-xs text-gray-500">
                                        <c:choose>
                                            <c:when test="${order.status != 'PENDING'}">
                                                <fmt:formatDate value="${order.confirmedAt}" pattern="dd/MM HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Đang chờ</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                            
                            <div class="flex-1 mx-4">
                                <div class="h-1 bg-gray-200 rounded">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING' || order.status == 'CONFIRMED'}">
                                            <div class="h-1 bg-green-500 rounded" style="width: 0%"></div>
                                        </c:when>
                                        <c:when test="${order.status == 'PROCESSING'}">
                                            <div class="h-1 bg-green-500 rounded" style="width: 50%"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-1 bg-green-500 rounded" style="width: 100%"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="flex items-center">
                                <div class="w-8 h-8 rounded-full ${order.status == 'PENDING' || order.status == 'CONFIRMED' ? 'bg-gray-300' : order.status == 'PROCESSING' ? 'bg-blue-500' : 'bg-green-500'} flex items-center justify-center text-white text-sm">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING' || order.status == 'CONFIRMED'}"><i class="fas fa-clock"></i></c:when>
                                        <c:when test="${order.status == 'PROCESSING'}"><i class="fas fa-cog fa-spin"></i></c:when>
                                        <c:otherwise><i class="fas fa-check"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ml-3">
                                    <p class="font-semibold text-sm">Chuẩn bị</p>
                                    <p class="text-xs text-gray-500">
                                        <c:choose>
                                            <c:when test="${order.status == 'PROCESSING' || order.status == 'SHIPPING' || order.status == 'DELIVERED'}">
                                                <fmt:formatDate value="${order.processingAt}" pattern="dd/MM HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Đang chờ</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                            
                            <div class="flex-1 mx-4">
                                <div class="h-1 bg-gray-200 rounded">
                                    <c:choose>
                                        <c:when test="${order.status == 'SHIPPING'}">
                                            <div class="h-1 bg-green-500 rounded" style="width: 50%"></div>
                                        </c:when>
                                        <c:when test="${order.status == 'DELIVERED'}">
                                            <div class="h-1 bg-green-500 rounded" style="width: 100%"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="h-1 bg-green-500 rounded" style="width: 0%"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="flex items-center">
                                <div class="w-8 h-8 rounded-full ${order.status == 'SHIPPING' ? 'bg-orange-500' : order.status == 'DELIVERED' ? 'bg-green-500' : 'bg-gray-300'} flex items-center justify-center text-white text-sm">
                                    <c:choose>
                                        <c:when test="${order.status == 'SHIPPING'}"><i class="fas fa-truck"></i></c:when>
                                        <c:when test="${order.status == 'DELIVERED'}"><i class="fas fa-check"></i></c:when>
                                        <c:otherwise><i class="fas fa-clock"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="ml-3">
                                    <p class="font-semibold text-sm">Giao hàng</p>
                                    <p class="text-xs text-gray-500">
                                        <c:choose>
                                            <c:when test="${order.status == 'DELIVERED'}">
                                                <fmt:formatDate value="${order.deliveredAt}" pattern="dd/MM HH:mm"/>
                                            </c:when>
                                            <c:when test="${order.status == 'SHIPPING'}">Đang giao</c:when>
                                            <c:otherwise>Đang chờ</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <h3 class="text-lg font-semibold mb-4">Sản phẩm đã đặt</h3>
                    
                    <div class="space-y-4">
                        <c:forEach var="item" items="${order.items}">
                            <div class="flex items-center space-x-4 p-4 border border-gray-200 rounded-lg">
                                <img src="${pageContext.request.contextPath}/images/products/${item.product.mainImage}" 
                                     alt="${item.product.name}" 
                                     class="w-20 h-20 object-cover rounded-lg">
                                
                                <div class="flex-1">
                                    <h4 class="font-semibold text-gray-800">${item.product.name}</h4>
                                    <p class="text-sm text-gray-600 mt-1">${item.product.description}</p>
                                    <div class="flex items-center mt-2">
                                        <span class="text-sm text-gray-500">Số lượng: ${item.quantity}</span>
                                        <span class="mx-2 text-gray-300">|</span>
                                        <span class="text-sm text-gray-500">Đơn giá: <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" groupingUsed="true"/></span>
                                    </div>
                                </div>
                                
                                <div class="text-right">
                                    <p class="text-lg font-bold text-bama-orange">
                                        <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Order Total -->
                    <div class="border-t pt-4 mt-6">
                        <div class="flex justify-between items-center text-lg font-bold">
                            <span>Tổng cộng:</span>
                            <span class="text-bama-orange">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Shipping Information -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h3 class="text-lg font-semibold mb-4">Thông tin giao hàng</h3>
                        <div class="space-y-2">
                            <p><strong>Người nhận:</strong> ${order.customerName}</p>
                            <p><strong>Số điện thoại:</strong> ${order.customerPhone}</p>
                            <p><strong>Email:</strong> ${order.customerEmail}</p>
                            <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h3 class="text-lg font-semibold mb-4">Thông tin thanh toán</h3>
                        <div class="space-y-2">
                            <p><strong>Phương thức:</strong> 
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'COD'}">Thanh toán khi nhận hàng</c:when>
                                    <c:when test="${order.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${order.paymentMethod == 'MOMO'}">Ví điện tử MoMo</c:when>
                                    <c:otherwise>${order.paymentMethod}</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Trạng thái:</strong> 
                                <span class="px-2 py-1 rounded text-sm font-medium
                                    <c:choose>
                                        <c:when test='${order.paymentStatus == "PAID"}'>bg-green-100 text-green-800</c:when>
                                        <c:when test='${order.paymentStatus == "PENDING"}'>bg-yellow-100 text-yellow-800</c:when>
                                        <c:otherwise>bg-red-100 text-red-800</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test='${order.paymentStatus == "PAID"}'>Đã thanh toán</c:when>
                                        <c:when test='${order.paymentStatus == "PENDING"}'>Chưa thanh toán</c:when>
                                        <c:otherwise>Thất bại</c:otherwise>
                                    </c:choose>
                                </span>
                            </p>
                            <c:if test="${not empty order.notes}">
                                <p><strong>Ghi chú:</strong> ${order.notes}</p>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="text-center mt-8">
                    <c:if test="${order.status == 'PENDING'}">
                        <button onclick="cancelOrder('${order.id}')" 
                                class="bg-red-500 text-white px-6 py-2 rounded-lg hover:bg-red-600 transition mr-4">
                            <i class="fas fa-times mr-2"></i>Hủy đơn hàng
                        </button>
                    </c:if>
                    
                    <a href="${pageContext.request.contextPath}/products" 
                       class="bg-bama-orange text-white px-6 py-2 rounded-lg hover:bg-orange-600 transition">
                        <i class="fas fa-shopping-bag mr-2"></i>Mua thêm sản phẩm
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="max-w-md mx-auto">
                <div class="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
                    <i class="fas fa-exclamation-triangle text-red-500 text-2xl mb-3"></i>
                    <p class="text-red-700">${error}</p>
                    <a href="${pageContext.request.contextPath}/order?action=track" 
                       class="inline-block mt-4 text-bama-orange hover:underline">
                        Tra cứu lại
                    </a>
                </div>
            </div>
        </c:if>
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
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra, vui lòng thử lại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra, vui lòng thử lại!');
                });
            }
        }
    </script>
</body>
</html>
