package com.user.servlet;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.CartDAOImpl;
import com.DAO.FashionDAOImpl;
import com.DAO.FashionOrderDAOImpl;
import com.DB.DBConnect;
import com.entity.Cart;
import com.entity.FashionDtls;
import com.entity.Fashion_Order;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession();
            
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("username");
            String email = req.getParameter("email");
            String phno = req.getParameter("phno");
            String address = req.getParameter("address");
            String numhouse = req.getParameter("numhouse");
            String city = req.getParameter("city");
            String province = req.getParameter("province");
            String paymentType = req.getParameter("paymentType");
            String timeorder = req.getParameter("timeorder");
            
            // Tạo địa chỉ đầy đủ từ các thành phần
            String fullAddress = numhouse + ", " + address + ", " + city + ", " + province;
            
            // Kiểm tra thông tin đầu vào
            if (name == null || name.isEmpty() || email == null || email.isEmpty() || 
                phno == null || phno.isEmpty() || paymentType == null || paymentType.isEmpty()) {
                session.setAttribute("failedMsg", "Vui lòng điền đầy đủ thông tin");
                resp.sendRedirect("checkout.jsp");
                return;
            }
            
            CartDAOImpl dao = new CartDAOImpl(DBConnect.getConn());
            List<Cart> blist = dao.getFashionByUser(id);
            
            if (blist == null || blist.isEmpty()) {
                session.setAttribute("failedMsg", "Giỏ hàng trống, không thể đặt hàng");
                resp.sendRedirect("checkout.jsp");
                return;
            }
            
            // Kiểm tra số lượng trong kho trước khi đặt hàng
            FashionDAOImpl fashionDao = new FashionDAOImpl(DBConnect.getConn());
            StringBuilder errorMsgs = new StringBuilder();
            boolean hasInventoryError = false;
            
            for (Cart c : blist) {
                FashionDtls fashion = fashionDao.getFashionById(c.getFid());
                if (fashion == null) {
                    errorMsgs.append("Sản phẩm ").append(c.getFashionName()).append(" không tồn tại trong hệ thống. ");
                    hasInventoryError = true;
                    continue;
                }
                
                int availableStock = fashion.getQuantity();
                int requestedQuantity = c.getQuantity();
                
                if (requestedQuantity > availableStock) {
                    errorMsgs.append("Sản phẩm ").append(c.getFashionName())
                            .append(" chỉ còn ").append(availableStock)
                            .append(" trong kho (yêu cầu: ").append(requestedQuantity).append("). ");
                    hasInventoryError = true;
                }
            }
            
            if (hasInventoryError) {
                session.setAttribute("failedMsg", "Lỗi về số lượng sản phẩm: " + errorMsgs.toString());
                resp.sendRedirect("checkout.jsp");
                return;
            }
            
            // Tạo Order ID ngẫu nhiên
            Random r = new Random();
            String orderId = "ORDER-" + System.currentTimeMillis() + "-" + r.nextInt(1000);
            
            // Lấy ngày hiện tại
            String currentDate = "";
            if (timeorder != null && !timeorder.isEmpty()) {
                currentDate = timeorder;
            } else {
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                currentDate = dateFormat.format(new Date());
            }
            
            List<Fashion_Order> orderList = new ArrayList<Fashion_Order>();
            
            // Hiển thị tất cả sản phẩm trong giỏ hàng để debug
            System.out.println("===== SẢN PHẨM TRONG GIỎ HÀNG =====");
            for (Cart c : blist) {
                System.out.println("Fashion ID: " + c.getFid());
                System.out.println("Fashion Name: " + c.getFashionName());
                System.out.println("Size: " + c.getSize());
                System.out.println("Price: " + c.getPrice());
                System.out.println("Quantity: " + c.getQuantity());
                System.out.println("-----------------------");
                
                // Tạo đối tượng Fashion_Order
                Fashion_Order o = new Fashion_Order();
                o.setOrderId(orderId);
                o.setUserName(name);
                o.setEmail(email);
                o.setPhno(phno);
                o.setFullAdd(fullAddress);
                o.setFashionName(c.getFashionName());
                o.setSize(c.getSize());
                o.setPrice(c.getPrice());
                o.setPaymentType(paymentType);
                o.setQuantity(c.getQuantity());
                o.setDate(currentDate);
                
                orderList.add(o);
            }
            
            // Lưu đơn hàng
            FashionOrderDAOImpl orderDao = new FashionOrderDAOImpl(DBConnect.getConn());
            boolean f = orderDao.saveOrder(orderList);
            
            if (f) {
                // Sau khi lưu đơn hàng thành công, cập nhật số lượng sản phẩm trong kho
                for (Cart c : blist) {
                    // Sử dụng phương thức của FashionDAOImpl thay vì FashionOrderDAOImpl
                    fashionDao.safeUpdateQuantity(c.getFid(), c.getQuantity());
                }
                
                // Xóa giỏ hàng sau khi đặt hàng thành công
                boolean deleteCart = dao.deleteUserCart(id);
                
                if (deleteCart) {
                    session.setAttribute("succMsg", "Đặt hàng thành công");
                    resp.sendRedirect("order_success.jsp");
                } else {
                    session.setAttribute("failedMsg", "Đặt hàng thành công nhưng không thể xóa giỏ hàng");
                    resp.sendRedirect("order_success.jsp");
                }
            } else {
                session.setAttribute("failedMsg", "Đặt hàng không thành công, vui lòng thử lại");
                resp.sendRedirect("checkout.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Lỗi: " + e.getMessage());
            resp.sendRedirect("checkout.jsp");
        }
    }
}