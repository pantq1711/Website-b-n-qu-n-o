<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<%@ page import="com.DAO.*"%>
<%@ page import="com.entity.*"%>
<%@ page import="com.DAO.FashionDAOImpl.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.DB.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin: All fashions</title>
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

td {
	font-family: 'Roboto', sans-serif !important;
	color: black !important;
	font-size: 18px !important;
}

.info-product {
	display: flex;
	align-items: center;
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

/* Pagination Styles */
.pagination-container {
	margin-top: 20px;
	display: flex;
	justify-content: center;
	align-items: center;
}

.pagination {
	display: flex;
	list-style: none;
	padding: 0;
	margin: 0;
	border-radius: 4px;
}

.pagination li {
	margin: 0 2px;
}

.pagination li a {
	color: #495057;
	background-color: #fff;
	border: 1px solid #dee2e6;
	border-top-left-radius: 0.25rem;
	border-bottom-left-radius: 0.25rem;
	border-top-right-radius: 0.25rem;
	border-bottom-right-radius: 0.25rem;
	padding: 0.375rem 0.75rem;
	text-decoration: none;
	transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
}

.pagination li a:hover {
	z-index: 2;
	color: #0056b3;
	background-color: #e9ecef;
	border-color: #dee2e6;
}

.pagination li.active a {
	z-index: 1;
	color: #fff;
	background-color: #007bff;
	border-color: #007bff;
}

.pagination li.disabled a {
	color: #6c757d;
	pointer-events: none;
	cursor: auto;
	background-color: #fff;
	border-color: #dee2e6;
}

.products-info {
	margin-bottom: 15px;
	color: #6c757d;
	font-size: 14px;
}

.products-per-page {
	margin-bottom: 15px;
}

.products-per-page select {
	padding: 5px 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
}

.products-per-page label {
	margin-right: 10px;
	font-weight: 500;
}

@media (max-width: 768px) {
	.pagination {
		flex-wrap: wrap;
		justify-content: center;
	}
	
	.pagination li {
		margin: 2px;
	}
}
</style>

<body>
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
					class="fa-solid fa-circle-plus"></i>Add product </a> <a
					href="all_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-layer-group"></i> All fashions</a> <a
					href="all_order.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-users"></i> All orders </a><a href="#"
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
							<h1>All products</h1>
						</div>
						<div class='card-body'>
							<%
							// Lấy các tham số phân trang
							int currentPage = 1;
							int productsPerPage = 10;
							
							// Lấy currentPage từ parameter
							String pageParam = request.getParameter("page");
							if (pageParam != null && !pageParam.isEmpty()) {
								try {
									currentPage = Integer.parseInt(pageParam);
								} catch (NumberFormatException e) {
									currentPage = 1;
								}
							}
							
							// Lấy productsPerPage từ parameter
							String perPageParam = request.getParameter("perPage");
							if (perPageParam != null && !perPageParam.isEmpty()) {
								try {
									productsPerPage = Integer.parseInt(perPageParam);
								} catch (NumberFormatException e) {
									productsPerPage = 10;
								}
							}
							
							// Lấy tất cả sản phẩm
							FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
							List<FashionDtls> allProducts = dao.getAllFashions();
							int totalProducts = allProducts.size();
							int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);
							
							// Đảm bảo currentPage hợp lệ
							if (currentPage < 1) currentPage = 1;
							if (currentPage > totalPages) currentPage = totalPages;
							
							// Tính toán start và end index
							int startIndex = (currentPage - 1) * productsPerPage;
							int endIndex = Math.min(startIndex + productsPerPage, totalProducts);
							
							// Lấy sản phẩm cho trang hiện tại
							List<FashionDtls> currentPageProducts = dao.getListByPage(
								new ArrayList<>(allProducts), startIndex, endIndex);
							%>
							
							<!-- Products per page selector -->
							<div class="products-per-page">
								<label for="perPageSelect">Hiển thị:</label>
								<select id="perPageSelect" name="perPage" onchange="changeProductsPerPage(this.value)">
									<option value="5" <%= productsPerPage == 5 ? "selected" : "" %>>5</option>
									<option value="10" <%= productsPerPage == 10 ? "selected" : "" %>>10</option>
									<option value="20" <%= productsPerPage == 20 ? "selected" : "" %>>20</option>
									<option value="50" <%= productsPerPage == 50 ? "selected" : "" %>>50</option>
								</select>
								<span> sản phẩm mỗi trang</span>
							</div>
							
							<!-- Products info -->
							<div class="products-info">
								Hiển thị <%= startIndex + 1 %> đến <%= endIndex %> trong tổng số <%= totalProducts %> sản phẩm
							</div>
							
							<table class="table table-striped">
								<thead class="bg-primary text-white">
									<tr>
										<th scope="col">#ID</th>
										<th scope="col">Product</th>
										<th scope="col">Price</th>
										<th scope="col">Status</th>
										<th scope="col" style="text-align: center;">Tool</th>
									</tr>
								</thead>
								<tbody>
									<% for (FashionDtls b : currentPageProducts) { %>
									<tr>
										<td>#<%=b.getFashionId()%></td>
										<td class="info-product" style="color: black;"><img
											src="../fashion/<%=b.getPhotoName()%>"
											style="width: 50px; height: 50px;"><%=b.getFashionName()%>,
											Size: <%=b.getSize()%>, Quantity: <%=b.getQuantity()%>
										</td>
										<td style="color: #ff0000; font-weight: 600;"><%=b.getPrice()%><span
											style="text-decoration: underline;">đ</span></td>
										<td style="color: #03c03c;"><%=b.getStatus()%></td>
										<td style="text-align: center;">
											<a href="edit_fashions.jsp?id=<%=b.getFashionId()%>" class="edit">
												<i class="fas fa-edit"></i>
											</a>
											<a href="../delete?id=<%=b.getFashionId()%>" class="delete"
											   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
												<i class="fas fa-trash-alt"></i>
											</a>
										</td>
									</tr>
									<% } %>
									
									<% if (currentPageProducts.isEmpty()) { %>
									<tr>
										<td colspan="5" class="text-center">Không có sản phẩm nào</td>
									</tr>
									<% } %>
								</tbody>
							</table>
							
							<!-- Pagination Controls -->
							<% if (totalPages > 1) { %>
							<div class="pagination-container">
								<ul class="pagination">
									<!-- Previous Button -->
									<li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
										<a class="page-link" href="?page=<%= currentPage - 1 %>&perPage=<%= productsPerPage %>">
											<i class="fas fa-chevron-left"></i> Previous
										</a>
									</li>
									
									<!-- First Page -->
									<% if (currentPage > 3) { %>
									<li class="page-item">
										<a class="page-link" href="?page=1&perPage=<%= productsPerPage %>">1</a>
									</li>
									<% if (currentPage > 4) { %>
									<li class="page-item disabled">
										<span class="page-link">...</span>
									</li>
									<% } %>
									<% } %>
									
									<!-- Page Numbers -->
									<% 
									int startPage = Math.max(1, currentPage - 2);
									int endPage = Math.min(totalPages, currentPage + 2);
									
									for (int i = startPage; i <= endPage; i++) { 
									%>
									<li class="page-item <%= i == currentPage ? "active" : "" %>">
										<a class="page-link" href="?page=<%= i %>&perPage=<%= productsPerPage %>"><%= i %></a>
									</li>
									<% } %>
									
									<!-- Last Page -->
									<% if (currentPage < totalPages - 2) { %>
									<% if (currentPage < totalPages - 3) { %>
									<li class="page-item disabled">
										<span class="page-link">...</span>
									</li>
									<% } %>
									<li class="page-item">
										<a class="page-link" href="?page=<%= totalPages %>&perPage=<%= productsPerPage %>"><%= totalPages %></a>
									</li>
									<% } %>
									
									<!-- Next Button -->
									<li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
										<a class="page-link" href="?page=<%= currentPage + 1 %>&perPage=<%= productsPerPage %>">
											Next <i class="fas fa-chevron-right"></i>
										</a>
									</li>
								</ul>
							</div>
							<% } %>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
	// Function to change products per page
	function changeProductsPerPage(perPage) {
		window.location.href = '?page=1&perPage=' + perPage;
	}
	
	// Confirm delete function
	function confirmDelete(id) {
		if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
			window.location.href = '../delete?id=' + id;
		}
		return false;
	}
	</script>
</body>
</html>