package com.user.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionOrderDAOImpl;
import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.Fashion_Order;
import java.util.List;

@WebServlet("/cancel_order")
public class CancelOrderServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Set character encoding
            if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            
            String orderId = req.getParameter("orderId");
            
            // Check if request is AJAX
            String xRequestedWith = req.getHeader("X-Requested-With");
            boolean isAjax = "XMLHttpRequest".equals(xRequestedWith);
            
            // Validate input
            if (orderId == null || orderId.trim().isEmpty()) {
                sendResponse(req, resp, false, "ID đơn hàng không hợp lệ", isAjax);
                return;
            }
            
            FashionOrderDAOImpl orderDao = new FashionOrderDAOImpl(DBConnect.getConn());
            FashionDAOImpl fashionDao = new FashionDAOImpl(DBConnect.getConn());
            
            // Get all items in the order
            List<Fashion_Order> orderItems = orderDao.getOrdersByOrderId(orderId);
            
            if (orderItems == null || orderItems.isEmpty()) {
                sendResponse(req, resp, false, "Không tìm thấy đơn hàng", isAjax);
                return;
            }
            
            // Check if order can be cancelled (simple business rule)
            // In a real system, you might check order status, time elapsed, etc.
            // For now, we'll allow cancellation of all orders
            
            // Restore product quantities back to inventory
            boolean quantityRestored = true;
            for (Fashion_Order item : orderItems) {
                try {
                    // Add the quantity back to the product inventory
                    boolean restored = fashionDao.restoreQuantity(item.getFashionName(), item.getQuantity());
                    if (!restored) {
                        quantityRestored = false;
                        System.out.println("Failed to restore quantity for: " + item.getFashionName());
                        // Continue with other items even if one fails
                    }
                } catch (Exception e) {
                    System.out.println("Error restoring quantity for " + item.getFashionName() + ": " + e.getMessage());
                    quantityRestored = false;
                }
            }
            
            // Cancel the order (delete from database)
            boolean orderCancelled = orderDao.cancelOrder(orderId);
            
            if (orderCancelled) {
                String message = "Đơn hàng đã được hủy thành công";
                if (!quantityRestored) {
                    message += " (một số sản phẩm có thể chưa được hoàn lại kho)";
                }
                sendResponse(req, resp, true, message, isAjax);
            } else {
                sendResponse(req, resp, false, "Không thể hủy đơn hàng. Vui lòng thử lại sau.", isAjax);
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
        
        // Save message to session for non-AJAX requests
        if (success) {
            session.setAttribute("succMsg", message);
        } else {
            session.setAttribute("failedMsg", message);
        }
        
        if (isAjax) {
            // Return JSON response for AJAX requests
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{\"success\":" + success + ",\"message\":\"" + message.replace("\"", "\\\"") + "\"}");
            out.flush();
        } else {
            // Redirect to order page for non-AJAX requests
            resp.sendRedirect("order.jsp");
        }
    }
}