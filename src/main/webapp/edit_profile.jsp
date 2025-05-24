<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="all_component/userPageStyle.css">
<title>Edit Profile</title>
<%@include file="all_component/allCss.jsp"%>

</head>
<body style="background-color: white;">
	<%@include file="all_component/navbar.jsp"%>

	<div class="user-content-main">
		<%@include file="all_component/nav-user-page.jsp"%>
		<div class="user-content">
			<div class="report-mes">
				<c:if test="${not empty failedMsg }">
					<h5 class="text-center text-danger">${failedMsg}</h5>
					<c:remove var="failedMsg" scope="session" />
				</c:if>
			</div>
			<c:if test="${not empty succMsg }">
				<h5 class="text-center text-success">${succMsg}</h5>
				<c:remove var="succMsg" scope="session" />
			</c:if>
			<form action="update_profile" method="post">
				<input class="info" type="hidden" value="${userobj.id}" name="id">
				<div class="form-group">
					<label for="exampleInputEmail1">Enter Full Name</label> <input
						type="text" class="info form-control" id="exampleInputEmail1"
						aria-describedby="emailHelp" required="required" name="fname"
						value="${userobj.name}">
				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Email address</label> <input
						type="email" class="info form-control" id="exampleInputEmail1"
						aria-describedby="emailHelp" required="required" name="email"
						value="${userobj.email}">

				</div>
				<div class="form-group">
					<label for="exampleInputEmail1">Phone No</label> <input
						type="number" class="info form-control" id="exampleInputEmail1"
						aria-describedby="emailHelp" required="required" name="phno"
						value="${userobj.phno}">

				</div>
				<div class="form-group">
					<label for="exampleInputPassword1">Password</label> <input
						type="password" class="info form-control"
						id="exampleInputPassword1" required="required" name="password">
				</div>

				<button type="submit" class="btn-update">Save change</button>
			</form>

		</div>

	</div>
	<%@include file="all_component/footer.jsp"%>

</body>

<script>
	const items = document.querySelectorAll('.nav-ver.nav-link') ;
	/* document.querySelector('.nav-ver.nav-link.active').classList.remove('active') ; */
	items[0].classList.add('active');
	const text = document.querySelector('.nav-ver.nav-link.active').innerHTML;
	document.getElementById('direction').innerHTML = text;
</script>
</html>
