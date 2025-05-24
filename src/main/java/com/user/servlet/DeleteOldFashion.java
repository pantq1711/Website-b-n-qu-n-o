/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.user.servlet;

/**
 *
 * @author Anphan
 */
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;

import java.io.IOException;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Anphan
 */
@WebServlet("/delete_old_fashion")
public class DeleteOldFashion  extends HttpServlet{

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
    		if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
            String em = req.getParameter("em");
            
            int id = Integer.parseInt(req.getParameter("id"));
            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
            Boolean f = dao.oldFashionDelete(em, "Cũ", id);
            HttpSession session = req.getSession();
            if(f)
            {
                session.setAttribute("succMsg", "Xóa sản phẩm cũ thành công!");
                resp.sendRedirect("old_fashion.jsp");
            }
            else 
            {
                session.setAttribute("failedMsg", "Lỗi Server rồi!");
                resp.sendRedirect("old_fashion.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}

