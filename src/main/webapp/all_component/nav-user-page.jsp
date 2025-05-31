<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<div class="nav-user">
    <div class="title-user">
        <h3>TÀI KHOẢN CỦA TÔI</h3>
        <p id="direction">Tổng quan</p>
    </div>
    
    <div class="user-face">
        <img src="img/user_icon.png" alt="User Avatar">
        <div class="name-user">${userobj.name}</div>
    </div>

    <nav class="nav flex-column">
        <a class="nav-ver nav-link" href="setting.jsp">
            <i class="fas fa-tachometer-alt"></i>
            Tổng quan
        </a>
        <a class="nav-ver nav-link" href="edit_profile.jsp">
            <i class="fas fa-user-edit"></i>
            Chỉnh sửa hồ sơ
        </a>
        <a class="nav-ver nav-link" href="order.jsp">
            <i class="fas fa-shopping-bag"></i>
            Đơn hàng của tôi
        </a>
        <a class="nav-ver nav-link" href="user_address.jsp">
            <i class="fas fa-map-marker-alt"></i>
            Địa chỉ của bạn
        </a>
        <a class="nav-ver nav-link" href="sell_fashion.jsp">
            <i class="fas fa-store"></i>
            Bán sản phẩm
        </a>
        <a class="nav-ver nav-link" href="old_fashion.jsp">
            <i class="fas fa-tshirt"></i>
            Sản phẩm cũ
        </a>
        <a class="nav-ver nav-link" href="my_reviews.jsp">
            <i class="fas fa-star"></i>
            Đánh giá của tôi
        </a>
        <a class="nav-ver nav-link" href="javascript:void(0)" data-toggle="modal" data-target="#exampleModalCenter">
            <i class="fas fa-sign-out-alt"></i>
            Đăng xuất
        </a>
    </nav>
</div>

<!-- Logout Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">
                    <i class="fas fa-sign-out-alt mr-2"></i>Xác nhận đăng xuất
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="fas fa-question-circle" style="font-size: 3rem; color: #ffc107; margin-bottom: 20px;"></i>
                    <h4>Bạn có chắc chắn muốn đăng xuất?</h4>
                    <p class="text-muted">Bạn sẽ cần đăng nhập lại để tiếp tục sử dụng dịch vụ.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    <i class="fas fa-times mr-2"></i>Hủy
                </button>
                <a href="logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt mr-2"></i>Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tự động cập nhật tiêu đề dựa trên trang hiện tại
    const currentPage = window.location.pathname.split('/').pop();
    const direction = document.getElementById('direction');
    const navLinks = document.querySelectorAll('.nav-ver.nav-link');
    
    // Remove active class from all links
    navLinks.forEach(link => link.classList.remove('active'));
    
    // Add active class and update direction based on current page
    let pageTitle = 'Tổng quan';
    
    navLinks.forEach((link, index) => {
        const href = link.getAttribute('href');
        if (href && currentPage.includes(href.split('/').pop())) {
            link.classList.add('active');
            pageTitle = link.textContent.trim();
        }
    });
    
    // Special cases for pages
    if (currentPage.includes('setting.jsp')) {
        navLinks[0].classList.add('active');
        pageTitle = 'Tổng quan';
    } else if (currentPage.includes('edit_profile.jsp')) {
        navLinks[1].classList.add('active');
        pageTitle = 'Chỉnh sửa hồ sơ';
    } else if (currentPage.includes('order.jsp')) {
        navLinks[2].classList.add('active');
        pageTitle = 'Đơn hàng của tôi';
    } else if (currentPage.includes('user_address.jsp')) {
        navLinks[3].classList.add('active');
        pageTitle = 'Địa chỉ của bạn';
    } else if (currentPage.includes('sell_fashion.jsp')) {
        navLinks[4].classList.add('active');
        pageTitle = 'Bán sản phẩm';
    } else if (currentPage.includes('old_fashion.jsp')) {
        navLinks[5].classList.add('active');
        pageTitle = 'Sản phẩm cũ';
    } else if (currentPage.includes('my_reviews.jsp')) {
        navLinks[6].classList.add('active');
        pageTitle = 'Đánh giá của tôi';
    }
    
    if (direction) {
        direction.textContent = pageTitle;
    }
});
</script>