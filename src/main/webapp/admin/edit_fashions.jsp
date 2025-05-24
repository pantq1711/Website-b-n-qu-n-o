<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.DAO.*"%>
<%@ page import="com.DAO.FashionDAOImpl.*"%>
<%@ page import="com.DB.*"%>
<%@ page import="com.entity.*"%>
<%@ page import="com.entity.FashionDtls.*"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin: Edit Fashions</title>
    <%@include file="allCss.jsp"%>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
</head>

<style>
body {
    font-size: 16px;
    color: black;
}

*:focus {
    outline: none;
    box-shadow: rgb(204, 219, 232) 3px 3px 6px 0px inset,
        rgba(255, 255, 255, 0.5) -3px -3px 6px 1px inset;
    border: none;
}

input, select {
    border-radius: 5px;
    width: 100%;
    height: 40px;
    box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3)
        0px 1px 3px -1px;
    border: none;
    color: black;
    margin: 10px 0;
    padding: 10px;
    font-size: 16px;
    transition: all 0.3s linear !important;
    box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3)
        0px 1px 3px -1px;
}

input:focus {
    border: none !important;
    outline: none !important;
}

label {
    font-size: 18px;
    font-weight: 600;
    color: black !important;
}

.counter {
    width: 100%;
    display: flex;
    align-items: center;
}

.counter input {
    width: 30%;
    border: 0.5px solid #ccc !important;
    box-shadow: none;
    line-height: 30px;
    font-size: 20px;
    background: white;
    color: black;
    text-align: center;
    appearance: none;
    outline: 0;
    appearance: none;
}

select {
    padding: 0 10px;
}

.counter span {
    display: block;
    font-size: 25px;
    padding: 0 10px;
    cursor: pointer;
    color: black !important;
    user-select: none;
}

input[type=number]::-webkit-inner-spin-button {
    -webkit-appearance: none;
}

.price-edit {
    display: flex;
    align-items: center !important;
}

.form-control:focus {
    color: #495057;
    background-color: #fff;
    boxshadow: rgb(204, 219, 232) 3px 3px 6px 0px inset,
        rgba(255, 255, 255, 0.5) -3px -3px 6px 1px inset !important;
}

button {
    trasition: all 0.4s linear;
}

button:hover {
    background-color: #ccc !important;
    animation: hov 1s;
    color: white;
}

@keyframes hov {
    from { background:linear-gradient(115deg, #000000, #444444); }
    25% { background:linear-gradient(115deg, #020202, #f6f6f6); }
    50% { background:linear-gradient(115deg, #000000, #ffffff); }
    to { background: linear-gradient(115deg, #242424, #ffffff); }
}

.quantity-error {
    color: #dc3545;
    font-size: 14px;
    margin-top: 5px;
    display: none;
}
</style>
<body>
    <%@include file="navbar.jsp"%>
    <div class='dashboard'>
        <div class="dashboard-nav">
            <header>
                <a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a>
                <a href="home.jsp" class="brand-logo"><i
                    class="fa-regular fa-heart"></i> <span class="brand">Menu</span></a>
            </header>
            <nav class="dashboard-nav-list">
                <a href="home.jsp" class="dashboard-nav-item"><i
                    class="fas fa-home"></i> Home </a>
                <div class='dashboard-nav-dropdown'>
                    <a href="#!"
                        class="dashboard-nav-item dashboard-nav-dropdown-toggle"><i
                        class="fas fa-tachometer-alt"></i>Dashboard</a>
                    <div class='dashboard-nav-dropdown-menu'>
                        <a href="bestSeller.jsp" class="dashboard-nav-dropdown-item">Best
                            Seller</a><a href="userRank.jsp" class="dashboard-nav-dropdown-item">User Rank</a>
                    </div>
                </div>
                <a href="add_fashions.jsp" class="dashboard-nav-item"><i
                    class="fa-solid fa-circle-plus"></i>Add product </a> 
                <a href="all_fashions.jsp" class="dashboard-nav-item"><i
                    class="fa-solid fa-layer-group"></i> All fashions</a> 
                <a href="all_order.jsp" class="dashboard-nav-item"><i
                    class="fa-solid fa-users"></i> All orders </a><a href="#"
                    class="dashboard-nav-item"><i class="fas fa-user"></i> Profile
                </a>

                <div class="nav-item-divider"></div>
                <a href="../logout" class="dashboard-nav-item logout"><i
                    class="fas fa-sign-out-alt"></i> Logout </a>

            </nav>
        </div>
        <div class='dashboard-app'>
            <header class='dashboard-toolbar'>
                <a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a>
            </header>
            <div class='dashboard-content'>
                <div class='container' style="padding: 0;">
                    <div class='card' style="border: none; width: 100%;">
                        <div class='card-header' style="border-radius: 10px;">
                            <h1>Edit product</h1>
                        </div>
                        <div class='card-body'>
                            <%
                            int id = Integer.parseInt(request.getParameter("id"));
                            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
                            FashionDtls b = dao.getFashionById(id);
                            %>

                            <form action="../editFashions" method="post" id="productForm" onsubmit="return validateForm()">
                                <input type="hidden" name="id" value="<%=b.getFashionId()%>">
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Name</label> <input
                                        name="fname" type="text" id="exampleInputEmail1"
                                        aria-describedby="emailHelp" value="<%=b.getFashionName()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="exampleInputEmail1">Size</label> <input name="size"
                                        type="text" id="exampleInputEmail1"
                                        aria-describedby="emailHelp" value="<%=b.getSize()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="exampleInputEmail1">Price</label>
                                    <div class="price-edit input-group">
                                        <input name="price" type="text" id="priceInput"
                                            aria-describedby="price-addon" pattern="[0-9]+([.,][0-9]+)?"
                                            placeholder="Enter the price..." value="<%=b.getPrice()%>" required>
                                    </div>
                                    <div class="price-error" id="priceError" style="color: #dc3545; font-size: 14px; margin-top: 5px; display: none;">
                                        Giá không được là số âm
                                    </div>
                                </div>

                                <div class="counter">
                                    <label for="quantityInput" style="margin-bottom: 0;">Quantity</label><br> 
                                    <span class="down" onClick='decreaseCount(event, this)'>-</span>
                                    <input type="text" id="quantityInput" value="<%=b.getQuantity()%>" name="quantity" min="1" required> 
                                    <span class="up" onClick='increaseCount(event, this)'>+</span>
                                </div>
                                <div class="quantity-error" id="quantityError">
                                    Số lượng phải lớn hơn hoặc bằng 1
                                </div>

                                <div class="form-group">
                                    <label for="exampleTextarea">Description</label>
                                    <textarea name="describe" class="form-control"
                                        id="exampleTextarea" rows="4"><%=b.getDescribe()%></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="inputState">Status</label> 
                                    <select id="inputState" name="status">
                                        <%
                                        if ("Active".equals(b.getStatus())) {
                                        %>
                                        <option value="Active">Active</option>
                                        <option value="Inactive">Inactive</option>
                                        <%
                                        } else {
                                        %>
                                        <option value="Inactive">Inactive</option>
                                        <option value="Active">Active</option>
                                        <%
                                        }
                                        %>
                                    </select>
                                </div>

                                <div class="button-block" style="margin-top: 10px;">
                                    <div class="text-center">
                                        <button type="submit" class="button"
                                            style="background: linear-gradient(115deg, #000000, #444444); color: white; width: 40%; height: 50px; border: none; font-size: 20px; border-radius: 5px;">Update</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script
        src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>

<script>
    const items = document.querySelectorAll('.nav-ver.nav-link');
    items[3].classList.add('active');
    const text = document.querySelector('.nav-ver.nav-link.active').innerHTML;
    document.getElementById('direction').innerHTML = text;

    function increaseCount(a, b) {
        var input = b.previousElementSibling;
        var value = parseInt(input.value, 10);
        value = isNaN(value) ? 0 : value;
        value++;
        input.value = value;
        validateQuantity(); // Kiểm tra lại sau khi thay đổi
    }

    function decreaseCount(a, b) {
        var input = b.nextElementSibling;
        var value = parseInt(input.value, 10);
        if (value > 1) {
            value = isNaN(value) ? 0 : value;
            value--;
            input.value = value;
        }
        validateQuantity(); // Kiểm tra lại sau khi thay đổi
    }
    
    // Kiểm tra giá trị số lượng
    function validateQuantity() {
        const quantityInput = document.getElementById('quantityInput');
        const quantityError = document.getElementById('quantityError');
        
        const value = parseInt(quantityInput.value, 10);
        
        if (isNaN(value) || value < 1) {
            quantityError.style.display = 'block';
            return false;
        } else {
            quantityError.style.display = 'none';
            return true;
        }
    }
    
    // Kiểm tra giá trị giá
    function validatePrice() {
        const priceInput = document.getElementById('priceInput');
        const priceError = document.getElementById('priceError');
        
        // Xóa dấu phẩy và chuyển đổi thành số
        const value = parseFloat(priceInput.value.replace(/,/g, '.'));
        
        if (isNaN(value) || value < 0) {
            priceError.style.display = 'block';
            return false;
        } else {
            priceError.style.display = 'none';
            return true;
        }
    }
    
    // Kiểm tra form trước khi submit
    function validateForm() {
        const isQuantityValid = validateQuantity();
        const isPriceValid = validatePrice();
        
        return isQuantityValid && isPriceValid;
    }
    
    // Thêm event listener để kiểm tra khi người dùng nhập
    document.getElementById('quantityInput').addEventListener('input', validateQuantity);
    document.getElementById('priceInput').addEventListener('input', validatePrice);
    
    // Kiểm tra ban đầu
    document.addEventListener('DOMContentLoaded', function() {
        validateQuantity();
        validatePrice();
    });
</script>
</html>