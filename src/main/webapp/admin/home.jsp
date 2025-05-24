<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin: Trang chủ</title>
<%@include file="allCss.jsp"%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	integrity="sha384-HyTmHdJZ39jr2R5eSpKU6R8teK0mZlVRrZpIg4Jt3S9yqudjHqfIm1ZmnA2sqQeP"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	integrity="sha384-HyTmHdJZ39jr2R5eSpKU6R8teK0mZlVRrZpIg4Jt3S9yqudjHqfIm1ZmnA2sqQeP"
	crossorigin="anonymous">
<link rel='stylesheet'
	href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css'>
<style>
body {
	font-family: 'Arial', sans-serif;
	color: #000;
}

.img-thumblin {
	width: 100%;
	height: auto;
	max-width: 100px;
	max-height: 100px;
	display: block;
	margin: 0 auto;
}

#toast {
	min-width: 300px;
	position: fixed;
	bottom: 30px;
	left: 50%;
	margin-left: -125px;
	padding: 10px;
	color: white;
	text-align: center;
	z-index: 1;
	font-size: 18px;
	visibility: hidden;
	box-shadow: 0px 0px 100px #000;
	z-index: 10;
}

#toast.display {
	visibility: visible;
	animation: fadeIn 0.5s, fadeOut 0.5s 2.5s;
}

@
keyframes fadeIn {from { bottom:0;
	opacity: 0;
}

to {
	bottom: 30px;
	opacity: 1;
}

}
@
keyframes fadeOut {from { bottom:30px;
	opacity: 1;
}

to {
	bottom: 0;
	opacity: 0;
}

}
#toast.success {
	background-color: #dc3545; /* Red color */
}
</style>
<%@include file="navbar.jsp"%>
</head>
<body>

	<c:if test="${empty userobj }">
		<c:redirect url="../login.jsp" />
	</c:if>

	<c:if test="${not empty userobj }">
		<div id="toast" class="success">Xin chào, Admin</div>

		<script type="text/javascript">
            // Show the toast when the page loads
            showToast();

            function showToast() {
                $('#toast').addClass("display");
                setTimeout(() => {
                    $("#toast").removeClass("display");
                }, 2000);
            }
        </script>
	</c:if>
	<div class='dashboard'>
		<div class="dashboard-nav">
			<header>
				<a href="#!" class="menu-toggle"><i class="fas fa-bars"></i></a><a
					href="home.jsp" class="brand-logo"><i
					class="fa-regular fa-heart"></i> <span class="brand">MENU </span></a>
			</header>
			<nav class="dashboard-nav-list">
				<a href="home.jsp" class="dashboard-nav-item"><i
					class="fas fa-home"></i> Home </a>
				<div class='dashboard-nav-dropdown'>
					<a href="#!"
						class="dashboard-nav-item dashboard-nav-dropdown-toggle"><i
					class="fas fa-tachometer-alt"></i>Dashboard</a>
					<div class='dashboard-nav-dropdown-menu'>
						<a href="bestSeller.jsp" class="dashboard-nav-dropdown-item">Best Seller</a><a href="userRank.jsp"
							class="dashboard-nav-dropdown-item">User Rank</a>
							<a href="dashborad.jsp"
							class="dashboard-nav-dropdown-item">Dashboard</a>
					</div>
				</div>
				<a href="add_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-circle-plus"></i>Add product </a><a
					href="all_fashions.jsp" class="dashboard-nav-item"><i
					class="fa-solid fa-layer-group"></i> All fashions</a> <a
					href="all_order.jsp" class="dashboard-nav-item"><i
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
				<div class='container'>
					<div class='card'>
						<div class='card-header'>
							<h1>Welcome back Admin</h1>
						</div>
						<div class='card-body'>
							<p>Đây là tài khoản của ông chủ</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>


</html>
