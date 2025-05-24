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
        .reviews-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px 0;
        }
        
        .content-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .card-header-custom {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-header-custom h4 {
            margin: 0;
            font-weight: 600;
        }
        
        .badge-count {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
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
            padding: 15px 20px;
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .pending-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .product-info h6 {
            margin: 0 0 5px 0;
            color: #333;
            font-weight: 600;
        }
        
        .product-info small {
            color: #666;
            font-size: 13px;
        }
        
        .btn-write-review {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            white-space: nowrap;
        }
        
        .btn-write-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            color: white;
        }
        
        .reviews-section {
            padding: 25px;
        }
        
        .review-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 20px;
            background: white;
            transition: all 0.3s ease;
        }
        
        .review-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
        }
        
        .review-date {
            color: #666;
            font-size: 14px;
        }
        
        .star-rating {
            color: #ffc107;
            font-size: 18px;
            margin: 10px 0;
        }
        
        .review-content {
            margin: 15px 0;
        }
        
        .review-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .review-text {
            color: #555;
            line-height: 1.6;
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
            transition: all 0.3s ease;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #c82333;
            transform: translateY(-1px);
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
        }
        
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
        
        .section-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .toggle-section {
            background: none;
            border: none;
            color: #007bff;
            cursor: pointer;
            font-size: 14px;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        .toggle-section:hover {
            background: #f8f9fa;
        }
        
        .collapsed-section {
            display: none;
        }
        
        /* Modal styles */
        .modal-content {
            border-radius: 10px;
            border: none;
        }
        
        .modal-header-custom {
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            color: white;
            border-radius: 10px 10px 0 0;
            padding: 20px;
        }
        
        .modal-header-custom .close {
            color: white;
            opacity: 0.8;
        }
        
        .star-input {
            display: flex;
            gap: 5px;
            margin: 15px 0;
            flex-direction: row;
        }
        
        .star-input input[type="radio"] {
            display: none;
        }
        
        .star-input label {
            font-size: 24px;
            color: #ddd;
            cursor: pointer;
            transition: color 0.3s ease;
            user-select: none;
        }
        
        .star-input label:hover {
            color: #ffc107;
        }
        
        .star-input label.active {
            color: #ffc107;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .pending-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .btn-write-review {
                align-self: flex-end;
            }
            
            .review-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .review-actions {
                justify-content: flex-start;
            }
            
            .section-title {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
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
                                    <i class="fas fa-receipt mr-1"></i>Đơn hàng: <%=order.get("orderId")%> | 
                                    <i class="fas fa-calendar mr-1"></i><%=order.get("orderDate")%>
                                </small>
                            </div>
                            <button class="btn-write-review" 
                                    onclick="openReviewModal('<%=order.get("fashionId")%>', '<%=order.get("orderId")%>', '<%=order.get("fashionName")%>')">
                                <i class="fas fa-pen mr-1"></i>Viết đánh giá
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
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </li>
                            
                            <% for (int i = 1; i <= totalPendingPages; i++) { %>
                            <li class="<%=i == pendingPage ? "active" : ""%>">
                                <a href="?pendingPage=<%=i%>"><%=i%></a>
                            </li>
                            <% } %>
                            
                            <li class="<%=pendingPage == totalPendingPages ? "disabled" : ""%>">
                                <a href="?pendingPage=<%=pendingPage + 1%>">
                                    Sau <i class="fas fa-chevron-right"></i>
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
                        <a href="index.jsp" class="btn btn-primary">
                            <i class="fas fa-shopping-bag mr-2"></i>Tiếp tục mua sắm
                        </a>
                    </div>
                    <% } else { %>
                    
                    <% for (FashionReview review : currentReviews) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <h5 class="product-name"><%=review.getFashionName()%></h5>
                            <div class="review-date">
                                <i class="fas fa-calendar mr-1"></i><%=review.getReviewDate()%>
                            </div>
                        </div>
                        
                        <div class="star-rating">
                            <%=review.getStarRating()%>
                            <span class="ml-2">(<%=review.getRating()%>/5)</span>
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
                                <i class="fas fa-trash mr-1"></i>Xóa
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
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </li>
                            
                            <% for (int i = 1; i <= totalReviewPages; i++) { %>
                            <li class="<%=i == reviewPage ? "active" : ""%>">
                                <a href="?reviewPage=<%=i%><%=request.getParameter("pendingPage") != null ? "&pendingPage=" + request.getParameter("pendingPage") : ""%>"><%=i%></a>
                            </li>
                            <% } %>
                            
                            <li class="<%=reviewPage == totalReviewPages ? "disabled" : ""%>">
                                <a href="?reviewPage=<%=reviewPage + 1%><%=request.getParameter("pendingPage") != null ? "&pendingPage=" + request.getParameter("pendingPage") : ""%>">
                                    Sau <i class="fas fa-chevron-right"></i>
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
                    <div class="modal-body" style="padding: 30px;">
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
                                   placeholder="Nhập tiêu đề cho đánh giá của bạn"
                                   style="border-radius: 8px; padding: 12px;">
                        </div>
                        
                        <div class="form-group">
                            <label for="reviewContent"><strong>Nội dung đánh giá:</strong></label>
                            <textarea class="form-control" id="reviewContent" name="reviewContent" 
                                      rows="5" maxlength="1000"
                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..."
                                      style="border-radius: 8px; padding: 12px;"></textarea>
                            <small class="form-text text-muted">Tối đa 1000 ký tự</small>
                        </div>
                    </div>
                    
                    <div class="modal-footer" style="padding: 20px 30px;">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal"
                                style="border-radius: 20px; padding: 8px 20px;">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary"
                                style="background: linear-gradient(135deg, #ff7e5f, #feb47b); border: none; border-radius: 20px; padding: 8px 20px;">
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
            
            // Set active navigation
            const items = document.querySelectorAll('.nav-ver.nav-link');
            if (items.length > 5) {
                items.forEach(item => item.classList.remove('active'));
                items[5].classList.add('active');
                
                const text = items[5].innerHTML;
                const directionElement = document.getElementById('direction');
                if (directionElement) {
                    directionElement.innerHTML = text;
                }
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