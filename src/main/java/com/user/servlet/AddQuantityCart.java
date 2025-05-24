package com.user.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.DAO.CartDAOImpl;
import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

@WebServlet("/addcart")
public class AddQuantityCart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int fid = Integer.parseInt(req.getParameter("fid"));
            int cid = Integer.parseInt(req.getParameter("cid"));
            
            // Kiểm tra xem request có phải là AJAX không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            // Lấy thông tin sản phẩm từ database
            FashionDAOImpl fashionDao = new FashionDAOImpl(DBConnect.getConn());
            FashionDtls fashion = fashionDao.getFashionById(fid);
            
            if (fashion == null) {
                sendResponse(req, resp, false, "Không tìm thấy sản phẩm", isAjax);
                return;
            }
            
            // Kiểm tra số lượng sản phẩm trong kho
            int availableQuantity = fashion.getQuantity();
            
            // Lấy số lượng hiện tại trong cart
            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            int currentQuantity = 0;
            
            try {
                String getCartSql = "SELECT quantity FROM cart WHERE fid = ? AND cid = ?";
                PreparedStatement ps = DBConnect.getConn().prepareStatement(getCartSql);
                ps.setInt(1, fid);
                ps.setInt(2, cid);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    currentQuantity = rs.getInt("quantity");
                }
            } catch (Exception e) {
                // Lỗi truy vấn được ghi log, nhưng không làm gián đoạn quá trình
                e.printStackTrace();
            }
            
            if (currentQuantity >= availableQuantity) {
                sendResponse(req, resp, false, "Số lượng vượt quá tồn kho. Chỉ còn " + availableQuantity + " sản phẩm.", isAjax);
                return;
            }
            
            boolean result = cartDao.addQuantityToCart(fid, cid);
            
            if (result) {
                sendResponse(req, resp, true, "Đã cập nhật số lượng", isAjax);
            } else {
                sendResponse(req, resp, false, "Không thể tăng số lượng", isAjax);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            sendResponse(req, resp, false, "Lỗi: " + e.getMessage(), isAjax);
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
            // hoặc về index.jsp nếu đang ở trang chủ
            String referer = req.getHeader("Referer");
            if (referer != null && referer.contains("checkout.jsp")) {
                resp.sendRedirect("checkout.jsp");
            } else {
                resp.sendRedirect("index.jsp");
            }
        }
    }
}