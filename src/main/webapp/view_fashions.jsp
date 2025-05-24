<%@ page import="java.util.*"%>
<%@ page import="com.DAO.*"%>
<%@ page import="com.DAO.FashionDAOImpl.*"%>
<%@ page import="com.entity.*"%>
<%@ page import="com.DB.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
    <%@ include file="all_component/allCss.jsp"%>
    <link rel="stylesheet" href="all_component/viewStyle.css">
    <style type="text/css">
        /* Product view container */
        .view-product {
            margin: 30px auto;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        /* Product details layout */
        .details {
            display: flex;
            background: white;
            margin: 0;
        }

        /* Product image styles */
        .img-view {
            transition: all 0.3s ease;
            padding: 20px !important;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .img-view img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            transition: transform 0.5s ease;
        }

        .img-view:hover img {
            transform: scale(1.05);
        }

        /* Product info styles */
        .inf-view {
            padding: 30px !important;
        }

        .info-1 {
            margin-bottom: 15px;
        }

        h2.info-1 {
            font-weight: 700;
            color: #333;
            font-size: 28px;
        }

        /* Price display */
        .root-price {
            text-decoration: line-through;
            color: rgba(255, 133, 71, 0.7);
            font-size: 18px;
            margin-right: 10px;
        }

        .sale-price {
            font-weight: bold;
            color: #e63946;
            font-size: 24px;
        }

        /* Product details sections */
        .info p {
            display: flex;
            align-items: center;
            color: #555;
            font-size: 16px;
        }

        .info p span {
            margin-left: 5px;
            font-weight: 600;
        }

        .text-success {
            color: #28a745 !important;
        }

        /* Size display */
        .size-view {
            margin: 15px 0;
            padding: 10px;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }

        .size-view p {
            font-weight: 600;
            color: #333;
            margin-bottom: 0;
        }

        .size-option {
            background-color: #f8f9fa;
            padding: 5px 15px;
            border-radius: 20px;
            margin-left: 10px;
            font-weight: 500;
        }

        /* Stock information */
        .stock-info {
            margin: 15px 0;
            font-size: 15px;
            color: #666;
        }

        .out-of-stock {
            color: #dc3545;
            font-weight: 600;
        }

        .in-stock {
            color: #28a745;
            font-weight: 600;
        }

        /* Quantity selector styles */
        .quantity-section {
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .quantity-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            display: block;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-bottom: 10px;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 2px solid #ddd;
            background-color: #fff;
            color: #333;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .quantity-btn:hover {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        .quantity-btn:disabled {
            background-color: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #ddd;
        }

        .quantity-btn:disabled:hover {
            background-color: #e9ecef;
            color: #6c757d;
            border-color: #ddd;
        }

        .quantity-input {
            width: 80px;
            height: 40px;
            text-align: center;
            border: 2px solid #ddd;
            border-left: none;
            border-right: none;
            font-size: 16px;
            font-weight: 600;
            background-color: #fff;
        }

        .quantity-input:focus {
            outline: none;
            border-color: #007bff;
        }

        .btn-decrease {
            border-top-left-radius: 6px;
            border-bottom-left-radius: 6px;
        }

        .btn-increase {
            border-top-right-radius: 6px;
            border-bottom-right-radius: 6px;
        }

        .quantity-note {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }

        .quantity-error {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        /* Action buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-block {
            display: block;
            width: 100%;
        }

        /* Contact seller section */
        .text-primary {
            color: #007bff !important;
        }

        /* Description section */
        .description {
            background: white;
            padding: 30px;
            margin: 30px auto;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .title-d {
            font-size: 22px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f1f1f1;
        }

        .pra-des {
            color: #555;
            line-height: 1.8;
        }

        /* Reviews Section Styles */
        .reviews-section {
            margin-top: 40px;
            padding: 30px 0;
            border-top: 2px solid #f0f0f0;
        }
        
        .reviews-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .reviews-summary {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .overall-rating {
            font-size: 2.5rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .rating-stars {
            font-size: 1.5rem;
            color: #ffc107;
            margin-bottom: 10px;
        }
        
        .rating-breakdown {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin-top: 20px;
        }
        
        .rating-bar {
            display: flex;
            align-items: center;
            margin: 5px 0;
            min-width: 150px;
        }
        
        .rating-bar span {
            margin-right: 10px;
            font-size: 14px;
        }
        
        .progress {
            flex-grow: 1;
            height: 8px;
            margin: 0 10px;
        }
        
        .review-item {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background: white;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .reviewer-info {
            display: flex;
            align-items: center;
        }
        
        .reviewer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #ff7e5f, #feb47b);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 15px;
        }
        
        .reviewer-name {
            font-weight: bold;
            color: #333;
        }
        
        .review-date {
            color: #666;
            font-size: 14px;
        }
        
        .verified-purchase {
            background: #28a745;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .review-rating {
            color: #ffc107;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .review-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            font-size: 16px;
        }
        
        .review-content {
            color: #555;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        .review-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .helpful-btn {
            background: none;
            border: 1px solid #ddd;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .helpful-btn:hover {
            background: #f8f9fa;
            border-color: #007bff;
            color: #007bff;
        }
        
        .helpful-count {
            color: #666;
            font-size: 14px;
        }
        
        .no-reviews {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .no-reviews i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .pagination-reviews {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
        
        .pagination-reviews .btn {
            margin: 0 5px;
        }

        /* Toast notification */
        #toast {
            min-width: 300px;
            position: fixed;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            padding: 15px 20px;
            border-radius: 5px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            color: white;
            text-align: center;
            z-index: 9999;
            font-size: 16px;
            visibility: hidden;
        }

        #toast.display {
            visibility: visible;
            animation: fadeIn 0.5s, fadeOut 0.5s 2.5s;
        }

        #toast.success {
            background-color: #28a745;
        }

        #toast.error {
            background-color: #dc3545;
        }

        @keyframes fadeIn {
            from {bottom: 0; opacity: 0;}
            to {bottom: 30px; opacity: 1;}
        }

        @keyframes fadeOut {
            from {bottom: 30px; opacity: 1;}
            to {bottom: 0; opacity: 0;}
        }

        /* Responsive styles */
        @media (max-width: 992px) {
            .details {
                flex-direction: column;
            }
            
            .img-view {
                max-width: 100% !important;
                padding: 20px !important;
            }
            
            .inf-view {
                padding: 20px !important;
            }
            
            h2.info-1 {
                font-size: 24px;
            }
            
            .sale-price {
                font-size: 20px;
            }
        }

        @media (max-width: 768px) {
            .view-product {
                margin: 20px auto;
            }
            
            .description {
                padding: 20px;
                margin: 20px auto;
            }
            
            .title-d {
                font-size: 20px;
            }
            
            #toast {
                min-width: 250px;
                font-size: 14px;
            }
            
            .quantity-input {
                width: 60px;
            }
            
            .quantity-btn {
                width: 35px;
                height: 35px;
                font-size: 16px;
            }

            .reviews-header {
                flex-direction: column;
            }
            
            .rating-breakdown {
                flex-direction: column;
            }
            
            .review-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .reviewer-info {
                margin-bottom: 10px;
            }
        }

        @media (max-width: 576px) {
            h2.info-1 {
                font-size: 20px;
            }
            
            .description {
                padding: 15px;
            }
            
            .title-d {
                font-size: 18px;
            }
            
            .pra-des {
                font-size: 14px !important;
            }
            
            #toast {
                min-width: 200px;
            }
        }
    </style>
</head>
<body>
    <%@include file="all_component/navbar.jsp"%>
    
    <!-- Show toast if there's a message in session -->
    <c:if test="${not empty succMsg || not empty failedMsg}">
        <div id="toast" class="${not empty succMsg ? 'success' : 'error'}">
            ${not empty succMsg ? succMsg : failedMsg}
        </div>
        <c:remove var="succMsg" scope="session" />
        <c:remove var="failedMsg" scope="session" />
        <script>
            showToast();
        </script>
    </c:if>
    
    <%
    User u = (User) session.getAttribute("userobj");
    int bid = Integer.parseInt(request.getParameter("fid"));
    FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
    FashionDtls b = dao.getFashionById(bid);
    
    // Format price for better display
    String formattedPrice = "";
    try {
        String priceStr = b.getPrice().replaceAll("[^0-9]", "");
        if (!priceStr.isEmpty()) {
            formattedPrice = String.format("%,d", Integer.parseInt(priceStr));
        } else {
            formattedPrice = b.getPrice();
        }
    } catch (Exception e) {
        formattedPrice = b.getPrice();
    }
    
    // Calculate discount price (20% higher for display purposes)
    String originalPrice = "";
    try {
        double price = Double.parseDouble(b.getPrice().replaceAll("[^0-9]", ""));
        double origPrice = price * 1.2;
        originalPrice = String.format("%,d", (int)origPrice);
    } catch (Exception e) {
        originalPrice = b.getPrice();
    }
    %>

    <div class="view-product container">
        <div class="details row">
            <div class="img-view col-md-6 p-5 bg-white"
                style="max-width: 40% !important;">
                <img src="fashion/<%=b.getPhotoName()%>"
                    alt="<%=b.getFashionName()%>" title="<%=b.getFashionName()%>">
            </div>
            <div class="inf-view col-md-6 p-5 bg-white">
                <h2 class="info-1"><%=b.getFashionName()%></h2>
                <p class="info info-1">
                    <span class="root-price"><%=originalPrice%> VNĐ</span>
                    <span class="sale-price"><%=formattedPrice%> VNĐ</span>
                </p>

                <%
                if ("Cũ".equals(b.getFashionCategory())) {
                %>
                <h5 class="text-primary info-1">Contact To Seller</h5>
                <h5 class="text-primary info-1">
                    <i class="far fa-envelope"></i> Email:
                    <%=b.getEmail()%></h5>
                <%
                }
                %>

                <div class="info info-1">
                    <p>
                        Category: <span class="text-success"><%=b.getFashionCategory()%></span>
                    </p>
                </div>
                
                <div class="info info-1">
                    <p>
                        Status: <span style="color: black;"><%=b.getStatus()%></span>
                    </p>
                </div>

                <div class="size-view">
                    <p>
                        SIZE: <span class="size-option"><%=b.getSize()%></span>
                    </p>
                </div>

                <!-- Stock information -->
                <div class="stock-info">
                    <% if (b.getQuantity() > 0) { %>
                        <p>Availability: <span class="in-stock">In Stock (<%=b.getQuantity()%> items available)</span></p>
                    <% } else { %>
                        <p>Availability: <span class="out-of-stock">Out of Stock</span></p>
                    <% } %>
                </div>

                <!-- Quantity selector - only for new products that are in stock -->
                <% if ("Mới".equals(b.getFashionCategory()) && b.getQuantity() > 0) { %>
                <div class="quantity-section">
                    <label class="quantity-label">Số lượng:</label>
                    <div class="quantity-selector">
                        <button type="button" class="quantity-btn btn-decrease" id="decreaseBtn" onclick="decreaseQuantity()">-</button>
                        <input type="number" id="quantityInput" class="quantity-input" value="1" min="1" max="<%=b.getQuantity()%>" readonly>
                        <button type="button" class="quantity-btn btn-increase" id="increaseBtn" onclick="increaseQuantity()">+</button>
                    </div>
                    <div class="quantity-note">
                        Tối đa: <%=b.getQuantity()%> sản phẩm
                    </div>
                    <div class="quantity-error" id="quantityError">
                        Số lượng không hợp lệ
                    </div>
                </div>
                <% } %>

                <!-- Action buttons section -->
                <div class="row mt-4">
                    <div class="col-6">
                        <a href="index.jsp" class="btn btn-success btn-block">
                            <i class="fas fa-shopping-bag mr-2"></i> Continue Shopping
                        </a>
                    </div>
                    <div class="col-6">
                        <% if ("Mới".equals(b.getFashionCategory()) && b.getQuantity() > 0) { %>
                            <% if (u == null) { %>
                                <a href="login.jsp" class="btn btn-danger btn-block">
                                    <i class="fas fa-shopping-cart mr-2"></i> Add to Cart
                                </a>
                            <% } else { %>
                                <button id="addToCartBtn" class="btn btn-danger btn-block ajax-cart-btn"
                                   data-fid="<%=b.getFashionId()%>" data-uid="<%=u.getId()%>">
                                    <i class="fas fa-shopping-cart mr-2"></i> Add to Cart
                                </button>
                            <% } %>
                        <% } else if ("Mới".equals(b.getFashionCategory()) && b.getQuantity() <= 0) { %>
                            <button class="btn btn-secondary btn-block" disabled>
                                <i class="fas fa-shopping-cart mr-2"></i> Out of Stock
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="description container">
        <h3 class="title-d text-uppercase text-left">Product Detail Information</h3>
        <p class="pra-des text-left" style="font-size:18px;"><%=b.getDescribe()%></p>
    </div>

    <!-- Component để thêm vào view_fashions.jsp -->
    <!-- Thêm vào sau phần mô tả sản phẩm -->

    <%@ page import="com.DAO.FashionReviewDAOImpl"%>
    <%@ page import="com.entity.FashionReview"%>
    <%@ page import="java.util.Map"%>
    <%@ page import="java.text.DecimalFormat"%>

    <%
    // Lấy ID sản phẩm từ request
    int fashionId = Integer.parseInt(request.getParameter("fid"));

    // Khởi tạo DAO
    FashionReviewDAOImpl reviewDao = new FashionReviewDAOImpl(DBConnect.getConn());

    // Lấy thống kê đánh giá
    Map<String, Object> reviewStats = reviewDao.getReviewStatistics(fashionId);
    int totalReviews = (Integer) reviewStats.getOrDefault("totalReviews", 0);
    double averageRating = (Double) reviewStats.getOrDefault("averageRating", 0.0);

    // Lấy danh sách đánh giá
    List<FashionReview> reviews = reviewDao.getReviewsByFashionId(fashionId, 1, 10);

    // Format số
    DecimalFormat df = new DecimalFormat("#.#");
    %>

    <div class="reviews-section container">
        <div class="reviews-header">
            <h3><i class="fas fa-star mr-2"></i>Đánh giá sản phẩm</h3>
            <span class="badge badge-info"><%=totalReviews%> đánh giá</span>
        </div>
        
        <% if (totalReviews > 0) { %>
        <!-- Reviews Summary -->
        <div class="reviews-summary">
            <div class="overall-rating"><%=df.format(averageRating)%>/5</div>
            <div class="rating-stars">
                <%
                int fullStars = (int) averageRating;
                boolean hasHalfStar = (averageRating - fullStars) >= 0.5;
                
                for (int i = 0; i < fullStars; i++) {
                    out.print("★");
                }
                if (hasHalfStar) {
                    out.print("☆");
                }
                for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) {
                    out.print("☆");
                }
                %>
            </div>
            <p>Dựa trên <%=totalReviews%> đánh giá</p>
            
            <!-- Rating Breakdown -->
            <div class="rating-breakdown">
                <%
                for (int star = 5; star >= 1; star--) {
                    String starKey = "";
                    switch(star) {
                        case 5: starKey = "fiveStar"; break;
                        case 4: starKey = "fourStar"; break;
                        case 3: starKey = "threeStar"; break;
                        case 2: starKey = "twoStar"; break;
                        case 1: starKey = "oneStar"; break;
                    }
                    
                    int starCount = (Integer) reviewStats.getOrDefault(starKey, 0);
                    double percentage = totalReviews > 0 ? (double) starCount / totalReviews * 100 : 0;
                %>
                <div class="rating-bar">
                    <span><%=star%> ★</span>
                    <div class="progress">
                        <div class="progress-bar bg-warning" role="progressbar" 
                             style="width: <%=percentage%>%" aria-valuenow="<%=percentage%>" 
                             aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <span>(<%=starCount%>)</span>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Individual Reviews -->
        <div class="reviews-list">
            <% for (FashionReview review : reviews) { %>
            <div class="review-item">
                <div class="review-header">
                    <div class="reviewer-info">
                        <div class="reviewer-avatar">
                            <%=review.getUserName().substring(0, 1).toUpperCase()%>
                        </div>
                        <div>
                            <div class="reviewer-name">
                                <%=review.getUserName()%>
                                <% if (review.isVerifiedPurchase()) { %>
                                <span class="verified-purchase">✓ Đã mua hàng</span>
                                <% } %>
                            </div>
                            <div class="review-date"><%=review.getReviewDate()%></div>
                        </div>
                    </div>
                </div>
                
                <div class="review-rating">
                    <%
                    for (int i = 1; i <= 5; i++) {
                        if (i <= review.getRating()) {
                            out.print("★");
                        } else {
                            out.print("☆");
                        }
                    }
                    %>
                </div>
                
                <% if (review.getReviewTitle() != null && !review.getReviewTitle().isEmpty()) { %>
                <div class="review-title"><%=review.getReviewTitle()%></div>
                <% } %>
                
                <% if (review.getReviewContent() != null && !review.getReviewContent().isEmpty()) { %>
                <div class="review-content"><%=review.getReviewContent()%></div>
                <% } %>
                
                <div class="review-actions">
                    <button class="helpful-btn" onclick="markHelpful(<%=review.getReviewId()%>)">
                        <i class="fas fa-thumbs-up mr-1"></i>Hữu ích
                    </button>
                    <div class="helpful-count">
                        <% if (review.getHelpfulCount() > 0) { %>
                        <%=review.getHelpfulCount()%> người thấy hữu ích
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <% } else { %>
        <!-- No Reviews -->
        <div class="no-reviews">
            <i class="fas fa-star"></i>
            <h5>Chưa có đánh giá nào</h5>
            <p>Hãy là người đầu tiên đánh giá sản phẩm này!</p>
        </div>
        <% } %>
    </div>

    <%@include file="all_component/footer.jsp"%>

    <!-- Toast element for notifications -->
    <div id="toast"></div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script type="text/javascript">
    // Global variables
    const maxQuantity = <%=b.getQuantity()%>;
    let currentQuantity = 1;
    
    // Quantity control functions
    function increaseQuantity() {
        const quantityInput = document.getElementById('quantityInput');
        const increaseBtn = document.getElementById('increaseBtn');
        const decreaseBtn = document.getElementById('decreaseBtn');
        const quantityError = document.getElementById('quantityError');
        
        if (currentQuantity < maxQuantity) {
            currentQuantity++;
            quantityInput.value = currentQuantity;
            
            // Enable decrease button
            decreaseBtn.disabled = false;
            
            // Disable increase button if at max
            if (currentQuantity >= maxQuantity) {
                increaseBtn.disabled = true;
            }
            
            // Hide error message
            quantityError.style.display = 'none';
        }
    }
    
    function decreaseQuantity() {
        const quantityInput = document.getElementById('quantityInput');
        const increaseBtn = document.getElementById('increaseBtn');
        const decreaseBtn = document.getElementById('decreaseBtn');
        const quantityError = document.getElementById('quantityError');
        
        if (currentQuantity > 1) {
            currentQuantity--;
            quantityInput.value = currentQuantity;
            
            // Enable increase button
            increaseBtn.disabled = false;
            
            // Disable decrease button if at min
            if (currentQuantity <= 1) {
                decreaseBtn.disabled = true;
            }
            
            // Hide error message
            quantityError.style.display = 'none';
        }
    }
    
    // Validate quantity input
    function validateQuantity() {
        const quantityInput = document.getElementById('quantityInput');
        const quantityError = document.getElementById('quantityError');
        
        let quantity = parseInt(quantityInput.value);
        
        if (isNaN(quantity) || quantity < 1) {
            quantity = 1;
        } else if (quantity > maxQuantity) {
            quantity = maxQuantity;
            quantityError.textContent = 'Số lượng vượt quá tồn kho';
            quantityError.style.display = 'block';
            return false;
        }
        
        currentQuantity = quantity;
        quantityInput.value = quantity;
        quantityError.style.display = 'none';
        
        // Update button states
        updateButtonStates();
        
        return true;
    }
    
    function updateButtonStates() {
        const increaseBtn = document.getElementById('increaseBtn');
        const decreaseBtn = document.getElementById('decreaseBtn');
        
        if (increaseBtn && decreaseBtn) {
            decreaseBtn.disabled = (currentQuantity <= 1);
            increaseBtn.disabled = (currentQuantity >= maxQuantity);
        }
    }
    
    // Review helpful function
    function markHelpful(reviewId) {
        // Gửi AJAX request để đánh dấu hữu ích
        fetch('helpful_review', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'reviewId=' + reviewId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật UI
                location.reload(); // Reload để cập nhật số lượng helpful
            } else {
                alert('Không thể thực hiện thao tác này');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Đã xảy ra lỗi');
        });
    }
    
    $(document).ready(function(){
        // Initialize button states
        updateButtonStates();
        
        // Handle quantity input changes
        $('#quantityInput').on('input', function() {
            validateQuantity();
        });
        
        // AJAX for "Add to Cart" button
        $('.ajax-cart-btn').click(function(e) {
            e.preventDefault();
            
            const fid = $(this).data('fid');
            const uid = $(this).data('uid');
            const quantity = currentQuantity;
            
            // Validate quantity before sending
            if (!validateQuantity()) {
                return;
            }
            
            // Disable button temporarily
            const btn = $(this);
            const originalText = btn.html();
            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin mr-2"></i>Adding...');
            
            $.ajax({
                url: 'cart',
                type: 'GET',
                data: {
                    fid: fid,
                    uid: uid,
                    quantity: quantity
                },
                dataType: 'json',
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                success: function(response) {
                    if (response.success) {
                        showToastMessage(response.message, 'success');
                        // Reset quantity to 1 after successful add
                        currentQuantity = 1;
                        $('#quantityInput').val(1);
                        updateButtonStates();
                    } else {
                        showToastMessage(response.message, 'error');
                    }
                },
                error: function() {
                    showToastMessage('An error occurred while processing your request', 'error');
                },
                complete: function() {
                    // Re-enable button
                    btn.prop('disabled', false).html(originalText);
                }
            });
        });
        
        // Check if we need to show toast on page load
        if ($('#toast').text().trim() !== '') {
            showToast();
        }
    });
    
    // Function to show toast notification
    function showToastMessage(message, type) {
        const toast = document.getElementById('toast');
        toast.textContent = message;
        toast.className = type;
        
        showToast();
    }
    
    // Show the toast
    function showToast() {
        const toast = document.getElementById('toast');
        toast.classList.add('display');
        setTimeout(() => {
            toast.classList.remove('display');
        }, 3000);
    }
    </script>
</body>
</html>