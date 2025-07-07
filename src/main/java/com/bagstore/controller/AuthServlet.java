package com.bagstore.controller;

import com.bagstore.dao.UserDAO;
import com.bagstore.model.User;
import com.bagstore.util.DatabaseConnection;
import com.bagstore.util.PasswordUtil;
import com.bagstore.util.StringUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        // Initialize database connection if not already done
        DatabaseConnection.initialize(getServletContext());

        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "login";
        }

        switch (action) {
            case "login":
                showLoginPage(request, response);
                break;
            case "register":
                showRegisterPage(request, response);
                break;
            case "logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        switch (action) {
            case "login":
                processLogin(request, response);
                break;
            case "register":
                processRegister(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/");
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        // Validate input
        if (StringUtil.isEmpty(username) || StringUtil.isEmpty(password)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.setAttribute("username", username);
            showLoginPage(request, response);
            return;
        }

        try {
            // Authenticate user
            User user = userDAO.authenticateUser(username, password);

            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());

                // Redirect to intended page or home
                String redirectUrl = StringUtil.isNotEmpty(redirect) ? redirect : request.getContextPath() + "/";
                response.sendRedirect(redirectUrl);

            } else {
                // Login failed
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                request.setAttribute("username", username);
                showLoginPage(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error in login process: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập");
            request.setAttribute("username", username);
            showLoginPage(request, response);
        }
    }

    private void processRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validate input
        if (StringUtil.isEmpty(username) || StringUtil.isEmpty(email) ||
                StringUtil.isEmpty(password) || StringUtil.isEmpty(fullName)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
            setRegisterAttributes(request, username, email, fullName, phone, address);
            showRegisterPage(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            setRegisterAttributes(request, username, email, fullName, phone, address);
            showRegisterPage(request, response);
            return;
        }

        if (!PasswordUtil.isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số");
            setRegisterAttributes(request, username, email, fullName, phone, address);
            showRegisterPage(request, response);
            return;
        }

        try {
            // Check if username or email already exists
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại");
                setRegisterAttributes(request, username, email, fullName, phone, address);
                showRegisterPage(request, response);
                return;
            }

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email đã được sử dụng");
                setRegisterAttributes(request, username, email, fullName, phone, address);
                showRegisterPage(request, response);
                return;
            }

            // Create new user
            User user = new User(username, email, password, fullName);
            user.setPhone(phone);
            user.setAddress(address);

            if (userDAO.createUser(user)) {
                // Registration successful
                request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                showLoginPage(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký");
                setRegisterAttributes(request, username, email, fullName, phone, address);
                showRegisterPage(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error in registration process: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký");
            setRegisterAttributes(request, username, email, fullName, phone, address);
            showRegisterPage(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private void setRegisterAttributes(HttpServletRequest request, String username, String email,
            String fullName, String phone, String address) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("fullName", fullName);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
    }
}
