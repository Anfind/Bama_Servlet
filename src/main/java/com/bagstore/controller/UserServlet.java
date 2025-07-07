package com.bagstore.controller;

import com.bagstore.dao.UserDAO;
import com.bagstore.model.User;
import com.bagstore.model.Order;
import com.bagstore.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class UserServlet extends HttpServlet {
    private UserDAO userDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String section = request.getParameter("section");
        if (section == null) {
            section = "profile";
        }

        try {
            switch (section) {
                case "profile":
                    showProfile(request, response, user);
                    break;
                case "orders":
                    showOrders(request, response, user);
                    break;
                case "addresses":
                    showAddresses(request, response, user);
                    break;
                case "wishlist":
                    showWishlist(request, response, user);
                    break;
                case "password":
                    showPasswordChange(request, response, user);
                    break;
                default:
                    showProfile(request, response, user);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/error/500.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "updateProfile":
                    updateProfile(request, response, user);
                    break;
                case "changePassword":
                    changePassword(request, response, user);
                    break;
                case "addAddress":
                    addAddress(request, response, user);
                    break;
                case "deleteAddress":
                    deleteAddress(request, response, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/views/error/500.jsp").forward(request, response);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // Get updated user info from database
        User updatedUser = userDAO.findById(user.getId());
        if (updatedUser != null) {
            request.getSession().setAttribute("user", updatedUser);
        }

        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 10;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        String status = request.getParameter("status");

        // Get user orders with pagination
        List<Order> userOrders = orderDAO.findByUserId(user.getId(), page, pageSize, status);
        int totalOrders = orderDAO.countByUserId(user.getId(), status);
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        request.setAttribute("userOrders", userOrders);
        request.setAttribute("userOrderCount", totalOrders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void showAddresses(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // TODO: Implement address management
        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void showWishlist(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // TODO: Implement wishlist functionality
        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void showPasswordChange(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            // Get form data
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String address = request.getParameter("address");

            // Update user object
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setGender(gender);
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                // Parse date if needed
                // user.setDateOfBirth(java.sql.Date.valueOf(dateOfBirth));
            }
            user.setAddress(address);

            // Update in database
            boolean success = userDAO.update(user);

            if (success) {
                // Update session
                request.getSession().setAttribute("user", user);
                request.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Không thể cập nhật thông tin!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin!");
        }

        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate passwords
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới không khớp!");
                request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!userDAO.verifyPassword(user.getUsername(), currentPassword)) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
                request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
                return;
            }

            // Update password
            boolean success = userDAO.updatePassword(user.getId(), newPassword);

            if (success) {
                request.setAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("error", "Không thể đổi mật khẩu!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu!");
        }

        request.getRequestDispatcher("/views/user/account.jsp").forward(request, response);
    }

    private void addAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // TODO: Implement address addition
        response.sendRedirect(request.getContextPath() + "/user?section=addresses");
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // TODO: Implement address deletion
        response.sendRedirect(request.getContextPath() + "/user?section=addresses");
    }
}
