
<%@page import="com.entity.FashionDtls"%>
<%@page import="java.util.List"%>
<%@page import="com.entity.User"%>
<%@page import="com.DB.DBConnect"%>
<%@page import="com.DAO.FashionDAOImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>User : Old Fashion</title>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<%@include file="all_component/allCss.jsp"%>
</head>

<style>
table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	padding: 8px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	font-size: 25px;
	color: black !important;
	font-weight: 700 !important;
	font-family: 'Roboto', sans-serif;
	font-weight: 500;
}

}
td {
	font-family: 'Roboto', sans-serif !important;
	color: black !important;
	font-size: 18px !important;
}

.quantity{
	text-align:center;
}
</style>

<body>
	<%@include file="all_component/navbar.jsp"%>
	
	<div class="user-content-main">
	<%@include file="all_component/nav-user-page.jsp"%>
	<c:if test="${not empty succMsg }">
		<div class="alert alert-success text-center">${succMsg}</div>
		<c:remove var="succMsg" scope="session" />
	</c:if>

	<div class="user-content">
		<table>
			<thead>
				<tr>
					<th scope="col" class="text-uppercase">Product</th>
					<th scope="col" class="text-uppercase">Category</th>
					<th scope="col" class="text-uppercase">Price</th>
					<th scope="col" class="text-uppercase text-center">Quantity</th>
				</tr>
			</thead>
			<tbody>
				<%
				User u = (User) session.getAttribute("userobj");
				String email = u.getEmail();
				int count = 1 ;
				FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
				List<FashionDtls> list = dao.getFashionByOld(email, "Cũ");
				for (FashionDtls b : list) {
				%>
				<tr>
					<td style="font-family:'Roboto',san-serif; font-weight:650;"><%=b.getFashionName()%>, Size: <%=b.getSize()%></td>
					<td style="font-family:'Roboto',san-serif; font-weight:650; color:rgba(0,0,0,0.5)"><%=b.getFashionCategory()%></td>
					<td style="color:#ff0000;font-weight:600;"><%=b.getPrice()%></td>
					<td class="quantity" style="font-family:'Roboto',san-serif; font-weight:650;"><span style="border:2px solid #ccc; padding:4px 6px;"><%=b.getQuantity() %></span><a
						href="delete_old_fashion?em=<%=email%>&&id=<%=b.getFashionId()%>"
						class="trash"><i class="fa-solid fa-trash"></i></a></td>
				</tr>
				<%
				count++;
				}
				%>
			</tbody>
		</table>
	</div>
	</div>
	<%@include file="all_component/footer.jsp"%>
</body>

<script>
	const items = document.querySelectorAll('.nav-ver.nav-link') ;
	items[4].classList.add('active');
	const text = document.querySelector('.nav-ver.nav-link.active').innerHTML;
	document.getElementById('direction').innerHTML = text;
</script>
</html>
