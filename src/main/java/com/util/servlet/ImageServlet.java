package com.util.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ImageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String requestedImage = request.getPathInfo();
        System.out.println("ImageServlet: Requested path: " + requestedImage);
        
        if (requestedImage == null || requestedImage.equals("/")) {
            System.out.println("ImageServlet: No image requested");
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Remove leading slash
        if (requestedImage.startsWith("/")) {
            requestedImage = requestedImage.substring(1);
        }
        
        System.out.println("ImageServlet: Looking for image: " + requestedImage);
        
        // Try multiple locations for the image
        File imageFile = null;
        String[] possiblePaths = {
            getServletContext().getRealPath("/fashion/" + requestedImage),
            getServletContext().getRealPath("/fashion") + File.separator + requestedImage,
            getServletContext().getRealPath("/") + "fashion" + File.separator + requestedImage,
            System.getProperty("user.home") + File.separator + "fashion_uploads" + File.separator + requestedImage
        };
        
        for (String path : possiblePaths) {
            System.out.println("ImageServlet: Trying path: " + path);
            File testFile = new File(path);
            if (testFile.exists() && testFile.isFile()) {
                imageFile = testFile;
                System.out.println("ImageServlet: Found image at: " + path);
                break;
            }
        }
        
        if (imageFile == null || !imageFile.exists()) {
            System.out.println("ImageServlet: Image not found: " + requestedImage);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // Set content type based on file extension
        String contentType = getContentType(imageFile.getName());
        response.setContentType(contentType);
        response.setContentLength((int) imageFile.length());
        
        // Add cache headers
        response.setHeader("Cache-Control", "public, max-age=3600");
        
        System.out.println("ImageServlet: Serving image: " + imageFile.getAbsolutePath() + 
                          " (" + imageFile.length() + " bytes)");
        
        // Copy file to response
        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            long totalBytes = 0;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
                totalBytes += bytesRead;
            }
            System.out.println("ImageServlet: Sent " + totalBytes + " bytes");
        } catch (Exception e) {
            System.out.println("ImageServlet: Error serving image: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private String getContentType(String fileName) {
        String extension = "";
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot > 0) {
            extension = fileName.substring(lastDot + 1).toLowerCase();
        }
        
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "bmp":
                return "image/bmp";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}