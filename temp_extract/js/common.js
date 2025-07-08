// BagStore Common JavaScript Functions

// Utility functions
const BagStore = {
    // Configuration
    config: {
        contextPath: '', // Will be set dynamically
        apiEndpoint: '',
        version: '1.0.0'
    },

    // Initialize the application
    init: function() {
        this.setupEventListeners();
        this.setupAjax();
        this.setupNotifications();
        console.log('BagStore initialized');
    },

    // Setup global event listeners
    setupEventListeners: function() {
        // Mobile menu toggle
        const mobileMenuBtn = document.querySelector('[data-mobile-menu]');
        const mobileMenu = document.querySelector('.mobile-menu');
        
        if (mobileMenuBtn && mobileMenu) {
            mobileMenuBtn.addEventListener('click', function() {
                mobileMenu.classList.toggle('open');
            });
        }

        // Close mobile menu when clicking outside
        document.addEventListener('click', function(e) {
            if (mobileMenu && !mobileMenu.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
                mobileMenu.classList.remove('open');
            }
        });

        // Image lazy loading
        this.setupLazyLoading();

        // Form validation
        this.setupFormValidation();
    },

    // Setup AJAX defaults
    setupAjax: function() {
        // Add CSRF token to all AJAX requests if available
        const csrfToken = document.querySelector('meta[name="csrf-token"]');
        if (csrfToken) {
            // Setup for jQuery if available
            if (typeof $ !== 'undefined') {
                $.ajaxSetup({
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-CSRF-Token', csrfToken.getAttribute('content'));
                    }
                });
            }
        }
    },

    // Notification system
    setupNotifications: function() {
        // Auto-hide notifications after 5 seconds
        const notifications = document.querySelectorAll('.notification');
        notifications.forEach(notification => {
            setTimeout(() => {
                this.hideNotification(notification);
            }, 5000);
        });
    },

    // Show notification
    showNotification: function(message, type = 'success', duration = 5000) {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <div class="flex items-center">
                <i class="fas ${this.getNotificationIcon(type)} mr-2"></i>
                <span>${message}</span>
                <button onclick="BagStore.hideNotification(this.parentElement.parentElement)" class="ml-4 text-white hover:text-gray-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            this.hideNotification(notification);
        }, duration);
        
        return notification;
    },

    // Hide notification
    hideNotification: function(notification) {
        if (notification && notification.parentElement) {
            notification.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => {
                notification.remove();
            }, 300);
        }
    },

    // Get notification icon based on type
    getNotificationIcon: function(type) {
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-exclamation-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };
        return icons[type] || icons.info;
    },

    // Cart functionality
    cart: {
        // Add item to cart
        addItem: function(productId, quantity = 1) {
            const data = new FormData();
            data.append('action', 'add');
            data.append('productId', productId);
            data.append('quantity', quantity);

            return fetch(BagStore.config.contextPath + '/cart', {
                method: 'POST',
                body: data
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    BagStore.showNotification('Đã thêm sản phẩm vào giỏ hàng!', 'success');
                    BagStore.cart.updateCartCount(data.cartItemCount);
                } else {
                    BagStore.showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
                return data;
            })
            .catch(error => {
                console.error('Error:', error);
                BagStore.showNotification('Có lỗi xảy ra!', 'error');
                throw error;
            });
        },

        // Update cart item quantity
        updateItem: function(productId, quantity) {
            const data = new FormData();
            data.append('action', 'update');
            data.append('productId', productId);
            data.append('quantity', quantity);

            return fetch(BagStore.config.contextPath + '/cart', {
                method: 'POST',
                body: data
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    BagStore.cart.updateCartCount(data.cartItemCount);
                    // Update cart total if on cart page
                    BagStore.cart.updateCartTotal(data.cartTotal);
                } else {
                    BagStore.showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
                return data;
            })
            .catch(error => {
                console.error('Error:', error);
                BagStore.showNotification('Có lỗi xảy ra!', 'error');
                throw error;
            });
        },

        // Remove item from cart
        removeItem: function(productId) {
            const data = new FormData();
            data.append('action', 'remove');
            data.append('productId', productId);

            return fetch(BagStore.config.contextPath + '/cart', {
                method: 'POST',
                body: data
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    BagStore.showNotification('Đã xóa sản phẩm khỏi giỏ hàng!', 'success');
                    BagStore.cart.updateCartCount(data.cartItemCount);
                    BagStore.cart.updateCartTotal(data.cartTotal);
                } else {
                    BagStore.showNotification(data.message || 'Có lỗi xảy ra!', 'error');
                }
                return data;
            })
            .catch(error => {
                console.error('Error:', error);
                BagStore.showNotification('Có lỗi xảy ra!', 'error');
                throw error;
            });
        },

        // Update cart count in header
        updateCartCount: function(count) {
            const cartCountElements = document.querySelectorAll('#cart-count, .cart-count');
            cartCountElements.forEach(element => {
                element.textContent = count;
                element.style.display = count > 0 ? 'inline' : 'none';
            });
        },

        // Update cart total
        updateCartTotal: function(total) {
            const cartTotalElements = document.querySelectorAll('.cart-total');
            cartTotalElements.forEach(element => {
                element.textContent = BagStore.formatCurrency(total);
            });
        }
    },

    // Utility functions
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    },

    formatNumber: function(number) {
        return new Intl.NumberFormat('vi-VN').format(number);
    },

    // Setup lazy loading for images
    setupLazyLoading: function() {
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.classList.remove('lazy');
                        imageObserver.unobserve(img);
                    }
                });
            });

            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        }
    },

    // Setup form validation
    setupFormValidation: function() {
        const forms = document.querySelectorAll('form[data-validate]');
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                if (!BagStore.validateForm(this)) {
                    e.preventDefault();
                }
            });
        });
    },

    // Validate form
    validateForm: function(form) {
        let isValid = true;
        const requiredFields = form.querySelectorAll('[required]');
        
        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                BagStore.showFieldError(field, 'Trường này là bắt buộc');
                isValid = false;
            } else {
                BagStore.clearFieldError(field);
            }
        });

        // Email validation
        const emailFields = form.querySelectorAll('input[type="email"]');
        emailFields.forEach(field => {
            if (field.value && !BagStore.isValidEmail(field.value)) {
                BagStore.showFieldError(field, 'Email không hợp lệ');
                isValid = false;
            }
        });

        // Phone validation
        const phoneFields = form.querySelectorAll('input[type="tel"]');
        phoneFields.forEach(field => {
            if (field.value && !BagStore.isValidPhone(field.value)) {
                BagStore.showFieldError(field, 'Số điện thoại không hợp lệ');
                isValid = false;
            }
        });

        return isValid;
    },

    // Show field error
    showFieldError: function(field, message) {
        field.classList.add('border-red-500');
        
        // Remove existing error
        const existingError = field.parentElement.querySelector('.field-error');
        if (existingError) {
            existingError.remove();
        }

        // Add error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'field-error text-red-500 text-sm mt-1';
        errorDiv.textContent = message;
        field.parentElement.appendChild(errorDiv);
    },

    // Clear field error
    clearFieldError: function(field) {
        field.classList.remove('border-red-500');
        const errorDiv = field.parentElement.querySelector('.field-error');
        if (errorDiv) {
            errorDiv.remove();
        }
    },

    // Validation helpers
    isValidEmail: function(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    isValidPhone: function(phone) {
        const phoneRegex = /^[\d\s\-\+\(\)]{10,15}$/;
        return phoneRegex.test(phone.replace(/\s/g, ''));
    },

    // Loading state
    showLoading: function(element) {
        if (element) {
            element.disabled = true;
            const originalText = element.innerHTML;
            element.setAttribute('data-original-text', originalText);
            element.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...';
        }
    },

    hideLoading: function(element) {
        if (element) {
            element.disabled = false;
            const originalText = element.getAttribute('data-original-text');
            if (originalText) {
                element.innerHTML = originalText;
                element.removeAttribute('data-original-text');
            }
        }
    },

    // Debounce function
    debounce: function(func, wait, immediate) {
        let timeout;
        return function executedFunction() {
            const context = this;
            const args = arguments;
            const later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            const callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    BagStore.init();
});

// Export for use in other scripts
window.BagStore = BagStore;
