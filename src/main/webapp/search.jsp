<%--Nguyen Trong Vu--%>
<%@ page import="com.entity.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.DB.DBConnect"%>
<%@ page import="com.DAO.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Recent Fashion</title>
    <%@ include file="all_component/allCss.jsp"%>
<style type="text/css">
    .img-thumblin {
        width: 100%; /* Đặt chiều rộng ảnh là 100% để nói rằng chiều rộng của ảnh sẽ chiếm 100% của phần tử chứa nó */
        height: 100%; /* Chiều cao tự động điều chỉnh để giữ tỷ lệ khung hình */
        max-width: 100px; /* Đặt chiều rộng tối đa của ảnh là 100px */
        max-height: 100px; /* Đặt chiều cao tối đa của ảnh là 100px */
        display: block; /* Để giữ định dạng hiển thị cho hình ảnh */
        margin: 0 auto; /* Canh giữa ảnh trong phần tử cha */
    }
</style>
</head>
<body>
 
    <%
        User u = (User) session.getAttribute("useobj");
    %>
    <%@ include file="all_component/navbar.jsp"%>
    <div class="container-fluid">
        <div class="row p-3">
            <%
                String ch = request.getParameter("ch");
                FashionDAOImpl dao2 = new FashionDAOImpl(DBConnect.getConn());
                List<FashionDtls> list2 = dao2.getFashionBySearch(ch);
                for (FashionDtls b : list2) {
            %>
            <div class="items col-md-2"
				style="padding: 0; margin: 5px 5px;">
				<div class="cart-user" style="padding: 0; width: 100%;">
					<div class="card-body" style="padding: 0; width: 100%;">
						<img alt="" src="fashion/<%=b.getPhotoName()%>"
							style="width: 100%; height: fit-object;">
						<div class="inf-product" style="padding: 10px;">

							<p class="name"><%=b.getFashionName()%></p>
							<p>
								<%
								if (b.getFashionCategory().equals("Old")) {
								%>
								Categories:<span style="color: rgba(0, 0, 0, 0.6);';"><%=b.getFashionCategory()%></span>
							</p>
							<p class="text-left">
								<span class="root-price"
									style="text-decoration: line-through; color: rgba(255, 133, 71, 0.7);"><%=b.getPrice()%>vnd</span>
								<span class="sale-price"><%=b.getPrice()%> vnd</span>
							</p>


							<div class="view-class row">
								<a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
									class="btn btn-success btn-sm ml-5"><i
									class="fa-solid fa-eye"></i></a>
							</div>

							<%
							} else {
							%>
							Categories:<span style="color: rgb(26, 223, 34);';"><%=b.getFashionCategory()%></span>
							<div class="view-class row">
								<a href="view_fashions.jsp?fid=<%=b.getFashionId()%>"
									class="btn btn-success btn-sm ml-5"><i
									class="fa-solid fa-eye"></i></a>
							</div>
							<p class="text-left">
								<span class="root-price"
									style="text-decoration: line-through; color: rgba(255, 133, 71, 0.7)"><%=b.getPrice()%>vnd</span>
								<span class="sale-price"><%=b.getPrice()%> vnd</span>
							</p>

							<div class="cart-parent row">

								<%
								if (u == null) {
								%>
								<div class="cart-icon">
									<a href="login.jsp"
										class="cart-link btn btn-danger btn-sm ml-2"><i
										class="fa-solid fa-cart-plus"
										style="background-color: rgba(0, 0, 0, 0.7); border: none;"></i></a>
								</div>
								<%
								} else {
								%>
								<div class="cart-icon">
									<a href="cart?fid=<%=b.getFashionId()%>&&uid=<%=u.getId()%>"
										class="cart-link btn btn-danger btn-sm ml-2"
										style="background-color: rgba(0, 0, 0, 0.7); border: none;"><i
										class="fa-solid fa-cart-plus"></i></a>
								</div>
								<%
								}
								%>

							</div>
							<%
							}
							%>
						</div>
					</div>
				</div>
			</div>
			<%
			}
			%>
        </div>
    </div>
</body>
</html>
