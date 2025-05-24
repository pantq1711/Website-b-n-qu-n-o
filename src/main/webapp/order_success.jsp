<%-- 
    Document   : User_address
    Created on : Nov 12, 2023, 11:27:16?AM
    Author     : Anphan
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>JSP Page</title>
        <%@include file="all_component/allCss.jsp" %>
    </head>
    
    <body style="background-color: #f0f1f2;">
	<%@include file="all_component/navbar.jsp" %>
        
        <div class="container text-center md-3" style="position:relative;top:80px;">
        
            <i class="fas fa-check-circle fa-5x text-success"></i>
            <h1>Cảm ơn bạn</h1>
            <h2>Đơn hàng đã được đặt thành công </h2>
            <h5> Trong vòng 7 ngày đơn hàng sẽ được vận chuyển đến bạn </h5>
            <a href="index.jsp" class="btn btn-primary mt-3">Home</a> 
            <a href="order.jsp" class="btn btn-danger mt-3">View Order</a>
        </div>
    </body>
</html>
