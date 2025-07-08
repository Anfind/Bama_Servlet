<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - BagStore Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
<body class="bg-gray-100">
    <!-- Header -->
    <header class="bg-white shadow-md">
        <div class="flex items-center justify-between px-6 py-4">
            <div class="flex items-center">
                <button id="sidebar-toggle" class="text-gray-500 hover:text-gray-700 lg:hidden">
                    <i class="fas fa-bars text-xl"></i>
                </button>
                <h1 class="text-2xl font-bold text-bama-orange ml-4 lg:ml-0">
                    <i class="fas fa-tachometer-alt mr-2"></i>BagStore Admin
                </h1>
            </div>
            
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <button class="text-gray-500 hover:text-gray-700">
                        <i class="fas fa-bell text-xl"></i>
                        <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">3</span>
                    </button>
                </div>
                
                <div class="relative">
                    <button class="flex items-center text-gray-700 hover:text-gray-900">
                        <img src="https://via.placeholder.com/32" alt="Admin" class="w-8 h-8 rounded-full mr-2">
                        <span class="font-medium">${sessionScope.user.fullName}</span>
                        <i class="fas fa-chevron-down ml-1"></i>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <div class="flex">
        <!-- Sidebar -->
        <aside id="sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-bama-dark text-white transform -translate-x-full transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0">
            <div class="flex items-center justify-center h-16 bg-bama-orange">
                <h2 class="text-xl font-bold">Admin Panel</h2>
            </div>
            
            <nav class="mt-8">
                <a href="${pageContext.request.contextPath}/admin" class="flex items-center px-6 py-3 bg-bama-orange text-white">
                    <i class="fas fa-dashboard w-5 h-5 mr-3"></i>
                    Dashboard
                </a>
                
                <a href="${pageContext.request.contextPath}/admin?section=products" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                    <i class="fas fa-box w-5 h-5 mr-3"></i>
                    Sản phẩm
                    <span class="ml-auto bg-blue-500 text-xs px-2 py-1 rounded-full">${productCount}</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin?section=categories" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                    <i class="fas fa-tags w-5 h-5 mr-3"></i>
                    Danh mục
                </a>
                
                <a href="${pageContext.request.contextPath}/admin?section=orders" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                    <i class="fas fa-shopping-cart w-5 h-5 mr-3"></i>
                    Đơn hàng
                    <span class="ml-auto bg-red-500 text-xs px-2 py-1 rounded-full">${pendingOrderCount}</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/admin?section=users" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                    <i class="fas fa-users w-5 h-5 mr-3"></i>
                    Khách hàng
                </a>
                
                <a href="${pageContext.request.contextPath}/admin?section=reports" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                    <i class="fas fa-chart-line w-5 h-5 mr-3"></i>
                    Báo cáo
                </a>
                
                <div class="border-t border-gray-600 mt-8">
                    <a href="${pageContext.request.contextPath}/admin?section=settings" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                        <i class="fas fa-cog w-5 h-5 mr-3"></i>
                        Cài đặt
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="flex items-center px-6 py-3 hover:bg-gray-700 transition">
                        <i class="fas fa-sign-out-alt w-5 h-5 mr-3"></i>
                        Đăng xuất
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 lg:ml-0">
            <div class="p-6">
                <!-- Welcome Banner -->
                <div class="bg-gradient-to-r from-bama-orange to-orange-600 rounded-lg p-6 text-white mb-8">
                    <h2 class="text-2xl font-bold mb-2">Chào mừng trở lại, ${sessionScope.user.fullName}!</h2>
                    <p class="opacity-90">Đây là bảng điều khiển quản trị BagStore. Theo dõi các thống kê và quản lý cửa hàng của bạn.</p>
                </div>

                <!-- Stats Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <!-- Total Revenue -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center">
                            <div class="p-3 bg-green-100 rounded-full">
                                <i class="fas fa-dollar-sign text-green-600 text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Doanh thu tháng này</p>
                                <p class="text-2xl font-bold text-gray-900">
                                    <fmt:formatNumber value="${monthlyRevenue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                </p>
                            </div>
                        </div>
                        <div class="mt-4">
                            <span class="text-green-500 text-sm font-medium">+12.5%</span>
                            <span class="text-gray-500 text-sm"> so với tháng trước</span>
                        </div>
                    </div>

                    <!-- Total Orders -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center">
                            <div class="p-3 bg-blue-100 rounded-full">
                                <i class="fas fa-shopping-cart text-blue-600 text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Đơn hàng hôm nay</p>
                                <p class="text-2xl font-bold text-gray-900">${todayOrderCount}</p>
                            </div>
                        </div>
                        <div class="mt-4">
                            <span class="text-blue-500 text-sm font-medium">+8.2%</span>
                            <span class="text-gray-500 text-sm"> so với hôm qua</span>
                        </div>
                    </div>

                    <!-- Total Products -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center">
                            <div class="p-3 bg-purple-100 rounded-full">
                                <i class="fas fa-box text-purple-600 text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Tổng sản phẩm</p>
                                <p class="text-2xl font-bold text-gray-900">${totalProducts}</p>
                            </div>
                        </div>
                        <div class="mt-4">
                            <span class="text-purple-500 text-sm font-medium">${outOfStockCount}</span>
                            <span class="text-gray-500 text-sm"> sản phẩm hết hàng</span>
                        </div>
                    </div>

                    <!-- Total Customers -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <div class="flex items-center">
                            <div class="p-3 bg-yellow-100 rounded-full">
                                <i class="fas fa-users text-yellow-600 text-xl"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Khách hàng mới</p>
                                <p class="text-2xl font-bold text-gray-900">${newCustomersCount}</p>
                            </div>
                        </div>
                        <div class="mt-4">
                            <span class="text-yellow-500 text-sm font-medium">+15.3%</span>
                            <span class="text-gray-500 text-sm"> so với tuần trước</span>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                    <!-- Revenue Chart -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">Doanh thu 7 ngày qua</h3>
                        <canvas id="revenueChart" height="300"></canvas>
                    </div>

                    <!-- Order Status Chart -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h3 class="text-lg font-semibold text-gray-800 mb-4">Trạng thái đơn hàng</h3>
                        <canvas id="orderStatusChart" height="300"></canvas>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="bg-white rounded-lg shadow-md">
                    <div class="flex items-center justify-between p-6 border-b">
                        <h3 class="text-lg font-semibold text-gray-800">Đơn hàng gần đây</h3>
                        <a href="${pageContext.request.contextPath}/admin?section=orders" 
                           class="text-bama-orange hover:underline">Xem tất cả</a>
                    </div>
                    
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mã đơn hàng</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Khách hàng</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tổng tiền</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Trạng thái</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ngày đặt</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="order" items="${recentOrders}" varStatus="status">
                                    <tr class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="text-sm font-medium text-bama-orange">#${order.orderCode}</span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">${order.customerName}</div>
                                            <div class="text-sm text-gray-500">${order.customerEmail}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="text-sm font-semibold text-gray-900">
                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
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
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/admin?section=orders&action=view&id=${order.id}" 
                                               class="text-bama-orange hover:text-orange-600 mr-3">Xem</a>
                                            <c:if test="${order.status == 'PENDING'}">
                                                <button onclick="updateOrderStatus('${order.id}', 'CONFIRMED')" 
                                                        class="text-green-600 hover:text-green-800">Xác nhận</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
                    <a href="${pageContext.request.contextPath}/admin?section=products&action=add" 
                       class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition text-center">
                        <div class="w-12 h-12 bg-bama-orange rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-plus text-white text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Thêm sản phẩm</h4>
                        <p class="text-gray-600 text-sm">Thêm sản phẩm mới vào cửa hàng</p>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/admin?section=orders" 
                       class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition text-center">
                        <div class="w-12 h-12 bg-blue-500 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-list text-white text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Quản lý đơn hàng</h4>
                        <p class="text-gray-600 text-sm">Xem và xử lý đơn hàng</p>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/admin?section=reports" 
                       class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition text-center">
                        <div class="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-chart-bar text-white text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Xem báo cáo</h4>
                        <p class="text-gray-600 text-sm">Phân tích doanh thu và hiệu suất</p>
                    </a>
                </div>
            </div>
        </main>
    </div>

    <!-- Overlay for mobile sidebar -->
    <div id="sidebar-overlay" class="fixed inset-0 bg-black opacity-50 z-40 lg:hidden hidden"></div>

    <script>
        // Sidebar toggle for mobile
        const sidebarToggle = document.getElementById('sidebar-toggle');
        const sidebar = document.getElementById('sidebar');
        const sidebarOverlay = document.getElementById('sidebar-overlay');

        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('-translate-x-full');
            sidebarOverlay.classList.toggle('hidden');
        });

        sidebarOverlay.addEventListener('click', () => {
            sidebar.classList.add('-translate-x-full');
            sidebarOverlay.classList.add('hidden');
        });

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: [1200000, 1900000, 3000000, 5000000, 2000000, 3000000, 4500000],
                    borderColor: '#ff6b35',
                    backgroundColor: 'rgba(255, 107, 53, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(value);
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });

        // Order Status Chart
        const orderStatusCtx = document.getElementById('orderStatusChart').getContext('2d');
        new Chart(orderStatusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Chờ xử lý', 'Đã xác nhận', 'Đang chuẩn bị', 'Đang giao', 'Đã giao'],
                datasets: [{
                    data: [12, 19, 3, 8, 25],
                    backgroundColor: [
                        '#FCD34D',
                        '#60A5FA',
                        '#A78BFA',
                        '#FB923C',
                        '#34D399'
                    ],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Update order status function
        function updateOrderStatus(orderId, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng?')) {
                fetch('${pageContext.request.contextPath}/admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=updateOrderStatus&orderId=' + orderId + '&status=' + status
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra!');
                });
            }
        }
    </script>
</body>
</html>
