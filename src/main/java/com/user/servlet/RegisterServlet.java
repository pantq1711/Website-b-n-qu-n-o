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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		try {
			if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
			String name = req.getParameter("fname");
			String email= req.getParameter("email"); 
			String phno= req.getParameter("phno"); 
			String password= req.getParameter("password"); 
			String check= req.getParameter("check");
			
			//System.out.println(name+ " " + email + " " + phon+" "+ password +" "+ check);
			
			User us= new User();
			us.setName(name);
			us.setEmail(email);
			us.setPhno(phno);
			us.setPassword(password);
			
			HttpSession session= req.getSession();
			
			if(check!= null) {
				UserDAOImpl dao= new UserDAOImpl(DBConnect.getConn());
				
				boolean f2= dao.checkUser(email);
				if(f2)
				{
					
					boolean f= dao.userRegister(us);
					if(f) {
						//System.out.println("User Register Success..");
						session.setAttribute("succMsg", "Register successfully!");
						resp.sendRedirect("register.jsp");
						
					}else {
						//System.out.println("Something wrong on server..");
						session.setAttribute("failedMsg","Lỗi Server rồi!");
						resp.sendRedirect("register.jsp");
						
					}
					
					
					
				}else {
					session.setAttribute("failedMsg","Email already exists, please use another email!");
					resp.sendRedirect("register.jsp");
					
				}
				
			}else {
				//System.out.println("Please Check Agree & Terms Condition");
				session.setAttribute("failedMsg", "Please Agree terms & Condition!");
				resp.sendRedirect("register.jsp");
			}
			
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
