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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            UserDAOImpl dao = new UserDAOImpl(DBConnect.getConn());
            
            HttpSession session = req.getSession();
            
            String email = req.getParameter("email");
            String password = req.getParameter("password");
        
            if ("admin@gmail.com".equals(email) && "admin".equals(password)) {
                User us = new User();
                us.setName("Admin");
                session.setAttribute("userobj", us);
                resp.sendRedirect("admin/home.jsp");
            } else {
                User us = dao.login(email, password);
                if(us != null) {
                    session.setAttribute("userobj", us);
                    resp.sendRedirect("index.jsp");
                } else {
                    session.setAttribute("failedMsg", "Wrong username or password!");
                    resp.sendRedirect("login.jsp");
                }
                // Xóa dòng này: resp.sendRedirect("home.jsp");
                // Đây là dòng gây lỗi vì bạn đã gọi sendRedirect trước đó
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Đã xảy ra lỗi: " + e.getMessage());
            resp.sendRedirect("login.jsp");
        }
    }
}