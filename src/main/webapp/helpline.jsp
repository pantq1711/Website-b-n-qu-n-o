<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %> 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="ISO-8859-1">
        <title>Contact</title>
        <%@include file="all_component/allCss.jsp" %>
    </head>
    
    <body style="background-color: white;">
	<%@include file="all_component/navbar.jsp" %>
    <%@include file="all_component/footer.jsp"%> 
    </body>
<script>
	const $ = document.querySelector.bind(document);
	const $$ = document.querySelectorAll.bind(document);
	const tabs = $$('.nav-h.nav-item');
	$('.nav-h.nav-item.active').classList.remove('active');
	tabs[4].classList.add('active');
</script>
</html>
