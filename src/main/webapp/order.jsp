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
<title>Order Fashion</title>
<%@include file="all_component/allCss.jsp"%>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<style>
table {
    border-collapse: collapse;
    width: 100%;
    margin-bottom: 20px;
}

th, td {
    padding: 12px 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
    vertical-align: top;
}

th {
    font-size: 18px;
    color: black !important;
    font-weight: 700 !important;
    font-family: 'Roboto', sans-serif;
    background-color: #f8f9fa;
}

td {
    font-family: 'Roboto', sans-serif !important;
    color: black !important;
    font-size: 16px !important;
}

/* Order Card Styles */
.order-card {
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    margin-bottom: 20px;
    background: white;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    overflow: hidden;
}

.order-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px 20px;
}

.order-id {
    font-weight: bold;
    font-size: 16px;
}

.order-date {
    font-size: 14px;
    opacity: 0.9;
}

.order-body {
    padding: 0;
}

.order-summary {
    background: #f8f9fa;
    padding: 15px 20px;
    border-bottom: 1px solid #e0e0e0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
}

.summary-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 5px 0;
}

.summary-label {
    font-size: 12px;
    color: #666;
    text-transform: uppercase;
}

.summary-value {
    font-weight: bold;
    color: #333;
    font-size: 16px;
}

.items-list {
    max-height: 300px;
    overflow-y: auto;
}

.item-row {
    padding: 12px 20px;
    border-bottom: 1px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.item-row:last-child {
    border-bottom: none;
}

.item-info {
    flex-grow: 1;
}

.item-name {
    font-weight: bold;
    color: #333;
    margin-bottom: 4px;
}

.item-details {
    font-size: 14px;
    color: #666;
}

.item-price {
    text-align: right;
    font-weight: bold;
    color: #e63946;
}

.order-actions {
    padding: 15px 20px;
    background: #fafafa;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 1px solid #e0e0e0;
}

.order-total {
    font-size: 18px;
    font-weight: bold;
    color: #333;
}

.btn-cancel {
    background-color: #dc3545;
    border-color: #dc3545;
    color: white;
    padding: 8px 16px;
    border-radius: 4px;
    font-size: 14px;
    border: none;
    cursor: pointer;
    transition: all 0.3s ease;
}

.btn-cancel:hover {
    background-color: #c82333;
    border-color: #bd2130;
}

.btn-cancel:disabled {
    background-color: #6c757d;
    cursor: not-allowed;
    opacity: 0.65;
}

.status-pending {
    background-color: #ffc107;
    color: #212529;
}

.status-completed {
    background-color: #28a745;
}

.status-cancelled {
    background-color: #dc3545;
}

/* Pagination Styles */
.pagination-container {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
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
    border-radius: 0.25rem;
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

.orders-info {
    margin-bottom: 15px;
    color: #6c757d;
    font-size: 14px;
    text-align: center;
}

.orders-per-page {
    margin-bottom: 15px;
    text-align: center;
}

.orders-per-page select {
    padding: 5px 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
}

.orders-per-page label {
    margin-right: 10px;
    font-weight: 500;
}

.no-orders {
    text-align: center;
    padding: 40px 20px;
    color: #6c757d;
}

.no-orders i {
    font-size: 3rem;
    margin-bottom: 15px;
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

@keyframes slideIn {
    from {transform: translateX(100%); opacity: 0;}
    to {transform: translateX(0); opacity: 1;}
}

@keyframes fadeOut {
    from {opacity: 1;}
    to {opacity: 0;}
}

/* Responsive design */
@media (max-width: 768px) {
    .order-header {
        flex-direction: column;
        text-align: center;
    }
    
    .order-summary {
        flex-direction: column;
        gap: 15px;
    }
    
    .item-row {
        flex-direction: column;
        align-items: flex-start;
        gap: 8px;
    }
    
    .item-price {
        text-align: left;
        align-self: flex-end;
    }
    
    .order-actions {
        flex-direction: column;
        gap: 10px;
    }
    
    .pagination {
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .pagination li {
        margin: 2px;
    }
}

@media (max-width: 576px) {
    .pagination li a {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    
    .orders-per-page {
        text-align: left;
    }
    
    .order-card {
        margin-bottom: 15px;
    }
    
    .order-summary {
        padding: 10px 15px;
    }
    
    .item-row {
        padding: 10px 15px;
    }
}
</style>
</head>

<body style="background-color: #f0f1f2;">
<%@include file="all_component/navbar.jsp"%>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer"></div>

<div class="user-content-main">
<%@include file="all_component/nav-user-page.jsp" %>
<div class="user-content">
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
    
    // Group orders by order ID - simplified approach
    Map<String, List<Fashion_Order>> groupedOrders = new LinkedHashMap<>();
    Map<String, Fashion_Order> orderInfo = new LinkedHashMap<>();
    
    for (Fashion_Order order : allOrders) {
        String orderId = order.getOrderId();
        if (orderId == null || orderId.isEmpty()) {
            orderId = "ORDER-" + order.getId(); // Fallback if no order ID
        }
        
        if (!groupedOrders.containsKey(orderId)) {
            groupedOrders.put(orderId, new ArrayList<Fashion_Order>());
            orderInfo.put(orderId, order); // Store order info for header
        }
        groupedOrders.get(orderId).add(order);
    }
    
    // Convert to simple list for pagination
    List<String> orderIdsList = new ArrayList<String>();
    for (String key : groupedOrders.keySet()) {
        orderIdsList.add(key);
    }
    
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
    
    <!-- Orders per page selector -->
    <div class="orders-per-page">
        <label for="perPageSelect">Hiển thị:</label>
        <select id="perPageSelect" name="perPage" onchange="changeOrdersPerPage(this.value)">
            <option value="5" <%= ordersPerPage == 5 ? "selected" : "" %>>5</option>
            <option value="10" <%= ordersPerPage == 10 ? "selected" : "" %>>10</option>
            <option value="20" <%= ordersPerPage == 20 ? "selected" : "" %>>20</option>
        </select>
        <span> đơn hàng mỗi trang</span>
    </div>
    
    <!-- Orders info -->
    <% if (totalOrders > 0) { %>
    <div class="orders-info">
        Hiển thị <%= startIndex + 1 %> đến <%= endIndex %> trong tổng số <%= totalOrders %> đơn hàng
    </div>
    <% } %>
    
    <% if (totalOrders > 0) { %>
        <!-- Display grouped orders -->
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
                    <div class="order-date">Ngày đặt: <%= mainOrder.getDate() != null ? mainOrder.getDate() : "N/A" %></div>
                </div>
            </div>
            
            <!-- Order Summary -->
            <div class="order-summary">
                <div class="summary-item">
                    <span class="summary-label">Số sản phẩm</span>
                    <span class="summary-value"><%= totalItems %></span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">Phương thức thanh toán</span>
                    <span class="summary-value"><%= mainOrder.getPaymentType() != null ? mainOrder.getPaymentType() : "COD" %></span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">Tổng tiền</span>
                    <span class="summary-value" style="color: #e63946;">
                        <%= String.format("%,d", (long)orderTotal) %> VNĐ
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
                        <div class="item-name"><%= item.getFashionName() != null ? item.getFashionName() : "Unknown Product" %></div>
                        <div class="item-details">
                            Size: <%= item.getSize() != null ? item.getSize() : "N/A" %> | Số lượng: <%= item.getQuantity() %>
                        </div>
                    </div>
                    <div class="item-price">
                        <%= formattedPrice %> VNĐ
                        <% if (item.getQuantity() > 1) { %>
                        <br><small>(× <%= item.getQuantity() %>)</small>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
            
            <!-- Order Actions -->
            <div class="order-actions">
                <div class="order-total">
                    Tổng: <%= String.format("%,d", (long)orderTotal) %> VNĐ
                </div>
                <button class="btn-cancel" onclick="cancelOrder('<%= orderId %>')" 
                        title="Hủy đơn hàng này">
                    <i class="fas fa-times mr-1"></i> Hủy đơn
                </button>
            </div>
        </div>
        
        <% } %>
        
    <% } else { %>
    <div class="no-orders">
        <i class="fas fa-shopping-bag"></i>
        <h4>Bạn chưa có đơn hàng nào</h4>
        <p>Hãy thực hiện mua sắm để xem đơn hàng tại đây</p>
        <a href="index.jsp" class="btn btn-primary">Tiếp tục mua sắm</a>
    </div>
    <% } %>
    
    <!-- Pagination Controls -->
    <% if (totalPages > 1) { %>
    <div class="pagination-container">
        <ul class="pagination">
            <!-- Previous Button -->
            <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                <a class="page-link" href="?page=<%= currentPage - 1 %>&perPage=<%= ordersPerPage %>">
                    <i class="fas fa-chevron-left"></i> Previous
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
                    Next <i class="fas fa-chevron-right"></i>
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
        button.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Đang hủy...';
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
        '<button type="button" onclick="closeToast(\'' + toastId + '\')" style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer;">&times;</button>';
    
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

// Set active navigation
var items = document.querySelectorAll('.nav-ver.nav-link');
if (items.length > 1) {
    items[1].classList.add('active');
    var text = document.querySelector('.nav-ver.nav-link.active');
    if (text && document.getElementById('direction')) {
        document.getElementById('direction').innerHTML = text.innerHTML;
    }
}
</script>

</body>
</html>