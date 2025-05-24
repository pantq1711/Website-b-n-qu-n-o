<%@page import="java.util.List"%>
<%@page import="com.entity.Fashion_Order"%>
<%@page import="com.DB.DBConnect"%>
<%@page import="com.DAO.FashionOrderDAOImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin: All Orders</title>
<%@include file="allCss.jsp"%>
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
	font-size: 18px;
	color: black !important;
	font-weight: 700 !important;
	font-family: 'Roboto', sans-serif;
	font-weight: 500;
}

}
td {
	font-family: 'Roboto', sans-serif !important;
	color: black !important;
	font-size: 16px !important;
}
</style>

<body>
	<c:if test="${empty userobj}">
		<c:redirect url="../login.jsp" />
	</c:if>
	<%@include file="navbar.jsp"%>
	<div class='dashboard'>
		<div class="dashboard-nav">
			<header>
				<a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a><a
					href="#" class="brand-logo"><i class="fa-regular fa-heart"></i><span
					class="brand">Menu</span></a>
			</header>
			<nav class="dashboard-nav-list">
				<a href="home.jsp" class="dashboard-nav-item"><i
					class="fas fa-home"></i> Home </a>
				<div class='dashboard-nav-dropdown'>
					<a href="#!"
						class="dashboard-nav-item dashboard-nav-dropdown-toggle"><i
						class="fas fa-tachometer-alt"></i>Dashboard</a>
					<div class='dashboard-nav-dropdown-menu'>
						<a href="bestSeller.jsp" class="dashboard-nav-dropdown-item">Best
							Seller</a><a href="userRank.jsp" class="dashboard-nav-dropdown-item">User Rank</a>
					</div>
				</div>
				<a href="add_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-circle-plus"></i>Add product </a> <a
					href="all_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-layer-group"></i> All fashions</a> <a
					href="all_order.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-users"></i>All orders </a><a href="#"
					class="dashboard-nav-item"><i class="fas fa-user"></i> Profile
				</a>

				<div class="nav-item-divider"></div>
				<a href="../logout" class="dashboard-nav-item logout"><i
					class="fas fa-sign-out-alt"></i> Logout </a>

			</nav>
		</div>
		<div class='dashboard-app'>
			<header class='dashboard-toolbar'>
				<a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a>
			</header>
			<div class='dashboard-content'>
				<div class='container'>
					<div class='card'>
						<div class='card-header'>
							<h1>All orders</h1>
						</div>
						<div class='card-body'>
							<table>
								<thead>
									<tr>
										<th>#Id</th>
										<th>Name buyer</th>
										<th>Address</th>
										<th>Phone number</th>
										<th>Product</th>
										<th>Price buy</th>
										<th>Payment method</th>
										<th>Time order</th>

									</tr>
								</thead>
								<tbody>
									<%
									FashionOrderDAOImpl dao = new FashionOrderDAOImpl(DBConnect.getConn());
									List<Fashion_Order> flist = dao.getAllOrder();
									for (Fashion_Order b : flist) {
									%>
									<tr>
										<td><%=b.getOrderId()%></td>
										<td><%=b.getUserName()%></td>
										<td><%=b.getFullAdd()%></td>
										<td><%=b.getPhno()%></td>
										<td
											style="width: 20%; font-family: 'Roboto', san-serif; font-weight: 550; color: black;"><%=b.getFashionName()%>,
											Size:<%=b.getSize()%>, SL: <%=b.getQuantity()%></td>
										<td style="color: #ff0000; font-weight: 600;"><%=b.getPrice()%><span
											style="text-decoration: underline;">đ</span></td>
										<td><%=b.getPaymentType()%></td>
										<td><%=b.getDate()%></td>
									</tr>

									<%
									}
									%>
								</tbody>
							</table>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>