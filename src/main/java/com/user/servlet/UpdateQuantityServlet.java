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
import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

@WebServlet("/update_quantity")
public class UpdateQuantityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            int fid = Integer.parseInt(req.getParameter("fid"));
            int cid = Integer.parseInt(req.getParameter("cid"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            
            // Lấy user ID từ session
            HttpSession session = req.getSession();
            int uid = 0;
            if (session.getAttribute("userobj") != null) {
                com.entity.User user = (com.entity.User) session.getAttribute("userobj");
                uid = user.getId();
            } else {
                sendResponse(resp, false, "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại");
                return;
            }
            
            // Kiểm tra số lượng hợp lệ
            if (quantity < 1) {
                sendResponse(resp, false, "Số lượng không được nhỏ hơn 1");
                return;
            }
            
            // Kiểm tra số lượng trong kho
            FashionDAOImpl fashionDao = new FashionDAOImpl(DBConnect.getConn());
            FashionDtls fashion = fashionDao.getFashionById(fid);
            
            if (fashion == null) {
                sendResponse(resp, false, "Không tìm thấy sản phẩm");
                return;
            }
            
            // Kiểm tra số lượng trong kho
            int availableQuantity = fashion.getQuantity();
            
            if (quantity > availableQuantity) {
                sendResponse(resp, false, "Số lượng vượt quá tồn kho. Chỉ còn " + availableQuantity + " sản phẩm");
                return;
            }
            
            // Cập nhật số lượng trong giỏ hàng
            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            boolean success = cartDao.updateQuantityToCart(quantity, uid, fid, cid);
            
            if (success) {
                sendResponse(resp, true, "Đã cập nhật số lượng thành công");
            } else {
                sendResponse(resp, false, "Không thể cập nhật số lượng");
            }
            
        } catch (NumberFormatException e) {
            sendResponse(resp, false, "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(resp, false, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }
    
    private void sendResponse(HttpServletResponse resp, boolean success, String message) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }
}