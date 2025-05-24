# 👗 Website Thương Mại Điện Tử Thời Trang

Nền tảng thương mại điện tử thời trang toàn diện được xây dựng bằng Java JSP/Servlet, với giao diện hiện đại và đầy đủ tính năng mua sắm.

![Java](https://img.shields.io/badge/Java-17-orange)
![JSP](https://img.shields.io/badge/JSP-2.3-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Bootstrap](https://img.shields.io/badge/Bootstrap-4.6-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## 🌟 Tính Năng Chính

### 👤 Quản Lý Người Dùng
- **Đăng ký & Đăng nhập** với xác thực bảo mật
- **Quản lý hồ sơ** - Cập nhật thông tin cá nhân và địa chỉ
- **Khôi phục mật khẩu** qua xác thực OTP email
- **Quản lý phiên làm việc** bảo mật

### 🛍️ Trải Nghiệm Mua Sắm
- **Danh mục sản phẩm** với phân loại (Sản phẩm mới/Cũ)
- **Tìm kiếm & Lọc nâng cao** với tùy chọn sắp xếp
- **Giỏ hàng** với quản lý số lượng bằng AJAX
- **Thư viện sản phẩm responsive** với xem chi tiết
- **Phân trang** cho trải nghiệm duyệt web tốt hơn

### 📦 Quản Lý Đơn Hàng
- **Quy trình xử lý đơn hàng** hoàn chỉnh
- **Lịch sử đơn hàng** với theo dõi chi tiết
- **Hủy đơn hàng** linh hoạt
- **Nhiều phương thức thanh toán** (COD, Chuyển khoản)
- **Quản lý tồn kho** thời gian thực

### ⭐ Hệ Thống Đánh Giá
- **Đánh giá & Xếp hạng sản phẩm** (1-5 sao)
- **Đánh giá từ người mua đã xác thực**
- **Hệ thống vote đánh giá hữu ích**
- **Thống kê đánh giá** và phân tích

### 👨‍💼 Trang Quản Trị
- **Quản lý sản phẩm** (CRUD đầy đủ)
- **Kiểm soát tồn kho** với theo dõi stock
- **Xử lý đơn hàng** và quản lý
- **Quản lý người dùng**
- **Thống kê bán hàng** và báo cáo

### 🎨 Tính Năng UI/UX
- **Thiết kế responsive** cho mọi thiết bị
- **Giao diện hiện đại** với chủ đề gradient
- **Tích hợp AJAX** cho tương tác mượt mà
- **Thông báo Toast** cho phản hồi người dùng
- **Trạng thái loading** và animations

## 🛠️ Công Nghệ Sử Dụng

### Backend
- **Java 17** - Ngôn ngữ lập trình chính
- **JSP/Servlet** - Framework ứng dụng web
- **JDBC** - Kết nối cơ sở dữ liệu
- **MySQL** - Cơ sở dữ liệu quan hệ

### Frontend
- **HTML5/CSS3** - Tiêu chuẩn web hiện đại
- **JavaScript/jQuery** - Chức năng tương tác
- **Bootstrap 4.6** - Framework responsive
- **Font Awesome** - Thư viện icon
- **AJAX** - Thao tác bất đồng bộ

### Công Cụ & Thư Viện
- **Apache Tomcat** - Máy chủ ứng dụng
- **JavaMail API** - Chức năng email
- **BCrypt** - Mã hóa mật khẩu (khuyến nghị)
- **Maven/Gradle** - Quản lý build

## 📋 Yêu Cầu Hệ Thống

Trước khi chạy ứng dụng này, đảm bảo bạn có:

- ☕ **Java JDK 17+** đã cài đặt
- 🗄️ **MySQL 8.0+** database server
- 🌐 **Apache Tomcat 9+** web server
- 🔧 **IDE** (Eclipse, IntelliJ IDEA, hoặc VS Code)

## 🚀 Cài Đặt & Thiết Lập

### 1. Clone Repository
```bash
git clone https://github.com/pantq1711/fashion-ecommerce.git
cd fashion-ecommerce
```

### 2. Thiết Lập Cơ Sở Dữ Liệu
```sql
-- Tạo database
CREATE DATABASE fashion_store;

-- Import schema cơ sở dữ liệu
mysql -u root -p fashion_store < database/schema.sql

-- Import dữ liệu mẫu (tùy chọn)
mysql -u root -p fashion_store < database/sample_data.sql
```

### 3. Cấu Hình Kết Nối Database
Cập nhật cài đặt kết nối database trong `com/DB/DBConnect.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/fashion_store";
private static final String USERNAME = "your_username";
private static final String PASSWORD = "your_password";
```

### 4. Cấu Hình Email
Cấu hình cài đặt email trong `com/user/servlet/ForgotPassword.java`:
```java
props.put("mail.smtp.host", "smtp.gmail.com");
// Cập nhật với thông tin email của bạn
return new PasswordAuthentication("hongan.gv10@gmail.com", "your-app-password");
```

### 5. Deploy lên Tomcat
1. Build project thành file WAR
2. Deploy vào thư mục webapps của Tomcat
3. Khởi động Tomcat server
4. Truy cập ứng dụng tại `http://localhost:8080/fashion-ecommerce`

## 📁 Cấu Trúc Dự Án

```
fashion-ecommerce/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── com/
│   │   │   │   ├── admin/servlet/     # Chức năng admin
│   │   │   │   ├── user/servlet/      # Thao tác người dùng
│   │   │   │   ├── DAO/               # Data Access Objects
│   │   │   │   ├── entity/            # Lớp thực thể
│   │   │   │   └── DB/                # Kết nối database
│   │   │   └── webapp/
│   │   │       ├── admin/             # Trang JSP admin
│   │   │       ├── all_component/     # Component dùng chung
│   │   │       ├── fashion/           # Hình ảnh sản phẩm
│   │   │       ├── img/               # Hình ảnh tĩnh
│   │   │       └── *.jsp              # Trang JSP người dùng
├── database/
│   ├── schema.sql                     # Schema database
│   └── sample_data.sql                # Dữ liệu mẫu
├── README.md
└── pom.xml                            # Cấu hình Maven
```

## 💻 Cách Sử Dụng

### Dành Cho Khách Hàng:
1. **Duyệt Sản Phẩm** - Xem các mặt hàng thời trang với lọc và sắp xếp
2. **Tạo Tài Khoản** - Đăng ký để có trải nghiệm cá nhân hóa
3. **Thêm Vào Giỏ** - Chọn sản phẩm và quản lý số lượng
4. **Đặt Hàng** - Hoàn tất mua hàng với nhiều tùy chọn thanh toán
5. **Theo Dõi Đơn Hàng** - Giám sát trạng thái và lịch sử đơn hàng
6. **Viết Đánh Giá** - Chia sẻ phản hồi về sản phẩm đã mua

### Dành Cho Quản Trị Viên:
1. **Đăng Nhập** với thông tin: `admin@gmail.com` / `admin`
2. **Quản Lý Sản Phẩm** - Thêm, sửa, xóa các mặt hàng thời trang
3. **Xử Lý Đơn Hàng** - Xử lý đơn hàng khách hàng và giao hàng
4. **Giám Sát Tồn Kho** - Theo dõi mức tồn kho và tình trạng
5. **Xem Thống Kê** - Truy cập báo cáo bán hàng và thống kê

## 🔒 Tính Năng Bảo Mật

- **Quản Lý Phiên** - Xác thực người dùng bảo mật
- **Ngăn Chặn SQL Injection** - Truy vấn tham số hóa
- **Xác Thực Input** - Validation phía client và server
- **Bảo Vệ CSRF** - Ngăn chặn cross-site request forgery
- **Bảo Mật Mật Khẩu** - Lưu trữ mật khẩu mã hóa (khuyến nghị)

## 🎯 API Endpoints

### Thao Tác Người Dùng
- `POST /login` - Xác thực người dùng
- `POST /register` - Đăng ký người dùng
- `POST /update_profile` - Cập nhật hồ sơ
- `POST /update_address` - Cập nhật địa chỉ

### Thao Tác Sản Phẩm
- `GET /all_recent_fashion.jsp` - Duyệt tất cả sản phẩm
- `GET /view_fashions.jsp?fid=<id>` - Chi tiết sản phẩm
- `GET /search.jsp?ch=<query>` - Tìm kiếm sản phẩm

### Thao Tác Giỏ Hàng
- `GET /cart?fid=<id>&uid=<id>` - Thêm vào giỏ
- `GET /addcart?fid=<id>&cid=<id>` - Tăng số lượng
- `GET /subcart?fid=<id>&cid=<id>` - Giảm số lượng
- `GET /remove_fashion?fid=<id>&uid=<id>&cid=<id>` - Xóa item

### Thao Tác Đơn Hàng
- `POST /order` - Đặt hàng
- `POST /cancel_order` - Hủy đơn hàng

## 🐛 Vấn Đề Đã Biết & Hạn Chế

- Lưu trữ mật khẩu cần triển khai mã hóa
- Xác thực email cho đăng ký chưa được triển khai
- Tích hợp cổng thanh toán đang chờ xử lý
- Bộ lọc tìm kiếm nâng cao cần cải thiện
- Phiên bản ứng dụng di động chưa có

## 🚧 Cải Tiến Trong Tương Lai

- [ ] **Cải Thiện Bảo Mật** - Triển khai mã hóa mật khẩu BCrypt
- [ ] **Tích Hợp Thanh Toán** - Thêm PayPal, Stripe, VNPay
- [ ] **Ứng Dụng Di Động** - Phiên bản React Native hoặc Flutter
- [ ] **Phát Triển API** - RESTful API cho tích hợp mobile
- [ ] **Thống Kê Nâng Cao** - Báo cáo bán hàng và dashboard
- [ ] **Tính Năng Wishlist** - Lưu sản phẩm yêu thích
- [ ] **Đăng Nhập Xã Hội** - Xác thực Google, Facebook
- [ ] **Chat Trực Tuyến** - Tích hợp hỗ trợ khách hàng
- [ ] **Thông Báo Push** - Cập nhật đơn hàng và khuyến mãi
- [ ] **Đa Ngôn Ngữ** - Hỗ trợ quốc tế hóa

## 🤝 Đóng Góp

Chúng tôi hoan nghênh các đóng góp! Vui lòng tạo Pull Request. Đối với các thay đổi lớn, hãy mở issue trước để thảo luận về những gì bạn muốn thay đổi.

### Cách Đóng Góp:
1. Fork repository
2. Tạo feature branch (`git checkout -b feature/TinhNangTuyetVoi`)
3. Commit thay đổi (`git commit -m 'Thêm tính năng tuyệt vời'`)
4. Push lên branch (`git push origin feature/TinhNangTuyetVoi`)
5. Mở Pull Request

## 📄 Giấy Phép

Dự án này được cấp phép theo Giấy phép MIT - xem file [LICENSE](LICENSE) để biết chi tiết.

## 👨‍💻 Tác Giả

**Anphan**
- GitHub: [@pantq1711](https://github.com/pantq1711)
- Email: hongan.gv10@gmail.com

## 🙏 Lời Cảm Ơn

- Đội ngũ Bootstrap cho framework responsive
- Font Awesome cho thư viện icon
- MySQL cho hệ thống database mạnh mẽ
- Apache Tomcat cho web server đáng tin cậy
- Tất cả contributors và testers

## 📞 Hỗ Trợ

Nếu bạn gặp vấn đề hoặc có câu hỏi:

1. Kiểm tra trang [Issues](https://github.com/pantq1711/fashion-ecommerce/issues)
2. Tạo issue mới với mô tả chi tiết
3. Liên hệ tác giả qua email

---

⭐ **Hãy star repository này nếu bạn thấy hữu ích!**

Xây dựng với ❤️ bởi Anphan
