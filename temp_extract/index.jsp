<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BagStore - Balo & Túi Xách Thời Trang</title>
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
                            <a href="/BagStore/auth?action=logout" class="hover:text-accent">Đăng xuất</a>
                        </c:when>
                        <c:otherwise>
                            <a href="/BagStore/auth?action=login" class="hover:text-accent">Đăng nhập</a>
                            <a href="/BagStore/auth?action=register" class="hover:text-accent">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Main header -->
            <div class="flex justify-between items-center py-4">
                <div class="flex items-center">
                    <a href="/BagStore/" class="text-2xl font-bold text-primary">
                        <i class="fas fa-shopping-bag mr-2"></i>BagStore
                    </a>
                </div>
                
                <!-- Search bar -->
                <div class="flex-1 max-w-xl mx-8">
                    <form action="/BagStore/product" method="get" class="relative">
                        <input type="text" name="search" placeholder="Tìm kiếm sản phẩm..." 
                               class="w-full px-4 py-2 pr-12 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-accent">
                        <button type="submit" class="absolute right-3 top-2.5 text-gray-400 hover:text-accent">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
                
                <!-- User actions -->
                <div class="flex items-center space-x-4">
                    <a href="/BagStore/cart" class="relative text-primary hover:text-accent">
                        <i class="fas fa-shopping-cart text-xl"></i>
                        <span class="absolute -top-2 -right-2 bg-accent text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                            ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                        </span>
                    </a>
                    <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                        <a href="/BagStore/admin/" class="text-primary hover:text-accent">
                            <i class="fas fa-cog text-xl"></i>
                        </a>
                    </c:if>
                </div>
            </div>
            
            <!-- Navigation -->
            <nav class="py-3 border-t">
                <ul class="flex space-x-8">
                    <li><a href="/BagStore/" class="text-primary hover:text-accent font-medium">Trang chủ</a></li>
                    <li class="relative group">
                        <a href="/BagStore/product" class="text-primary hover:text-accent font-medium">
                            Sản phẩm <i class="fas fa-chevron-down ml-1"></i>
                        </a>
                        <ul class="absolute top-full left-0 bg-white shadow-lg py-2 w-48 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300">
                            <c:forEach var="category" items="${categories}">
                                <li>
                                    <a href="/BagStore/category?slug=${category.slug}" class="block px-4 py-2 text-gray-700 hover:bg-gray-100">
                                        ${category.name}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                    <li><a href="/BagStore/about" class="text-primary hover:text-accent font-medium">Về chúng tôi</a></li>
                    <li><a href="/BagStore/contact" class="text-primary hover:text-accent font-medium">Liên hệ</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="bg-gradient-to-r from-primary to-secondary text-white py-20">
        <div class="container mx-auto px-4 text-center">
            <h1 class="text-5xl font-bold mb-6">Balo & Túi Xách Thời Trang</h1>
            <p class="text-xl mb-8">Khám phá bộ sưu tập đa dạng với thiết kế hiện đại và chất lượng cao</p>
            <a href="/BagStore/product" class="bg-accent hover:bg-yellow-600 text-white px-8 py-3 rounded-lg text-lg font-semibold transition duration-300">
                Mua sắm ngay
            </a>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="text-center">
                    <div class="bg-accent text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-truck text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Giao hàng miễn phí</h3>
                    <p class="text-gray-600">Miễn phí giao hàng cho đơn hàng trên 500k</p>
                </div>
                <div class="text-center">
                    <div class="bg-accent text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-shield-alt text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Bảo hành chất lượng</h3>
                    <p class="text-gray-600">Bảo hành 12 tháng cho tất cả sản phẩm</p>
                </div>
                <div class="text-center">
                    <div class="bg-accent text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                        <i class="fas fa-undo text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2">Đổi trả dễ dàng</h3>
                    <p class="text-gray-600">Đổi trả trong 30 ngày nếu không hài lòng</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="py-16 bg-gray-50">
        <div class="container mx-auto px-4">
            <h2 class="text-3xl font-bold text-center mb-12">Danh mục sản phẩm</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <c:forEach var="category" items="${categories}">
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition duration-300">
                        <a href="/BagStore/category?slug=${category.slug}">
                            <div class="h-48 bg-gray-200 flex items-center justify-center">
                                <c:choose>
                                    <c:when test="${category.imageUrl != null}">
                                        <img src="${category.imageUrl}" alt="${category.name}" class="w-full h-full object-cover">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-shopping-bag text-4xl text-gray-400"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="p-4">
                                <h3 class="text-lg font-semibold text-center">${category.name}</h3>
                                <p class="text-gray-600 text-sm text-center mt-1">${category.description}</p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Featured Products Section -->
    <section class="py-16 bg-white">
        <div class="container mx-auto px-4">
            <h2 class="text-3xl font-bold text-center mb-12">Sản phẩm nổi bật</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <c:forEach var="product" items="${featuredProducts}" varStatus="status">
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition duration-300">
                        <a href="/BagStore/product?id=${product.id}">
                            <div class="relative">
                                <img src="${product.primaryImageUrl}" alt="${product.name}" class="w-full h-48 object-cover">
                                <c:if test="${product.hasDiscount()}">
                                    <span class="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded text-sm">
                                        -${product.discountPercentage}%
                                    </span>
                                </c:if>
                            </div>
                            <div class="p-4">
                                <h3 class="text-lg font-semibold mb-2 truncate">${product.name}</h3>
                                <div class="flex items-center justify-between">
                                    <div class="flex flex-col">
                                        <c:choose>
                                            <c:when test="${product.hasDiscount()}">
                                                <span class="text-lg font-bold text-red-500">
                                                    <fmt:formatNumber value="${product.discountPrice}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                                <span class="text-sm text-gray-500 line-through">
                                                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-lg font-bold text-primary">
                                                    <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> ₫
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <button class="bg-accent hover:bg-yellow-600 text-white px-3 py-1 rounded text-sm transition duration-300">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
            <div class="text-center mt-8">
                <a href="/BagStore/product" class="bg-primary hover:bg-secondary text-white px-6 py-3 rounded-lg font-semibold transition duration-300">
                    Xem tất cả sản phẩm
                </a>
            </div>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="py-16 bg-primary text-white">
        <div class="container mx-auto px-4 text-center">
            <h2 class="text-3xl font-bold mb-4">Đăng ký nhận tin</h2>
            <p class="text-lg mb-8">Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt</p>
            <form class="flex justify-center max-w-md mx-auto">
                <input type="email" placeholder="Nhập email của bạn" 
                       class="flex-1 px-4 py-3 rounded-l-lg text-gray-900 focus:outline-none">
                <button type="submit" class="bg-accent hover:bg-yellow-600 px-6 py-3 rounded-r-lg font-semibold transition duration-300">
                    Đăng ký
                </button>
            </form>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-12">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div>
                    <h3 class="text-xl font-bold mb-4">BagStore</h3>
                    <p class="text-gray-400 mb-4">Chuyên cung cấp balo và túi xách chất lượng cao với thiết kế thời trang.</p>
                    <div class="flex space-x-4">
                        <a href="#" class="text-gray-400 hover:text-accent"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="text-gray-400 hover:text-accent"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-gray-400 hover:text-accent"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
                <div>
                    <h4 class="text-lg font-semibold mb-4">Liên kết</h4>
                    <ul class="space-y-2">
                        <li><a href="/BagStore/" class="text-gray-400 hover:text-accent">Trang chủ</a></li>
                        <li><a href="/BagStore/product" class="text-gray-400 hover:text-accent">Sản phẩm</a></li>
                        <li><a href="/BagStore/about" class="text-gray-400 hover:text-accent">Về chúng tôi</a></li>
                        <li><a href="/BagStore/contact" class="text-gray-400 hover:text-accent">Liên hệ</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="text-lg font-semibold mb-4">Chính sách</h4>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-gray-400 hover:text-accent">Chính sách đổi trả</a></li>
                        <li><a href="#" class="text-gray-400 hover:text-accent">Chính sách vận chuyển</a></li>
                        <li><a href="#" class="text-gray-400 hover:text-accent">Chính sách thanh toán</a></li>
                        <li><a href="#" class="text-gray-400 hover:text-accent">Điều khoản dịch vụ</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="text-lg font-semibold mb-4">Liên hệ</h4>
                    <ul class="space-y-2 text-gray-400">
                        <li><i class="fas fa-phone mr-2"></i> 0705.777.760</li>
                        <li><i class="fas fa-envelope mr-2"></i> bama.bags@gmail.com</li>
                        <li><i class="fas fa-map-marker-alt mr-2"></i> Hà Nội, Việt Nam</li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400">
                <p>&copy; 2025 BagStore. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Add to cart functionality
        document.addEventListener('DOMContentLoaded', function() {
            const addToCartButtons = document.querySelectorAll('button[data-product-id]');
            
            addToCartButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const productId = this.getAttribute('data-product-id');
                    
                    // Add AJAX call to add item to cart
                    fetch('/BagStore/cart', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'action=add&productId=' + productId + '&quantity=1'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Update cart count
                            const cartCount = document.querySelector('.fa-shopping-cart + span');
                            cartCount.textContent = data.cartCount;
                            
                            // Show success message
                            alert('Đã thêm sản phẩm vào giỏ hàng!');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
                });
            });
        });
    </script>
</body>
</html>
