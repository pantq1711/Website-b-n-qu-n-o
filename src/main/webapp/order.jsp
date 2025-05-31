<%@page import="java.util.List"%>
<%@page import="com.entity.Fashion_Order"%>
<%@page import="com.DB.DBConnect"%>
<%@page import="com.DAO.FashionOrderDAOImpl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đơn Hàng Của Tôi</title>
<%@include file="all_component/allCss.jsp"%>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<style>
/* Order Page Specific Styles */
.order-container {
    background: #f8f9fa;
    min-height: 100vh;
}

.page-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    margin-bottom: 30px;
    border-radius: 10px;
}

.page-header h2 {
    margin: 0;
    font-weight: 600;
}

.orders-controls {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.orders-per-page {
    display: flex;
    align-items: center;
    gap: 10px;
}

.orders-per-page select {
    padding: 8px 12px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 14px;
    background-color: white;
}

.orders-info {
    color: #666;
    font-size: 14px;
    margin: 0;
}

/* Order Card Styles */
.order-card {
    background: white;
    border-radius: 12px;
    margin-bottom: 25px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    border: 1px solid #e9ecef;
    transition: all 0.3s ease;
}

.order-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.order-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
}

.order-id {
    font-weight: 700;
    font-size: 18px;
    margin: 0;
}

.order-date {
    font-size: 14px;
    opacity: 0.9;
    margin: 5px 0 0 0;
}

.order-status {
    background: rgba(255,255,255,0.2);
    color: white;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
}

.order-summary {
    background: #f8f9fa;
    padding: 20px;
    border-bottom: 1px solid #e9ecef;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 20px;
    text-align: center;
}

.summary-item {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.summary-label {
    font-size: 12px;
    color: #666;
    text-transform: uppercase;
    font-weight: 600;
    letter-spacing: 0.5px;
    margin-bottom: 5px;
}

.summary-value {
    font-weight: 700;
    color: #333;
    font-size: 16px;
}

.summary-value.price {
    color: #e63946;
    font-size: 18px;
}

/* Items List */
.items-list {
    max-height: 350px;
    overflow-y: auto;
}

.item-row {
    padding: 20px;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: background-color 0.3s ease;
}

.item-row:hover {
    background-color: #f8f9fa;
}

.item-row:last-child {
    border-bottom: none;
}

.item-info {
    flex: 1;
}

.item-name {
    font-weight: 600;
    color: #333;
    margin-bottom: 5px;
    font-size: 16px;
}

.item-details {
    font-size: 14px;
    color: #666;
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

.item-price {
    text-align: right;
    font-weight: 700;
    color: #e63946;
    font-size: 16px;
}

.item-price small {
    display: block;
    font-size: 12px;
    color: #666;
    margin-top: 2px;
}

/* Order Actions */
.order-actions {
    padding: 20px;
    background: #fafafa;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid #e9ecef;
    flex-wrap: wrap;
    gap: 15px;
}

.order-total {
    font-size: 20px;
    font-weight: 700;
    color: #333;
}

.order-total .currency {
    color: #e63946;
}

.btn-cancel {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 25px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 3px 10px rgba(220,53,69,0.3);
}

.btn-cancel:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(220,53,69,0.4);
    color: white;
}

.btn-cancel:disabled {
    background: #6c757d;
    cursor: not-allowed;
    opacity: 0.65;
    transform: none;
    box-shadow: none;
}

/* Empty State */
.no-orders {
    text-align: center;
    padding: 60px 20px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.no-orders i {
    font-size: 4rem;
    color: #ddd;
    margin-bottom: 20px;
}

.no-orders h4 {
    color: #333;
    margin-bottom: 15px;
}

.no-orders p {
    color: #666;
    margin-bottom: 25px;
}

.btn-shop {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    border: none;
    padding: 12px 25px;
    border-radius: 25px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    display: inline-block;
}

.btn-shop:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(40,167,69,0.3);
    color: white;
    text-decoration: none;
}

/* Pagination */
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
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    background: white;
}

.pagination li {
    margin: 0;
}

.pagination a {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 12px 16px;
    text-decoration: none;
    color: #495057;
    background-color: white;
    border-right: 1px solid #dee2e6;
    transition: all 0.3s ease;
    font-weight: 500;
}

.pagination li:last-child a {
    border-right: none;
}

.pagination a:hover {
    background-color: #e9ecef;
    color: #333;
}

.pagination .active a {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
    font-weight: 600;
}

.pagination .disabled a {
    color: #6c757d;
    cursor: not-allowed;
    background-color: #f8f9fa;
}

.pagination .disabled a:hover {
    background-color: #f8f9fa;
    color: #6c757d;
}

/* Toast Notifications */
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
    font-weight: 500;
}

.toast-success {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
}

.toast-error {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
}

@keyframes slideIn {
    from {transform: translateX(100%); opacity: 0;}
    to {transform: translateX(0); opacity: 1;}
}

@keyframes fadeOut {
    from {opacity: 1;}
    to {opacity: 0;}
}

/* Responsive Design */
@media (max-width: 1200px) {
    .user-content {
        padding: 20px;
    }
}

@media (max-width: 992px) {
    .orders-controls {
        flex-direction: column;
        align-items: stretch;
        text-align: center;
    }
    
    .order-header {
        flex-direction: column;
        text-align: center;
        gap: 15px;
    }
    
    .order-summary {
        grid-template-columns: repeat(2, 1fr);
        gap: 15px;
    }
    
    .item-row {
        flex-direction: column;
        align-items: flex-start;
        gap: 10px;
    }
    
    .item-price {
        text-align: left;
        align-self: flex-end;
    }
    
    .order-actions {
        flex-direction: column;
        gap: 15px;
        text-align: center;
    }
}

@media (max-width: 768px) {
    .page-header {
        padding: 15px;
        margin-bottom: 20px;
    }
    
    .page-header h2 {
        font-size: 1.5rem;
    }
    
    .orders-controls {
        padding: 15px;
    }
    
    .order-card {
        margin-bottom: 20px;
    }
    
    .order-header {
        padding: 15px;
    }
    
    .order-id {
        font-size: 16px;
    }
    
    .order-summary {
        grid-template-columns: 1fr;
        gap: 10px;
        padding: 15px;
    }
    
    .item-row {
        padding: 15px;
    }
    
    .item-name {
        font-size: 15px;
    }
    
    .item-details {
        flex-direction: column;
        gap: 5px;
    }
    
    .order-actions {
        padding: 15px;
    }
    
    .pagination a {
        padding: 10px 12px;
        font-size: 14px;
    }
    
    .toast {
        min-width: 250px;
        right: 10px;
    }
}

@media (max-width: 576px) {
    .user-content {
        padding: 10px;
    }
    
    .page-header {
        padding: 10px;
        margin-bottom: 15px;
    }
    
    .page-header h2 {
        font-size: 1.3rem;
    }
    
    .orders-controls {
        padding: 10px;
    }
    
    .orders-per-page {
        flex-direction: column;
        align-items: stretch;
        gap: 8px;
    }
    
    .orders-per-page select {
        width: 100%;
    }
    
    .order-header {
        padding: 10px;
    }
    
    .order-id {
        font-size: 15px;
    }
    
    .order-date {
        font-size: 13px;
    }
    
    .order-status {
        padding: 3px 8px;
        font-size: 11px;
    }
    
    .summary-value {
        font-size: 15px;
    }
    
    .summary-value.price {
        font-size: 16px;
    }
    
    .item-row {
        padding: 10px;
    }
    
    .item-name {
        font-size: 14px;
    }
    
    .item-price {
        font-size: 15px;
    }
    
    .order-actions {
        padding: 10px;
    }
    
    .order-total {
        font-size: 18px;
    }
    
    .btn-cancel {
        width: 100%;
        padding: 12px;
    }
    
    .pagination a {
        padding: 8px 10px;
        font-size: 13px;
    }
    
    .no-orders {
        padding: 40px 15px;
    }
    
    .no-orders i {
        font-size: 3rem;
    }
    
    .toast {
        min-width: 200px;
        right: 5px;
        padding: 12px 15px;
        font-size: 14px;
    }
}

/* Loading States */
.loading-spinner {
    display: inline-block;
    width: 16px;
    height: 16px;
    border: 2px solid #f3f3f3;
    border-top: 2px solid #666eea;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-right: 8px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>
</head>

<body class="order-container">
    <c:if test="${empty userobj}">
        <c:redirect url="login.jsp"/>
    </c:if>
    
    <%@include file="all_component/navbar.jsp"%>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <div class="user-content-main">
        <%@include file="all_component/nav-user-page.jsp" %>
        
        <div class="user-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-shopping-bag mr-3"></i>Đơn Hàng Của Tôi</h2>
            </div>

            <%
            // Pagination logic
            int currentPage = 1;
            int ordersPerPage = 5;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            String perPageParam = request.getParameter("perPage");
            if (perPageParam != null && !perPageParam.isEmpty()) {
                try {
                    ordersPerPage = Integer.parseInt(perPageParam);
                } catch (NumberFormatException e) {
                    ordersPerPage = 5;
                }
            }
            
            // Get all orders and group by order ID
            FashionOrderDAOImpl dao = new FashionOrderDAOImpl(DBConnect.getConn());
            List<Fashion_Order> allOrders = dao.getAllOrder();
            
            // Group orders by order ID
            Map<String, List<Fashion_Order>> groupedOrders = new LinkedHashMap<>();
            Map<String, Fashion_Order> orderInfo = new LinkedHashMap<>();
            
            for (Fashion_Order order : allOrders) {
                String orderId = order.getOrderId();
                if (orderId == null || orderId.isEmpty()) {
                    orderId = "ORDER-" + order.getId();
                }
                
                if (!groupedOrders.containsKey(orderId)) {
                    groupedOrders.put(orderId, new ArrayList<Fashion_Order>());
                    orderInfo.put(orderId, order);
                }
                groupedOrders.get(orderId).add(order);
            }
            
            // Convert to list for pagination
            List<String> orderIdsList = new ArrayList<String>(groupedOrders.keySet());
            
            int totalOrders = orderIdsList.size();
            int totalPages = (int) Math.ceil((double) totalOrders / ordersPerPage);
            
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
            
            int startIndex = (currentPage - 1) * ordersPerPage;
            int endIndex = Math.min(startIndex + ordersPerPage, totalOrders);
            
            List<String> currentPageOrderIds = new ArrayList<String>();
            if (totalOrders > 0) {
                for (int i = startIndex; i < endIndex; i++) {
                    currentPageOrderIds.add(orderIdsList.get(i));
                }
            }
            %>
            
            <!-- Orders Controls -->
            <% if (totalOrders > 0) { %>
            <div class="orders-controls">
                <div class="orders-per-page">
                    <label for="perPageSelect">Hiển thị:</label>
                    <select id="perPageSelect" name="perPage" onchange="changeOrdersPerPage(this.value)">
                        <option value="5" <%= ordersPerPage == 5 ? "selected" : "" %>>5</option>
                        <option value="10" <%= ordersPerPage == 10 ? "selected" : "" %>>10</option>
                        <option value="20" <%= ordersPerPage == 20 ? "selected" : "" %>>20</option>
                    </select>
                    <span>đơn hàng mỗi trang</span>
                </div>
                
                <div class="orders-info">
                    Hiển thị <%= startIndex + 1 %> đến <%= endIndex %> trong tổng số <%= totalOrders %> đơn hàng
                </div>
            </div>
            <% } %>
            
            <!-- Orders List -->
            <% if (totalOrders > 0) { %>
                <% for (String orderId : currentPageOrderIds) { 
                    List<Fashion_Order> orderItems = groupedOrders.get(orderId);
                    Fashion_Order mainOrder = orderInfo.get(orderId);
                    
                    // Calculate order total
                    double orderTotal = 0;
                    int totalItems = 0;
                    for (Fashion_Order item : orderItems) {
                        try {
                            String priceStr = item.getPrice();
                            if (priceStr != null) {
                                String cleanPrice = priceStr.replaceAll("[^0-9]", "");
                                if (!cleanPrice.isEmpty()) {
                                    double price = Double.parseDouble(cleanPrice);
                                    orderTotal += price * item.getQuantity();
                                }
                            }
                            totalItems += item.getQuantity();
                        } catch (Exception e) {
                            // Handle parsing error silently
                        }
                    }
                %>
                
                <div class="order-card">
                    <!-- Order Header -->
                    <div class="order-header">
                        <div>
                            <div class="order-id">Đơn hàng: <%= orderId %></div>
                            <div class="order-date">
                                <i class="fas fa-calendar-alt mr-1"></i>
                                Ngày đặt: <%= mainOrder.getDate() != null ? mainOrder.getDate() : "N/A" %>
                            </div>
                        </div>
                        <div class="order-status">
                            <i class="fas fa-clock mr-1"></i>Đang xử lý
                        </div>
                    </div>
                    
                    <!-- Order Summary -->
                    <div class="order-summary">
                        <div class="summary-item">
                            <span class="summary-label">Số sản phẩm</span>
                            <span class="summary-value"><%= totalItems %></span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Thanh toán</span>
                            <span class="summary-value"><%= mainOrder.getPaymentType() != null ? mainOrder.getPaymentType() : "COD" %></span>
                        </div>
                        <div class="summary-item">
                            <span class="summary-label">Tổng tiền</span>
                            <span class="summary-value price">
                                <span class="currency"><%= String.format("%,d", (long)orderTotal) %> VNĐ</span>
                            </span>
                        </div>
                    </div>
                    
                    <!-- Order Items -->
                    <div class="items-list">
                        <% for (Fashion_Order item : orderItems) { 
                            String formattedPrice = "";
                            try {
                                String priceStr = item.getPrice();
                                if (priceStr != null) {
                                    String cleanPrice = priceStr.replaceAll("[^0-9]", "");
                                    if (!cleanPrice.isEmpty()) {
                                        long price = Long.parseLong(cleanPrice);
                                        formattedPrice = String.format("%,d", price);
                                    } else {
                                        formattedPrice = "0";
                                    }
                                } else {
                                    formattedPrice = "0";
                                }
                            } catch (Exception e) {
                                formattedPrice = "0";
                            }
                        %>
                        <div class="item-row">
                            <div class="item-info">
                                <div class="item-name">
                                    <i class="fas fa-tshirt mr-2"></i>
                                    <%= item.getFashionName() != null ? item.getFashionName() : "Sản phẩm không xác định" %>
                                </div>
                                <div class="item-details">
                                    <span><i class="fas fa-expand-arrows-alt mr-1"></i>Size: <%= item.getSize() != null ? item.getSize() : "N/A" %></span>
                                    <span><i class="fas fa-shopping-cart mr-1"></i>Số lượng: <%= item.getQuantity() %></span>
                                </div>
                            </div>
                            <div class="item-price">
                                <%= formattedPrice %> VNĐ
                                <% if (item.getQuantity() > 1) { %>
                                <small>(× <%= item.getQuantity() %>)</small>
                                <% } %>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Order Actions -->
                    <div class="order-actions">
                        <div class="order-total">
                            Tổng cộng: <span class="currency"><%= String.format("%,d", (long)orderTotal) %> VNĐ</span>
                        </div>
                        <button class="btn-cancel" onclick="cancelOrder('<%= orderId %>')" 
                                title="Hủy đơn hàng này">
                            <i class="fas fa-times mr-2"></i>Hủy đơn hàng
                        </button>
                    </div>
                </div>
                
                <% } %>
                
            <% } else { %>
            <!-- Empty State -->
            <div class="no-orders">
                <i class="fas fa-shopping-bag"></i>
                <h4>Bạn chưa có đơn hàng nào</h4>
                <p>Hãy thực hiện mua sắm để xem đơn hàng tại đây</p>
                <a href="index.jsp" class="btn-shop">
                    <i class="fas fa-shopping-cart mr-2"></i>Tiếp tục mua sắm
                </a>
            </div>
            <% } %>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <div class="pagination-container">
                <ul class="pagination">
                    <!-- Previous Button -->
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&perPage=<%= ordersPerPage %>">
                            <i class="fas fa-chevron-left mr-1"></i>Trước
                        </a>
                    </li>
                    
                    <!-- First Page -->
                    <% if (currentPage > 3) { %>
                    <li class="page-item">
                        <a class="page-link" href="?page=1&perPage=<%= ordersPerPage %>">1</a>
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
                        <a class="page-link" href="?page=<%= i %>&perPage=<%= ordersPerPage %>"><%= i %></a>
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
                        <a class="page-link" href="?page=<%= totalPages %>&perPage=<%= ordersPerPage %>"><%= totalPages %></a>
                    </li>
                    <% } %>
                    
                    <!-- Next Button -->
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&perPage=<%= ordersPerPage %>">
                            Sau<i class="fas fa-chevron-right ml-1"></i>
                        </a>
                    </li>
                </ul>
            </div>
            <% } %>
        </div>
    </div>

    <%@include file="all_component/footer.jsp"%>

    <script>
    // Function to change orders per page
    function changeOrdersPerPage(perPage) {
        window.location.href = '?page=1&perPage=' + perPage;
    }

    // Function to cancel order
    function cancelOrder(orderId) {
        if (confirm('Bạn có chắc chắn muốn hủy đơn hàng ' + orderId + ' không?')) {
            // Show loading state
            var button = event.target.closest('.btn-cancel');
            var originalText = button.innerHTML;
            button.innerHTML = '<span class="loading-spinner"></span>Đang hủy...';
            button.disabled = true;
            
            // Send AJAX request
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'cancel_order', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            if (data.success) {
                                showToast('Đơn hàng đã được hủy thành công', 'success');
                                // Reload page after a short delay
                                setTimeout(function() {
                                    location.reload();
                                }, 1000);
                            } else {
                                showToast(data.message || 'Không thể hủy đơn hàng', 'error');
                                // Restore button state
                                button.innerHTML = originalText;
                                button.disabled = false;
                            }
                        } catch (e) {
                            showToast('Đã xảy ra lỗi khi xử lý phản hồi', 'error');
                            button.innerHTML = originalText;
                            button.disabled = false;
                        }
                    } else {
                        showToast('Đã xảy ra lỗi khi hủy đơn hàng', 'error');
                        // Restore button state
                        button.innerHTML = originalText;
                        button.disabled = false;
                    }
                }
            };
            
            xhr.send('orderId=' + encodeURIComponent(orderId));
        }
    }

    // Function to show toast notification
    function showToast(message, type) {
        var toastContainer = document.getElementById('toastContainer');
        var toastId = 'toast-' + Date.now();
        
        var toast = document.createElement('div');
        toast.id = toastId;
        toast.className = 'toast toast-' + type;
        toast.innerHTML = 
            '<i class="fas ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle') + ' mr-2"></i>' +
            '<span>' + message + '</span>' +
            '<button type="button" onclick="closeToast(\'' + toastId + '\')" style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer; font-size: 18px;">&times;</button>';
        
        toastContainer.appendChild(toast);
        
        // Auto remove after 5 seconds
        setTimeout(function() {
            closeToast(toastId);
        }, 5000);
    }

    // Function to close toast
    function closeToast(toastId) {
        var toast = document.getElementById(toastId);
        if (toast) {
            toast.style.animation = 'fadeOut 0.5s';
            setTimeout(function() {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 500);
        }
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        // Add any page initialization code here
        console.log('Order page loaded successfully');
    });
    </script>
</body>
</html>