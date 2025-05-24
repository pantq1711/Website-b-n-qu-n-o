<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@ page import="com.entity.*"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.DAO.FashionDAOImpl"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Add viewport meta tag for responsive design -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>All New Fashion</title>
<%@ include file="all_component/allCss.jsp"%>
<style type="text/css">
/* Base styles */
* {
    box-sizing: border-box;
}

body {
    font-family: 'Roboto', sans-serif;
}

/* Product Card Styles */
.items {
    margin-bottom: 20px;
}

.cart-user {
    border: 1px solid #eee;
    border-radius: 5px;
    transition: transform 0.3s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.cart-user:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.card-body {
    display: flex;
    flex-direction: column;
    height: 100%;
}

.card-body img {
    width: 100%;
    height: auto;
    object-fit: cover;
    border-top-left-radius: 5px;
    border-top-right-radius: 5px;
}

.inf-product {
    padding: 15px !important;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.name {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 10px;
    height: 40px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.view-class {
    margin: 10px 0;
}

.btn {
    padding: 8px 12px;
    border-radius: 4px;
    transition: all 0.3s ease;
}

.btn:hover {
    opacity: 0.9;
}

.root-price {
    font-size: 14px;
    margin-right: 5px;
}

.sale-price {
    font-weight: bold;
    color: #dc3545;
}

.cart-parent {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}

/* Toast Notification */
#toast {
    min-width: 300px;
    position: fixed;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%);
    padding: 15px;
    color: white;
    text-align: center;
    z-index: 1000;
    font-size: 16px;
    visibility: hidden;
    box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.3);
    border-radius: 4px;
}

#toast.display {
    visibility: visible;
    animation: fadeIn 0.5s, fadeOut 0.5s 2.5s;
}

@keyframes fadeIn {
    from {
        bottom: 0;
        opacity: 0;
    }
    to {
        bottom: 30px;
        opacity: 1;
    }
}

@keyframes fadeOut {
    from {
        bottom: 30px;
        opacity: 1;
    }
    to {
        bottom: 0;
        opacity: 0;
    }
}

#toast.success {
    background-color: #dc3545;
}

/* Sorting Form */
.sorting-container {
    display: flex;
    align-items: center;
    margin: 20px 0;
    flex-wrap: wrap;
}

.sort {
    font-size: 18px;
    margin-right: 10px;
}

#sortingOptions {
    padding: 8px 12px;
    border-radius: 4px;
    border: 1px solid #ced4da;
    background-color: #fff;
    min-width: 200px;
    height: 40px;
    cursor: pointer;
}

#sortingOptions:focus {
    outline: none;
    border-color: #80bdff;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
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

/* Responsive adjustments */
@media (max-width: 1200px) {
    .items {
        margin: 0 5px 20px;
    }
}

@media (max-width: 992px) {
    .sort {
        font-size: 16px;
    }
    
    #sortingOptions {
        min-width: 180px;
    }
}

@media (max-width: 768px) {
    .sorting-container {
        justify-content: center;
        margin: 15px 0;
    }
    
    #sortingOptions {
        min-width: 160px;
    }
    
    .card-body img {
        max-height: 200px;
    }
    
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

@media (max-width: 576px) {
    .sorting-container {
        flex-direction: column;
        align-items: stretch;
    }
    
    .sort {
        margin-bottom: 10px;
        text-align: center;
    }
    
    #sortingOptions {
        width: 100%;
        max-width: 100%;
    }
}
</style>
</head>
<body>
	<%
    User u = (User) session.getAttribute("userobj");
    %>
	<c:if test="${not empty addCart}">
		<div id="toast" class="success">${addCart}</div>

		<script type="text/javascript">
            showToast();
            function showToast() {
                document.getElementById('toast').classList.add("display");
                setTimeout(() => {
                    document.getElementById('toast').classList.remove("display");
                }, 2000);
            }
        </script>

		<c:remove var="addCart" scope="session" />
	</c:if>
	
	<%@include file="all_component/navbar.jsp"%>
	
	<div class="container-fluid">
		<div class="sorting-container">
            <label class="sort" for="sortingOptions">Sắp xếp:</label>
            <select id="sortingOptions" name="sortingOption" onchange="resetPageAndSubmit()">
                <option value="a-z" <%= "a-z".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>A-Z</option>
                <option value="z-a" <%= "z-a".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Z-A</option>
                <option value="price-asc" <%= "price-asc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Giá tăng dần</option>
                <option value="price-desc" <%= "price-desc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Giá giảm dần</option>
            </select>
            <form id="sortingForm" action="" method="get" style="display: none;">
                <input type="hidden" name="page" value="<%=request.getParameter("page") != null ? request.getParameter("page") : "1"%>">
                <input type="hidden" name="sortingOption" id="sortingOptionHidden" value="a-z">
            </form>
        </div>
        
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
        List<FashionDtls> allList = dao3.getSortedFashion(sortingOption, "new");
        
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
            Hiển thị <%=startIndex + 1%> đến <%=endIndex%> trong tổng số <%=totalItems%> sản phẩm
        </div>
        
		<div class="row">
			<%
            for (FashionDtls b : pageList) {
            %>
			<div class="col-6 col-sm-6 col-md-4 col-lg-3 col-xl-2 items">
				<div class="cart-user">
					<div class="card-body">
						<img src="fashion/<%=b.getPhotoName()%>" alt="<%=b.getFashionName()%>">
						<div class="inf-product">
							<p class="name"><%=b.getFashionName()%></p>
							<div class="d-flex justify-content-center">
								<a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
									class="btn btn-success btn-sm">
									<i class="fa-solid fa-eye"></i> Chi tiết
								</a>
							</div>
							<p class="text-center mt-2">
								<span class="root-price"
									style="text-decoration: line-through; color: rgba(255, 133, 71, 0.7)"><%=b.getPrice()%>VND</span>
								<span class="sale-price"><%=b.getPrice()%> VND</span>
							</p>

							<div class="d-flex justify-content-center">
								<%
								if (u == null) {
								%>
								<a href="login.jsp" class="btn btn-danger btn-sm">
									<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
								</a>
								<%
								} else {
								%>
								<a href="cart?fid=<%=b.getFashionId()%>&&uid=<%=u.getId()%>"
									class="btn btn-danger btn-sm">
									<i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
								</a>
								<%
								}
								%>
							</div>
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
						<i class="fas fa-chevron-left"></i> Trước
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
						Sau <i class="fas fa-chevron-right"></i>
					</a>
				</li>
			</ul>
		</div>
		<%} %>
	</div>
	
	<%@include file="all_component/footer.jsp"%>
	
	<script>
	// Keep the active tab highlighted
	document.addEventListener('DOMContentLoaded', function() {
		const tabs = document.querySelectorAll('.nav-item');
		document.querySelector('.nav-item.active')?.classList.remove('active');
		tabs[2]?.classList.add('active');
	});
	
	function resetPageAndSubmit() {
	    // Reset to page 1 when sorting changes
	    document.querySelector('input[name="page"]').value = '1';
	    document.getElementById('sortingOptionHidden').value = document.getElementById('sortingOptions').value;
	    document.getElementById('sortingForm').submit();
	}
	</script>
</body>
</html>