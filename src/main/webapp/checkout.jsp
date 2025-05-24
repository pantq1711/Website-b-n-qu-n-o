<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="com.entity.Cart"%>
<%@page import="com.entity.User"%>
<%@page import="com.DB.DBConnect"%>
<%@page import="com.DAO.CartDAOImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Giỏ Hàng</title>
<%@include file="all_component/allCss.jsp"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style type="text/css">
body {
    background-color: #f8f9fa;
    font-family: 'Roboto', sans-serif;
}

.card {
    border: none;
    border-radius: 10px;
    box-shadow: 0 0 20px rgba(0,0,0,0.05);
    margin-bottom: 30px;
}

.card-header {
    background: linear-gradient(135deg, #ff7e5f, #feb47b);
    color: white;
    border-radius: 10px 10px 0 0 !important;
    padding: 15px 20px;
    border: none;
}

.card-header h4 {
    margin: 0;
    font-weight: 600;
}

.cart-title {
    font-weight: 600;
    color: #333;
    text-align: center;
    margin: 30px 0;
    position: relative;
}

.cart-title::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 3px;
    background: linear-gradient(90deg, #ff7e5f, #feb47b);
}

.table {
    margin-bottom: 0;
}

.table th {
    font-weight: 600;
    color: #555;
    background-color: #f8f9fa;
    border-top: none;
}

.table td {
    vertical-align: middle;
    color: #333;
}

.product-name {
    font-weight: 600;
}

.price-tag {
    color: #e63946;
    font-weight: 600;
}

.quantity-control {
    display: flex;
    align-items: center;
    justify-content: center;
}

.quantity-input {
    width: 50px;
    text-align: center;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin: 0 5px;
}

.btn-quantity {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
    line-height: 1.5;
    border-radius: 0.2rem;
}

.btn-decrease {
    background-color: #f8f9fa;
    border-color: #ddd;
}

.btn-increase {
    background-color: #f8f9fa;
    border-color: #ddd;
}

.btn-remove {
    background-color: #dc3545;
    border-color: #dc3545;
    color: white;
}

.btn-remove:hover {
    background-color: #c82333;
    border-color: #bd2130;
}

.total-row {
    background-color: #f8f9fa;
    font-weight: 700;
}

.checkout-form label {
    font-weight: 500;
    color: #555;
}

.checkout-form .form-control {
    border-radius: 5px;
    padding: 0.75rem;
    border: 1px solid #ddd;
}

.checkout-form .form-control:focus {
    border-color: #ff7e5f;
    box-shadow: 0 0 0 0.2rem rgba(255, 126, 95, 0.25);
}

.payment-method {
    margin-top: 1rem;
}

.payment-method .form-group label {
    display: block;
    margin-bottom: 0.5rem;
}

.btn-order {
    background: linear-gradient(135deg, #ff7e5f, #feb47b);
    color: white;
    border: none;
    padding: 10px 30px;
    border-radius: 30px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.btn-order:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
}

.btn-continue {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 30px;
    border-radius: 30px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.btn-continue:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    background-color: #218838;
}

.action-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 20px;
}

.empty-cart {
    text-align: center;
    padding: 40px 20px;
}

.empty-cart i {
    font-size: 4rem;
    color: #ccc;
    margin-bottom: 20px;
}

.empty-cart h4 {
    color: #555;
    margin-bottom: 15px;
}

.empty-cart p {
    color: #777;
    margin-bottom: 20px;
}

.btn-shop {
    background: linear-gradient(135deg, #ff7e5f, #feb47b);
    color: white;
    border: none;
    padding: 10px 30px;
    border-radius: 30px;
    font-weight: 600;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
}

.btn-shop:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    text-decoration: none;
    color: white;
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

/* Media Queries for Responsive Design */
@media (max-width: 1200px) {
    .card-header h4 {
        font-size: 1.25rem;
    }
    
    .action-buttons {
        flex-direction: column;
        gap: 10px;
    }
    
    .btn-order, .btn-continue {
        width: 100%;
    }
}

@media (max-width: 992px) {
    .card-header h4 {
        font-size: 1.1rem;
    }
    
    .cart-title {
        font-size: 1.5rem;
    }
    
    .cart-title::after {
        width: 60px;
    }
    
    .table th, .table td {
        padding: 0.5rem;
    }
    
    .product-name {
        font-size: 0.9rem;
    }
    
    .price-tag {
        font-size: 0.9rem;
    }
    
    .toast {
        min-width: 250px;
    }
}

@media (max-width: 768px) {
    .card-header h4 {
        font-size: 1rem;
    }
    
    .cart-title {
        font-size: 1.3rem;
        margin: 20px 0;
    }
    
    .cart-title::after {
        width: 50px;
    }
    
    .checkout-form label {
        font-size: 0.9rem;
    }
    
    .checkout-form .form-control {
        padding: 0.5rem;
    }
    
    .btn-order, .btn-continue {
        padding: 8px 20px;
        font-size: 0.9rem;
    }
    
    .toast {
        min-width: 200px;
        padding: 10px 15px;
    }
    
    /* Make table responsive */
    .table {
        display: block;
        width: 100%;
        overflow-x: auto;
    }
    
    .table th, .table td {
        white-space: nowrap;
    }
}

@media (max-width: 576px) {
    .container {
        padding: 0 10px;
    }
    
    .card {
        margin-bottom: 20px;
    }
    
    .card-header {
        padding: 10px 15px;
    }
    
    .card-header h4 {
        font-size: 0.9rem;
    }
    
    .cart-title {
        font-size: 1.1rem;
        margin: 15px 0;
    }
    
    .cart-title::after {
        width: 40px;
        height: 2px;
    }
    
    .empty-cart i {
        font-size: 3rem;
    }
    
    .empty-cart h4 {
        font-size: 1.1rem;
    }
    
    .empty-cart p {
        font-size: 0.9rem;
    }
    
    .btn-shop {
        padding: 8px 20px;
        font-size: 0.9rem;
    }
    
    .toast {
        min-width: 180px;
        padding: 8px 12px;
        font-size: 0.9rem;
        right: 10px;
    }
    
    .toast-icon {
        font-size: 16px;
    }
    
    .toast-close {
        font-size: 16px;
    }
    
    /* Stack buttons in smaller screens */
    .quantity-control {
        flex-direction: column;
    }
    
    .quantity-control .btn {
        margin: 2px 0;
    }
    
    .quantity-input {
        width: 40px;
        height: 30px;
    }
}

/* For very small screens */
@media (max-width: 320px) {
    .cart-title {
        font-size: 1rem;
    }
    
    .btn-order, .btn-continue {
        padding: 6px 15px;
        font-size: 0.8rem;
    }
    
    .empty-cart {
        padding: 20px 10px;
    }
    
    .empty-cart i {
        font-size: 2.5rem;
    }
    
    .empty-cart h4 {
        font-size: 1rem;
    }
    
    .btn-shop {
        padding: 6px 15px;
        font-size: 0.8rem;
    }
}
</style>
</head>
<body>
	<c:if test="${empty userobj }">
		<c:redirect url="login.jsp"></c:redirect>
	</c:if>

    <div class="toast-container" id="toastContainer"></div>

	<%@include file="all_component/navbar.jsp"%>

	<div class="container">
		<h3 class="cart-title">Giỏ Hàng Của Bạn</h3>

        <!-- Hiển thị thông báo từ session (nếu có) -->
        <div class="container mb-3">
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

		<div class="row">
			<div class="col-lg-8 col-md-7 mb-4">
				<div class="card">
					<div class="card-header">
						<h4><i class="fas fa-shopping-cart mr-2"></i> Sản Phẩm Trong Giỏ</h4>
					</div>
					<div class="card-body p-0">
						<%
						User user = (User) session.getAttribute("userobj");
						CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
						List<Cart> cart = dao.getFashionByUser(user.getId());
						double totalPrice = 0.0;
						boolean hasProducts = false;

						for (Cart c : cart) {
							totalPrice += Double.parseDouble(c.getTotalPrice().replaceAll("[^0-9]", ""));
							hasProducts = true;
						}

						if (!hasProducts) {
							// Nếu giỏ hàng trống
						%>
						<div class="empty-cart">
							<i class="fas fa-shopping-cart"></i>
							<h4>Giỏ hàng của bạn đang trống</h4>
							<p>Thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm</p>
							<a href="index.jsp" class="btn-shop">Tiếp tục mua sắm</a>
						</div>
						<%
						} else {
						// Nếu giỏ hàng có sản phẩm
						%>
						<div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th scope="col">Sản phẩm</th>
                                        <th scope="col">Giá</th>
                                        <th scope="col">Số lượng</th>
                                        <th scope="col">Thành tiền</th>
                                        <th scope="col">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    for (Cart c : cart) {
                                        // Format giá theo VND
                                        String price = String.format("%,d", Integer.parseInt(c.getPrice().replaceAll("[^0-9]", "")));
                                        String totalItemPrice = String.format("%,d", Integer.parseInt(c.getTotalPrice().replaceAll("[^0-9]", "")));
                                    %>
                                    <tr>
                                        <td class="product-name"><%=c.getFashionName()%></td>
                                        <td class="price-tag"><%=price%> VNĐ</td>
                                        <td>
                                            <div class="quantity-control">
                                                <a href="subcart?fid=<%=c.getFid()%>&cid=<%=c.getCid()%>"
                                                    class="btn btn-sm btn-quantity btn-decrease quantity-btn">
                                                    <i class="fas fa-minus"></i>
                                                </a>
                                                <input type="text" readonly name="quantity" value="<%=c.getQuantity()%>"
                                                    class="form-control quantity-input">
                                                <a href="addcart?fid=<%=c.getFid()%>&cid=<%=c.getCid()%>"
                                                    class="btn btn-sm btn-quantity btn-increase quantity-btn">
                                                    <i class="fas fa-plus"></i>
                                                </a>
                                            </div>
                                        </td>
                                        <td class="price-tag"><%=totalItemPrice%> VNĐ</td>
                                        <td>
                                            <a href="remove_fashion?fid=<%=c.getFid()%>&uid=<%=c.getUserId()%>&cid=<%=c.getCid()%>"
                                            class="btn btn-sm btn-remove remove-btn">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                    }
                                    %>
                                    <tr class="total-row">
                                        <td colspan="3" class="text-right">Tổng cộng:</td>
                                        <td class="price-tag"><%=String.format("%,d", (int)totalPrice)%> VNĐ</td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
					</div>
				</div>
			</div>

			<div class="col-lg-4 col-md-5">
				<div class="card">
					<div class="card-header">
						<h4><i class="fas fa-credit-card mr-2"></i> Thanh Toán</h4>
					</div>
					<div class="card-body checkout-form">
						<form action="order" method="post">
							<input type="hidden" name="id" value="${userobj.id}">

							<div class="form-row">
								<div class="form-group col-md-12">
									<label for="inputName">Họ tên*</label>
                                    <input type="text" class="form-control" id="inputName" value="${userobj.name}" name="username" required>
								</div>
							</div>

							<div class="form-row">
								<div class="form-group col-md-12">
									<label for="inputEmail">Email*</label>
                                    <input type="email" class="form-control" id="inputEmail" value="${userobj.email}" name="email" required>
								</div>
							</div>

							<div class="form-row">
								<div class="form-group col-md-12">
									<label for="inputPhone">Số điện thoại*</label>
                                    <input type="number" class="form-control" id="inputPhone" value="${userobj.phno}" name="phno" required>
								</div>
							</div>

							<div class="form-row">
								<div class="form-group col-md-12">
									<label for="inputAddress">Số nhà</label>
                                    <input type="text" class="form-control" id="inputAddress" value="${userobj.numhouse}" name="numhouse">
								</div>
							</div>

							<div class="form-row">
								<div class="form-group col-sm-6">
									<label for="inputCity">Thành phố</label>
                                    <input type="text" class="form-control" id="inputCity" value="${userobj.city}" name="city">
								</div>
								<div class="form-group col-sm-6">
									<label for="inputProvince">Tỉnh</label>
                                    <input type="text" class="form-control" id="inputProvince" value="${userobj.province}" name="province">
								</div>
							</div>

							<div class="form-group">
								<label for="inputHouseAddress">Địa chỉ</label>
                                <input type="text" class="form-control" id="inputHouseAddress" value="${userobj.address}" name="address">
							</div>

							<div class="form-group payment-method">
								<label for="paymentType">Phương thức thanh toán</label>
                                <select class="form-control" id="paymentType" name="paymentType" required>
									<option value="COD">Thanh toán khi nhận hàng (COD)</option>
									<option value="Bank">Chuyển khoản ngân hàng</option>
								</select>
							</div>

							<div class="form-group">
								<%
								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
								String currentDate = dateFormat.format(new Date());
								%>
								<input type="hidden" class="form-control" id="timeorder" value="<%=currentDate%>" name="timeorder">
							</div>

							<div class="action-buttons">
								<button type="submit" class="btn-order">
                                    <i class="fas fa-check-circle mr-2"></i> Đặt Hàng
                                </button>
								<a href="index.jsp" class="btn-continue">
                                    <i class="fas fa-shopping-bag mr-2"></i> Tiếp Tục Mua Hàng
                                </a>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<%@include file="all_component/footer.jsp"%>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- JavaScript để xử lý thao tác trong giỏ hàng -->
    <script>
    $(document).ready(function() {
        // Thiết lập container cho thông báo
        if ($('#toastContainer').length === 0) {
            $('body').append('<div class="toast-container" id="toastContainer"></div>');
        }
        
        // Kiểm tra kích thước màn hình và điều chỉnh layout
        function adjustLayout() {
            var width = $(window).width();
            
            // Điều chỉnh toast container
            if (width < 576) {
                $('.toast-container').css({
                    'top': '10px',
                    'right': '10px'
                });
                
                $('.toast').css({
                    'min-width': '200px',
                    'padding': '10px 15px'
                });
            } else {
                $('.toast-container').css({
                    'top': '20px',
                    'right': '20px'
                });
                
                $('.toast').css({
                    'min-width': '300px',
                    'padding': '15px 20px'
                });
            }
            
            // Điều chỉnh buttons trong action-buttons
            if (width < 768) {
                $('.action-buttons').css('flex-direction', 'column');
                $('.btn-order, .btn-continue').css('width', '100%');
            } else {
                $('.action-buttons').css('flex-direction', 'row');
                $('.btn-order, .btn-continue').css('width', 'auto');
            }
        }
        
        // Gọi hàm khi trang load và khi thay đổi kích thước màn hình
        adjustLayout();
        $(window).resize(adjustLayout);
        
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
        
        // Đóng thông báo alert tự động sau 5 giây
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
        
        // Xử lý tăng/giảm số lượng sản phẩm bằng AJAX
        $('.quantity-btn').click(function(e) {
            e.preventDefault();
            var link = $(this).attr('href');
            
            $.ajax({
                url: link,
                type: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                success: function(response) {
                    if (response.success) {
                        showToast(response.message, 'success');
                        // Reload trang sau 1 giây để cập nhật thông tin giỏ hàng
                        setTimeout(function() {
                            location.reload();
                        }, 1000);
                    } else {
                        showToast(response.message, 'error');
                    }
                },
                error: function() {
                    showToast('Đã xảy ra lỗi khi cập nhật số lượng', 'error');
                }
            });
        });
        
        // Xử lý xóa sản phẩm khỏi giỏ hàng bằng AJAX
        $('.remove-btn').click(function(e) {
            e.preventDefault();
            var link = $(this).attr('href');
            
            $.ajax({
                url: link,
                type: 'GET',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                success: function(response) {
                    if (response.success) {
                        showToast(response.message, 'success');
                        // Reload trang sau 1 giây để cập nhật giỏ hàng
                        setTimeout(function() {
                            location.reload();
                        }, 1000);
                    } else {
                        showToast(response.message, 'error');
                    }
                },
                error: function() {
                    showToast('Đã xảy ra lỗi khi xóa sản phẩm', 'error');
                }
            });
        });
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
        
        // Điều chỉnh toast cho màn hình nhỏ
        if ($(window).width() < 576) {
            $('#' + toastId).css({
                'min-width': '200px',
                'padding': '10px 15px',
                'font-size': '0.9rem'
            });
            
            $('#' + toastId + ' .toast-icon').css('font-size', '16px');
            $('#' + toastId + ' .toast-close').css('font-size', '16px');
        }
        
        // Tự động đóng sau 5 giây
        setTimeout(function(){            closeToast(toastId);
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