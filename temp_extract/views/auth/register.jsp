<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - BagStore</title>
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
    <header class="bg-white shadow-sm">
        <div class="container mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <a href="/BagStore/" class="text-2xl font-bold text-primary">
                    <i class="fas fa-shopping-bag mr-2"></i>BagStore
                </a>
                <div class="flex items-center space-x-4">
                    <a href="/BagStore/" class="text-gray-600 hover:text-accent">Trang chủ</a>
                    <a href="/BagStore/auth?action=login" class="text-gray-600 hover:text-accent">Đăng nhập</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Register Form -->
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            <div>
                <div class="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-accent">
                    <i class="fas fa-user-plus text-white text-xl"></i>
                </div>
                <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                    Tạo tài khoản mới
                </h2>
                <p class="mt-2 text-center text-sm text-gray-600">
                    Hoặc
                    <a href="/BagStore/auth?action=login" class="font-medium text-accent hover:text-yellow-600">
                        đăng nhập nếu đã có tài khoản
                    </a>
                </p>
            </div>
            
            <form class="mt-8 space-y-6" action="/BagStore/auth" method="post" id="registerForm">
                <input type="hidden" name="action" value="register">
                
                <!-- Error Message -->
                <c:if test="${error != null}">
                    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
                        <i class="fas fa-exclamation-circle mr-2"></i>${error}
                    </div>
                </c:if>
                
                <div class="space-y-4">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700">Tên đăng nhập *</label>
                        <input id="username" name="username" type="text" required 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập tên đăng nhập" value="${username}">
                    </div>
                    
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700">Email *</label>
                        <input id="email" name="email" type="email" required 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập địa chỉ email" value="${email}">
                    </div>
                    
                    <div>
                        <label for="fullName" class="block text-sm font-medium text-gray-700">Họ và tên *</label>
                        <input id="fullName" name="fullName" type="text" required 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập họ và tên đầy đủ" value="${fullName}">
                    </div>
                    
                    <div>
                        <label for="phone" class="block text-sm font-medium text-gray-700">Số điện thoại</label>
                        <input id="phone" name="phone" type="tel" 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập số điện thoại" value="${phone}">
                    </div>
                    
                    <div>
                        <label for="address" class="block text-sm font-medium text-gray-700">Địa chỉ</label>
                        <textarea id="address" name="address" rows="2"
                                  class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                                  placeholder="Nhập địa chỉ">${address}</textarea>
                    </div>
                    
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700">Mật khẩu *</label>
                        <input id="password" name="password" type="password" required 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
                        <p class="mt-1 text-xs text-gray-500">Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số</p>
                    </div>
                    
                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700">Xác nhận mật khẩu *</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" required 
                               class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-accent focus:border-accent sm:text-sm" 
                               placeholder="Nhập lại mật khẩu">
                        <p id="passwordError" class="mt-1 text-xs text-red-500 hidden">Mật khẩu xác nhận không khớp</p>
                    </div>
                </div>

                <div class="flex items-center">
                    <input id="agree-terms" name="agree-terms" type="checkbox" required
                           class="h-4 w-4 text-accent focus:ring-accent border-gray-300 rounded">
                    <label for="agree-terms" class="ml-2 block text-sm text-gray-900">
                        Tôi đồng ý với 
                        <a href="#" class="text-accent hover:text-yellow-600">điều khoản sử dụng</a> 
                        và 
                        <a href="#" class="text-accent hover:text-yellow-600">chính sách bảo mật</a>
                    </label>
                </div>

                <div>
                    <button type="submit" 
                            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-accent hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-accent">
                        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                            <i class="fas fa-user-plus h-5 w-5 text-yellow-200 group-hover:text-yellow-100"></i>
                        </span>
                        Đăng ký
                    </button>
                </div>
                
                <div class="text-center">
                    <p class="text-sm text-gray-600">
                        Đã có tài khoản?
                        <a href="/BagStore/auth?action=login" class="font-medium text-accent hover:text-yellow-600">
                            Đăng nhập ngay
                        </a>
                    </p>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-8">
        <div class="container mx-auto px-4 text-center">
            <p>&copy; 2025 BagStore. Tất cả quyền được bảo lưu.</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('registerForm');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const passwordError = document.getElementById('passwordError');
            
            // Check password match
            function checkPasswordMatch() {
                if (confirmPassword.value !== '' && password.value !== confirmPassword.value) {
                    passwordError.classList.remove('hidden');
                    confirmPassword.classList.add('border-red-500');
                } else {
                    passwordError.classList.add('hidden');
                    confirmPassword.classList.remove('border-red-500');
                }
            }
            
            confirmPassword.addEventListener('input', checkPasswordMatch);
            password.addEventListener('input', function() {
                if (confirmPassword.value !== '') {
                    checkPasswordMatch();
                }
            });
            
            // Form validation
            form.addEventListener('submit', function(e) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    checkPasswordMatch();
                    confirmPassword.focus();
                    return false;
                }
                
                if (password.value.length < 6) {
                    e.preventDefault();
                    alert('Mật khẩu phải có ít nhất 6 ký tự');
                    password.focus();
                    return false;
                }
            });
            
            // Auto focus on first empty input
            const inputs = form.querySelectorAll('input[required]');
            for (let input of inputs) {
                if (input.value === '') {
                    input.focus();
                    break;
                }
            }
        });
    </script>
</body>
</html>
