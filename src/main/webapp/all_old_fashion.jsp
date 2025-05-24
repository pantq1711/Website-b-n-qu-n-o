<%@ page import="com.entity.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.DAO.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>All Old Fashion</title>
<%@ include file="all_component/allCss.jsp"%>
<style type="text/css">
/* Base styles */
* {
    box-sizing: border-box;
}

body {
    font-family: 'Roboto', sans-serif;
    background-color: #f8f9fa;
}

/* Product Card Styles */
.items {
    margin-bottom: 20px;
}

.cart-user {
    border: 1px solid #eee;
    border-radius: 10px;
    transition: all 0.3s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
    background: white;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.cart-user:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
}

.card-body {
    display: flex;
    flex-direction: column;
    height: 100%;
    padding: 0;
}

.product-img-container {
    position: relative;
    padding: 15px;
    background-color: #f9f9f9;
    text-align: center;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    border-radius: 10px 10px 0 0;
}

.card-body img {
    max-width: 100%;
    max-height: 180px;
    object-fit: cover;
    border-radius: 5px;
    transition: transform 0.3s ease;
}

.cart-user:hover .card-body img {
    transform: scale(1.05);
}

.old-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: #ffc107;
    color: white;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
}

.inf-product {
    padding: 15px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.name {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 8px;
    height: 40px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    color: #333;
}

.category-info {
    color: #666;
    font-size: 14px;
    margin-bottom: 8px;
}

.category-old {
    color: #ff9800;
    font-weight: 600;
}

.price-section {
    margin: 10px 0;
}

.root-price {
    text-decoration: line-through;
    color: rgba(255, 133, 71, 0.7);
    font-size: 14px;
    margin-right: 8px;
}

.sale-price {
    font-weight: bold;
    color: #dc3545;
    font-size: 16px;
}

.view-class {
    margin-top: auto;
    text-align: center;
}

.btn {
    padding: 8px 16px;
    border-radius: 5px;
    transition: all 0.3s ease;
    font-weight: 500;
}

.btn-success {
    background-color: #28a745;
    border-color: #28a745;
}

.btn-success:hover {
    background-color: #218838;
    border-color: #1e7e34;
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
    font-weight: 600;
    color: #333;
}

#sortingOptions {
    padding: 8px 12px;
    border-radius: 5px;
    border: 1px solid #ced4da;
    background-color: #fff;
    min-width: 200px;
    height: 40px;
    cursor: pointer;
    font-size: 14px;
}

#sortingOptions:focus {
    outline: none;
    border-color: #80bdff;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
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
    border-radius: 5px;
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
    background-color: #28a745;
}

#toast.error {
    background-color: #dc3545;
}

/* Section Title */
.section-title {
    text-align: center;
    font-size: 28px;
    font-weight: 600;
    color: #333;
    margin: 40px 0 30px;
    position: relative;
}

.section-title::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 3px;
    background: linear-gradient(90deg, #ff7e5f, #feb47b);
}

/* Responsive */
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
    
    .product-img-container {
        height: 180px;
    }
    
    .card-body img {
        max-height: 160px;
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
    
    .section-title {
        font-size: 24px;
        margin: 30px 0 20px;
    }
    
    .section-title::after {
        width: 60px;
    }
    
    .product-img-container {
        height: 160px;
    }
    
    .card-body img {
        max-height: 140px;
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
    
    .section-title {
        font-size: 20px;
        margin: 20px 0 15px;
    }
    
    .section-title::after {
        width: 50px;
    }
    
    .product-img-container {
        height: 140px;
    }
    
    .card-body img {
        max-height: 120px;
    }
    
    .inf-product {
        padding: 10px;
    }
    
    .name {
        font-size: 14px;
        height: 35px;
    }
    
    .btn {
        padding: 6px 12px;
        font-size: 14px;
    }
    
    #toast {
        min-width: 250px;
        bottom: 20px;
    }
}

@media (max-width: 320px) {
    .section-title {
        font-size: 18px;
    }
    
    .product-img-container {
        height: 120px;
    }
    
    .card-body img {
        max-height: 100px;
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
        <h2 class="section-title">Sản Phẩm Đã Qua Sử Dụng</h2>
        
        <div class="sorting-container">
            <label class="sort" for="sortingOptions">Sắp xếp:</label>
            <select id="sortingOptions" name="sortingOption" onchange="document.getElementById('sortingForm').submit()">
                <option value="a-z" <%= "a-z".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>A-Z</option>
                <option value="z-a" <%= "z-a".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Z-A</option>
                <option value="price-asc" <%= "price-asc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Giá tăng dần</option>
                <option value="price-desc" <%= "price-desc".equals(request.getParameter("sortingOption")) ? "selected" : "" %>>Giá giảm dần</option>
            </select>
            <form id="sortingForm" action="" method="get" style="display: none;">
                <input type="hidden" name="sortingOption" id="sortingOptionHidden" value="a-z">
            </form>
        </div>
        
        <div class="row">
            <%
            FashionDAOImpl dao3 = new FashionDAOImpl(DBConnect.getConn());
            String sortingOption = request.getParameter("sortingOption");
            if (sortingOption == null) {
                sortingOption = "a-z";
            }
            List<FashionDtls> list3 = dao3.getSortedFashion(sortingOption, "old");
            
            if (list3 != null && !list3.isEmpty()) {
                for (FashionDtls b : list3) {
                    // Format giá
                    String formattedPrice = "";
                    try {
                        String priceStr = b.getPrice().replaceAll("[^0-9]", "");
                        if (!priceStr.isEmpty()) {
                            formattedPrice = String.format("%,d", Integer.parseInt(priceStr));
                        }
                    } catch (Exception e) {
                        formattedPrice = b.getPrice();
                    }
            %>
            <div class="col-6 col-sm-6 col-md-4 col-lg-3 col-xl-2 items">
                <div class="cart-user">
                    <div class="card-body">
                        <div class="product-img-container">
                            <img src="fashion/<%=b.getPhotoName()%>" alt="<%=b.getFashionName()%>">
                            <span class="old-badge">Đã sử dụng</span>
                        </div>
                        <div class="inf-product">
                            <p class="name"><%=b.getFashionName()%></p>
                            <p class="category-info">
                                Danh mục: <span class="category-old"><%=b.getFashionCategory()%></span>
                            </p>
                            <div class="price-section">
                                <span class="sale-price"><%=formattedPrice%> VNĐ</span>
                            </div>
                            <div class="view-class">
                                <a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
                                   class="btn btn-success btn-sm">
                                    <i class="fa-solid fa-eye"></i> Xem Chi Tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="col-12">
                <div class="text-center mt-5">
                    <h4>Không có sản phẩm cũ nào</h4>
                    <p class="text-muted">Hiện tại chưa có sản phẩm đã qua sử dụng nào trong hệ thống.</p>
                    <a href="index.jsp" class="btn btn-primary">
                        <i class="fas fa-home"></i> Về Trang Chủ
                    </a>
                </div>
            </div>
            <%
            }
            %>
        </div>
    </div>
    
    <%@include file="all_component/footer.jsp"%>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Keep the active tab highlighted
        const tabs = document.querySelectorAll('.nav-item');
        document.querySelector('.nav-item.active')?.classList.remove('active');
        tabs[3]?.classList.add('active'); // Old Fashion tab
        
        // Update hidden input on select change
        document.getElementById('sortingOptions').addEventListener('change', function() {
            document.getElementById('sortingOptionHidden').value = this.value;
            document.getElementById('sortingForm').submit();
        });
        
        // Set selected option on page load
        const urlParams = new URLSearchParams(window.location.search);
        const currentSort = urlParams.get('sortingOption') || 'a-z';
        document.getElementById('sortingOptions').value = currentSort;
    });
    </script>
</body>
</html>