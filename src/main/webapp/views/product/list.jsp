<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - BagStore</title>
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
                    <!-- Logo -->
                    <a href="${pageContext.request.contextPath}/home" class="text-2xl font-bold text-primary">
                        BAMA BAG
                    </a>
                    
                    <!-- Navigation -->
                    <nav class="hidden md:flex space-x-8">
                        <a href="${pageContext.request.contextPath}/home" class="text-gray-700 hover:text-accent font-medium">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/product" class="text-accent font-medium">Tất cả sản phẩm</a>
                        <div class="relative group">
                            <button class="text-gray-700 hover:text-accent font-medium flex items-center">
                                Danh mục <i class="fas fa-chevron-down ml-1 text-xs"></i>
                            </button>
                            <div class="absolute top-full left-0 bg-white shadow-lg rounded-lg py-2 w-48 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                                <c:forEach var="category" items="${categories}">
                                    <a href="${pageContext.request.contextPath}/product?action=category&slug=${category.slug}" 
                                       class="block px-4 py-2 text-gray-700 hover:bg-gray-100 hover:text-accent">
                                        ${category.name}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/category" class="text-gray-700 hover:text-accent font-medium">Bộ sưu tập</a>
                    </nav>
                </div>

                <!-- Search & Cart -->
                <div class="flex items-center space-x-4">
                    <!-- Search -->
                    <form action="${pageContext.request.contextPath}/product" method="get" class="hidden md:block">
                        <input type="hidden" name="action" value="search">
                        <div class="relative">
                            <input type="text" name="q" value="${searchKeyword}" 
                                   placeholder="Tìm kiếm sản phẩm..." 
                                   class="w-64 px-4 py-2 pl-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                    </form>

                    <!-- Cart -->
                    <a href="${pageContext.request.contextPath}/cart" class="relative p-2 text-gray-700 hover:text-accent">
                        <i class="fas fa-shopping-bag text-xl"></i>
                        <span id="cart-count" class="absolute -top-1 -right-1 bg-accent text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                            0
                        </span>
                    </a>

                    <!-- Mobile menu button -->
                    <button class="md:hidden p-2 text-gray-700 hover:text-accent">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
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
                <c:choose>
                    <c:when test="${currentCategory != null}">
                        <a href="${pageContext.request.contextPath}/product" class="hover:text-accent">Sản phẩm</a>
                        <i class="fas fa-chevron-right text-xs"></i>
                        <span class="text-accent">${currentCategory.name}</span>
                    </c:when>
                    <c:when test="${searchKeyword != null}">
                        <a href="${pageContext.request.contextPath}/product" class="hover:text-accent">Sản phẩm</a>
                        <i class="fas fa-chevron-right text-xs"></i>
                        <span class="text-accent">Tìm kiếm: "${searchKeyword}"</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-accent">Tất cả sản phẩm</span>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8">
        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Sidebar Filters -->
            <div class="lg:w-1/4">
                <div class="bg-white rounded-lg shadow-md p-6 sticky top-24">
                    <h3 class="text-lg font-semibold text-primary mb-4">Bộ lọc</h3>
                    
                    <!-- Category Filter -->
                    <div class="mb-6">
                        <h4 class="font-medium text-gray-900 mb-3">Danh mục</h4>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="radio" name="category" value="all" 
                                       ${categoryFilter == null || categoryFilter == 'all' ? 'checked' : ''}
                                       class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">Tất cả</span>
                            </label>
                            <c:forEach var="category" items="${categories}">
                                <label class="flex items-center">
                                    <input type="radio" name="category" value="${category.id}"
                                           ${categoryFilter == category.id ? 'checked' : ''}
                                           class="text-accent focus:ring-accent">
                                    <span class="ml-2 text-gray-700">${category.name}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Price Filter -->
                    <div class="mb-6">
                        <h4 class="font-medium text-gray-900 mb-3">Khoảng giá</h4>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="radio" name="priceRange" value="all" checked class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">Tất cả</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="priceRange" value="0-500000" class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">Dưới 500.000₫</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="priceRange" value="500000-1000000" class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">500.000₫ - 1.000.000₫</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="priceRange" value="1000000-2000000" class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">1.000.000₫ - 2.000.000₫</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="priceRange" value="2000000-999999999" class="text-accent focus:ring-accent">
                                <span class="ml-2 text-gray-700">Trên 2.000.000₫</span>
                            </label>
                        </div>
                    </div>

                    <!-- Apply Filter Button -->
                    <button onclick="applyFilters()" 
                            class="w-full bg-accent text-white py-2 px-4 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                        Áp dụng bộ lọc
                    </button>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="lg:w-3/4">
                <!-- Sort & Results Info -->
                <div class="flex flex-col sm:flex-row justify-between items-center mb-6">
                    <div class="text-gray-600 mb-4 sm:mb-0">
                        <c:choose>
                            <c:when test="${totalProducts > 0}">
                                Hiển thị ${(currentPage - 1) * 12 + 1} - ${currentPage * 12 > totalProducts ? totalProducts : currentPage * 12} 
                                trong tổng số ${totalProducts} sản phẩm
                            </c:when>
                            <c:otherwise>
                                Không tìm thấy sản phẩm nào
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Sort Options -->
                    <div class="flex items-center space-x-4">
                        <span class="text-gray-700">Sắp xếp:</span>
                        <select id="sortSelect" onchange="applySorting()" 
                                class="border border-gray-300 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-accent">
                            <option value="newest">Mới nhất</option>
                            <option value="price_asc">Giá thấp đến cao</option>
                            <option value="price_desc">Giá cao đến thấp</option>
                            <option value="name_asc">Tên A-Z</option>
                            <option value="name_desc">Tên Z-A</option>
                        </select>
                    </div>
                </div>

                <!-- Products Grid -->
                <c:choose>
                    <c:when test="${products != null && products.size() > 0}">
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            <c:forEach var="product" items="${products}">
                                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300 group">
                                    <!-- Product Image -->
                                    <div class="relative aspect-square overflow-hidden">
                                        <c:choose>
                                            <c:when test="${product.images != null && product.images.size() > 0}">
                                                <img src="${pageContext.request.contextPath}${product.images[0].imageUrl}" 
                                                     alt="${product.name}"
                                                     class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-full h-full bg-gray-200 flex items-center justify-center">
                                                    <i class="fas fa-image text-4xl text-gray-400"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Discount Badge -->
                                        <c:if test="${product.discountPrice > 0}">
                                            <div class="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded-md text-xs font-semibold">
                                                -<fmt:formatNumber value="${((product.price - product.discountPrice) / product.price) * 100}" 
                                                                   maxFractionDigits="0"/>%
                                            </div>
                                        </c:if>

                                        <!-- Quick Add to Cart -->
                                        <div class="absolute inset-0 bg-black bg-opacity-40 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center">
                                            <button onclick="addToCart(${product.id})" 
                                                    class="bg-accent text-white px-4 py-2 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                                <i class="fas fa-shopping-cart mr-2"></i>Thêm vào giỏ
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Product Info -->
                                    <div class="p-4">
                                        <h3 class="font-medium text-gray-900 mb-2 line-clamp-2">
                                            <a href="${pageContext.request.contextPath}/product?action=detail&slug=${product.slug}" 
                                               class="hover:text-accent transition-colors">
                                                ${product.name}
                                            </a>
                                        </h3>
                                        
                                        <!-- Category -->
                                        <p class="text-sm text-gray-600 mb-2">${product.categoryName}</p>
                                        
                                        <!-- Price -->
                                        <div class="flex items-center space-x-2">
                                            <c:choose>
                                                <c:when test="${product.discountPrice > 0}">
                                                    <span class="text-lg font-semibold text-accent">
                                                        <fmt:formatNumber value="${product.discountPrice}" pattern="#,###"/>₫
                                                    </span>
                                                    <span class="text-sm text-gray-500 line-through">
                                                        <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-lg font-semibold text-accent">
                                                        <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Stock Status -->
                                        <div class="mt-2">
                                            <c:choose>
                                                <c:when test="${product.stockQuantity > 10}">
                                                    <span class="text-sm text-green-600">Còn hàng</span>
                                                </c:when>
                                                <c:when test="${product.stockQuantity > 0}">
                                                    <span class="text-sm text-orange-600">Còn ${product.stockQuantity} sản phẩm</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-red-600">Hết hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="flex justify-center mt-8">
                                <nav class="flex items-center space-x-2">
                                    <!-- Previous -->
                                    <c:if test="${currentPage > 1}">
                                        <a href="?${pageContext.request.queryString.replaceAll('page=\\d+', '')}&page=${currentPage - 1}" 
                                           class="px-3 py-2 text-gray-500 hover:text-accent border border-gray-300 rounded-lg hover:border-accent">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </c:if>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <c:choose>
                                            <c:when test="${pageNum == currentPage}">
                                                <span class="px-3 py-2 bg-accent text-white border border-accent rounded-lg">
                                                    ${pageNum}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?${pageContext.request.queryString.replaceAll('page=\\d+', '')}&page=${pageNum}" 
                                                   class="px-3 py-2 text-gray-500 hover:text-accent border border-gray-300 rounded-lg hover:border-accent">
                                                    ${pageNum}
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next -->
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?${pageContext.request.queryString.replaceAll('page=\\d+', '')}&page=${currentPage + 1}" 
                                           class="px-3 py-2 text-gray-500 hover:text-accent border border-gray-300 rounded-lg hover:border-accent">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </nav>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="text-center py-16">
                            <i class="fas fa-search text-6xl text-gray-300 mb-4"></i>
                            <h3 class="text-xl font-medium text-gray-900 mb-2">Không tìm thấy sản phẩm</h3>
                            <p class="text-gray-600 mb-6">Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm khác</p>
                            <a href="${pageContext.request.contextPath}/product" 
                               class="inline-block bg-accent text-white px-6 py-2 rounded-lg font-medium hover:bg-yellow-600 transition-colors">
                                Xem tất cả sản phẩm
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-primary text-white mt-16">
        <div class="container mx-auto px-4 py-12">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <!-- Company Info -->
                <div>
                    <h3 class="text-xl font-bold mb-4">BAMA BAG</h3>
                    <p class="text-gray-300 mb-4">Chuyên cung cấp balo, túi xách chất lượng cao với thiết kế hiện đại và giá cả hợp lý.</p>
                    <div class="flex space-x-4">
                        <a href="#" class="text-gray-300 hover:text-accent"><i class="fab fa-facebook text-xl"></i></a>
                        <a href="#" class="text-gray-300 hover:text-accent"><i class="fab fa-instagram text-xl"></i></a>
                        <a href="#" class="text-gray-300 hover:text-accent"><i class="fab fa-tiktok text-xl"></i></a>
                    </div>
                </div>

                <!-- Quick Links -->
                <div>
                    <h4 class="font-semibold mb-4">Liên kết nhanh</h4>
                    <ul class="space-y-2">
                        <li><a href="${pageContext.request.contextPath}/home" class="text-gray-300 hover:text-accent">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/product" class="text-gray-300 hover:text-accent">Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/category" class="text-gray-300 hover:text-accent">Danh mục</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-accent">Liên hệ</a></li>
                    </ul>
                </div>

                <!-- Customer Service -->
                <div>
                    <h4 class="font-semibold mb-4">Hỗ trợ khách hàng</h4>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-gray-300 hover:text-accent">Chính sách đổi trả</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-accent">Chính sách vận chuyển</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-accent">Chính sách thanh toán</a></li>
                        <li><a href="#" class="text-gray-300 hover:text-accent">Hướng dẫn mua hàng</a></li>
                    </ul>
                </div>

                <!-- Contact Info -->
                <div>
                    <h4 class="font-semibold mb-4">Thông tin liên hệ</h4>
                    <div class="space-y-2 text-gray-300">
                        <p><i class="fas fa-phone mr-2"></i> 0705.777.760</p>
                        <p><i class="fas fa-envelope mr-2"></i> bama.bags@gmail.com</p>
                        <p><i class="fas fa-map-marker-alt mr-2"></i> Việt Nam</p>
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
        // Apply filters
        function applyFilters() {
            const categoryFilter = document.querySelector('input[name="category"]:checked').value;
            const priceFilter = document.querySelector('input[name="priceRange"]:checked').value;
            
            let url = new URL(window.location.href);
            url.searchParams.set('action', 'filter');
            
            if (categoryFilter !== 'all') {
                url.searchParams.set('categoryId', categoryFilter);
            } else {
                url.searchParams.delete('categoryId');
            }
            
            if (priceFilter !== 'all') {
                const [minPrice, maxPrice] = priceFilter.split('-');
                url.searchParams.set('minPrice', minPrice);
                url.searchParams.set('maxPrice', maxPrice);
            } else {
                url.searchParams.delete('minPrice');
                url.searchParams.delete('maxPrice');
            }
            
            url.searchParams.set('page', '1'); // Reset to first page
            window.location.href = url.toString();
        }

        // Apply sorting
        function applySorting() {
            const sortValue = document.getElementById('sortSelect').value;
            let url = new URL(window.location.href);
            url.searchParams.set('action', 'filter');
            url.searchParams.set('sort', sortValue);
            url.searchParams.set('page', '1'); // Reset to first page
            window.location.href = url.toString();
        }

        // Add to cart
        function addToCart(productId) {
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: `action=add&productId=${productId}&quantity=1`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update cart count
                    document.getElementById('cart-count').textContent = data.cartCount;
                    
                    // Show success message
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

        // Show notification
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 z-50 px-6 py-3 rounded-lg text-white font-medium ${
                type === 'success' ? 'bg-green-500' : 'bg-red-500'
            } transform translate-x-full transition-transform duration-300`;
            notification.textContent = message;
            
            document.body.appendChild(notification);
            
            // Show notification
            setTimeout(() => {
                notification.classList.remove('translate-x-full');
            }, 100);
            
            // Hide notification
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
