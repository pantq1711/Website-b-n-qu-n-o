package com.user.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.UserDAOImpl;
import com.DB.DBConnect;
import com.entity.User;

@WebServlet("/update_address")
public class UpdateAddress extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(req.getParameter("id"));
            String numhouse = req.getParameter("numhouse");
            String address = req.getParameter("address");
            String province = req.getParameter("province");
            String city = req.getParameter("city");
            String password = req.getParameter("password");
            
            HttpSession session = req.getSession();
            UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
            
            // Kiểm tra mật khẩu trước
            boolean f = dao.checkPassword(id, password);
            if(f){
                // Tạo User object với thông tin địa chỉ mới
                User us = new User();
                us.setId(id);
                us.setAddress(address);
                us.setNumhouse(numhouse);
                us.setCity(city);
                us.setProvince(province);
                
                // Cập nhật địa chỉ
                boolean f2 = dao.updateAddress(us);
                if(f2){
                    // Lấy lại thông tin User từ database để cập nhật session
                    User updatedUser = dao.getUserById(id);
                    if(updatedUser != null) {
                        // Cập nhật session với User object mới
                        session.setAttribute("userobj", updatedUser);
                    }
                    
                    session.setAttribute("succMsg", "Địa chỉ được cập nhật thành công!");
                    resp.sendRedirect("user_address.jsp");
                }else{
                    session.setAttribute("failedMsg","Lỗi Server rồi");
                    resp.sendRedirect("user_address.jsp");
                }
            }else{
                session.setAttribute("failedMsg","Mật khẩu bạn đã nhập chưa chính xác!");
                resp.sendRedirect("user_address.jsp");
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}