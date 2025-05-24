<%@page import="com.entity.User"%>
<%@page import="com.entity.FashionDtls"%>
<%@page import="java.util.List"%>
<%@page import="com.DAO.FashionDAOImpl"%>
<%@page import="com.DB.DBConnect"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cửa Hàng Thời Trang</title>
<%@include file="all_component/allCss.jsp"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
/* Thiết lập chung */
body {
    background-color: #f8f9fa;
    font-family: 'Roboto', sans-serif;
}

.section-title {
    position: relative;
    margin: 50px 0 30px;
    text-align: center;
    font-weight: 600;
    color: #333;
    font-size: 28px;
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

/* Banner */
.banner-container {
    height: 50vh;
    overflow: hidden;
    position: relative;
    margin-bottom: 30px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.banner-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.banner-container:hover .banner-img {
    transform: scale(1.05);
}

.banner-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(to bottom, rgba(0,0,0,0), rgba(0,0,0,0.5));
    display: flex;
    align-items: center;
    justify-content: center;
}

.banner-content {
    color: white;
    text-align: center;
    padding: 20px;
}

.banner-content h1 {
    font-size: 2.5rem;
    margin-bottom: 15px;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

/* Card sản phẩm */
.product-card {
    border: none;
    border-radius: 10px;
    overflow: hidden;
    transition: all 0.3s ease;
    margin-bottom: 30px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    height: 100%;
}

.product-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
}

.product-img-container {
    position: relative;
    padding-top: 20px;
    background-color: #f9f9f9;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.product-img {
    max-width: 100%;
    max-height: 180px;
    transition: transform 0.5s ease;
}

.product-card:hover .product-img {
    transform: scale(1.1);
}

.new-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: #28a745;
    color: white;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
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

.product-info {
    padding: 20px;
    background: white;
}

.product-name {
    font-weight: 600;
    font-size: 16px;
    color: #333;
    margin-bottom: 10px;
    height: 40px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.product-props {
    color: #666;
    font-size: 14px;
    margin-bottom: 5px;
}

.product-category {
    display: inline-block;
    padding: 3px 8px;
    border-radius: 4px;
    font-size: 12px;
    margin-bottom: 10px;
}

.category-new {
    background-color: #e8f5e9;
    color: #28a745;
}

.category-old {
    background-color: #fff3e0;
    color: #ff9800;
}

.price-container {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
    flex-wrap: wrap;
}

.price {
    font-size: 18px;
    font-weight: 700;
    color: #e63946;
}

.original-price {
    text-decoration: line-through;
    color: #aaa;
    margin-right: 10px;
    font-size: 14px;
}

.discount-badge {
    background-color: #e63946;
    color: white;
    padding: 2px 5px;
    border-radius: 4px;
    margin-left: 10px;
    font-size: 12px;
}

.btn-view {
    background-color: #343a40;
    border-color: #343a40;
    color: white;
}

.btn-view:hover {
    background-color: #23272b;
    border-color: #23272b;
}

.btn-cart {
    background-color: #dc3545;
    border-color: #dc3545;
    color: white;
}

.btn-cart:hover {
    background-color: #c82333;
    border-color: #c82333;
}

.view-all-btn {
    display: inline-block;
    padding: 8px 25px;
    background: linear-gradient(90deg, #ff7e5f, #feb47b);
    color: white;
    border-radius: 30px;
    text-decoration: none;
    transition: all 0.3s ease;
    border: none;
    margin-top: 10px;
    margin-bottom: 30px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.view-all-btn:hover {
    text-decoration: none;
    color: white;
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}

.view-all-container {
    text-align: center;
    margin-bottom: 40px;
}

/* Toast notification */
.toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
}

.toast {
    min-width: 300px;
    margin-bottom: 10px;
    padding: 15px 20px;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    display: flex;
    align-items: center;
    justify-content: space-between;
    animation: slideIn 0.5s, fadeOut 0.5s 4.5s;
    backdrop-filter: blur(5px);
}

.toast-success {
    background-color: rgba(40, 167, 69, 0.95);
    color: white;
    border-left: 4px solid #1e7e34;
}

.toast-error {
    background-color: rgba(220, 53, 69, 0.95);
    color: white;
    border-left: 4px solid #bd2130;
}

.toast-icon {
    margin-right: 10px;
    font-size: 20px;
}

.toast-message {
    flex-grow: 1;
    font-weight: 500;
}

.toast-close {
    background: transparent;
    border: none;
    color: white;
    cursor: pointer;
    font-size: 20px;
    margin-left: 10px;
    opacity: 0.8;
    transition: opacity 0.3s;
}

.toast-close:hover {
    opacity: 1;
}

@keyframes slideIn {
    from {transform: translateX(100%); opacity: 0;}
    to {transform: translateX(0); opacity: 1;}
}

@keyframes fadeOut {
    from {opacity: 1;}
    to {opacity: 0;}
}

/* Divider */
.section-divider {
    height: 2px;
    background: linear-gradient(90deg, transparent, rgba(0,0,0,0.1), transparent);
    margin: 30px 0;
}

/* Media queries */
@media (max-width: 1200px) {
    .section-title {
        font-size: 26px;
    }
    
    .product-name {
        font-size: 15px;
    }
    
    .price {
        font-size: 16px;
    }
}

@media (max-width: 992px) {
    .banner-container {
        height: 40vh;
    }
    
    .banner-content h1 {
        font-size: 2.2rem;
    }
    
    .section-title {
        font-size: 24px;
        margin: 40px 0 25px;
    }
    
    .product-img-container {
        height: 180px;
    }
    
    .product-img {
        max-height: 160px;
    }
}

@media (max-width: 768px) {
    .banner-container {
        height: 35vh;
    }
    
    .banner-content h1 {
        font-size: 1.8rem;
    }
    
    .banner-content p {
        font-size: 0.9rem;
    }
    
    .section-title {
        font-size: 22px;
        margin: 35px 0 20px;
    }
    
    .section-title::after {
        width: 60px;
    }
    
    .price-container {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .original-price {
        margin-bottom: 5px;
    }
    
    .discount-badge {
        margin-left: 0;
        margin-top: 5px;
    }
    
    .toast {
        min-width: 250px;
        right: 10px;
    }
}

@media (max-width: 576px) {
    .banner-container {
        height: 30vh;
    }
    
    .banner-content h1 {
        font-size: 1.5rem;
    }
    
    .banner-content p {
        font-size: 0.8rem;
    }
    
    .section-title {
        font-size: 20px;
        margin: 30px 0 20px;
    }
    
    .product-img-container {
        height: 160px;
    }
    
    .product-img {
        max-height: 140px;
    }
    
    .product-info {
        padding: 15px;
    }
    
    .product-name {
        font-size: 14px;
        height: 35px;
    }
    
    .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.8rem;
    }
    
    .toast {
        min-width: 200px;
        padding: 10px 15px;
        right: 5px;
    }
}

@media (max-width: 320px) {
    .banner-container {
        height: 25vh;
    }
    
    .banner-content h1 {
        font-size: 1.2rem;
    }
    
    .product-card {
        margin-bottom: 15px;
    }
    
    .product-img-container {
        height: 140px;
    }
    
    .product-img {
        max-height: 120px;
    }
    
    .view-all-btn {
        padding: 5px 15px;
        font-size: 0.8rem;
    }
}
</style>
</head>
<body>

    <%
    User u = (User) session.getAttribute("userobj");
    %>

    <div class="toast-container" id="toastContainer"></div>

    <%@include file="all_component/navbar.jsp"%>
    
    <!-- Banner mới với gradient overlay -->
    <div class="banner-container">
        <img src="img/fashion.jpg" alt="Fashion Banner" class="banner-img">
        <div class="banner-overlay">
            <div class="banner-content">
                <h1>Thời Trang Cho Mọi Người</h1>
                <p class="lead">Khám phá bộ sưu tập mới nhất của chúng tôi</p>
            </div>
        </div>
    </div>

    <!-- Hiển thị thông báo từ session (nếu có) -->
    <div class="container mt-3">
        <% String successMessage = (String) session.getAttribute("succMsg");
           if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% session.removeAttribute("succMsg");
           }
        %>
        
        <% String failedMessage = (String) session.getAttribute("failedMsg");
           if (failedMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= failedMessage %>
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% session.removeAttribute("failedMsg");
           }
        %>
    </div>

    <!-- Sản phẩm mới nhất -->
    <div class="container">
        <h2 class="section-title">Sản Phẩm Mới Nhất</h2>
        <div class="row">
            <%
            FashionDAOImpl dao2 = new FashionDAOImpl(DBConnect.getConn());
            List<FashionDtls> list2 = dao2.getNewFashion();
            for (FashionDtls f : list2) {
                // Giả sử giá gốc cao hơn 10-20% để tạo hiệu ứng giảm giá
                double originalPrice = Double.parseDouble(f.getPrice().replaceAll("[^0-9]", "")) * 1.2;
                int discountPercent = 20; // 20% discount
                
                // Format giá theo VND
                String formattedPrice = String.format("%,d", Integer.parseInt(f.getPrice().replaceAll("[^0-9]", "")));
                String formattedOriginalPrice = String.format("%,d", (int)originalPrice);
            %>
            <div class="col-6 col-sm-6 col-md-4 col-lg-3">
                <div class="product-card">
                    <div class="product-img-container">
                        <img src="fashion/<%=f.getPhotoName()%>" alt="<%=f.getFashionName()%>" class="product-img">
                        <% if (f.getFashionCategory().equals("Mới")) { %>
                            <span class="new-badge">Mới</span>
                        <% } else { %>
                            <span class="old-badge">Đã sử dụng</span>
                        <% } %>
                    </div>
                    <div class="product-info">
                        <h5 class="product-name"><%=f.getFashionName()%></h5>
                        <p class="product-props">Size: <%=f.getSize()%></p>
                        
                        <% if (f.getFashionCategory().equals("Mới")) { %>
                            <span class="product-category category-new"><%=f.getFashionCategory()%></span>
                        <% } else { %>
                            <span class="product-category category-old"><%=f.getFashionCategory()%></span>
                        <% } %>
                        
                        <div class="price-container">
                            <span class="original-price"><%=formattedOriginalPrice%> VNĐ</span>
                            <span class="price"><%=formattedPrice%> VNĐ</span>
                            <span class="discount-badge">-<%=discountPercent%>%</span>
                        </div>
                        
                        <div class="row">
                            <% if (f.getFashionCategory().equals("Cũ")) { %>
                                <div class="col-12">
                                    <a href="view_fashions.jsp?fid=<%=f.getFashionId()%>" class="btn btn-view btn-sm btn-block">
                                        <i class="fas fa-eye"></i> Xem Chi Tiết
                                    </a>
                                </div>
                            <% } else { %>
                                <div class="col-6">
                                    <a href="view_fashions.jsp?fid=<%=f.getFashionId()%>" class="btn btn-view btn-sm btn-block">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </div>
                                <div class="col-6">
                                    <% if (u == null) { %>
                                        <a href="login.jsp" class="btn btn-cart btn-sm btn-block">
                                            <i class="fas fa-shopping-cart"></i> Thêm
                                        </a>
                                    <% } else { %>
                                        <a href="cart?fid=<%=f.getFashionId()%>&uid=<%=u.getId()%>" class="btn btn-cart btn-sm btn-block cart-btn">
                                            <i class="fas fa-shopping-cart"></i> Thêm
                                        </a>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div class="view-all-container">
            <a href="all_new_fashion.jsp" class="view-all-btn">
                Xem Tất Cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </div>
    <!-- End Sản phẩm mới nhất -->

    <div class="section-divider"></div>

    <!-- Sản phẩm gần đây -->
    <div class="container">
        <h2 class="section-title">Tất Cả Sản Phẩm</h2>
        <div class="row">
            <%
            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
            List<FashionDtls> list = dao.getRecentFashions();
            for (FashionDtls f : list) {
                // Giả sử giá gốc cao hơn 10-20% để tạo hiệu ứng giảm giá
                double originalPrice = Double.parseDouble(f.getPrice().replaceAll("[^0-9]", "")) * 1.15;
                int discountPercent = 15; // 15% discount
                
                // Format giá theo VND
                String formattedPrice = String.format("%,d", Integer.parseInt(f.getPrice().replaceAll("[^0-9]", "")));
                String formattedOriginalPrice = String.format("%,d", (int)originalPrice);
            %>
            <div class="col-6 col-sm-6 col-md-4 col-lg-3">
                <div class="product-card">
                    <div class="product-img-container">
                        <img src="fashion/<%=f.getPhotoName()%>" alt="<%=f.getFashionName()%>" class="product-img">
                        <% if (f.getFashionCategory().equals("Mới")) { %>
                            <span class="new-badge">Mới</span>
                        <% } else { %>
                            <span class="old-badge">Đã sử dụng</span>
                        <% } %>
                    </div>
                    <div class="product-info">
                        <h5 class="product-name"><%=f.getFashionName()%></h5>
                        <p class="product-props">Size: <%=f.getSize()%></p>
                        
                        <% if (f.getFashionCategory().equals("Mới")) { %>
                            <span class="product-category category-new"><%=f.getFashionCategory()%></span>
                        <% } else { %>
                            <span class="product-category category-old"><%=f.getFashionCategory()%></span>
                        <% } %>
                        
                        <div class="price-container">
                            <span class="original-price"><%=formattedOriginalPrice%> VNĐ</span>
                            <span class="price"><%=formattedPrice%> VNĐ</span>
                            <span class="discount-badge">-<%=discountPercent%>%</span>
                        </div>
                        
                        <div class="row">
                            <% if (f.getFashionCategory().equals("Cũ")) { %>
                                <div class="col-12">
                                    <a href="view_fashions.jsp?fid=<%=f.getFashionId()%>" class="btn btn-view btn-sm btn-block">
                                        <i class="fas fa-eye"></i> Xem Chi Tiết
                                    </a>
                                </div>
                            <% } else { %>
                                <div class="col-6">
                                    <a href="view_fashions.jsp?fid=<%=f.getFashionId()%>" class="btn btn-view btn-sm btn-block">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </div>
                                <div class="col-6">
                                    <% if (u == null) { %>
                                        <a href="login.jsp" class="btn btn-cart btn-sm btn-block">
                                            <i class="fas fa-shopping-cart"></i> Thêm
                                        </a>
                                    <% } else { %>
                                        <a href="cart?fid=<%=f.getFashionId()%>&uid=<%=u.getId()%>" class="btn btn-cart btn-sm btn-block cart-btn">
                                            <i class="fas fa-shopping-cart"></i> Thêm
                                        </a>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div class="view-all-container">
            <a href="all_recent_fashion.jsp" class="view-all-btn">
                Xem Tất Cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </div>
    <!-- End Sản phẩm gần đây -->

    <div class="section-divider"></div>

    <!-- Sản phẩm cũ -->
    <div class="container">
        <h2 class="section-title">Sản Phẩm Đã Qua Sử Dụng</h2>
        <div class="row">
            <%
            FashionDAOImpl dao3 = new FashionDAOImpl(DBConnect.getConn());
            List<FashionDtls> list3 = dao3.getOldFashions();
            for (FashionDtls f : list3) {
                // Giá sản phẩm cũ thường có giảm giá sâu hơn
                double originalPrice = Double.parseDouble(f.getPrice().replaceAll("[^0-9]", "")) * 1.4;
                int discountPercent = 40; // 40% discount
                
                // Format giá theo VND
                String formattedPrice = String.format("%,d", Integer.parseInt(f.getPrice().replaceAll("[^0-9]", "")));
                String formattedOriginalPrice = String.format("%,d", (int)originalPrice);
            %>
            <div class="col-6 col-sm-6 col-md-4 col-lg-3">
                <div class="product-card">
                    <div class="product-img-container">
                        <img src="fashion/<%=f.getPhotoName()%>" alt="<%=f.getFashionName()%>" class="product-img">
                        <span class="old-badge">Đã sử dụng</span>
                    </div>
                    <div class="product-info">
                        <h5 class="product-name"><%=f.getFashionName()%></h5>
                        <p class="product-props">Size: <%=f.getSize()%></p>
                        <span class="product-category category-old"><%=f.getFashionCategory()%></span>
                        
                        <div class="price-container">
                            <span class="original-price"><%=formattedOriginalPrice%> VNĐ</span>
                            <span class="price"><%=formattedPrice%> VNĐ</span>
                            <span class="discount-badge">-<%=discountPercent%>%</span>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                <a href="view_fashions.jsp?fid=<%=f.getFashionId()%>" class="btn btn-view btn-sm btn-block">
                                    <i class="fas fa-eye"></i> Xem Chi Tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div class="view-all-container">
            <a href="all_old_fashion.jsp" class="view-all-btn">
                Xem Tất Cả <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </div>
    <!-- End Sản phẩm cũ -->

    <%@include file="all_component/footer.jsp"%>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- JavaScript để xử lý thêm vào giỏ hàng bằng AJAX -->
    <script>
    // Hiển thị thông báo từ session nếu có
    $(document).ready(function() {
        // Thiết lập container cho thông báo
        if ($('#toastContainer').length === 0) {
            $('body').append('<div class="toast-container" id="toastContainer"></div>');
        }
        
        // Hiển thị thông báo từ session nếu có
        var succMsg = '<%= session.getAttribute("succMsg") %>';
        var failedMsg = '<%= session.getAttribute("failedMsg") %>';
        
        if (succMsg != 'null' && succMsg !== '') {
            showToast(succMsg, 'success');
            <% session.removeAttribute("succMsg"); %>
        }
        
        if (failedMsg != 'null' && failedMsg !== '') {
            showToast(failedMsg, 'error');
            <% session.removeAttribute("failedMsg"); %>
        }
        
        // Xử lý thêm vào giỏ hàng bằng AJAX
        $(document).on('click', '.cart-btn', function(e) {
            e.preventDefault();
            var link = $(this).attr('href');
            
            $.ajax({
                url: link,
                type: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                success: function(response) {
                    if (response.success) {
                        showToast(response.message, 'success');
                    } else {
                        showToast(response.message, 'error');
                    }
                },
                error: function() {
                    showToast('Đã xảy ra lỗi khi thêm vào giỏ hàng', 'error');
                }
            });
        });
        
        // Đóng thông báo alert tự động sau 5 giây
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
    });

    // Hàm hiển thị thông báo
    function showToast(message, type) {
        var toastId = 'toast-' + new Date().getTime();
        var icon = type === 'success' ? '<i class="fas fa-check-circle toast-icon"></i>' : '<i class="fas fa-exclamation-circle toast-icon"></i>';
        var toastClass = type === 'success' ? 'toast-success' : 'toast-error';
        
        var toastHtml = '<div id="' + toastId + '" class="toast ' + toastClass + '">' +
                        icon +
                        '<span class="toast-message">' + message + '</span>' +
                        '<button class="toast-close" onclick="closeToast(\'' + toastId + '\')">×</button>' +
                        '</div>';
        
        $('#toastContainer').append(toastHtml);
        
        // Tự động đóng sau 5 giây
        setTimeout(function() {
            closeToast(toastId);
        }, 5000);
    }

    // Hàm đóng thông báo
    function closeToast(toastId) {
        $('#' + toastId).fadeOut('slow', function() {
            $(this).remove();
        });
    }
    </script>
</body>
</html>