<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Page</title>
</head>
<body>
    <h1>Debug Page</h1>
    <p>Current time: <%= new java.util.Date() %></p>
    <p>Context path: ${pageContext.request.contextPath}</p>
    <p>Test parameter: ${param.test}</p>
</body>
</html>
