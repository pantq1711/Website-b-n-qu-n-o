package com.util.servlet;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/copy-sample-images")
public class CopySampleImages extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Get webapp path
        String webappPath = getServletContext().getRealPath("/");
        String fashionPath = webappPath + "fashion";
        File fashionDir = new File(fashionPath);
        
        // Create fashion directory if not exists
        if (!fashionDir.exists()) {
            fashionDir.mkdirs();
        }
        
        // Look for sample images in img folder
        String imgPath = webappPath + "img";
        File imgDir = new File(imgPath);
        
        StringBuilder output = new StringBuilder();
        output.append("<html><body>");
        output.append("<h1>Copy Sample Images</h1>");
        
        if (imgDir.exists()) {
            // Custom file filter instead of lambda
            File[] imageFiles = imgDir.listFiles(new ImageFileFilter());
            
            if (imageFiles != null && imageFiles.length > 0) {
                output.append("<h2>Found ").append(imageFiles.length).append(" images in img folder</h2>");
                output.append("<ul>");
                
                for (File imgFile : imageFiles) {
                    try {
                        // Copy to fashion directory using streams
                        File targetFile = new File(fashionDir, imgFile.getName());
                        copyFile(imgFile, targetFile);
                        
                        output.append("<li>Copied: ").append(imgFile.getName()).append(" ✓</li>");
                    } catch (Exception e) {
                        output.append("<li>Error copying ").append(imgFile.getName()).append(": ").append(e.getMessage()).append("</li>");
                    }
                }
                output.append("</ul>");
            } else {
                output.append("<p>No image files found in img folder</p>");
            }
        } else {
            output.append("<p>Img folder not found at: ").append(imgPath).append("</p>");
        }
        
        // List current files in fashion directory
        File[] fashionFiles = fashionDir.listFiles();
        output.append("<h2>Current files in fashion directory</h2>");
        output.append("<p>Path: ").append(fashionPath).append("</p>");
        if (fashionFiles != null && fashionFiles.length > 0) {
            output.append("<ul>");
            for (File file : fashionFiles) {
                output.append("<li>").append(file.getName()).append(" (").append(file.length()).append(" bytes)</li>");
            }
            output.append("</ul>");
        } else {
            output.append("<p>No files in fashion directory</p>");
        }
        
        // Add instructions
        output.append("<h2>Instructions</h2>");
        output.append("<p>1. Copy your image files to webapp/img/ folder</p>");
        output.append("<p>2. Run this servlet again to copy them to fashion folder</p>");
        output.append("<p>3. Or manually copy images to: ").append(fashionPath).append("</p>");
        
        output.append("</body></html>");
        response.getWriter().write(output.toString());
    }
    
    // Custom FileFilter class instead of lambda
    private static class ImageFileFilter implements java.io.FileFilter {
        public boolean accept(File pathname) {
            String name = pathname.getName().toLowerCase();
            return name.endsWith(".jpg") || name.endsWith(".jpeg") || 
                   name.endsWith(".png") || name.endsWith(".gif");
        }
    }
    
    // Copy file method using streams
    private void copyFile(File source, File target) throws IOException {
        FileInputStream input = null;
        FileOutputStream output = null;
        try {
            input = new FileInputStream(source);
            output = new FileOutputStream(target);
            
            byte[] buffer = new byte[8192];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        } finally {
            if (input != null) {
                try { input.close(); } catch (IOException e) {}
            }
            if (output != null) {
                try { output.close(); } catch (IOException e) {}
            }
        }
    }
}