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
import com.entity.Cart;
import com.entity.FashionDtls;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            int fid = Integer.parseInt(req.getParameter("fid"));
            int uid = Integer.parseInt(req.getParameter("uid"));
            
            // Lấy số lượng từ request, mặc định là 1 nếu không có
            int requestedQuantity = 1;
            String quantityParam = req.getParameter("quantity");
            if (quantityParam != null && !quantityParam.isEmpty()) {
                try {
                    requestedQuantity = Integer.parseInt(quantityParam);
                    if (requestedQuantity < 1) {
                        requestedQuantity = 1;
                    }
                } catch (NumberFormatException e) {
                    requestedQuantity = 1;
                }
            }
            
            // Kiểm tra AJAX request
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            // Lấy thông tin sản phẩm từ database
            FashionDAOImpl fashionDao = new FashionDAOImpl(DBConnect.getConn());
            FashionDtls fashion = fashionDao.getFashionById(fid);
            
            if (fashion == null) {
                // Xử lý lỗi nếu không tìm thấy sản phẩm
                handleResponse(req, resp, false, "Không tìm thấy sản phẩm", isAjax);
                return;
            }
            
            // Kiểm tra số lượng trong kho
            int availableQuantity = fashion.getQuantity();
            
            // Kiểm tra số lượng hiện có trong giỏ hàng
            CartDAOImpl cartDao = new CartDAOImpl(DBConnect.getConn());
            int cartQuantity = cartDao.getCartItemQuantity(fid, uid);
            
            if (availableQuantity <= 0) {
                handleResponse(req, resp, false, "Sản phẩm đã hết hàng", isAjax);
                return;
            }
            
            // Kiểm tra xem có đủ hàng để thêm vào giỏ không
            int totalRequestedQuantity = cartQuantity + requestedQuantity;
            if (totalRequestedQuantity > availableQuantity) {
                String message = String.format("Không thể thêm %d sản phẩm vào giỏ hàng. " +
                        "Chỉ còn %d sản phẩm trong kho và bạn đã có %d sản phẩm trong giỏ hàng.", 
                        requestedQuantity, availableQuantity, cartQuantity);
                handleResponse(req, resp, false, message, isAjax);
                return;
            }
            
            // Tạo đối tượng Cart với số lượng được yêu cầu
            Cart cart = new Cart();
            cart.setFid(fid);
            cart.setUserId(uid);
            cart.setFashionName(fashion.getFashionName());
            
            try {
                cart.setSize(fashion.getSize() != null ? fashion.getSize() : "Default");
            } catch (Exception e) {
                cart.setSize("Default");
            }
            
            cart.setPrice(fashion.getPrice());
            cart.setQuantity(requestedQuantity);
            
            // Thêm vào giỏ hàng
            boolean success = cartDao.addCart(cart);
            
            // Xử lý kết quả
            if (success) {
                String message = String.format("Đã thêm %d sản phẩm %s vào giỏ hàng", 
                        requestedQuantity, fashion.getFashionName());
                handleResponse(req, resp, true, message, isAjax);
            } else {
                handleResponse(req, resp, false, "Không thể thêm sản phẩm vào giỏ hàng. Vui lòng thử lại sau.", isAjax);
            }
            
        } catch (NumberFormatException e) {
            // Kiểm tra xem request có phải là AJAX không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            handleResponse(req, resp, false, "Dữ liệu không hợp lệ: " + e.getMessage(), isAjax);
        } catch (Exception e) {
            // Kiểm tra xem request có phải là AJAX không
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            handleResponse(req, resp, false, "Đã xảy ra lỗi: " + e.getMessage(), isAjax);
        }
    }

    // Hàm xử lý response cho cả AJAX và redirect thông thường
    private void handleResponse(HttpServletRequest req, HttpServletResponse resp, boolean success, String message, boolean isAjax) throws IOException {
        HttpSession session = req.getSession();
        
        // Lưu thông báo vào session
        if (success) {
            session.setAttribute("succMsg", message);
        } else {
            session.setAttribute("failedMsg", message);
        }
        
        if (isAjax) {
            // Nếu là AJAX thì trả về JSON và KHÔNG redirect
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
            out.flush();
        } else {
            // Chuyển hướng về trang index.jsp thay vì checkout.jsp
            resp.sendRedirect("index.jsp");
        }
    }
}