<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>


<style>
.title-user {
	padding: 20px 20px;
	background-color: #ccc;
	width: 100%;
}

.title-user h3 {
	font-weight: 600;
}

#direction {
	font-size: 18px;
	text-transform: uppercase;
	margin-top: 2px;
}

.user-face {
	padding: 10px 20px;
}

.user-face .name-user {
	margin: 5px;
	letter-spacing: 2px;
	font-size: 20px;
	font-family: monospace;
}

.nav-user {
	width: 20%;
	z-index: 4;
	padding: 10px 0 10px 10px;
	margin-top: 5px;
}

.nav-ver.nav-link {
	border-bottom: 1px solid #ccc;
}

.nav-ver.nav-link {
	color: black !important;
	font-family: monospace;
	font-size: 17px;
	transform: uppercase;
	transition: all 0.3s linear;
	border-right: 5px solid rgba(0, 0, 0, 0);
}

.nav-ver.nav-link:hover {
	animation: move 0.5s 1;
	border-right: 5px solid rgba(0, 0, 0, 1);
}

@
keyframe move {from { border-right:5px solid rgba(0, 0, 0, 0);
	
}

50
%
{
border-right
:
5px
solid
rgba(
0
,
0
,
0
,
0.5
);
}
to {
	border-right: 5px solid rgba(0, 0, 0, 1);
}
}

.nav-ver.nav-link.active{
	border-right:5px solid rgba(0, 0, 0, 1) !important;
}
</style>




<div class="title-user">
	<h3 class="text-uppercase">my account page</h3>
	<p id="direction"></p>
</div>
<div class="nav-user">
	<div class="user-face">
		<img src="img/user_icon.png" alt=""
			style="width: 10vw; height: 20vh; border-radius: 50%;">
		<div class="name-user">${userobj.name }</div>
	</div>

	<nav class="nav flex-column">

		<a class="nav-ver nav-link" href="edit_profile.jsp">Edit
			profile</a> <a class="nav-ver nav-link" href="order.jsp">My Order</a> <a
			class="nav-ver nav-link" href="user_address.jsp">Your Address</a> <a
			class="nav-ver nav-link" href="sell_fashion.jsp">Sell Fashion</a>
			<a class="nav-ver nav-link" href="old_fashion.jsp">Old Fashion</a> 
			<a class="nav-ver nav-link" href="my_reviews.jsp">
				<i class="fas fa-star mr-2"></i>My Reviews
			</a>
			<a data-toggle="modal" data-target="#exampleModalCenter"
			class="nav-ver nav-link"
			style="cursor: pointer; border-bottom: none;">Logout</a>


	</nav>

</div>