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

@WebServlet("/subcart")
public class SubQuantityCart extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int fid = Integer.parseInt(req.getParameter("fid"));
            int cid = Integer.parseInt(req.getParameter("cid"));
            
            // Kiểm tra xem request có phải là AJAX không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
            boolean result = dao.subQuantityToCart(fid, cid);
            
            HttpSession session = req.getSession();
            if (result) {
                sendResponse(req, resp, true, "Số lượng đã được cập nhật", isAjax);
            } else {
                sendResponse(req, resp, false, "Số lượng tối thiểu là 1", isAjax);
            }
            
        } catch (Exception e) {
            System.out.println("Lỗi SubCartServlet: " + e.getMessage());
            e.printStackTrace();
            
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            sendResponse(req, resp, false, "Đã xảy ra lỗi khi cập nhật sản phẩm", isAjax);
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
            // Nếu không phải AJAX, chuyển hướng về trang checkout.jsp nếu đang trong trang đó
            String referer = req.getHeader("Referer");
            if (referer != null && referer.contains("checkout.jsp")) {
                resp.sendRedirect("checkout.jsp");
            } else {
                resp.sendRedirect("index.jsp");
            }
        }
    }
}