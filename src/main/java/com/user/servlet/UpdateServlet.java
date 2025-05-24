package com.user.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.CartDAOImpl;
import com.DB.DBConnect;

@WebServlet("/update_fashion")
public class UpdateServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
		int fid= Integer.parseInt(req.getParameter("fid"));
		int uid= Integer.parseInt(req.getParameter("uid"));
		int cid= Integer.parseInt(req.getParameter("cid"));
		  CartDAOImpl dao= new CartDAOImpl(DBConnect.getConn());
		  boolean f= dao.deleteFashion(fid,uid,cid);
		  HttpSession session = req.getSession();
		  
		  
		  if(f)
		  {
			  	session.setAttribute("succMsg", "Sản phẩm xóa thành công khỏi giỏ hàng");
			  	resp.sendRedirect("checkout.jsp");
		  }else {
			  
			  	session.setAttribute("failedMsg", "Lỗi Server rồi");
			  	resp.sendRedirect("checkout.jsp");
		  }	
	}
	
}