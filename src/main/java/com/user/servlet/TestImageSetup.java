// TestImageSetup.java - File để test và setup ảnh
package com.user.servlet;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/test-images")
public class TestImageSetup extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        StringBuilder output = new StringBuilder();
        output.append("<html><body>");
        output.append("<h1>Fashion Image Directory Test</h1>");
        
        // Check webapp/fashion directory
        String webappPath = getServletContext().getRealPath("/");
        String fashionPath = webappPath + "fashion";
        File fashionDir = new File(fashionPath);
        
        output.append("<h2>Webapp Fashion Directory</h2>");
        output.append("<p>Path: ").append(fashionPath).append("</p>");
        output.append("<p>Exists: ").append(fashionDir.exists()).append("</p>");
        
        if (!fashionDir.exists()) {
            boolean created = fashionDir.mkdirs();
            output.append("<p>Created: ").append(created).append("</p>");
        }
        
        if (fashionDir.exists()) {
            File[] files = fashionDir.listFiles();
            output.append("<p>Files count: ").append(files != null ? files.length : 0).append("</p>");
            
            if (files != null && files.length > 0) {
                output.append("<h3>Files in directory:</h3><ul>");
                for (File file : files) {
                    output.append("<li>").append(file.getName());
                    output.append(" - ").append(file.length()).append(" bytes");
                    // Test if image is accessible
                    String imagePath = request.getContextPath() + "/fashion/" + file.getName();
                    output.append("<br><img src='").append(imagePath).append("' width='100' onerror='this.style.border=\"2px solid red\"'>");
                    output.append("</li>");
                }
                output.append("</ul>");
            }
        }
        
        // Check backup directory
        String backupPath = System.getProperty("user.home") + File.separator + "fashion_uploads";
        File backupDir = new File(backupPath);
        
        output.append("<h2>Backup Fashion Directory</h2>");
        output.append("<p>Path: ").append(backupPath).append("</p>");
        output.append("<p>Exists: ").append(backupDir.exists()).append("</p>");
        
        if (backupDir.exists()) {
            File[] backupFiles = backupDir.listFiles();
            output.append("<p>Files count: ").append(backupFiles != null ? backupFiles.length : 0).append("</p>");
        }
        
        // Database file paths check would go here
        output.append("<h2>Instructions</h2>");
        output.append("<p>1. Upload some images through admin panel</p>");
        output.append("<p>2. Check if images appear in the directories above</p>");
        output.append("<p>3. Test image URL: /fashion/[filename]</p>");
        
        output.append("</body></html>");
        
        response.getWriter().write(output.toString());
    }
}