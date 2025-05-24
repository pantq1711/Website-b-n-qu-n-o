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

@WebServlet("/update_profile")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("fname");
            String email = req.getParameter("email");
            String phno = req.getParameter("phno");
            String password = req.getParameter("password");
            
            HttpSession session = req.getSession();
            UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
            
            // Kiểm tra mật khẩu trước
            boolean f = dao.checkPassword(id, password);
            if(f){
                // Tạo User object với thông tin mới
                User us = new User();
                us.setId(id);
                us.setName(name);
                us.setEmail(email);
                us.setPhno(phno);
                
                // Cập nhật profile
                boolean f2 = dao.updateProfile(us);
                if(f2){
                    // Lấy lại thông tin User từ database để cập nhật session
                    User updatedUser = dao.getUserById(id);
                    if(updatedUser != null) {
                        // Cập nhật session với User object mới
                        session.setAttribute("userobj", updatedUser);
                    }
                    
                    session.setAttribute("succMsg", "Profile has been changed successfully!");
                    resp.sendRedirect("edit_profile.jsp");
                }else{
                    session.setAttribute("failedMsg","Lỗi Server rồi!");
                    resp.sendRedirect("edit_profile.jsp");
                }
            }else{
                session.setAttribute("failedMsg","Wrong password!");
                resp.sendRedirect("edit_profile.jsp");
            }
        
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}