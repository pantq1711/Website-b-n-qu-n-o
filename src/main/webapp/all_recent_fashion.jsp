<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.entity.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.DAO.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>All Recent Fashion</title>
<%@include file="all_component/allCss.jsp"%>
<style type="text/css">
.img-thumblin {
	height: 50vh;
	width: 100%;
	background-repeat: no-repeat;
	background-size: cover;
}

#sortingOptions{
	margin:20px;
	width:200px;
	height:38px;
	padding:8px;
	border-radius:5px;
}

#sortingOptions:focus{
	border:0.5px solid #ccc;
}

.sort{
	font-size:20px; margin:0 10px;
}

/* Pagination Styles */
.pagination-container {
    display: flex;
    justify-content: center;
    margin: 30px 0;
}

.pagination {
    display: flex;
    list-style: none;
    padding: 0;
    margin: 0;
    border-radius: 5px;
    overflow: hidden;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.pagination li {
    margin: 0;
}

.pagination a {
    display: block;
    padding: 10px 15px;
    text-decoration: none;
    color: #333;
    background-color: #fff;
    border: 1px solid #ddd;
    border-right: none;
    transition: all 0.3s ease;
}

.pagination li:last-child a {
    border-right: 1px solid #ddd;
}

.pagination a:hover {
    background-color: #f5f5f5;
    color: #000;
}

.pagination .active a {
    background-color: #007bff;
    color: white;
    border-color: #007bff;
}

.pagination .disabled a {
    color: #999;
    cursor: not-allowed;
    background-color: #f8f9fa;
}

.pagination .disabled a:hover {
    background-color: #f8f9fa;
    color: #999;
}

.page-info {
    text-align: center;
    margin-bottom: 20px;
    color: #666;
    font-size: 14px;
}

@media (max-width: 768px) {
    .pagination a {
        padding: 8px 10px;
        font-size: 14px;
    }
    
    .pagination .page-num {
        display: none;
    }
    
    .pagination .page-num.active {
        display: block;
    }
}
</style>
</head>
<body>

	<%
	User u = (User) session.getAttribute("userobj");
	%>
	<%@include file="all_component/navbar.jsp"%>
	<div class="container-fluid">
		<!-- Sorting Form -->
		<form id="sortingForm" action="" method="get">
			<input type="hidden" name="page" value="<%=request.getParameter("page") != null ? request.getParameter("page") : "1"%>">
            <label class="sort" for="sortingOptions">Sort:</label>
            <select id="sortingOptions" name="sortingOption" onchange="resetPageAndSubmit()">
                <option value="a-z" <%= "a-z".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>A-Z</option>
                <option value="z-a" <%= "z-a".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Z-A</option>
                <option value="price-asc" <%= "price-asc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Price increasing</option>
                <option value="price-desc" <%= "price-desc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Price descreasing</option>
            </select>
        </form>
        
        <%
        // Pagination logic
        int currentPage = 1;
        int itemsPerPage = 12;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        
        // Get sorting option
        String sortingOption = request.getParameter("sortingOption");
        if (sortingOption == null) {
            sortingOption = "a-z";
        }
        
        // Get all fashion items
        FashionDAOImpl dao3 = new FashionDAOImpl(DBConnect.getConn());
        List<FashionDtls> allList = dao3.getSortedFashion(sortingOption, "recent");
        
        // Calculate pagination
        int totalItems = allList.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }
        
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        // Get items for current page
        List<FashionDtls> pageList = dao3.getListByPage(new ArrayList<>(allList), startIndex, endIndex);
        %>
        
        <!-- Page Info -->
        <div class="page-info">
            Showing <%=startIndex + 1%> to <%=endIndex%> of <%=totalItems%> products
        </div>
        
		<div class="row p-3">
			<%
            for (FashionDtls b : pageList) {
            %>
			<div class="items col-md-2"
				style="padding: 0; margin: 5px 5px;">
				<div class="cart-user" style="padding: 0; width: 100%;">
					<div class="card-body" style="padding: 0; width: 100%;">
						<img alt="" src="fashion/<%=b.getPhotoName()%>"
							style="width: 100%; height: fit-object;">
						<div class="inf-product" style="padding: 10px;">

							<p class="name"><%=b.getFashionName()%></p>
							<p>
								<%
								if (b.getFashionCategory().equals("Cũ")) {
								%>
								Categories:<span style="color: rgba(0, 0, 0, 0.6);';"><%=b.getFashionCategory()%></span>
							</p>
							<p class="text-left">
								<span class="root-price"
									style="text-decoration: line-through; color: rgba(255, 133, 71, 0.7);"><%=b.getPrice()%>VND</span>
								<span class="sale-price"><%=b.getPrice()%> VND</span>
							</p>


							<div class="view-class row">
								<a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
									class="btn btn-success btn-sm ml-5"><i
									class="fa-solid fa-eye"></i></a>
							</div>

							<%
							} else {
							%>
							Categories:<span style="color: rgb(26, 223, 34);';"><%=b.getFashionCategory()%></span>
							<div class="view-class row">
								<a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
									class="btn btn-success btn-sm ml-5"><i
									class="fa-solid fa-eye"></i></a>
							</div>
							<p class="text-left">
								<span class="root-price"
									style="text-decoration: line-through; color: rgba(255, 133, 71, 0.7)"><%=b.getPrice()%>VND</span>
								<span class="sale-price"><%=b.getPrice()%> VND</span>
							</p>

							<div class="cart-parent row">

								<%
								if (u == null) {
								%>
								<div class="cart-icon">
									<a href="login.jsp"
										class="cart-link btn btn-danger btn-sm ml-2"><i
										class="fa-solid fa-cart-plus"
										style="background-color: rgba(0, 0, 0, 0.7); border: none;"></i></a>
								</div>
								<%
								} else {
								%>
								<div class="cart-icon">
									<a href="cart?fid=<%=b.getFashionId()%>&&uid=<%=u.getId()%>"
										class="cart-link btn btn-danger btn-sm ml-2"
										style="background-color: rgba(0, 0, 0, 0.7); border: none;"><i
										class="fa-solid fa-cart-plus"></i></a>
								</div>
								<%
								}
								%>

							</div>
							<%
							}
							%>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			%>
		</div>
		
		<!-- Pagination -->
		<%if (totalPages > 1) { %>
		<div class="pagination-container">
			<ul class="pagination">
				<!-- Previous Button -->
				<li class="<%=currentPage == 1 ? "disabled" : ""%>">
					<a href="<%=currentPage == 1 ? "#" : "?page=" + (currentPage - 1) + 
					    (sortingOption != null ? "&sortingOption=" + sortingOption : "")%>">
						<i class="fas fa-chevron-left"></i> Previous
					</a>
				</li>
				
				<!-- Page Numbers -->
				<%
				int maxVisiblePages = 5;
				int startPage = Math.max(1, currentPage - maxVisiblePages / 2);
				int endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
				
				// Adjust start page if we're near the end
				if (endPage - startPage < maxVisiblePages - 1) {
					startPage = Math.max(1, endPage - maxVisiblePages + 1);
				}
				
				// First page
				if (startPage > 1) {
				%>
					<li class="page-num">
						<a href="?page=1<%=sortingOption != null ? "&sortingOption=" + sortingOption : ""%>">1</a>
					</li>
					<%if (startPage > 2) { %>
						<li class="disabled page-num"><a href="#">...</a></li>
					<%} %>
				<%} %>
				
				<!-- Visible page range -->
				<%for (int i = startPage; i <= endPage; i++) { %>
					<li class="<%=i == currentPage ? "active" : ""%> page-num">
						<a href="?page=<%=i%><%=sortingOption != null ? "&sortingOption=" + sortingOption : ""%>"><%=i%></a>
					</li>
				<%} %>
				
				<!-- Last page -->
				<%if (endPage < totalPages) { %>
					<%if (endPage < totalPages - 1) { %>
						<li class="disabled page-num"><a href="#">...</a></li>
					<%} %>
					<li class="page-num">
						<a href="?page=<%=totalPages%><%=sortingOption != null ? "&sortingOption=" + sortingOption : ""%>"><%=totalPages%></a>
					</li>
				<%} %>
				
				<!-- Next Button -->
				<li class="<%=currentPage == totalPages ? "disabled" : ""%>">
					<a href="<%=currentPage == totalPages ? "#" : "?page=" + (currentPage + 1) +
					    (sortingOption != null ? "&sortingOption=" + sortingOption : "")%>">
						Next <i class="fas fa-chevron-right"></i>
					</a>
				</li>
			</ul>
		</div>
		<%} %>
	</div>
</body>

<script>
const $ = document.querySelector.bind(document);
const $$ = document.querySelectorAll.bind(document);
const tabs = $$('.nav-h.nav-item');
$('.nav-h.nav-item.active').classList.remove('active');
tabs[1].classList.add('active');

function resetPageAndSubmit() {
    // Reset to page 1 when sorting changes
    document.querySelector('input[name="page"]').value = '1';
    document.getElementById('sortingForm').submit();
}
</script>
</html>