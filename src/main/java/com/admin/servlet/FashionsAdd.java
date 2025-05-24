/**
 *
 * @author Anphan
 */
package com.admin.servlet;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import com.entity.FashionDtls;
import com.DAO.FashionDAOImpl;
import com.DB.*;
import javax.servlet.annotation.MultipartConfig;

@WebServlet("/add_fashions")
@MultipartConfig
public class FashionsAdd extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
    try {
        if(req.getCharacterEncoding() == null) req.setCharacterEncoding("UTF-8");
        String fashionName = req.getParameter("fname"); 
        String price = req.getParameter("price");
        String size = req.getParameter("size");
        String categories = req.getParameter("categories");
        String status = req.getParameter("status");
        Part part = req.getPart("fimg");    
        String fileName = extractFileName(part);  // Sử dụng phương thức trích xuất tên tệp thay thế
        String pricebuy = req.getParameter("pricebuy");
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        String describe = req.getParameter("describe");
        FashionDtls b = new FashionDtls(fashionName, size, price, categories, status, fileName, "admin", pricebuy, quantity, describe);
        FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn()); 
        boolean f = dao.addFashions(b);
        System.out.print(b);
        HttpSession session = req.getSession();
        if(f) {
            String path = getServletContext().getRealPath("") + "fashion";
                
            File file = new File(path);
            if(!file.exists()) {
                file.mkdir();  // Tạo thư mục nếu chưa tồn tại
            }
            part.write(path + File.separator + fileName);
                
            session.setAttribute("succMsg", "Added successfully!");
            resp.sendRedirect("admin/add_fashions.jsp");
        } else {
            session.setAttribute("failedMsg", "Lỗi Server rồi!");
            resp.sendRedirect("admin/add_fashions.jsp");
        }
         
    } catch (Exception e) {
        e.printStackTrace();
    }    
    }
    
    // Phương thức trích xuất tên tệp từ Part
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return "";
    }
}