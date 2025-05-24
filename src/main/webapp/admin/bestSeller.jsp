<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<%@ page import="com.DAO.*"%>
<%@ page import="com.entity.*"%>
<%@ page import="com.DAO.FashionDAOImpl.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.DB.*"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin: Tất cả sản phẩm</title>
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
}

th {
	font-size: 22px;
	color: black !important;
	font-weight: 700 !important;
	font-weight: 500;
	padding-bottom: 20px;
	font-family: cursive;
}

}
td {
	font-family: 'Roboto', sans-serif !important;
	color: black !important;
	font-size: 18px !important;
}

.info-product {
	display: flex;
	align-items: center;
	flex-direction: row;
}

.edit {
	color: black;
	font-size: 20px;
	transition: all 0.4s ease-in-out;
	margin: 0 10px;
}

.delete {
	color: black;
	font-size: 20px;
}

.edit:hover, .delete:hover {
	font-size: 23px;
	color: #ccc;
	text-decoration: none;
}

img {
	margin-right: 20px !important;
}

img {
	border-radius: 15px;
	box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px
		6px;
}

.order {
	font-size: 50px;
	font-weight: 700;
	text-transform: uppercase;
	font-family: 'Gambetta', serif;
	letter-spacing: -3px;
	transition: 700ms ease;
	font-variation-settings: "wght" 311;
	margin-bottom: 0.8rem;
	color: #daa520;
	outline: none;
	text-align: center;
}

.order:hover {
	font-variation-settings: "wght" 582;
	letter-spacing: 1px;
}

.info-dashs {
	display: flex;
	justify-content: center;
	align-items: center;
	margin: 20px 0;
}

.info-dash {
	flex-grow: 1;
	min-width:25%;
	max-width:30%;
	height: 150px !important;
	margin: 20px !important;
	font-size: 20px;
	color: white;
	display: flex;
	
	justify-content: center;
	align-items: center;
}

.fa-gratipay:before {
	font-size: 70px;
}

.fa-chart-line:before, .fa-line-chart:before {
	font-size: 70px;
}

.fa-eye:before {
	font-size: 70px;
}

.info-dash p {
	margin-right: 5px;
}
</style>

<body style="background-color: #eaeef3;">
	<%@include file="navbar.jsp"%>
	<c:if test="${empty userobj}">
		<c:redirect url="../login.jsp" />
	</c:if>
	<c:if test="${not empty succMsg }">
		<h5 class="text-center text-success">${succMsg }</h5>
		<c:remove var="succMsg" scope="session" />
	</c:if>
	<c:if test="${not empty failedMsg }">
		<h5 class="text-center text-dangers">${failedMsg }</h5>
		<c:remove var="failedMsg" scope="session" />
	</c:if>
	<div class='dashboard'>
		<div class="dashboard-nav">
			<header>
				<a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a><a
					href="#" class="brand-logo"><i class="fa-regular fa-heart"></i>
					<span class="brand">Menu</span></a>
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
					class="fa-solid fa-circle-plus"></i>Thêm sản phẩm </a> <a
					href="all_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-layer-group"></i> Tất cả sản phẩm</a> <a
					href="all_order.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-users"></i> Đơn đặt hàng </a><a href="#"
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
				<%
				FashionOrderDAOImpl dao1 = new FashionOrderDAOImpl(DBConnect.getConn());
				long doanh_thu = dao1.getDoanhThu();
				DecimalFormat formatter = new DecimalFormat("###,###,###.##");
				%>
				<div class='container'>
					<div class='card'>
						<div class="info-dashs">
							<div class='info-dash card-header'
								style="background: linear-gradient(45deg, #2ed8b6, #59e0c5);">
								<p>
									<i class="fa-brands fa-gratipay"></i>
								<p>
								<p style="font-size: 18px;">SẢN PHẨM ƯA CHUỘNG</p>
							</div>
							<div class='info-dash card-header'
								style="background: linear-gradient(45deg, #ffb64d, #ffcb80);">
								<p>
									<i class="fa-solid fa-chart-line"></i>
								</p>
								<p>
									DOANH THU <br>
									<span><%=formatter.format(doanh_thu)%><span>đ</span></span>
								</p>

							</div>
							<div class='info-dash card-header'
								style="background: linear-gradient(45deg, #4099ff, #73b4ff)">
								<p>
									<i class="fa-regular fa-eye"></i>
								</p>
								<p>
									LƯỢT SEARCH NHIỀU NHẤT<br>
									<span></span>
								</p>
							</div>
						</div>
						<div class='card-header'
							style="background: linear-gradient(45deg, #ff5370, #ff869a)">
							<h1>BEST SELLER</h1>
						</div>
						<div class='card-body'>
							<table class="table table-striped">
								
								<th>SẢN PHẨM</th>
								<tbody>
									<%
									FashionOrderDAOImpl dao = new FashionOrderDAOImpl(DBConnect.getConn());
									HashMap<String,String> list = dao.getTop5FashionOrder();
									int count = 1;
									for (String i : list.keySet()) {
										
									%>
									<tr>
										
										<td class="info-product"
											style="color: black; width: 100%; background-color: #f9fcff; background-image: linear-gradient(147deg, #f9fcff 0%, #dee4ea 74%); margin-bottom: 20px; border-radius: 10px; box-shadow: rgba(0, 0, 0, 0.12) 0px 1px 3px, rgba(0, 0, 0, 0.24) 0px 1px 2px;">
											<div class="order" style="width:100px ; height:100px; border-radius:50%;box-shadow: rgba(0, 0, 0, 0.12) 0px 1px 3px, rgba(0, 0, 0, 0.24) 0px 1px 2px; margin-right:30px !important;">
												<%=count %>
											</div>
											<div>
												<p style="font-weight: 650; font-family: monospace;"><%=i %>
													</p>
												<p style="color: #ff0000; font-weight: 600;">
													Số lượt mua:
													<%=list.get(i) %>
												</p>
											</div>
									</tr>
									<%
								
									count++;
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