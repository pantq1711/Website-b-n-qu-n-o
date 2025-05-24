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

@WebServlet("/helpful_review")
public class HelpfulReviewServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            int reviewId = Integer.parseInt(req.getParameter("reviewId"));
            
            FashionReviewDAOImpl reviewDao = new FashionReviewDAOImpl(DBConnect.getConn());
            boolean success = reviewDao.updateHelpfulCount(reviewId, 1);
            
            // Kiểm tra xem có phải AJAX request không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            if (isAjax) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                PrintWriter out = resp.getWriter();
                out.print("{\"success\":" + success + "}");
                out.flush();
            } else {
                HttpSession session = req.getSession();
                if (success) {
                    session.setAttribute("succMsg", "Cảm ơn bạn đã đánh giá hữu ích!");
                } else {
                    session.setAttribute("failedMsg", "Không thể cập nhật");
                }
                
                String referer = req.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    resp.sendRedirect(referer);
                } else {
                    resp.sendRedirect("index.jsp");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            if (isAjax) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                PrintWriter out = resp.getWriter();
                out.print("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
                out.flush();
            } else {
                HttpSession session = req.getSession();
                session.setAttribute("failedMsg", "Đã xảy ra lỗi");
                resp.sendRedirect("index.jsp");
            }
        }
    }
}