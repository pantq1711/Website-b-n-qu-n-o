package com.user.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.CartDAOImpl;
import com.DB.DBConnect;

@WebServlet("/remove_fashion")
public class RemoveFashionCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int fid = Integer.parseInt(req.getParameter("fid"));
            int uid = Integer.parseInt(req.getParameter("uid"));
            int cid = Integer.parseInt(req.getParameter("cid"));
            
            // Kiểm tra xem request có phải là AJAX không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
            boolean f = dao.deleteFashion(fid, uid, cid);
            
            if (f) {
                sendResponse(req, resp, true, "Sản phẩm đã được xóa khỏi giỏ hàng", isAjax);
            } else {
                sendResponse(req, resp, false, "Đã xảy ra lỗi khi xóa sản phẩm", isAjax);
            }
        } catch (Exception e) {
            e.printStackTrace();
            
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            sendResponse(req, resp, false, "Đã xảy ra lỗi: " + e.getMessage(), isAjax);
        }
    }
    
    private void sendResponse(HttpServletRequest req, HttpServletResponse resp, boolean success, String message, boolean isAjax) throws IOException {
        HttpSession session = req.getSession();
        
        // Lưu thông báo vào session
        if (success) {
            session.setAttribute("succMsg", message);
        } else {
            session.setAttribute("failedMsg", message);
        }
        
        if (isAjax) {
            // Nếu là AJAX thì trả về JSON
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
            out.flush();
        } else {
            // Nếu không phải AJAX, chuyển hướng về trang checkout.jsp vì thao tác xóa thường được thực hiện từ đó
            resp.sendRedirect("checkout.jsp");
        }
    }
}