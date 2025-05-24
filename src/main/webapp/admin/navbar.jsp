
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
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

:root {
	--font-family-sans-serif: "Open Sans", -apple-system, BlinkMacSystemFont,
		"Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif,
		"Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol",
		"Noto Color Emoji";
}

*, *::before, *::after {
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
}

html {
	font-family: sans-serif;
	line-height: 1.15;
	-webkit-text-size-adjust: 100%;
	-webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

nav {
	display: block;
}

body {
	margin: 0;
	font-family: "Open Sans", -apple-system, BlinkMacSystemFont, "Segoe UI",
		Roboto, "Helvetica Neue", Arial, sans-serif, "Apple Color Emoji",
		"Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
	font-size: 1rem;
	font-weight: 400;
	line-height: 1.5;
	color: #515151;
	text-align: left;
	background-color: #eaeef3;
}

h1, h2, h3, h4, h5, h6 {
	margin-top: 0;
	margin-bottom: 0.5rem;
}

h1{
	font-family:monospace !important;

}

p {
	margin-top: 0;
	margin-bottom: 1rem;
}

a {
	color: #3f84fc;
	text-decoration: none;
	background-color: transparent;
}

a:hover {
	color: #0458eb;
	text-decoration: underline;
}

h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
	font-family: "Nunito", sans-serif;
	margin-bottom: 0.5rem;
	font-weight: 500;
	line-height: 1.2;
}

h1, .h1 {
	font-size: 2.5rem;
	font-weight: normal;
}

.card {
	position: relative;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-orient: vertical;
	-webkit-box-direction: normal;
	-webkit-flex-direction: column;
	-ms-flex-direction: column;
	flex-direction: column;
	min-width: 0;
	word-wrap: break-word;
	background-color: #fff;
	background-clip: border-box;
	
	border-radius: 10px;
	
}

.card-body {
	-webkit-box-flex: 1;
	-webkit-flex: 1 1 auto;
	-ms-flex: 1 1 auto;
	flex: 1 1 auto;
	padding: 1.25rem;
}

.card-header {
	padding: 0.75rem 1.25rem;
	margin-bottom: 0;
	background: linear-gradient(178.6deg, rgb(20, 36, 50) 11.8%, rgb(124, 143, 161) 83.8%);
	border-bottom: 1px solid rgba(0, 0, 0, 0.125);
	text-align: center;
	border:none;
	border-radius:10px;
	background-color: #c3cbdc;
background-image: linear-gradient(147deg, #c3cbdc 0%, #edf1f4 74%);
	
}

.card-header h1{
	color:rgba(255,255,255,0.9) !important;
	color:#5F5449 !important;
}

.dashboard {
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	min-height: 100vh;
}

.dashboard-app {
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-orient: vertical;
	-webkit-box-direction: normal;
	-webkit-flex-direction: column;
	-ms-flex-direction: column;
	flex-direction: column;
	-webkit-box-flex: 2;
	-webkit-flex-grow: 2;
	-ms-flex-positive: 2;
	flex-grow: 2;
	margin-top: 84px;
	max-width:100%;
	transition:all 0.4s linear;
}

.dashboard-content {
	-webkit-box-flex: 2;
	-webkit-flex-grow: 2;
	-ms-flex-positive: 2;
	flex-grow: 2;
	padding: 25px;
	max-width:100%;
	transition:all 0.4s linear;
}

.dashboard-nav {
	min-width: 238px;
	position: fixed;
	left: 0;
	top: 0;
	bottom: 0;
	overflow: auto;
	transition:all 0.4s linear;
	z-index:1000;
	flex-grow:1;
}

.dashboard-compact .dashboard-nav {
	left: -238px;
	top: 0;	
}

.dashboard-nav header {
	min-height: 84px;
	padding: 8px 27px;
	background-color:#6673fc;
	color:white;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-pack: center;
	-webkit-justify-content: center;
	-ms-flex-pack: center;
	justify-content: center;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
}



.dashboard-nav header a{
	color:white !important;
}

.dashboard-nav header .menu-toggle {
	display: none;
	margin-right: auto;
}

.dashboard-nav a {
	color: #515151;
}

.dashboard-nav a:hover {
	text-decoration: none;
}

.dashboard-nav {
	background-color: #443ea2;
}

.dashboard-nav a {
	color: #fff;
}

.brand-logo {
	font-family: "Nunito", sans-serif;
	font-weight: bold;
	font-size: 20px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	color: #515151;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
}

.brand-logo:focus, .brand-logo:active, .brand-logo:hover {
	color: #dbdbdb;
	text-decoration: none;
}

.brand-logo i {
	color: #d2d1d1;
	font-size: 27px;
	margin-right: 10px;
}

.dashboard-nav-list {
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-orient: vertical;
	-webkit-box-direction: normal;
	-webkit-flex-direction: column;
	-ms-flex-direction: column;
	flex-direction: column;
}

.dashboard-nav-item {
	min-height: 56px;
	padding: 8px 20px 8px 70px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
	letter-spacing: 0.02em;
	transition: ease-out 0.5s;
}

.dashboard-nav-item i {
	width: 36px;
	font-size: 19px;
	margin-left: -40px;
}

.dashboard-nav-item:hover {
	background: #ccc;
}

.active {
	background: rgba(0, 0, 0, 0.1);
}

.dashboard-nav-dropdown {
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-orient: vertical;
	-webkit-box-direction: normal;
	-webkit-flex-direction: column;
	-ms-flex-direction: column;
	flex-direction: column;
}

.dashboard-nav-dropdown.show {
	background: rgba(255, 255, 255, 0.04);
}

.dashboard-nav-dropdown.show>.dashboard-nav-dropdown-toggle {
	font-weight: bold;
}

.dashboard-nav-dropdown.show>.dashboard-nav-dropdown-toggle:after {
	-webkit-transform: none;
	-o-transform: none;
	transform: none;
}

.dashboard-nav-dropdown.show>.dashboard-nav-dropdown-menu {
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
}

.dashboard-nav-dropdown-toggle:after {
	content: "";
	margin-left: auto;
	display: inline-block;
	width: 0;
	height: 0;
	border-left: 5px solid transparent;
	border-right: 5px solid transparent;
	border-top: 5px solid rgba(81, 81, 81, 0.8);
	-webkit-transform: rotate(90deg);
	-o-transform: rotate(90deg);
	transform: rotate(90deg);
}

.dashboard-nav .dashboard-nav-dropdown-toggle:after {
	
}

.dashboard-nav-dropdown-menu {
	display: none;
	-webkit-box-orient: vertical;
	-webkit-box-direction: normal;
	-webkit-flex-direction: column;
	-ms-flex-direction: column;
	flex-direction: column;
}

.dashboard-nav-dropdown-item {
	min-height: 40px;
	padding: 8px 20px 8px 70px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
	transition: ease-out 0.5s;
}

.dashboard-nav-dropdown-item:hover {
	background: #ccc;
}

.menu-toggle {
	position: relative;
	width: 42px;
	height: 42px;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
	-webkit-box-pack: center;
	-webkit-justify-content: center;
	-ms-flex-pack: center;
	justify-content: center;
	color: #443ea2;
}

.menu-toggle:hover, .menu-toggle:active, .menu-toggle:focus {
	text-decoration: none;
	color: rgba(0,0,0,0.4);
}

.menu-toggle i {
	font-size: 20px;
}

.dashboard-toolbar {
	min-height: 60px;
	background-color: white;
	display: -webkit-box;
	display: -webkit-flex;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-align: center;
	-webkit-align-items: center;
	-ms-flex-align: center;
	align-items: center;
	padding: 8px 27px;
	position: fixed;
	top: 0;
	right: 0;
	left: 0;
	box-shadow : rgba(0, 0, 0, 0.18) 0px 2px 4px;
	z-index: 500;
	transition:all 0.4s linear;
	width:auto;
  	max-width:100%
  	
}

.nav-item-divider {
	height: 1px;
	margin: 1rem 0;
	overflow: hidden;
	background-color: rgba(236, 238, 239, 0.3);
}

.brand{
	font-style:italic;
}

@media ( min-width : 992px) {
	.dashboard-app {
		margin-left: 238px;
	}
	.dashboard-compact .dashboard-app {
		margin-left: 0;
		left:0;
	}
}

@media ( max-width : 768px) {
	.dashboard-content {
		padding: 15px 0px;
	}
}

@media ( max-width : 992px) {
	.dashboard-nav {
		display: none;
		position: fixed;
		top: 0;
		right: 0;
		left: 0;
		bottom: 0;
		z-index: 1070;
	}
	.dashboard-nav.mobile-show {
		display: block;
	}
}

@media ( max-width : 992px) {
	.dashboard-nav header .menu-toggle {
		display: -webkit-box;
		display: -webkit-flex;
		display: -ms-flexbox;
		display: flex;
	}
	.dashboard-compact .dashboard-toolbar {
		left: 0;
	}
	
}

@media ( min-width : 992px) {
	.dashboard-toolbar {
		left: 238px;
	}
	.dashboard-compact .dashboard-toolbar {
		left: 0;
	}
	
	
}

.dashboard-nav {
	background-color: rgba(255,255,255,1);
}

.menu-toggle {
	color: black;
}

.dashboard-nav a{
	color:#444444 !important;
}
</style>


<!--Container Main end-->

<script
	src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
<script
	src='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/js/bootstrap.min.js'></script>
<script id="rendered-js">
	
	const mobileScreen = window.matchMedia("(max-width: 990px )");
	$(document).ready(function () {
	    $(".dashboard-nav-dropdown-toggle").click(function () {
	        $(this).closest(".dashboard-nav-dropdown")
	            .toggleClass("show")
	            .find(".dashboard-nav-dropdown")
	            .removeClass("show");
	        $(this).parent()
	            .siblings()
	            .removeClass("show");
	    });
	    $(".menu-toggle").click(function () {
	        if (mobileScreen.matches) {
	            $(".dashboard-nav").toggleClass("mobile-show");
	            
	        } else {
	            $(".dashboard").toggleClass("dashboard-compact");
	        }
	    });
	});
	</script>