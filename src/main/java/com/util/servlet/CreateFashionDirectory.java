// Tạo file CreateFashionDirectory.java để tạo thư mục khi khởi động app
package com.util.servlet;

import java.io.File;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class CreateFashionDirectory implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Get webapp path
        String webappPath = sce.getServletContext().getRealPath("/");
        String fashionPath = webappPath + "fashion";
        
        // Create fashion directory if it doesn't exist
        File fashionDir = new File(fashionPath);
        if (!fashionDir.exists()) {
            if (fashionDir.mkdirs()) {
                System.out.println("Fashion directory created at: " + fashionPath);
            } else {
                System.out.println("Failed to create fashion directory at: " + fashionPath);
            }
        } else {
            System.out.println("Fashion directory already exists at: " + fashionPath);
        }
        
        // Also create backup directory
        String backupPath = System.getProperty("user.home") + File.separator + "fashion_uploads";
        File backupDir = new File(backupPath);
        if (!backupDir.exists()) {
            if (backupDir.mkdirs()) {
                System.out.println("Fashion backup directory created at: " + backupPath);
            }
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}