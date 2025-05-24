<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin: Add product</title>
<%@include file="allCss.jsp"%>
</head>

<style>
:root {
	--arrow-bg: rgba(255, 255, 255, 0.3);
	--option-bg: white;
	--select-bg: rgba(255, 255, 255, 0.2);
}

*:focus {
	outline: none;
	box-shadow: rgb(204, 219, 232) 3px 3px 6px 0px inset,
		rgba(255, 255, 255, 0.5) -3px -3px 6px 1px inset;
}

body {
	background-color: white;
}

label {
	font-size: 18px;
	font-weight: 600;
	color: black !important;
}

input {
	width: 100%;
	height: 35px;
	box-shadow: rgba(50, 50, 93, 0.25) 0px 2px 5px -1px, rgba(0, 0, 0, 0.3)
		0px 1px 3px -1px;
	border: none;
	color: black;
	margin: 10px 0;
	padding: 10px;
	font-size: 18px;
}

input:focus {
	box-shadow: rgba(60, 64, 67, 0.3) 0px 1px 2px 0px,
		rgba(60, 64, 67, 0.15) 0px 1px 3px 1px !important;
	border: none !important;
}

.error-message {
    color: #ff2800;
    font-size: 14px;
    margin-top: -5px;
    margin-bottom: 10px;
    display: none;
}

select {
	/* Reset Select */
	margin: 10px 0;
	width: 100%;
	box-shadow: rgba(0, 0, 0, 0.1) 0px 1px 3px 0px, rgba(0, 0, 0, 0.06) 0px
		1px 2px 0px;
	border-radius: 0.25em;
	color: black;
	appearance: none;
	border: 0;
	font-size: 18px;
	height: 35px !important;
	/* Personalize */
	flex: 1;
	padding: 0 1em;
	cursor: pointer;
	margin-left: 15px;
}
/* Remove IE arrow */
select::-ms-expand {
	display: none;
}
/* Custom Select wrapper */
.select {
	position: relative;
	display: flex;
	width: 20em;
	border-radius: .25em;
	overflow: hidden;
	align-items: center;
}
/* Arrow */
.select::after {
	content: '\25BC';
	position: absolute;
	top: 0px;
	right: 0;
	padding: 1em;
	height: 30px;
	transition: .25s all ease;
	pointer-events: none;
}
/* Transition */
.select:hover::after {
	color: black;
	opacity: 1;
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

.button {
	border: none;
	margin: 10px 0;
	transition: all 0.3s linear !important;
}

.button:hover {
	background-color: #333 !important;
	color: white !important;
}

.invalid-input {
    border: 1px solid #ff2800 !important;
    box-shadow: 0 0 5px rgba(255, 40, 0, 0.5) !important;
}
</style>
<body>
	<%@include file="navbar.jsp"%>
	<c:if test="${empty userobj}">
		<c:redirect url="login.jsp" />
	</c:if>
	<div class='dashboard'>
		<div class="dashboard-nav">
			<header>
				<a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a><a
					href="#" class="brand-logo"><i class="fa-regular fa-heart"></i><span
					class="brand">Menu</span></a>
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
					class="fa-solid fa-circle-plus"></i>Add product </a> <a
					href="all_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-layer-group"></i> All fashions</a> <a
					href="all_order.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-users"></i>All orders </a><a href="#"
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
				<div class="slider">
					<img src="">
				</div>
			</header>
			<div class='dashboard-content'>
				<div class='container'>
					<div class='card'>
						<div class='card-header'>
							<h1>Add product</h1>
						</div>
						<div class="card-body">
							<c:if test="${not empty succMsg }">
								<p class="text-center text-success"
									style="font-size: 18px; color: #03c03c;">${succMsg }</p>
								<c:remove var="succMsg" scope="session" />
							</c:if>
							<c:if test="${not empty failedMsg }">
								<p class="text-center text-danger"
									style="font-size: 18px; color: #ff2800;">${failedMsg }</p>
								<c:remove var="failedMsg" scope="session" />
							</c:if>
							<form id="productForm" action="../add_fashions" method="post"
								enctype="multipart/form-data" onsubmit="return validateForm()">
								<div class="form-group">
									<label for="productName">Name product*</label> 
									<input name="fname" type="text" class="form-control" id="productName" required>
									<div id="nameError" class="error-message">Vui lòng nhập tên sản phẩm</div>
								</div>

								<div class="form-group">
									<label for="productSize">Size*</label> 
									<input name="size" type="text" class="form-control" id="productSize" required>
									<div id="sizeError" class="error-message">Vui lòng nhập kích thước</div>
								</div>

								<div class="form-group">
									<label for="quantity" style="margin-bottom: 0;">Quantity*</label>
									<div class="counter">
										<span class="down" onClick='decreaseCount(event, this)'>-</span>
										<input type="number" value="1" name="quantity" id="quantity" min="1" required> 
										<span class="up" onClick='increaseCount(event, this)'>+</span>
									</div>
									<div id="quantityError" class="error-message">Số lượng không được bé hơn 1</div>
								</div>
								
								<div class="form-group">
									<label for="priceBuy">Price buy (<span
										style="text-decoration: underline; color:">vnđ</span>)*
									</label>
									<div class="input-group">
										<input name="pricebuy" type="number" class="form-control"
											id="priceBuy" aria-describedby="price-addon" min="0" required>
									</div>
									<div id="priceBuyError" class="error-message">Giá mua không được là số âm</div>
								</div>

								<div class="form-group">
									<label for="priceSell">Price sell (<span
										style="text-decoration: underline;">vnđ</span>)*
									</label>
									<div class="input-group">
										<input name="price" type="number" class="form-control"
											id="priceSell" aria-describedby="price-addon" min="0" required>
									</div>
									<div id="priceSellError" class="error-message">Giá bán không được là số âm</div>
								</div>

								<div class="select">
									<label for="category">Category*</label> <br>
									<select id="category" name="categories" class="form-control" required>
										<option value="" disabled selected
											style="opacity: 0.4 !important; text-transform: uppercase;">Select</option>
										<option value="Mới">New</option>
									</select>
									<div id="categoryError" class="error-message">Vui lòng chọn danh mục</div>
								</div>

								<div class="select">
									<label for="status">Status*</label><br> 
									<select id="status" name="status" class="form-control" required>
										<option value="" disabled selected>Select</option>
										<option value="Active">Active</option>
										<option value="Inactive">Inactive</option>
									</select>
									<div id="statusError" class="error-message">Vui lòng chọn trạng thái</div>
								</div>

								<div class="form-group">
									<label for="productImage">Image*</label> 
									<input name="fimg" type="file" class="form-control-file"
										id="productImage" required
										style="box-shadow: none; font-size: 16px;">
									<div id="imageError" class="error-message">Vui lòng chọn hình ảnh</div>
								</div>

								<div class="form-group">
									<label for="description">Description</label><br>
									<textarea name="describe" class="form-control"
										id="description" rows="8" cols="60"></textarea>
								</div>

								<div style="text-align: center;">
									<button type="submit" class="button" style="width: 40%; padding: 10px; font-size: 20px; background-color: black; color: white; border-radius: 3px;">Add</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<script>
	// Highlight active menu item
	const items = document.querySelectorAll('.nav-ver.nav-link');
	if (items.length > 0) {
		items[3].classList.add('active');
		const text = document.querySelector('.nav-ver.nav-link.active')?.innerHTML || '';
		const directionElement = document.getElementById('direction');
		if (directionElement) {
			directionElement.innerHTML = text;
		}
	}

	// Quantity counter functions
	function increaseCount(e, element) {
		e.preventDefault();
		var input = element.previousElementSibling;
		var value = parseInt(input.value, 10);
		value = isNaN(value) ? 0 : value;
		value++;
		input.value = value;
		validateQuantity();
	}

	function decreaseCount(e, element) {
		e.preventDefault();
		var input = element.nextElementSibling;
		var value = parseInt(input.value, 10);
		if (value > 1) {
			value = isNaN(value) ? 0 : value;
			value--;
			input.value = value;
		}
		validateQuantity();
	}

	// Form validation functions
	function validateQuantity() {
		const quantityInput = document.getElementById('quantity');
		const quantityError = document.getElementById('quantityError');
		
		if (!quantityInput) return true;
		
		const quantity = parseInt(quantityInput.value);
		
		if (isNaN(quantity) || quantity < 1) {
			quantityInput.classList.add('invalid-input');
			quantityError.style.display = 'block';
			return false;
		} else {
			quantityInput.classList.remove('invalid-input');
			quantityError.style.display = 'none';
			return true;
		}
	}

	function validatePriceBuy() {
		const priceBuyInput = document.getElementById('priceBuy');
		const priceBuyError = document.getElementById('priceBuyError');
		
		if (!priceBuyInput) return true;
		
		const price = parseFloat(priceBuyInput.value);
		
		if (isNaN(price) || price < 0) {
			priceBuyInput.classList.add('invalid-input');
			priceBuyError.style.display = 'block';
			return false;
		} else {
			priceBuyInput.classList.remove('invalid-input');
			priceBuyError.style.display = 'none';
			return true;
		}
	}

	function validatePriceSell() {
		const priceSellInput = document.getElementById('priceSell');
		const priceSellError = document.getElementById('priceSellError');
		
		if (!priceSellInput) return true;
		
		const price = parseFloat(priceSellInput.value);
		
		if (isNaN(price) || price < 0) {
			priceSellInput.classList.add('invalid-input');
			priceSellError.style.display = 'block';
			return false;
		} else {
			priceSellInput.classList.remove('invalid-input');
			priceSellError.style.display = 'none';
			return true;
		}
	}

	function validateName() {
		const nameInput = document.getElementById('productName');
		const nameError = document.getElementById('nameError');
		
		if (!nameInput) return true;
		
		if (!nameInput.value.trim()) {
			nameInput.classList.add('invalid-input');
			nameError.style.display = 'block';
			return false;
		} else {
			nameInput.classList.remove('invalid-input');
			nameError.style.display = 'none';
			return true;
		}
	}

	function validateSize() {
		const sizeInput = document.getElementById('productSize');
		const sizeError = document.getElementById('sizeError');
		
		if (!sizeInput) return true;
		
		if (!sizeInput.value.trim()) {
			sizeInput.classList.add('invalid-input');
			sizeError.style.display = 'block';
			return false;
		} else {
			sizeInput.classList.remove('invalid-input');
			sizeError.style.display = 'none';
			return true;
		}
	}

	function validateCategory() {
		const categorySelect = document.getElementById('category');
		const categoryError = document.getElementById('categoryError');
		
		if (!categorySelect) return true;
		
		if (!categorySelect.value) {
			categorySelect.classList.add('invalid-input');
			categoryError.style.display = 'block';
			return false;
		} else {
			categorySelect.classList.remove('invalid-input');
			categoryError.style.display = 'none';
			return true;
		}
	}

	function validateStatus() {
		const statusSelect = document.getElementById('status');
		const statusError = document.getElementById('statusError');
		
		if (!statusSelect) return true;
		
		if (!statusSelect.value) {
			statusSelect.classList.add('invalid-input');
			statusError.style.display = 'block';
			return false;
		} else {
			statusSelect.classList.remove('invalid-input');
			statusError.style.display = 'none';
			return true;
		}
	}

	function validateImage() {
		const imageInput = document.getElementById('productImage');
		const imageError = document.getElementById('imageError');
		
		if (!imageInput) return true;
		
		if (!imageInput.files || imageInput.files.length === 0) {
			imageInput.classList.add('invalid-input');
			imageError.style.display = 'block';
			return false;
		} else {
			imageInput.classList.remove('invalid-input');
			imageError.style.display = 'none';
			return true;
		}
	}

	// Real-time validation
	document.getElementById('quantity').addEventListener('input', validateQuantity);
	document.getElementById('priceBuy').addEventListener('input', validatePriceBuy);
	document.getElementById('priceSell').addEventListener('input', validatePriceSell);
	document.getElementById('productName').addEventListener('input', validateName);
	document.getElementById('productSize').addEventListener('input', validateSize);
	document.getElementById('category').addEventListener('change', validateCategory);
	document.getElementById('status').addEventListener('change', validateStatus);
	document.getElementById('productImage').addEventListener('change', validateImage);

	// Form submission validation
	function validateForm() {
		const isQuantityValid = validateQuantity();
		const isPriceBuyValid = validatePriceBuy();
		const isPriceSellValid = validatePriceSell();
		const isNameValid = validateName();
		const isSizeValid = validateSize();
		const isCategoryValid = validateCategory();
		const isStatusValid = validateStatus();
		const isImageValid = validateImage();
		
		return isQuantityValid && isPriceBuyValid && isPriceSellValid && 
			   isNameValid && isSizeValid && isCategoryValid && 
			   isStatusValid && isImageValid;
	}
</script>
</body>
</html>