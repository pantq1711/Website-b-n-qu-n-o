<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sell Fashion</title>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<%@include file="all_component/allCss.jsp"%>
</head>
<style>
.footer-block{
	margin-top:27%!important;
}

.counter {
	width: 100%;
	display: flex;
	align-items:center;
}

.counter input {
	width: 80%px;
	border: 0.5px solid #ccc;
	line-height: 30px;
	font-size: 20px;
	background: white;
	color: black;
	text-align: center;
	appearance: none;
	outline: 0;
	appearance: none;
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
</style>
<body style="background-color: #f0f1f2;">
	<c:if test="${empty userobj}">
		<c:redirect url="login.jsp" />
	</c:if>
	<%@include file="all_component/navbar.jsp"%>

	<div class="user-content-main">
		<%@include file="all_component/nav-user-page.jsp"%>
		<div class="user-content">

			<c:if test="${not empty succMsg}">
				<p class="text-center text-success">${succMsg}</p>
				<c:remove var="succMsg" scope="session" />
			</c:if>
			<c:if test="${not empty failedMsg}">
				<p class="text-center text-danger">${failedMsg}</p>
				<c:remove var="failedMsg" scope="session" />
			</c:if>
			<form action="add_old_fashion" method="post"
				enctype="multipart/form-data">
				<input type="hidden" value="${userobj.email}" name="user">
				<div class="form-group">
					<label for="exampleInputEmail1">Fashion Name*</label> <input
						name="fname" type="text" class="info form-control"
						id="exampleInputEmail1" aria-describedby="emailHelp">
				</div>

				<div class="form-group">
					<label for="exampleInputEmail1">Size*</label> <input name="size"
						type="text" class="info form-control" id="exampleInputEmail1"
						aria-describedby="emailHelp">
				</div>

				<div class="form-group">
					<label for="exampleInputEmail1">Price*</label>
					<div class="input-group">
						<input name="price" type="text" class="info form-control"
							id="exampleInputPassword1" aria-describedby="price-addon"
							pattern="[0-9]+([.,][0-9]+)?">
						<div class="input-group-append">
							<span class="input-group-text" id="price-addon">VND</span>
						</div>
					</div>
					<small id="emailHelp" class="form-text text-muted">Enter a
						numeric value</small>
				</div>
				
				<div class="counter">
				<label for="exampleInputEmail1" style="margin-bottom:0;">Quantity*</label><br>
					<span class="down" onClick='decreaseCount(event, this)'>-</span><input
						type="text" value="1" name="quantity" min="1"> <span class="up"
						onClick='increaseCount(event, this)'>+</span>
				</div>

				<div class="form-group">
					<label for="exampleTextarea">Description</label>
					<textarea name="describe" class="form-control" id="exampleTextarea"
						rows="4"></textarea>
				</div>

				<div class="form-group">
					<label for="exampleFormControlFile1">Upload Photo</label> <input
						name="fimg" type="file" class="form-control-file" style=""
						id="exampleFormControlFile1">
				</div>

				<button type="submit" class="btn-update">Sell</button>
			</form>
		</div>
	</div>
	<%@include file="all_component/footer.jsp"%>
</body>

<script>
	const items = document.querySelectorAll('.nav-ver.nav-link') ;
	items[3].classList.add('active');
	const text = document.querySelector('.nav-ver.nav-link.active').innerHTML;
	document.getElementById('direction').innerHTML = text;
	
	
	function increaseCount(a, b) {
		var input = b.previousElementSibling;
		var value = parseInt(input.value, 10);
		value = isNaN(value) ? 0 : value;
		value++;
		input.value = value;
	}

	function decreaseCount(a, b) {
		var input = b.nextElementSibling;
		var value = parseInt(input.value, 10);
		if (value > 1) {
			value = isNaN(value) ? 0 : value;
			value--;
			input.value = value;
		}
	}
</script>
</html>
