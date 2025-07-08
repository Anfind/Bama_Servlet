<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - BagStore</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#1f2937',
                        secondary: '#374151',
                        accent: '#f59e0b'
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow-lg sticky top-0 z-50">
        <div class="container mx-auto px-4">
            <!-- Top bar -->
            <div class="flex justify-between items-center py-2 text-sm text-gray-600 border-b">
                <div class="flex items-center space-x-4">
                    <span><i class="fas fa-phone mr-1"></i> 0705.777.760</span>
                    <span><i class="fas fa-envelope mr-1"></i> bama.bags@gmail.com</span>
                </div>
                <div class="flex items-center space-x-4">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <span>Xin chào, ${sessionScope.user.fullName}</span>
                            <a href="${pageContext.request.contextPath}/auth?action=logout" class="hover:text-accent">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/auth?action=login" class="hover:text-accent">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/auth?action=register" class="hover:text-accent">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Main header -->
            <div class="flex items-center justify-between py-4">
                <div class="flex items-center space-x-8">
                    <a href="${pageContext.request.contextPath}/home" class="text-2xl font-bold text-primary">BAMA BAG</a>
                    <nav class="hidden md:flex space-x-8">
                        <a href="${pageContext.request.contextPath}/home" class="text-gray-700 hover:text-accent font-medium">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/product" class="text-gray-700 hover:text-accent font-medium">Tất cả sản phẩm</a>
                        <a href="${pageContext.request.contextPath}/category" class="text-gray-700 hover:text-accent font-medium">Bộ sưu tập</a>
                    </nav>
                </div>

                <div class="flex items-center space-x-4">
                    <form action="${pageContext.request.contextPath}/product" method="get" class="hidden md:block">
                        <input type="hidden" name="action" value="search">
                        <div class="relative">
                            <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." 
                                   class="w-64 px-4 py-2 pl-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-accent">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                    </form>

                    <a href="${pageContext.request.contextPath}/cart" class="relative p-2 text-accent">
                        <i class="fas fa-shopping-bag text-xl"></i>
                        <span id="cart-count" class="absolute -top-1 -right-1 bg-accent text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                            ${cartCount != null ? cartCount : 0}
                        </span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Breadcrumb -->
    <div class="bg-white border-b">
        <div class="container mx-auto px-4 py-3">
            <nav class="flex items-center space-x-2 text-sm text-gray-600">
                <a href="${pageContext.request.contextPath}/home" class="hover:text-accent">Trang chủ</a>
                <i class="fas fa-chevron-right text-xs"></i>
                <span class="text-accent">Giỏ hàng</span>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold text-primary mb-8">Giỏ hàng của bạn</h1>

        <c:choose>
            <c:when test="${cartItems != null && cartItems.size() > 0}">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Cart Items -->
                    <div class="lg:col-span-2">
                        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                            <!-- Cart Header -->
                            <div class="bg-gray-50 px-6 py-4 border-b">
                                <div class="grid grid-cols-12 gap-4 text-sm font-medium text-gray-700">
                                    <div class="col-span-5">Sản phẩm</div>
                                    <div class="col-span-2 text-center">Đơn giá</div>
                                    <div class="col-span-2 text-center">Số lượng</div>
                                    <div class="col-span-2 text-center">Thành tiền</div>
                                    <div class="col-span-1 text-center">Thao tác</div>
                                </div>
                            </div>

                            <!-- Cart Items List -->
                            <div class="divide-y divide-gray-200">
                                <c:forEach var="item" items="${cartItems}" varStatus="status">
                                    <div class="p-6 cart-item" data-product-id="${item.productId}">
                                        <div class="grid grid-cols-12 gap-4 items-center">
                                            <!-- Product Info -->
                                            <div class="col-span-5">
                                                <div class="flex items-center space-x-4">
                                                    <!-- Product Image -->
                                                    <div class="w-20 h-20 bg-gray-200 rounded-lg overflow-hidden flex-shrink-0">
                                                        <c:choose>
                                                            <c:when test="${item.product.images != null && item.product.images.size() > 0}">
                                                                <img src="${pageContext.request.contextPath}${item.product.images[0].imageUrl}" 
                                                                     alt="${item.product.name}" class="w-full h-full object-cover">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                                                    <i class="fas fa-image text-2xl text-gray-400"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <!-- Product Details -->
                                                    <div class="flex-1 min-w-0">
                                                        <h3 class="font-medium text-gray-900 mb-1">
                                                            <a href="${pageContext.request.contextPath}/product?action=detail&slug=${item.product.slug}" 
                                                               class="hover:text-accent transition-colors">
                                                                ${item.product.name}
                                                            </a>
                                                        </h3>
                                                        <p class="text-sm text-gray-600">
                                                            <c:choose>
                                                                <c:when test="${item.product.categoryName != null}">
                                                                    ${item.product.categoryName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Sản phẩm
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                        <c:if test="${item.color != null || item.size != null}">
                                                            <div class="flex items-center space-x-2 mt-1">
                                                                <c:if test="${item.color != null}">
                                                                    <span class="text-xs bg-gray-100 px-2 py-1 rounded">Màu: ${item.color}</span>
                                                                </c:if>
                                                                <c:if test="${item.size != null}">
                                                                    <span class="text-xs bg-gray-100 px-2 py-1 rounded">Size: ${item.size}</span>
                                                                </c:if>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Price -->
                                            <div class="col-span-2 text-center">
                                                <span class="font-medium text-accent" data-price="${item.price}">
                                                    <fmt:formatNumber value="${item.price}" pattern="#,###"/>₫
                                                </span>
                                            </div>

                                            <!-- Quantity -->
                                            <div class="col-span-2 text-center">
                                                <div class="flex items-center justify-center space-x-2">
                                                    <button onclick="updateQuantity(${item.productId}, ${item.quantity - 1})" 
                                                            class="w-8 h-8 border border-gray-300 rounded-lg flex items-center justify-center hover:bg-gray-100 text-sm"
                                                            ${item.quantity <= 1 ? 'disabled' : ''}>
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <span class="w-12 text-center font-medium quantity-display">${item.quantity}</span>
                                                    <button onclick="updateQuantity(${item.productId}, ${item.quantity + 1})" 
                                                            class="w-8 h-8 border border-gray-300 rounded-lg flex items-center justify-center hover:bg-gray-100 text-sm"
                                                            ${item.quantity >= item.product.stockQuantity ? 'disabled' : ''}>
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                                <p class="text-xs text-gray-500 mt-1">Còn ${item.product.stockQuantity} sản phẩm</p>
                                            </div>

                                            <!-- Subtotal -->
                                            <div class="col-span-2 text-center">
                                                <span class="font-semibold text-accent subtotal-display">
                                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>₫
                                                </span>
                                            </div>

                                            <!-- Remove Button -->
                                            <div class="col-span-1 text-center">
                                                <button onclick="removeFromCart(${item.productId})" 
                                                        class="text-red-500 hover:text-red-700 p-2">
                                                    <i class="fas fa-trash text-sm"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Cart Actions -->
                            <div class="bg-gray-50 px-6 py-4 border-t">
                                <div class="flex justify-between items-center">
                                    <button onclick="clearCart()" 
                                            class="text-red-500 hover:text-red-700 font-medium">
                                        <i class="fas fa-trash mr-2"></i>Xóa tất cả
                                    </button>
                                    <a href="${pageContext.request.contextPath}/product" 
                                       class="text-accent hover:text-yellow-600 font-medium">
                                        <i class="fas fa-arrow-left mr-2"></i>Tiếp tục mua sắm
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Summary -->
                    <div class="lg:col-span-1">
                        <div class="bg-white rounded-lg shadow-lg p-6 sticky top-24">
                            <h3 class="text-lg font-semibold text-primary mb-4">Tóm tắt đơn hàng</h3>
                            
                            <div class="space-y-3 mb-6">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Tạm tính:</span>
                                    <span class="font-medium" id="subtotal-amount">
                                        <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫
                                    </span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Phí vận chuyển:</span>
                                    <span class="font-medium">
                                        <c:choose>
                                            <c:when test="${totalAmount >= 500000}">
                                                <span class="text-green-600">Miễn phí</span>
                                            </c:when>
                                            <c:otherwise>
                                                30.000₫
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="border-t pt-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-lg font-semibold">Tổng cộng:</span>
                                        <span class="text-xl font-bold text-accent" id="total-amount">
                                            <c:choose>
                                                <c:when test="${totalAmount >= 500000}">
                                                    <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${totalAmount + 30000}" pattern="#,###"/>₫
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Free Shipping Notice -->
                            <c:if test="${totalAmount < 500000}">
                                <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-6">
                                    <div class="flex items-center text-yellow-800">
                                        <i class="fas fa-truck mr-2"></i>
                                        <span class="text-sm">
                                            Mua thêm <strong><fmt:formatNumber value="${500000 - totalAmount}" pattern="#,###"/>₫</strong> 
                                            để được miễn phí vận chuyển
                                        </span>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Checkout Button -->
                            <c:choose>
                                <c:when test="${sessionScope.user != null}">
                                    <a href="${pageContext.request.contextPath}/order?action=checkout" 
                                       class="w-full bg-accent text-white py-3 px-6 rounded-lg font-semibold text-center block hover:bg-yellow-600 transition-colors">
                                        Tiến hành thanh toán
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/auth?action=login&returnUrl=${pageContext.request.contextPath}/order?action=checkout" 
                                       class="w-full bg-accent text-white py-3 px-6 rounded-lg font-semibold text-center block hover:bg-yellow-600 transition-colors">
                                        Đăng nhập để thanh toán
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <!-- Payment Methods -->
                            <div class="mt-6 pt-6 border-t">
                                <h4 class="font-medium text-gray-900 mb-3">Phương thức thanh toán</h4>
                                <div class="flex space-x-2">
                                    <img src="https://cdn.hstatic.net/0/0/global/design/seller/image/payment/visa.svg" alt="Visa" class="h-8">
                                    <img src="https://cdn.hstatic.net/0/0/global/design/seller/image/payment/mastercard.svg" alt="Mastercard" class="h-8">
                                    <img src="https://cdn.hstatic.net/0/0/global/design/seller/image/payment/vnpay.svg" alt="VNPay" class="h-8">
                                    <img src="https://cdn.hstatic.net/0/0/global/design/seller/image/payment/momo.svg" alt="Momo" class="h-8">
                                </div>
                            </div>

                            <!-- Security Badge -->
                            <div class="mt-4 pt-4 border-t">
                                <div class="flex items-center text-sm text-gray-600">
                                    <i class="fas fa-shield-alt text-green-600 mr-2"></i>
                                    <span>Thanh toán an toàn & bảo mật</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty Cart -->
                <div class="text-center py-16">
                    <div class="bg-white rounded-lg shadow-lg p-12 max-w-md mx-auto">
                        <i class="fas fa-shopping-bag text-6xl text-gray-300 mb-6"></i>
                        <h2 class="text-2xl font-semibold text-gray-900 mb-4">Giỏ hàng trống</h2>
                        <p class="text-gray-600 mb-8">Bạn chưa có sản phẩm nào trong giỏ hàng. Hãy khám phá các sản phẩm tuyệt vời của chúng tôi!</p>
                        <a href="${pageContext.request.contextPath}/product" 
                           class="inline-block bg-accent text-white px-8 py-3 rounded-lg font-semibold hover:bg-yellow-600 transition-colors">
                            Bắt đầu mua sắm
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <footer class="bg-primary text-white mt-16">
        <div class="container mx-auto px-4 py-12">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div>
                    <h3 class="text-xl font-bold mb-4">BAMA BAG</h3>
                    <p class="text-gray-300 mb-4">Chuyên cung cấp balo, túi xách chất lượng cao với thiết kế hiện đại và giá cả hợp lý.</p>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Liên kết nhanh</h4>
                    <ul class="space-y-2">
                        <li><a href="${pageContext.request.contextPath}/home" class="text-gray-300 hover:text-accent">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/product" class="text-gray-300 hover:text-accent">Sản phẩm</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Hỗ trợ khách hàng</h4>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-gray-300 hover:text-accent">Chính sách đổi trả</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-accent">Chính sách vận chuyển</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Thông tin liên hệ</h4>
                    <div class="space-y-2 text-gray-300">
                        <p><i class="fas fa-phone mr-2"></i> 0705.777.760</p>
                        <p><i class="fas fa-envelope mr-2"></i> bama.bags@gmail.com</p>
                    </div>
                </div>
            </div>
            <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-300">
                <p>&copy; 2025 BagStore. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // Update quantity
        function updateQuantity(productId, newQuantity) {
            if (newQuantity < 1) return;

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `action=update&productId=${productId}&quantity=${newQuantity}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update quantity display
                    const cartItem = document.querySelector(`[data-product-id="${productId}"]`);
                    cartItem.querySelector('.quantity-display').textContent = newQuantity;
                    
                    // Recalculate subtotal for this item
                    const priceElement = cartItem.querySelector('[data-price]');
                    if (priceElement) {
                        const price = parseFloat(priceElement.dataset.price);
                        const newSubtotal = price * newQuantity;
                        cartItem.querySelector('.subtotal-display').textContent = formatCurrency(newSubtotal);
                    }
                    
                    // Update cart count and total
                    document.getElementById('cart-count').textContent = data.cartCount;
                    updateCartTotals();
                    
                    showNotification('Đã cập nhật số lượng!', 'success');
                } else {
                    showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }

        // Remove from cart
        function removeFromCart(productId) {
            if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) return;

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `action=remove&productId=${productId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove item from DOM
                    const cartItem = document.querySelector(`[data-product-id="${productId}"]`);
                    cartItem.remove();
                    
                    // Update cart count
                    document.getElementById('cart-count').textContent = data.cartCount;
                    
                    // Check if cart is empty
                    if (data.cartCount === 0) {
                        location.reload();
                    } else {
                        updateCartTotals();
                    }
                    
                    showNotification('Đã xóa sản phẩm khỏi giỏ hàng!', 'success');
                } else {
                    showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }

        // Clear cart
        function clearCart() {
            if (!confirm('Bạn có chắc muốn xóa tất cả sản phẩm trong giỏ hàng?')) return;

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: 'action=clear'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }

        // Update cart totals
        function updateCartTotals() {
            let subtotal = 0;
            document.querySelectorAll('.subtotal-display').forEach(element => {
                const amount = parseFloat(element.textContent.replace(/[₫,]/g, ''));
                subtotal += amount;
            });

            const shippingFee = subtotal >= 500000 ? 0 : 30000;
            const total = subtotal + shippingFee;

            document.getElementById('subtotal-amount').textContent = formatCurrency(subtotal);
            document.getElementById('total-amount').textContent = formatCurrency(total);
        }

        // Format currency
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        }

        // Show notification
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 z-50 px-6 py-3 rounded-lg text-white font-medium ${
                type === 'success' ? 'bg-green-500' : 'bg-red-500'
            } transform translate-x-full transition-transform duration-300`;
            notification.textContent = message;
            
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.classList.remove('translate-x-full');
            }, 100);
            
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => {
                    document.body.removeChild(notification);
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>
