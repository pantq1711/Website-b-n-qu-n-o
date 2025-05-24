package com.user.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionReviewDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionReview;
import com.entity.User;

@WebServlet("/add_review")
public class AddReviewServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            // Đảm bảo encoding UTF-8
            if (req.getCharacterEncoding() == null) {
                req.setCharacterEncoding("UTF-8");
            }
            resp.setCharacterEncoding("UTF-8");
            
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("userobj");
            
            if (user == null) {
                session.setAttribute("failedMsg", "Vui lòng đăng nhập để đánh giá sản phẩm");
                resp.sendRedirect("login.jsp");
                return;
            }
            
            // Lấy thông tin từ form
            int fashionId = Integer.parseInt(req.getParameter("fashionId"));
            String orderId = req.getParameter("orderId");
            int rating = Integer.parseInt(req.getParameter("rating"));
            String reviewTitle = req.getParameter("reviewTitle");
            String reviewContent = req.getParameter("reviewContent");
            
            // Kiểm tra dữ liệu đầu vào
            if (rating < 1 || rating > 5) {
                session.setAttribute("failedMsg", "Đánh giá phải từ 1 đến 5 sao");
                resp.sendRedirect("my_reviews.jsp");
                return;
            }
            
            if (reviewTitle == null || reviewTitle.trim().isEmpty()) {
                session.setAttribute("failedMsg", "Vui lòng nhập tiêu đề đánh giá");
                resp.sendRedirect("my_reviews.jsp");
                return;
            }
            
            FashionReviewDAOImpl reviewDao = new FashionReviewDAOImpl(DBConnect.getConn());
            
            // Kiểm tra người dùng đã mua sản phẩm này chưa
            if (!reviewDao.hasUserPurchasedProduct(user.getId(), fashionId)) {
                session.setAttribute("failedMsg", "Bạn chỉ có thể đánh giá sản phẩm đã mua");
                resp.sendRedirect("my_reviews.jsp");
                return;
            }
            
            // Kiểm tra đã đánh giá chưa
            if (reviewDao.hasUserReviewedProduct(user.getId(), fashionId, orderId)) {
                session.setAttribute("failedMsg", "Bạn đã đánh giá sản phẩm này rồi");
                resp.sendRedirect("my_reviews.jsp");
                return;
            }
            
            // Tạo đối tượng review
            FashionReview review = new FashionReview(fashionId, user.getId(), orderId, 
                                                   rating, reviewTitle, reviewContent);
            
            // Thêm đánh giá
            boolean success = reviewDao.addReview(review);
            
            if (success) {
                session.setAttribute("succMsg", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                session.setAttribute("failedMsg", "Không thể thêm đánh giá. Vui lòng thử lại!");
            }
            
            resp.sendRedirect("my_reviews.jsp");
            
        } catch (NumberFormatException e) {
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Dữ liệu không hợp lệ");
            resp.sendRedirect("my_reviews.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Đã xảy ra lỗi: " + e.getMessage());
            resp.sendRedirect("my_reviews.jsp");
        }
    }
}