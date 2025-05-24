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

@WebServlet("/delete_review")
public class DeleteReviewServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            User user = (User) session.getAttribute("userobj");
            
            if (user == null) {
                session.setAttribute("failedMsg", "Vui lòng đăng nhập");
                resp.sendRedirect("login.jsp");
                return;
            }
            
            int reviewId = Integer.parseInt(req.getParameter("reviewId"));
            
            FashionReviewDAOImpl reviewDao = new FashionReviewDAOImpl(DBConnect.getConn());
            boolean success = reviewDao.deleteReview(reviewId, user.getId());
            
            if (success) {
                session.setAttribute("succMsg", "Đã xóa đánh giá thành công");
            } else {
                session.setAttribute("failedMsg", "Không thể xóa đánh giá");
            }
            
            resp.sendRedirect("my_reviews.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Đã xảy ra lỗi: " + e.getMessage());
            resp.sendRedirect("my_reviews.jsp");
        }
    }
}
