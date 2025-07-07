package com.bagstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class FileUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images";
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String uploadType = request.getParameter("type"); // "product", "category", "avatar"
            if (uploadType == null) {
                uploadType = "product";
            }

            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                sendErrorResponse(response, "Không có file được chọn");
                return;
            }

            // Validate file
            String fileName = filePart.getSubmittedFileName();
            if (!isValidFile(fileName, filePart.getSize())) {
                sendErrorResponse(response, "File không hợp lệ hoặc quá lớn");
                return;
            }

            // Generate unique filename
            String fileExtension = getFileExtension(fileName);
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

            // Determine upload directory
            String uploadSubDir = getUploadSubDirectory(uploadType);
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR + File.separator
                    + uploadSubDir;

            // Create directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save file
            Path filePath = Paths.get(uploadPath, uniqueFileName);
            try (var inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Return success response
            String relativePath = UPLOAD_DIR + "/" + uploadSubDir + "/" + uniqueFileName;
            sendSuccessResponse(response, relativePath, uniqueFileName);

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi khi upload file: " + e.getMessage());
        }
    }

    private boolean isValidFile(String fileName, long fileSize) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }

        // Check file size
        if (fileSize > MAX_FILE_SIZE) {
            return false;
        }

        // Check file extension
        String fileExtension = getFileExtension(fileName).toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (fileExtension.equals(allowedExt)) {
                return true;
            }
        }

        return false;
    }

    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            return fileName.substring(lastDotIndex);
        }
        return "";
    }

    private String getUploadSubDirectory(String uploadType) {
        switch (uploadType) {
            case "category":
                return "categories";
            case "avatar":
                return "avatars";
            case "product":
            default:
                return "products";
        }
    }

    private void sendSuccessResponse(HttpServletResponse response, String filePath, String fileName)
            throws IOException {

        String jsonResponse = String.format(
                "{\"success\": true, \"filePath\": \"%s\", \"fileName\": \"%s\"}",
                filePath, fileName);
        response.getWriter().write(jsonResponse);
    }

    private void sendErrorResponse(HttpServletResponse response, String message)
            throws IOException {

        String jsonResponse = String.format(
                "{\"success\": false, \"message\": \"%s\"}",
                message);
        response.getWriter().write(jsonResponse);
    }
}
