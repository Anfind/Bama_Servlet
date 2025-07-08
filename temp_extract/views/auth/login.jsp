<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - BagStore</title>
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
                    <a href="/BagStore/auth?action=register" class="text-gray-600 hover:text-accent">Đăng ký</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Login Form -->
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            <div>
                <div class="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-accent">
                    <i class="fas fa-user text-white text-xl"></i>
                </div>
                <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                    Đăng nhập vào tài khoản
                </h2>
                <p class="mt-2 text-center text-sm text-gray-600">
                    Hoặc
                    <a href="/BagStore/auth?action=register" class="font-medium text-accent hover:text-yellow-600">
                        tạo tài khoản mới
                    </a>
                </p>
            </div>
            
            <form class="mt-8 space-y-6" action="/BagStore/auth" method="post">
                <input type="hidden" name="action" value="login">
                <c:if test="${param.redirect != null}">
                    <input type="hidden" name="redirect" value="${param.redirect}">
                </c:if>
                
                <!-- Error Message -->
                <c:if test="${error != null}">
                    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
                        <i class="fas fa-exclamation-circle mr-2"></i>${error}
                    </div>
                </c:if>
                
                <!-- Success Message -->
                <c:if test="${success != null}">
                    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg">
                        <i class="fas fa-check-circle mr-2"></i>${success}
                    </div>
                </c:if>
                
                <div class="rounded-md shadow-sm -space-y-px">
                    <div>
                        <label for="username" class="sr-only">Tên đăng nhập</label>
                        <input id="username" name="username" type="text" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-accent focus:border-accent focus:z-10 sm:text-sm" 
                               placeholder="Tên đăng nhập" value="${username}">
                    </div>
                    <div>
                        <label for="password" class="sr-only">Mật khẩu</label>
                        <input id="password" name="password" type="password" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-accent focus:border-accent focus:z-10 sm:text-sm" 
                               placeholder="Mật khẩu">
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox" 
                               class="h-4 w-4 text-accent focus:ring-accent border-gray-300 rounded">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-900">
                            Ghi nhớ đăng nhập
                        </label>
                    </div>

                    <div class="text-sm">
                        <a href="#" class="font-medium text-accent hover:text-yellow-600">
                            Quên mật khẩu?
                        </a>
                    </div>
                </div>

                <div>
                    <button type="submit" 
                            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-accent hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-accent">
                        <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                            <i class="fas fa-lock h-5 w-5 text-yellow-200 group-hover:text-yellow-100"></i>
                        </span>
                        Đăng nhập
                    </button>
                </div>
                
                <div class="text-center">
                    <p class="text-sm text-gray-600">
                        Chưa có tài khoản?
                        <a href="/BagStore/auth?action=register" class="font-medium text-accent hover:text-yellow-600">
                            Đăng ký ngay
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
        // Auto focus on first input if no value
        document.addEventListener('DOMContentLoaded', function() {
            const usernameInput = document.getElementById('username');
            const passwordInput = document.getElementById('password');
            
            if (usernameInput.value === '') {
                usernameInput.focus();
            } else {
                passwordInput.focus();
            }
        });
    </script>
</body>
</html>
