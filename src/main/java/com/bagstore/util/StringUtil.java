package com.bagstore.util;

import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

public class StringUtil {

    /**
     * Generate a slug from a string (for URLs)
     * 
     * @param input The input string
     * @return A URL-friendly slug
     */
    public static String generateSlug(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }

        // Normalize and remove accents
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        String withoutAccents = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        // Convert to lowercase and replace spaces/special chars with hyphens
        String slug = withoutAccents.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");

        return slug;
    }

    /**
     * Generate a unique order number
     * 
     * @return A unique order number
     */
    public static String generateOrderNumber() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String datePart = dateFormat.format(new Date());

        Random random = new Random();
        int randomPart = random.nextInt(9999) + 1000;

        return "BAG" + datePart + randomPart;
    }

    /**
     * Truncate text to specified length
     * 
     * @param text      The text to truncate
     * @param maxLength Maximum length
     * @return Truncated text with ellipsis if needed
     */
    public static String truncateText(String text, int maxLength) {
        if (text == null || text.length() <= maxLength) {
            return text;
        }
        return text.substring(0, maxLength - 3) + "...";
    }

    /**
     * Check if a string is null or empty
     * 
     * @param str The string to check
     * @return true if string is null or empty
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Check if a string is not null and not empty
     * 
     * @param str The string to check
     * @return true if string is not null and not empty
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    /**
     * Capitalize first letter of each word
     * 
     * @param input The input string
     * @return Capitalized string
     */
    public static String capitalizeWords(String input) {
        if (isEmpty(input)) {
            return input;
        }

        String[] words = input.split("\\s+");
        StringBuilder result = new StringBuilder();

        for (String word : words) {
            if (!word.isEmpty()) {
                result.append(Character.toUpperCase(word.charAt(0)))
                        .append(word.substring(1).toLowerCase())
                        .append(" ");
            }
        }

        return result.toString().trim();
    }

    /**
     * Format price for display
     * 
     * @param price The price value
     * @return Formatted price string
     */
    public static String formatPrice(java.math.BigDecimal price) {
        if (price == null) {
            return "0 ₫";
        }

        java.text.DecimalFormat formatter = new java.text.DecimalFormat("#,###");
        return formatter.format(price) + " ₫";
    }
}
