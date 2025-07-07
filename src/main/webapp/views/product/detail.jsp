<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - BagStore</title>
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
    <!-- Header (same as product listing) -->
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
                    <!-- Search -->
                    <form action="${pageContext.request.contextPath}/product" method="get" class="hidden md:block">
                        <input type="hidden" name="action" value="search">
                        <div class="relative">
                            <input type="text" name="q" placeholder="Tìm kiếm sản phẩm..." 
                                   class="w-64 px-4 py-2 pl-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-accent">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                    </form>

                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative p-2 text-gray-700 hover:text-accent">
                        <i class="fas fa-shopping-bag text-xl"></i>
                        <span id="cart-count" class="absolute -top-1 -right-1 bg-accent text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">0</span>
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
                <a href="${pageContext.request.contextPath}/product" class="hover:text-accent">Sản phẩm</a>
                <i class="fas fa-chevron-right text-xs"></i>
                <a href="${pageContext.request.contextPath}/product?action=category&id=${product.categoryId}" class="hover:text-accent">${product.categoryName}</a>
                <i class="fas fa-chevron-right text-xs"></i>
                <span class="text-accent">${product.name}</span>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
            <!-- Product Images -->
            <div class="space-y-4">
                <!-- Main Image -->
                <div class="aspect-square bg-white rounded-lg shadow-lg overflow-hidden">
                    <c:choose>
                        <c:when test="${product.images != null && product.images.size() > 0}">
                            <img id="mainImage" src="${pageContext.request.contextPath}${product.images[0].imageUrl}" 
                                 alt="${product.name}" class="w-full h-full object-cover">
                        </c:when>
                        <c:otherwise>
                            <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                <i class="fas fa-image text-6xl text-gray-400"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Image Thumbnails -->
                <c:if test="${product.images != null && product.images.size() > 1}">
                    <div class="flex space-x-2 overflow-x-auto">
                        <c:forEach var="image" items="${product.images}" varStatus="status">
                            <button onclick="changeMainImage('${pageContext.request.contextPath}${image.imageUrl}')"
                                    class="flex-shrink-0 w-20 h-20 border-2 ${status.index == 0 ? 'border-accent' : 'border-gray-300'} rounded-lg overflow-hidden hover:border-accent transition-colors">
                                <img src="${pageContext.request.contextPath}${image.imageUrl}" 
                                     alt="${product.name}" class="w-full h-full object-cover">
                            </button>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- Product Info -->
            <div class="space-y-6">
                <div>
                    <h1 class="text-3xl font-bold text-primary mb-2">${product.name}</h1>
                    <p class="text-gray-600">Danh mục: ${product.categoryName}</p>
                </div>

                <!-- Price -->
                <div class="flex items-center space-x-4">
                    <c:choose>
                        <c:when test="${product.discountPrice > 0}">
                            <span class="text-3xl font-bold text-accent">
                                <fmt:formatNumber value="${product.discountPrice}" pattern="#,###"/>₫
                            </span>
                            <span class="text-xl text-gray-500 line-through">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                            </span>
                            <span class="bg-red-500 text-white px-2 py-1 rounded-md text-sm font-semibold">
                                -<fmt:formatNumber value="${((product.price - product.discountPrice) / product.price) * 100}" 
                                                   maxFractionDigits="0"/>%
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-3xl font-bold text-accent">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Stock Status -->
                <div class="flex items-center space-x-2">
                    <span class="text-gray-700">Tình trạng:</span>
                    <c:choose>
                        <c:when test="${product.stockQuantity > 10}">
                            <span class="text-green-600 font-medium"><i class="fas fa-check-circle mr-1"></i>Còn hàng</span>
                        </c:when>
                        <c:when test="${product.stockQuantity > 0}">
                            <span class="text-orange-600 font-medium"><i class="fas fa-exclamation-triangle mr-1"></i>Còn ${product.stockQuantity} sản phẩm</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-red-600 font-medium"><i class="fas fa-times-circle mr-1"></i>Hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Product Options -->
                <div class="space-y-4">
                    <!-- Color Selection (if applicable) -->
                    <div id="colorSection" class="hidden">
                        <label class="block text-gray-700 font-medium mb-2">Màu sắc:</label>
                        <div class="flex space-x-2">
                            <button class="w-8 h-8 rounded-full border-2 border-gray-300 bg-gray-800 hover:border-accent"></button>
                            <button class="w-8 h-8 rounded-full border-2 border-gray-300 bg-gray-600 hover:border-accent"></button>
                            <button class="w-8 h-8 rounded-full border-2 border-gray-300 bg-yellow-600 hover:border-accent"></button>
                        </div>
                    </div>

                    <!-- Quantity -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Số lượng:</label>
                        <div class="flex items-center space-x-3">
                            <button onclick="decreaseQuantity()" class="w-10 h-10 border border-gray-300 rounded-lg flex items-center justify-center hover:bg-gray-100">
                                <i class="fas fa-minus text-sm"></i>
                            </button>
                            <input type="number" id="quantity" value="1" min="1" max="${product.stockQuantity}" 
                                   class="w-20 text-center border border-gray-300 rounded-lg py-2 focus:outline-none focus:ring-2 focus:ring-accent">
                            <button onclick="increaseQuantity()" class="w-10 h-10 border border-gray-300 rounded-lg flex items-center justify-center hover:bg-gray-100">
                                <i class="fas fa-plus text-sm"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="space-y-3">
                    <c:choose>
                        <c:when test="${product.stockQuantity > 0}">
                            <button onclick="addToCart(${product.id})" 
                                    class="w-full bg-accent text-white py-3 px-6 rounded-lg font-semibold text-lg hover:bg-yellow-600 transition-colors">
                                <i class="fas fa-shopping-cart mr-2"></i>Thêm vào giỏ hàng
                            </button>
                            <button onclick="buyNow(${product.id})" 
                                    class="w-full bg-primary text-white py-3 px-6 rounded-lg font-semibold text-lg hover:bg-gray-800 transition-colors">
                                Mua ngay
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button disabled class="w-full bg-gray-400 text-white py-3 px-6 rounded-lg font-semibold text-lg cursor-not-allowed">
                                Hết hàng
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Product Features -->
                <div class="border-t pt-6">
                    <h3 class="font-semibold text-gray-900 mb-3">Đặc điểm sản phẩm:</h3>
                    <ul class="space-y-2 text-gray-700">
                        <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Chất liệu cao cấp, bền đẹp</li>
                        <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Thiết kế hiện đại, thời trang</li>
                        <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Nhiều ngăn tiện lợi</li>
                        <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Chống nước, chống bám bẩn</li>
                        <li class="flex items-center"><i class="fas fa-check text-green-500 mr-2"></i>Bảo hành 12 tháng</li>
                    </ul>
                </div>

                <!-- Share -->
                <div class="border-t pt-6">
                    <h3 class="font-semibold text-gray-900 mb-3">Chia sẻ:</h3>
                    <div class="flex space-x-3">
                        <button class="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                            <i class="fab fa-facebook"></i>
                            <span>Facebook</span>
                        </button>
                        <button class="flex items-center space-x-2 px-4 py-2 bg-pink-500 text-white rounded-lg hover:bg-pink-600">
                            <i class="fab fa-instagram"></i>
                            <span>Instagram</span>
                        </button>
                        <button class="flex items-center space-x-2 px-4 py-2 bg-gray-800 text-white rounded-lg hover:bg-gray-900">
                            <i class="fab fa-tiktok"></i>
                            <span>TikTok</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Description -->
        <div class="mt-16">
            <div class="bg-white rounded-lg shadow-lg p-8">
                <h2 class="text-2xl font-bold text-primary mb-6">Mô tả sản phẩm</h2>
                <div class="prose max-w-none text-gray-700">
                    <c:choose>
                        <c:when test="${product.description != null && !product.description.isEmpty()}">
                            <p>${product.description}</p>
                        </c:when>
                        <c:otherwise>
                            <p>
                                <strong>${product.name}</strong> là sản phẩm chất lượng cao được thiết kế với phong cách hiện đại và tính năng ưu việt. 
                                Sản phẩm được làm từ chất liệu cao cấp, đảm bảo độ bền và tính thẩm mỹ. 
                                Với thiết kế ergonomic và nhiều ngăn tiện lợi, sản phẩm này sẽ đáp ứng hoàn hảo nhu cầu sử dụng hàng ngày của bạn.
                            </p>
                            <br>
                            <p>
                                <strong>Đặc điểm nổi bật:</strong>
                            </p>
                            <ul>
                                <li>Chất liệu vải cao cấp, chống nước hiệu quả</li>
                                <li>Thiết kế thời trang, phù hợp mọi độ tuổi</li>
                                <li>Hệ thống khóa kéo YKK bền bỉ</li>
                                <li>Nhiều ngăn chứa tiện lợi, sắp xếp đồ dùng khoa học</li>
                                <li>Quai đeo êm ái, có thể điều chỉnh độ dài</li>
                                <li>Kích thước phù hợp với laptop 15.6 inch</li>
                            </ul>
                            <br>
                            <p>
                                <strong>Hướng dẫn bảo quản:</strong>
                            </p>
                            <ul>
                                <li>Lau chùi bằng khăn ẩm khi cần thiết</li>
                                <li>Không ngâm nước hoặc giặt máy</li>
                                <li>Bảo quản nơi khô ráo, thoáng mát</li>
                                <li>Tránh tiếp xúc với vật sắc nhọn</li>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Related Products -->
        <c:if test="${relatedProducts != null && relatedProducts.size() > 0}">
            <div class="mt-16">
                <h2 class="text-2xl font-bold text-primary mb-8">Sản phẩm liên quan</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:forEach var="relatedProduct" items="${relatedProducts}">
                        <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300 group">
                            <div class="relative aspect-square overflow-hidden">
                                <c:choose>
                                    <c:when test="${relatedProduct.images != null && relatedProduct.images.size() > 0}">
                                        <img src="${pageContext.request.contextPath}${relatedProduct.images[0].imageUrl}" 
                                             alt="${relatedProduct.name}"
                                             class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                            <i class="fas fa-image text-4xl text-gray-400"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:if test="${relatedProduct.discountPrice > 0}">
                                    <div class="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded-md text-xs font-semibold">
                                        -<fmt:formatNumber value="${((relatedProduct.price - relatedProduct.discountPrice) / relatedProduct.price) * 100}" 
                                                           maxFractionDigits="0"/>%
                                    </div>
                                </c:if>
                            </div>

                            <div class="p-4">
                                <h3 class="font-medium text-gray-900 mb-2 line-clamp-2">
                                    <a href="${pageContext.request.contextPath}/product?action=detail&slug=${relatedProduct.slug}" 
                                       class="hover:text-accent transition-colors">
                                        ${relatedProduct.name}
                                    </a>
                                </h3>
                                
                                <div class="flex items-center space-x-2">
                                    <c:choose>
                                        <c:when test="${relatedProduct.discountPrice > 0}">
                                            <span class="text-lg font-semibold text-accent">
                                                <fmt:formatNumber value="${relatedProduct.discountPrice}" pattern="#,###"/>₫
                                            </span>
                                            <span class="text-sm text-gray-500 line-through">
                                                <fmt:formatNumber value="${relatedProduct.price}" pattern="#,###"/>₫
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-lg font-semibold text-accent">
                                                <fmt:formatNumber value="${relatedProduct.price}" pattern="#,###"/>₫
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Footer (same as product listing) -->
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
        // Change main image
        function changeMainImage(imageUrl) {
            document.getElementById('mainImage').src = imageUrl;
            
            // Update thumbnail borders
            document.querySelectorAll('[onclick*="changeMainImage"]').forEach(btn => {
                btn.classList.remove('border-accent');
                btn.classList.add('border-gray-300');
            });
            event.target.closest('button').classList.add('border-accent');
            event.target.closest('button').classList.remove('border-gray-300');
        }

        // Quantity controls
        function increaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const maxQuantity = ${product.stockQuantity};
            const currentQuantity = parseInt(quantityInput.value);
            
            if (currentQuantity < maxQuantity) {
                quantityInput.value = currentQuantity + 1;
            }
        }

        function decreaseQuantity() {
            const quantityInput = document.getElementById('quantity');
            const currentQuantity = parseInt(quantityInput.value);
            
            if (currentQuantity > 1) {
                quantityInput.value = currentQuantity - 1;
            }
        }

        // Add to cart
        function addToCart(productId) {
            const quantity = document.getElementById('quantity').value;
            
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `action=add&productId=${productId}&quantity=${quantity}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('cart-count').textContent = data.cartCount;
                    showNotification('Đã thêm sản phẩm vào giỏ hàng!', 'success');
                } else {
                    showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            });
        }

        // Buy now
        function buyNow(productId) {
            addToCart(productId);
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/cart';
            }, 1000);
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

        // Load cart count on page load
        document.addEventListener('DOMContentLoaded', function() {
            fetch('${pageContext.request.contextPath}/cart?action=count')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('cart-count').textContent = data.count;
                })
                .catch(error => console.error('Error loading cart count:', error));
        });
    </script>
</body>
</html>
