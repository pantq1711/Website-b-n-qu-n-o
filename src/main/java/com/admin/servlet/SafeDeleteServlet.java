package com.admin.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

@WebServlet("/safe_delete")
public class SafeDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            if (req.getCharacterEncoding() == null) {
                req.setCharacterEncoding("UTF-8");
            }
            
            int id = Integer.parseInt(req.getParameter("id"));
            String action = req.getParameter("action"); // "check" or "force"
            
            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
            HttpSession session = req.getSession();
            
            // Get fashion details first
            FashionDtls fashion = dao.getFashionById(id);
            if (fashion == null) {
                session.setAttribute("failedMsg", "Không tìm thấy sản phẩm với ID: " + id);
                resp.sendRedirect("admin/all_fashions.jsp");
                return;
            }
            
            if ("check".equals(action)) {
                // Check for constraints before deletion
                checkDeleteConstraints(req, resp, dao, fashion, session);
            } else if ("force".equals(action)) {
                // Force delete after user confirmation
                forceDeleteFashion(req, resp, dao, fashion, session);
            } else {
                // Default: safe delete
                performSafeDelete(req, resp, dao, fashion, session);
            }
            
        } catch (NumberFormatException e) {
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "ID sản phẩm không hợp lệ");
            resp.sendRedirect("admin/all_fashions.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Đã xảy ra lỗi: " + e.getMessage());
            resp.sendRedirect("admin/all_fashions.jsp");
        }
    }
    
    /**
     * Check deletion constraints and provide detailed feedback
     */
    private void checkDeleteConstraints(HttpServletRequest req, HttpServletResponse resp, 
                                      FashionDAOImpl dao, FashionDtls fashion, HttpSession session) 
            throws IOException {
        
        boolean hasPendingOrders = dao.hasPendingOrders(fashion.getFashionId());
        int pendingOrderCount = dao.getPendingOrderCount(fashion.getFashionId());
        List<String> orderIds = dao.getPendingOrderIds(fashion.getFashionId());
        
        // Check shopping carts
        int cartCount = getCartCount(fashion.getFashionId());
        
        if (hasPendingOrders || cartCount > 0) {
            // Build detailed warning message
            StringBuilder warningMsg = new StringBuilder();
            warningMsg.append("<div class='alert alert-warning'>");
            warningMsg.append("<h5><i class='fas fa-exclamation-triangle'></i> Cảnh báo xóa sản phẩm</h5>");
            warningMsg.append("<p><strong>Sản phẩm '").append(fashion.getFashionName()).append("' đang được sử dụng:</strong></p>");
            warningMsg.append("<ul>");
            
            if (hasPendingOrders) {
                warningMsg.append("<li><i class='fas fa-shopping-bag text-danger'></i> ");
                warningMsg.append("<strong>").append(pendingOrderCount).append(" đơn hàng</strong> đang chờ xử lý");
                if (!orderIds.isEmpty()) {
                    warningMsg.append(" (Mã đơn: ").append(joinStrings(orderIds, ", ")).append(")");
                }
                warningMsg.append("</li>");
            }
            
            if (cartCount > 0) {
                warningMsg.append("<li><i class='fas fa-shopping-cart text-warning'></i> ");
                warningMsg.append("Có trong <strong>").append(cartCount).append(" giỏ hàng</strong> của khách hàng</li>");
            }
            
            warningMsg.append("</ul>");
            warningMsg.append("<div class='mt-3'>");
            warningMsg.append("<strong>Tùy chọn:</strong><br>");
            warningMsg.append("• <a href='safe_delete?id=").append(fashion.getFashionId()).append("&action=force' ");
            warningMsg.append("class='btn btn-sm btn-danger' onclick='return confirmForceDelete()'>Xóa bắt buộc</a> ");
            warningMsg.append("(Sẽ hủy các đơn hàng và xóa khỏi giỏ hàng)<br>");
            warningMsg.append("• <a href='admin/all_fashions.jsp' class='btn btn-sm btn-secondary'>Hủy bỏ</a>");
            warningMsg.append("</div></div>");
            
            session.setAttribute("warningMsg", warningMsg.toString());
            
        } else {
            // Safe to delete
            boolean success = dao.safeDeleteFashion(fashion.getFashionId());
            if (success) {
                session.setAttribute("succMsg", "Đã xóa sản phẩm '" + fashion.getFashionName() + "' thành công!");
            } else {
                session.setAttribute("failedMsg", "Không thể xóa sản phẩm. Vui lòng thử lại.");
            }
        }
        
        resp.sendRedirect("admin/all_fashions.jsp");
    }
    
    /**
     * Force delete with cascading effects
     */
    private void forceDeleteFashion(HttpServletRequest req, HttpServletResponse resp, 
                                  FashionDAOImpl dao, FashionDtls fashion, HttpSession session) 
            throws IOException {
        
        try {
            // Start transaction for cascading delete
            boolean success = performCascadingDelete(fashion);
            
            if (success) {
                session.setAttribute("succMsg", 
                    "Đã xóa bắt buộc sản phẩm '" + fashion.getFashionName() + "' và tất cả dữ liệu liên quan!");
            } else {
                session.setAttribute("failedMsg", "Không thể xóa sản phẩm. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("failedMsg", "Lỗi khi xóa bắt buộc: " + e.getMessage());
        }
        
        resp.sendRedirect("admin/all_fashions.jsp");
    }
    
    /**
     * Perform safe delete (normal flow)
     */
    private void performSafeDelete(HttpServletRequest req, HttpServletResponse resp, 
                                 FashionDAOImpl dao, FashionDtls fashion, HttpSession session) 
            throws IOException {
        
        boolean success = dao.safeDeleteFashion(fashion.getFashionId());
        
        if (success) {
            session.setAttribute("succMsg", "Đã xóa sản phẩm '" + fashion.getFashionName() + "' thành công!");
        } else {
            // Check why deletion failed
            if (dao.hasPendingOrders(fashion.getFashionId())) {
                int pendingCount = dao.getPendingOrderCount(fashion.getFashionId());
                session.setAttribute("failedMsg", 
                    "Không thể xóa sản phẩm vì có " + pendingCount + " đơn hàng đang chờ xử lý. " +
                    "Vui lòng xử lý các đơn hàng trước hoặc sử dụng 'Xóa bắt buộc'.");
            } else {
                session.setAttribute("failedMsg", "Không thể xóa sản phẩm. Vui lòng thử lại.");
            }
        }
        
        resp.sendRedirect("admin/all_fashions.jsp");
    }
    
    /**
     * Get count of shopping carts containing this product
     */
    private int getCartCount(int fashionId) {
        Connection conn = null;
        try {
            conn = DBConnect.getConn();
            String sql = "SELECT COUNT(DISTINCT uid) FROM cart WHERE fid = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Perform cascading delete (delete product and all related data)
     */
    private boolean performCascadingDelete(FashionDtls fashion) {
        Connection conn = null;
        boolean success = false;
        
        try {
            conn = DBConnect.getConn();
            conn.setAutoCommit(false);
            
            int fashionId = fashion.getFashionId();
            String fashionName = fashion.getFashionName();
            
            // 1. Cancel and delete related orders
            String deleteOrdersSql = "DELETE FROM fashion_order WHERE fashionName = ?";
            PreparedStatement deleteOrdersPs = conn.prepareStatement(deleteOrdersSql);
            deleteOrdersPs.setString(1, fashionName);
            int ordersDeleted = deleteOrdersPs.executeUpdate();
            
            // 2. Remove from all shopping carts
            String deleteCartSql = "DELETE FROM cart WHERE fid = ?";
            PreparedStatement deleteCartPs = conn.prepareStatement(deleteCartSql);
            deleteCartPs.setInt(1, fashionId);
            int cartsDeleted = deleteCartPs.executeUpdate();
            
            // 3. Delete reviews if exists
            try {
                String deleteReviewsSql = "DELETE FROM fashion_reviews WHERE fashion_id = ?";
                PreparedStatement deleteReviewsPs = conn.prepareStatement(deleteReviewsSql);
                deleteReviewsPs.setInt(1, fashionId);
                int reviewsDeleted = deleteReviewsPs.executeUpdate();
                System.out.println("Đã xóa " + reviewsDeleted + " đánh giá");
            } catch (Exception e) {
                // Reviews table might not exist, continue
                System.out.println("Bảng reviews không tồn tại hoặc lỗi: " + e.getMessage());
            }
            
            // 4. Finally delete the fashion item
            String deleteFashionSql = "DELETE FROM fashion_dtls WHERE fashionId = ?";
            PreparedStatement deleteFashionPs = conn.prepareStatement(deleteFashionSql);
            deleteFashionPs.setInt(1, fashionId);
            int fashionDeleted = deleteFashionPs.executeUpdate();
            
            if (fashionDeleted > 0) {
                success = true;
                System.out.println("Cascading delete completed:");
                System.out.println("- Đã xóa sản phẩm: " + fashionName);
                System.out.println("- Đã hủy " + ordersDeleted + " đơn hàng");
                System.out.println("- Đã xóa khỏi " + cartsDeleted + " giỏ hàng");
            }
            
            conn.commit();
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return success;
    }
    
    /**
     * Helper method to join strings (Java 7 compatible)
     */
    private String joinStrings(List<String> strings, String delimiter) {
        if (strings == null || strings.isEmpty()) {
            return "";
        }
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < strings.size(); i++) {
            if (i > 0) {
                sb.append(delimiter);
            }
            sb.append(strings.get(i));
        }
        return sb.toString();
    }
}