<%@page import="java.sql.Connection"%>
<%@page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<div class="container-fluid" style="height: 10px;"></div>

<style>
/* Base styles */
* {
    box-sizing: border-box;
}

/* Header styles */
.nav-logon {
    padding: 10px 15px !important;
}

.logo img {
    max-width: 100%;
    height: auto;
    max-height: 120px;
}

/* Search form */
.search-form {
    position: relative;
    width: 100% !important;
    border-radius: 20px;
    height: 46px !important;
}

.search-form input {
    width: 100% !important;
    padding-right: 40px;
}

.icon-search {
    position: absolute !important;
    right: 10px;
    top: 0;
    height: 100%;
    background-color: transparent !important;
    color: rgba(0, 0, 0, 0.9) !important;
    border: none;
    outline: none;
}

/* User dropdown - Giữ lại tooltip phong cách cũ nhưng có cải tiến */
.tooltip-1 {
    position: relative;
    display: inline-block;
    z-index: 10;
    height: fit-content;
    width: auto;
    min-width: 100px;
    text-align: center;
    margin-top: 10px;
}

.tooltip-1 .tooltiptext-1 {
    padding: 10px;
    visibility: hidden;
    width: 200px;
    background-color: white;
    color: black;
    text-align: left;
    border-radius: 6px;
    position: absolute;
    margin-top: 2px;
    z-index: 10;
    top: 110%;
    right: 0;
    box-shadow: rgba(0, 0, 0, 0.16) 0px 1px 4px;
}

.tooltip-1 .tooltiptext-1::after {
    content: "";
    position: absolute;
    bottom: 100%;
    right: 30px;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: transparent transparent #ccc transparent;
}

.tooltiptext-1 .item-user {
    height: fit-content;
    padding: 10px;
    border-bottom: 1px solid #ccc;
}

.tooltiptext-1 div a {
    color: rgba(0, 0, 0, 0.7);
    text-decoration: none;
    transition: all 0.1s linear;
    display: block;
    width: 100%;
}

.tooltip-1 .usrn i{
    transition: all 0.2s linear;
}

.tooltiptext-1 .item-user:hover a {
    color: #888;
}

.tooltip-1 .usrn:hover i{
    opacity: 0.7;
}

.tool-main {
    position: relative !important;
}

/* Cart icon */
.nav-cart {
    position: relative !important;
    font-size: 22px !important;
    margin-left: 15px;
    color: rgba(0, 0, 0, 0.9) !important;
    transition: all 0.3s linear;
}

.nav-cart:hover, .nav-cart:hover i {
    color: #555 !important;
    transform: scale(1.1);
}

/* Navigation bar */
.navbar {
    padding: 10px 15px;
}

.navbar-brand {
    font-size: 20px;
}

.nav-link {
    font-weight: 500;
    padding: 8px 15px;
    transition: all 0.3s ease;
}

.nav-link:hover {
    background-color: rgba(255,255,255,0.1);
}

/* Media queries */
@media (max-width: 992px) {
    .nav-group {
        flex-wrap: wrap;
    }
    
    .logo {
        text-align: center;
        margin-bottom: 15px;
    }
    
    .block-buy {
        order: 3;
        margin-top: 15px;
        width: 100%;
    }
    
    .log {
        order: 2;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        width: 100%;
    }
}

@media (max-width: 768px) {
    .logo img {
        max-height: 80px;
    }
    
    .navbar-nav {
        text-align: center;
    }
    
    .nav-link {
        padding: 10px;
    }
}

@media (max-width: 576px) {
    .logo img {
        max-height: 60px;
    }
    
    .usrn i, .nav-cart i {
        font-size: 20px;
    }
}
</style>

<!-- Header section -->
<div class="nav-logon container-fluid p-3 bg-light">
    <div class="nav-group row">
        <!-- Logo -->
        <div class="logo col-lg-3 col-md-12">
            <a href="index.jsp">
                <img src="img/qa.jpg" alt="Fashion Shop Logo" class="img-fluid">
            </a>
        </div>
        
        <!-- Search Form -->
        <div class="block-buy col-lg-7 col-md-12">
            <form class="search-form form-inline my-2 my-lg-0"
                action="search.jsp" method="post">
                <input class="form-control" type="search"
                    placeholder="Search" aria-label="Search" name="ch">
                <button class="icon-search btn" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>

        <!-- User Menu and Cart -->
        <div class="log col-lg-2 col-md-12 d-flex justify-content-end align-items-center">
            <!-- User Dropdown - Giữ lại cấu trúc cũ nhưng cải tiến -->
            <div class="tooltip-1">
                <div class="user-main">
                    <div class="tool-main">
                        <div class="usrn">
                            <i class="fas fa-user"
                                style="font-size: 22px; color: black !important; cursor: pointer;"></i>
                        </div>
                        <c:if test="${not empty userobj }">
                            <a href="checkout.jsp" class="nav-cart">
                                <i class="fa-solid fa-cart-shopping"></i>
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="tooltiptext-1">
                    <div>
                        <c:if test="${not empty userobj }">
                            <div class="item-user">
                                <a href="setting.jsp" class="usrn">
                                    <i class="fas fa-user-circle mr-2"></i>${userobj.name}
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="edit_profile.jsp" class="usrn">
                                    <i class="fas fa-user-edit mr-2"></i>Edit Profile
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="order.jsp" class="usrn">
                                    <i class="fas fa-shopping-bag mr-2"></i>My Orders
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="my_reviews.jsp" class="usrn">
                                    <i class="fas fa-star mr-2"></i>My Reviews
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="user_address.jsp" class="usrn">
                                    <i class="fas fa-map-marker-alt mr-2"></i>Your Address
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="sell_fashion.jsp" class="usrn">
                                    <i class="fas fa-store mr-2"></i>Sell Fashion
                                </a>
                            </div>
                            <div class="item-user">
                                <a href="old_fashion.jsp" class="usrn">
                                    <i class="fas fa-tshirt mr-2"></i>Old Fashion
                                </a>
                            </div>
                            <div class="item-user" style="border: none;">
                                <a href="javascript:void(0)" data-toggle="modal" data-target="#exampleModalCenter" class="usrn">
                                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                                </a>
                            </div>
                        </c:if>
                        <c:if test="${empty userobj }">
                            <div class="item-user">
                                <a href="login.jsp" class="login">
                                    <i class="fas fa-sign-in-alt mr-2"></i>Login
                                </a>
                            </div>
                            <div class="item-user" style="border: none;">
                                <a href="register.jsp" class="login">
                                    <i class="fas fa-user-plus mr-2"></i>Register
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Logout Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1"
    role="dialog" aria-labelledby="exampleModalCenterTitle"
    aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Confirm Logout</h5>
                <button type="button" class="close" data-dismiss="modal"
                    aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <h4>Do you want to logout?</h4>
                    <button type="button" class="btn btn-secondary"
                        data-dismiss="modal">Close</button>
                    <a href="logout" type="button" class="btn btn-primary">Logout</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Navigation Menu -->
<nav class="navbar navbar-expand-lg navbar-dark bg-custom">
    <a class="navbar-brand" href="index.jsp">
        <i class="fa-solid fa-house"></i>
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent" aria-expanded="false"
        aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
                <a class="nav-link" href="index.jsp">HOME</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="all_recent_fashion.jsp">RECENT FASHION</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="all_new_fashion.jsp">NEW FASHION</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="all_old_fashion.jsp">OLD FASHION</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="helpline.jsp">CONTACT</a>
            </li>
        </ul>
    </div>
</nav>

<!-- Script for toggling user dropdown -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const user = document.querySelector('.usrn');
        const tooltip = document.querySelector('.tooltiptext-1');
        
        // Show/hide menu when clicking on user icon
        user.addEventListener('click', function() {
            if (tooltip.style.visibility === "visible") {
                tooltip.style.visibility = "hidden";
            } else {
                tooltip.style.visibility = "visible";
            }
        });
        
        // Hide menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.tooltip-1')) {
                tooltip.style.visibility = "hidden";
            }
        }, true);
    });
</script>