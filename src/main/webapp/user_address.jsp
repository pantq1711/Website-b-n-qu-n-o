<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chỉnh sửa Address</title>
<link rel="stylesheet" href="all_component/userPageStyle.css">
<%@include file="all_component/allCss.jsp"%>

<style>
.footer-block {
	margin-top: 25% !important;
}

.card {
	box-shadow: 0 0 10px 0 rgba(0, 0, 0, 0.3);
	border-radius: 10px;
	border: none;
}

.card-header {
	background: linear-gradient(135deg, #ff7e5f, #feb47b);
	color: white;
	border-radius: 10px 10px 0 0 !important;
	padding: 15px 20px;
	border: none;
}

.card-header h4 {
	margin: 0;
	font-weight: 600;
}

.form-group label {
	font-weight: 600;
	color: #333;
	margin-bottom: 5px;
}

.form-control {
	border-radius: 5px;
	padding: 10px;
	border: 1px solid #ddd;
	transition: border-color 0.3s ease;
}

.form-control:focus {
	border-color: #ff7e5f;
	box-shadow: 0 0 0 0.2rem rgba(255, 126, 95, 0.25);
}

.btn-update {
	background: linear-gradient(135deg, #ff7e5f, #feb47b);
	color: white;
	border: none;
	padding: 12px 30px;
	border-radius: 25px;
	font-weight: 600;
	transition: all 0.3s ease;
	box-shadow: 0 3px 10px rgba(0,0,0,0.1);
}

.btn-update:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(0,0,0,0.2);
	color: white;
}

.alert {
	border-radius: 8px;
	padding: 12px 15px;
	margin-bottom: 20px;
}

.required {
	color: #dc3545;
}

.form-text {
	font-size: 0.875rem;
	color: #6c757d;
}
</style>
</head>
<body style="background-color: #f0f1f2;">
	<%@include file="all_component/navbar.jsp"%>

	<c:if test="${empty userobj}">
		<c:redirect url="login.jsp" />
	</c:if>

	<div class="user-content-main">
		<%@include file="all_component/nav-user-page.jsp"%>
		<div class="user-content">
			<div class="card">
				<div class="card-header text-center">
					<h4><i class="fas fa-map-marker-alt mr-2"></i>Cập Nhật Địa Chỉ</h4>
				</div>
				<div class="card-body">
					<!-- Thông báo lỗi -->
					<c:if test="${not empty failedMsg}">
						<div class="alert alert-danger alert-dismissible fade show" role="alert">
							<i class="fas fa-exclamation-circle mr-2"></i>${failedMsg}
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<c:remove var="failedMsg" scope="session" />
					</c:if>
					
					<!-- Thông báo thành công -->
					<c:if test="${not empty succMsg}">
						<div class="alert alert-success alert-dismissible fade show" role="alert">
							<i class="fas fa-check-circle mr-2"></i>${succMsg}
							<button type="button" class="close" data-dismiss="alert" aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<c:remove var="succMsg" scope="session" />
					</c:if>

					<form action="update_address" method="post">
						<input type="hidden" value="${userobj.id}" name="id">

						<div class="form-row">
							<div class="form-group col-md-6">
								<label for="inputAddress">
									<i class="fas fa-home mr-1"></i>Địa chỉ <span class="required">*</span>
								</label>
								<input type="text" name="address" class="info form-control" 
									   id="inputAddress" value="${userobj.address}" 
									   placeholder="Nhập địa chỉ (ví dụ: 123 Đường ABC)" required>
								<small class="form-text text-muted">Nhập địa chỉ chi tiết (đường, phố)</small>
							</div>
							<div class="form-group col-md-6">
								<label for="inputNumhouse">
									<i class="fas fa-building mr-1"></i>Số nhà <span class="required">*</span>
								</label>
								<input type="text" name="numhouse" class="info form-control" 
									   id="inputNumhouse" value="${userobj.numhouse}" 
									   placeholder="Nhập số nhà (ví dụ: 123A)" required>
								<small class="form-text text-muted">Số nhà, tòa nhà, chung cư</small>
							</div>
						</div>

						<div class="form-row">
							<div class="form-group col-md-6">
								<label for="inputCity">
									<i class="fas fa-city mr-1"></i>Thành phố <span class="required">*</span>
								</label>
								<input type="text" name="city" class="info form-control" 
									   id="inputCity" value="${userobj.city}" 
									   placeholder="Nhập thành phố (ví dụ: Hà Nội)" required>
								<small class="form-text text-muted">Thành phố/Quận/Huyện</small>
							</div>
							<div class="form-group col-md-6">
								<label for="inputProvince">
									<i class="fas fa-map mr-1"></i>Tỉnh <span class="required">*</span>
								</label>
								<input type="text" name="province" class="info form-control" 
									   id="inputProvince" value="${userobj.province}" 
									   placeholder="Nhập tỉnh (ví dụ: Hà Nội)" required>
								<small class="form-text text-muted">Tỉnh/Thành phố trực thuộc trung ương</small>
							</div>
						</div>

						<hr class="my-4">

						<div class="form-group">
							<label for="inputPassword">
								<i class="fas fa-lock mr-1"></i>Mật khẩu xác nhận <span class="required">*</span>
							</label>
							<input type="password" class="confirm info form-control" 
								   id="inputPassword" name="password" 
								   placeholder="Nhập mật khẩu hiện tại để xác nhận" required>
							<small class="form-text text-muted">
								Để bảo mật, vui lòng nhập mật khẩu hiện tại để xác nhận thay đổi địa chỉ
							</small>
						</div>

						<div class="text-center mt-4">
							<button type="submit" class="btn-update">
								<i class="fas fa-save mr-2"></i>Cập Nhật Địa Chỉ
							</button>
						</div>
					</form>
				</div>
			</div>

			<!-- Thông tin hiện tại -->
			<div class="card mt-4">
				<div class="card-header">
					<h5 class="mb-0"><i class="fas fa-info-circle mr-2"></i>Địa Chỉ Hiện Tại</h5>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-6">
							<p><strong>Số nhà:</strong> ${userobj.numhouse != null ? userobj.numhouse : 'Chưa cập nhật'}</p>
							<p><strong>Địa chỉ:</strong> ${userobj.address != null ? userobj.address : 'Chưa cập nhật'}</p>
						</div>
						<div class="col-md-6">
							<p><strong>Thành phố:</strong> ${userobj.city != null ? userobj.city : 'Chưa cập nhật'}</p>
							<p><strong>Tỉnh:</strong> ${userobj.province != null ? userobj.province : 'Chưa cập nhật'}</p>
						</div>
					</div>
					<c:if test="${userobj.address != null && userobj.city != null && userobj.province != null}">
						<hr>
						<p><strong>Địa chỉ đầy đủ:</strong> 
							${userobj.numhouse}, ${userobj.address}, ${userobj.city}, ${userobj.province}
						</p>
					</c:if>
				</div>
			</div>
		</div>
	</div>

	<%@include file="all_component/footer.jsp"%>

	<script>
		// Set active navigation item
		const items = document.querySelectorAll('.nav-ver.nav-link');
		items[2].classList.add('active');
		const text = document.querySelector('.nav-ver.nav-link.active').innerHTML;
		document.getElementById('direction').innerHTML = text;

		// Auto close alerts after 5 seconds
		setTimeout(function() {
			$('.alert').alert('close');
		}, 5000);

		// Form validation
		document.querySelector('form').addEventListener('submit', function(e) {
			const password = document.getElementById('inputPassword').value;
			if (!password) {
				e.preventDefault();
				alert('Vui lòng nhập mật khẩu để xác nhận!');
				return false;
			}
		});
	</script>
</body>
</html>