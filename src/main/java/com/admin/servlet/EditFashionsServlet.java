package com.admin.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

@WebServlet("/editFashions")
public class EditFashionsServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Đảm bảo mã hóa UTF-8 cho dữ liệu đầu vào
            if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            
            // In thông tin debug để theo dõi các tham số
            System.out.println("Nhận tham số:");
            System.out.println("id: " + req.getParameter("id"));
            System.out.println("fname: " + req.getParameter("fname"));
            System.out.println("price: " + req.getParameter("price"));
            System.out.println("size: " + req.getParameter("size"));
            System.out.println("status: " + req.getParameter("status"));
            System.out.println("quantity: " + req.getParameter("quantity"));
            System.out.println("describe: " + req.getParameter("describe"));
            
            // Lấy các tham số từ form
            int id = Integer.parseInt(req.getParameter("id"));
            String fashionName = req.getParameter("fname");
            String price = req.getParameter("price");
            String size = req.getParameter("size");
            String status = req.getParameter("status");
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            String describe = req.getParameter("describe");
            
            // Lấy thông tin hiện tại của sản phẩm để bảo toàn các trường không được chỉnh sửa trong form
            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
            FashionDtls existingFashion = dao.getFashionById(id);
            
            // Tạo đối tượng FashionDtls với thông tin mới
            FashionDtls b = new FashionDtls();
            b.setFashionId(id);
            b.setFashionName(fashionName);
            b.setSize(size);
            b.setPrice(price);
            b.setStatus(status);
            b.setQuantity(quantity);
            b.setDescribe(describe);
            
            // Giữ nguyên các trường không được chỉnh sửa trong form
            if (existingFashion != null) {
                b.setFashionCategory(existingFashion.getFashionCategory());
                b.setPhotoName(existingFashion.getPhotoName());
                b.setEmail(existingFashion.getEmail());
                
                // Giữ nguyên giá nhập hiện tại
                if (existingFashion.getFashionCategory() != null) {
                    String priceBuy = existingFashion.getPriceBuy();
                    if ("Cũ".equals(existingFashion.getFashionCategory())) {
                        b.setPriceBuy("0", "Cũ");
                    } else {
                        b.setPriceBuy(priceBuy, existingFashion.getFashionCategory());
                    }
                }
            }
            
            // Cập nhật sản phẩm
            boolean f = dao.updateEditFashions(b);
            HttpSession session = req.getSession();
            
            if (f) {
                session.setAttribute("succMsg", "Sản phẩm được cập nhật thành công!");
                resp.sendRedirect("admin/all_fashions.jsp");
            } else {
                session.setAttribute("failedMsg", "Lỗi khi cập nhật sản phẩm!");
                resp.sendRedirect("admin/edit_fashions.jsp?id=" + id);
            }
        } catch (Exception e) {
            System.out.println("Lỗi trong EditFashionsServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Xử lý lỗi và chuyển hướng với thông báo
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Lỗi: " + e.getMessage());
            resp.sendRedirect("admin/all_fashions.jsp");
        }
    }
}