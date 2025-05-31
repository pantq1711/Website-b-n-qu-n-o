<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.DAO.FashionReviewDAOImpl"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.entity.*"%>
<%@ page import="java.util.*"%>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá Của Tôi</title>
    <%@include file="all_component/allCss.jsp"%>
    <link rel="stylesheet" href="all_component/userPageStyle.css">
    <style>
        /* Reviews Page Specific Styles */
        .reviews-container {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(255, 126, 95, 0.3);
        }
        
        .page-header h2 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        
        .page-header .subtitle {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 5px;
        }
        
        .content-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            overflow: hidden;
            border: 1px solid #e9ecef;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .card-header-custom h4 {
            margin: 0;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        
        .badge-count {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            backdrop-filter: blur(10px);
        }
        
        .pending-reviews-section {
            padding: 25px;
        }
        
        .pending-grid {
            display: grid;
            gap: 15px;
            margin-top: 20px;
        }
        
        .pending-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            transition: all 0.3s ease;
            border-left: 4px solid #ff7e5f;
        }
        
        .pending-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .product-info {
            flex: 1;
        }
        
        .product-info h6 {
            margin: 0 0 8px 0;
            color: #333;
            font-weight: 600;
            font-size: 16px;
        }
        
        .product-info small {
            color: #666;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .product-info small i {
            margin-right: 4px;
        }
        
        .btn-write-review {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
            box-shadow: 0 3px 10px rgba(255, 126, 95, 0.3);
        }
        
        .btn-write-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 126, 95, 0.4);
            color: white;
        }
        
        .reviews-section {
            padding: 25px;
        }
        
        .review-card {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            margin-bottom: 20px;
            padding: 20px;
            background: white;
            transition: all 0.3s ease;
            border-left: 4px solid #28a745;
        }
        
        .review-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .product-name {
            color: #333;
            font-weight: 600;
            margin: 0;
            font-size: 16px;
        }
        
        .review-date {
            color: #666;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .star-rating {
            color: #ffc107;
            font-size: 18px;
            margin: 10px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .rating-text {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }
        
        .review-content {
            margin: 15px 0;
        }
        
        .review-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .review-text {
            color: #555;
            line-height: 1.6;
            font-size: 15px;
        }
        
        .review-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn-review {
            padding: 8px 16px;
            border-radius: 20px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.3);
        }
        
        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h5 {
            margin-bottom: 15px;
            color: #333;
            font-size: 1.5rem;
        }
        
        .empty-state p {
            color: #666;
            margin-bottom: 25px;
            font-size: 16px;
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
        
        /* Modal Styles */
        .modal-content {
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .modal-header-custom {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            border-radius: 12px 12px 0 0;
            padding: 20px;
            border: none;
        }
        
        .modal-header-custom .close {
            color: white;
            opacity: 0.8;
            font-size: 24px;
        }
        
        .modal-header-custom .close:hover {
            opacity: 1;
        }
        
        .star-input {
            display: flex;
            gap: 8px;
            margin: 15px 0;
            justify-content: flex-start;
        }
        
        .star-input input[type="radio"] {
            display: none;
        }
        
        .star-input label {
            font-size: 28px;
            color: #ddd;
            cursor: pointer;
            transition: all 0.3s ease;
            user-select: none;
        }
        
        .star-input label:hover {
            color: #ffc107;
            transform: scale(1.1);
        }
        
        .star-input label.active {
            color: #ffc107;
        }
        
        .modal-body {
            padding: 30px;
        }
        
        .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 12px;
            transition: border-color 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #ff7e5f;
            box-shadow: 0 0 0 0.2rem rgba(255, 126, 95, 0.25);
        }
        
        .btn-submit-review {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-submit-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 126, 95, 0.4);
            color: white;
        }
        
        /* Responsive Design */
        @media (max-width: 1200px) {
            .user-content {
                padding: 20px;
            }
        }
        
        @media (max-width: 992px) {
            .pending-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .btn-write-review {
                align-self: stretch;
                text-align: center;
            }
            
            .review-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .review-actions {
                justify-content: flex-start;
                flex-wrap: wrap;
            }
            
            .card-header-custom {
                flex-direction: column;
                text-align: center;
                gap: 15px;
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
            
            .content-card {
                margin-bottom: 20px;
            }
            
            .card-header-custom {
                padding: 15px;
            }
            
            .card-header-custom h4 {
                font-size: 1.1rem;
            }
            
            .pending-reviews-section,
            .reviews-section {
                padding: 20px;
            }
            
            .pending-item {
                padding: 15px;
            }
            
            .product-info h6 {
                font-size: 15px;
            }
            
            .product-info small {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            
            .review-card {
                padding: 15px;
            }
            
            .star-input {
                justify-content: center;
            }
            
            .star-input label {
                font-size: 24px;
            }
            
            .pagination a {
                padding: 10px 12px;
                font-size: 14px;
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
                flex-direction: column;
                text-align: center;
                gap: 5px;
            }
            
            .card-header-custom {
                padding: 10px;
            }
            
            .card-header-custom h4 {
                font-size: 1rem;
            }
            
            .pending-reviews-section,
            .reviews-section {
                padding: 15px;
            }
            
            .pending-item {
                padding: 10px;
            }
            
            .btn-write-review {
                padding: 8px 16px;
                font-size: 13px;
            }
            
            .review-card {
                padding: 10px;
            }
            
            .product-name {
                font-size: 15px;
            }
            
            .review-title {
                font-size: 15px;
            }
            
            .review-text {
                font-size: 14px;
            }
            
            .star-input label {
                font-size: 20px;
            }
            
            .modal-body {
                padding: 20px;
            }
            
            .empty-state {
                padding: 40px 15px;
            }
            
            .empty-state i {
                font-size: 3rem;
            }
            
            .empty-state h5 {
                font-size: 1.3rem;
            }
            
            .pagination a {
                padding: 8px 10px;
                font-size: 13px;
            }
        }
        
        /* Alert Styles */
        .alert {
            border-radius: 8px;
            padding: 15px 20px;
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert .close {
            font-size: 20px;
            font-weight: 600;
            opacity: 0.7;
        }
        
        .alert .close:hover {
            opacity: 1;
        }
    </style>
</head>
<body class="reviews-container">
    <c:if test="${empty userobj}">
        <c:redirect url="login.jsp"/>
    </c:if>
    
    <%@include file="all_component/navbar.jsp"%>
    
    <div class="user-content-main">
        <%@include file="all_component/nav-user-page.jsp"%>
        
        <div class="user-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2>
                    <i class="fas fa-star mr-3"></i>
                    <span>Đánh Giá Của Tôi</span>
                </h2>
                <div class="subtitle">Quản lý và theo dõi các đánh giá sản phẩm của bạn</div>
            </div>
            
            <!-- Alert Messages -->
            <c:if test="${not empty succMsg}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle mr-2"></i>${succMsg}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
                <c:remove var="succMsg" scope="session"/>
            </c:if>
            
            <c:if test="${not empty failedMsg}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle mr-2"></i>${failedMsg}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
                <c:remove var="failedMsg" scope="session"/>
            </c:if>
            
            <%
            User user = (User) session.getAttribute("userobj");
            FashionReviewDAOImpl reviewDao = new FashionReviewDAOImpl(DBConnect.getConn());
            
            // Lấy danh sách đơn hàng có thể đánh giá
            List<Map<String, Object>> reviewableOrders = reviewDao.getReviewableOrders(user.getId());
            
            // Lọc sản phẩm chưa đánh giá
            List<Map<String, Object>> pendingReviews = new ArrayList<>();
            for (Map<String, Object> order : reviewableOrders) {
                if (!(Boolean) order.get("hasReview")) {
                    pendingReviews.add(order);
                }
            }
            
            // Pagination cho pending reviews
            int pendingPage = 1;
            int pendingPerPage = 5;
            String pendingPageParam = request.getParameter("pendingPage");
            if (pendingPageParam != null) {
                try {
                    pendingPage = Integer.parseInt(pendingPageParam);
                } catch (NumberFormatException e) {
                    pendingPage = 1;
                }
            }
            
            int totalPending = pendingReviews.size();
            int totalPendingPages = (int) Math.ceil((double) totalPending / pendingPerPage);
            int pendingStart = (pendingPage - 1) * pendingPerPage;
            int pendingEnd = Math.min(pendingStart + pendingPerPage, totalPending);
            
            List<Map<String, Object>> currentPendingReviews = new ArrayList<>();
            if (totalPending > 0) {
                currentPendingReviews = pendingReviews.subList(pendingStart, pendingEnd);
            }
            %>
            
            <!-- Pending Reviews Section -->
            <% if (totalPending > 0) { %>
            <div class="content-card">
                <div class="card-header-custom">
                    <h4><i class="fas fa-clock mr-2"></i>Sản phẩm chờ đánh giá</h4>
                    <span class="badge-count"><%=totalPending%> sản phẩm</span>
                </div>
                
                <div class="pending-reviews-section">
                    <div class="pending-grid">
                        <% for (Map<String, Object> order : currentPendingReviews) { %>
                        <div class="pending-item">
                            <div class="product-info">
                                <h6><%=order.get("fashionName")%></h6>
                                <small>
                                    <span><i class="fas fa-receipt"></i>Đơn hàng: <%=order.get("orderId")%></span>
                                    <span><i class="fas fa-calendar-alt"></i><%=order.get("orderDate")%></span>
                                </small>
                            </div>
                            <button class="btn-write-review" 
                                    onclick="openReviewModal('<%=order.get("fashionId")%>', '<%=order.get("orderId")%>', '<%=order.get("fashionName")%>')">
                                <i class="fas fa-pen mr-2"></i>Viết đánh giá
                            </button>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Pagination for Pending Reviews -->
                    <% if (totalPendingPages > 1) { %>
                    <div class="pagination-container">
                        <ul class="pagination">
                            <li class="<%=pendingPage == 1 ? "disabled" : ""%>">
                                <a href="?pendingPage=<%=pendingPage - 1%>">
                                    <i class="fas fa-chevron-left mr-1"></i>Trước
                                </a>
                            </li>
                            
                            <% for (int i = 1; i <= totalPendingPages; i++) { %>
                            <li class="<%=i == pendingPage ? "active" : ""%>">
                                <a href="?pendingPage=<%=i%>"><%=i%></a>
                            </li>
                            <% } %>
                            
                            <li class="<%=pendingPage == totalPendingPages ? "disabled" : ""%>">
                                <a href="?pendingPage=<%=pendingPage + 1%>">
                                    Sau<i class="fas fa-chevron-right ml-1"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
            
            <%
            // Pagination cho đánh giá đã viết
            int reviewPage = 1;
            int reviewPerPage = 5;
            String reviewPageParam = request.getParameter("reviewPage");
            if (reviewPageParam != null) {
                try {
                    reviewPage = Integer.parseInt(reviewPageParam);
                } catch (NumberFormatException e) {
                    reviewPage = 1;
                }
            }
            
            List<FashionReview> allReviews = reviewDao.getReviewsByUserId(user.getId());
            int totalReviews = allReviews.size();
            int totalReviewPages = (int) Math.ceil((double) totalReviews / reviewPerPage);
            int reviewStart = (reviewPage - 1) * reviewPerPage;
            int reviewEnd = Math.min(reviewStart + reviewPerPage, totalReviews);
            
            List<FashionReview> currentReviews = new ArrayList<>();
            if (totalReviews > 0) {
                currentReviews = allReviews.subList(reviewStart, reviewEnd);
            }
            %>
            
            <!-- My Reviews Section -->
            <div class="content-card">
                <div class="card-header-custom">
                    <h4><i class="fas fa-star mr-2"></i>Đánh giá đã viết</h4>
                    <span class="badge-count"><%=totalReviews%> đánh giá</span>
                </div>
                
                <div class="reviews-section">
                    <% if (totalReviews == 0) { %>
                    <div class="empty-state">
                        <i class="fas fa-star"></i>
                        <h5>Bạn chưa có đánh giá nào</h5>
                        <p>Hãy mua sắm và chia sẻ trải nghiệm của bạn về sản phẩm!</p>
                        <a href="index.jsp" class="btn-shop">
                            <i class="fas fa-shopping-bag mr-2"></i>Tiếp tục mua sắm
                        </a>
                    </div>
                    <% } else { %>
                    
                    <% for (FashionReview review : currentReviews) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <h5 class="product-name"><%=review.getFashionName()%></h5>
                            <div class="review-date">
                                <i class="fas fa-calendar-alt"></i>
                                <%=review.getReviewDate()%>
                            </div>
                        </div>
                        
                        <div class="star-rating">
                            <%=review.getStarRating()%>
                            <span class="rating-text">(<%=review.getRating()%>/5 sao)</span>
                        </div>
                        
                        <div class="review-content">
                            <% if (review.getReviewTitle() != null && !review.getReviewTitle().isEmpty()) { %>
                            <div class="review-title"><%=review.getReviewTitle()%></div>
                            <% } %>
                            <% if (review.getReviewContent() != null && !review.getReviewContent().isEmpty()) { %>
                            <div class="review-text"><%=review.getReviewContent()%></div>
                            <% } %>
                        </div>
                        
                        <div class="review-actions">
                            <button class="btn-review btn-delete" 
                                    onclick="deleteReview(<%=review.getReviewId()%>)">
                                <i class="fas fa-trash mr-2"></i>Xóa đánh giá
                            </button>
                        </div>
                    </div>
                    <% } %>
                    
                    <!-- Pagination for Reviews -->
                    <% if (totalReviewPages > 1) { %>
                    <div class="pagination-container">
                        <ul class="pagination">
                            <li class="<%=reviewPage == 1 ? "disabled" : ""%>">
                                <a href="?reviewPage=<%=reviewPage - 1%><%=request.getParameter("pendingPage") != null ? "&pendingPage=" + request.getParameter("pendingPage") : ""%>">
                                    <i class="fas fa-chevron-left mr-1"></i>Trước
                                </a>
                            </li>
                            
                            <% for (int i = 1; i <= totalReviewPages; i++) { %>
                            <li class="<%=i == reviewPage ? "active" : ""%>">
                                <a href="?reviewPage=<%=i%><%=request.getParameter("pendingPage") != null ? "&pendingPage=" + request.getParameter("pendingPage") : ""%>"><%=i%></a>
                            </li>
                            <% } %>
                            
                            <li class="<%=reviewPage == totalReviewPages ? "disabled" : ""%>">
                                <a href="?reviewPage=<%=reviewPage + 1%><%=request.getParameter("pendingPage") != null ? "&pendingPage=" + request.getParameter("pendingPage") : ""%>">
                                    Sau<i class="fas fa-chevron-right ml-1"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <% } %>
                    
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Review Modal -->
    <div class="modal fade" id="reviewModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header-custom">
                    <h5 class="modal-title">
                        <i class="fas fa-star mr-2"></i>Viết đánh giá sản phẩm
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                
                <form action="add_review" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="modalFashionId" name="fashionId">
                        <input type="hidden" id="modalOrderId" name="orderId">
                        
                        <div class="form-group">
                            <label><strong>Sản phẩm:</strong></label>
                            <p id="modalFashionName" class="text-primary" style="font-size: 16px; font-weight: 600;"></p>
                        </div>
                        
                        <div class="form-group">
                            <label><strong>Đánh giá của bạn:</strong></label>
                            <div class="star-input">
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1" data-rating="1">★</label>
                                
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2" data-rating="2">★</label>
                                
                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3" data-rating="3">★</label>
                                
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4" data-rating="4">★</label>
                                
                                <input type="radio" id="star5" name="rating" value="5">
                                <label for="star5" data-rating="5">★</label>
                            </div>
                            <div id="rating-text" class="mt-2 text-muted"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="reviewTitle"><strong>Tiêu đề đánh giá: *</strong></label>
                            <input type="text" class="form-control" id="reviewTitle" 
                                   name="reviewTitle" maxlength="200" required
                                   placeholder="Nhập tiêu đề cho đánh giá của bạn">
                        </div>
                        
                        <div class="form-group">
                            <label for="reviewContent"><strong>Nội dung đánh giá:</strong></label>
                            <textarea class="form-control" id="reviewContent" name="reviewContent" 
                                      rows="5" maxlength="1000"
                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."></textarea>
                            <small class="form-text text-muted">Tối đa 1000 ký tự</small>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fas fa-times mr-2"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-submit-review">
                            <i class="fas fa-paper-plane mr-2"></i>Gửi đánh giá
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%@include file="all_component/footer.jsp"%>
    
    <script>
        // Mở modal đánh giá
        function openReviewModal(fashionId, orderId, fashionName) {
            document.getElementById('modalFashionId').value = fashionId;
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('modalFashionName').textContent = fashionName;
            
            // Reset form
            document.querySelector('#reviewModal form').reset();
            resetStars();
            document.getElementById('rating-text').textContent = '';
            
            $('#reviewModal').modal('show');
        }
        
        // Xóa đánh giá
        function deleteReview(reviewId) {
            if (confirm('Bạn có chắc chắn muốn xóa đánh giá này?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete_review';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'reviewId';
                input.value = reviewId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Star rating functionality
        document.addEventListener('DOMContentLoaded', function() {
            const starLabels = document.querySelectorAll('.star-input label');
            const ratingText = document.getElementById('rating-text');
            
            const ratingTexts = {
                1: "Rất tệ - Sản phẩm không như mong đợi",
                2: "Tệ - Có nhiều vấn đề cần cải thiện", 
                3: "Trung bình - Sản phẩm ổn",
                4: "Tốt - Sản phẩm chất lượng",
                5: "Xuất sắc - Sản phẩm tuyệt vời!"
            };
            
            starLabels.forEach((label, index) => {
                const rating = parseInt(label.getAttribute('data-rating'));
                
                label.addEventListener('mouseenter', function() {
                    highlightStars(rating);
                    if (ratingText) ratingText.textContent = ratingTexts[rating];
                });
                
                label.addEventListener('click', function() {
                    const radioButton = document.getElementById(label.getAttribute('for'));
                    radioButton.checked = true;
                    highlightStars(rating);
                    if (ratingText) {
                        ratingText.textContent = ratingTexts[rating];
                        ratingText.style.fontWeight = 'bold';
                        ratingText.style.color = '#28a745';
                    }
                });
            });
            
            // Reset khi rời khỏi star container
            const starContainer = document.querySelector('.star-input');
            if (starContainer) {
                starContainer.addEventListener('mouseleave', function() {
                    const checkedInput = document.querySelector('.star-input input[type="radio"]:checked');
                    if (checkedInput) {
                        const checkedRating = parseInt(checkedInput.value);
                        highlightStars(checkedRating);
                        if (ratingText) {
                            ratingText.textContent = ratingTexts[checkedRating];
                            ratingText.style.fontWeight = 'bold';
                            ratingText.style.color = '#28a745';
                        }
                    } else {
                        resetStars();
                        if (ratingText) ratingText.textContent = '';
                    }
                });
            }
            
            // Auto close alerts
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
        });
        
        function highlightStars(rating) {
            const starLabels = document.querySelectorAll('.star-input label');
            starLabels.forEach((label, index) => {
                const labelRating = parseInt(label.getAttribute('data-rating'));
                if (labelRating <= rating) {
                    label.style.color = '#ffc107';
                } else {
                    label.style.color = '#ddd';
                }
            });
        }
        
        function resetStars() {
            const starLabels = document.querySelectorAll('.star-input label');
            starLabels.forEach(label => {
                label.style.color = '#ddd';
            });
        }
    </script>
</body>
</html>