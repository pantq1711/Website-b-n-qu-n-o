<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>JSP Page</title>
<%@include file="all_component/allCss.jsp"%>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<style type="text/css">
a {
	text-decoration: none;
	color: black;
}

a:hover {
	text-decoration: none;
}

.user-content .report span{
	font-weight:600 ;
	font-style:italic ;
}
</style>
</head>
<body style="background-color: white;">

	<c:if test="${empty userobj}">
		<c:redirect url="login.jsp" />
	</c:if>
	<%@include file="all_component/navbar.jsp"%>
	<div class="user-content-main">
	<%@include file="all_component/nav-user-page.jsp" %>
	<div class="user-content">
		<div class="report">
			<p>Xin chào <span>${userobj.name }</span> (không phải tài khoản <span>${userobj.name} </span>? Hãy thoát ra và đăng nhập vào tài khoản của bạn) 
			<p class="instruction" style="margin-top:30px;">Từ trang quản lý tài khoản bạn có thể xem đơn hàng mới, quản lý địa chỉ giao hàng và thanh toán, and sửa mật khẩu và thông tin tài khoản.</p>
		</div>
	</div>
	</div>
	<%@include file="all_component/footer.jsp"%>
</body>
</html>
