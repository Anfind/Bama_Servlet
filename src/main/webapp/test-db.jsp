<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    
    <%
    Connection conn = null;
    try {
        // Test JNDI DataSource
        Context ctx = new InitialContext();
        DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/bagstore");
        conn = ds.getConnection();
        
        out.println("<p style='color: green;'>✓ Database connection successful!</p>");
        
        // Test query
        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM products");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            out.println("<p>Total products: " + count + "</p>");
        }
        
        ps = conn.prepareStatement("SELECT COUNT(*) FROM product_images");
        rs = ps.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            out.println("<p>Total product images: " + count + "</p>");
        }
        
        ps.close();
        
    } catch (Exception e) {
        out.println("<p style='color: red;'>✗ Database connection failed: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // ignore
            }
        }
    }
    %>
    
    <p><a href="debug.jsp">← Back to Debug</a></p>
    <p><a href="./">← Home</a></p>
</body>
</html>
