package com.user.servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.DAO.FashionDAOImpl;
import com.DB.DBConnect;
import com.entity.FashionDtls;

@WebServlet("/advanced_search")
public class AdvancedSearchServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        try {
            if (req.getCharacterEncoding() == null) {
                req.setCharacterEncoding("UTF-8");
            }
            
            // Get search parameters
            String searchTerm = req.getParameter("q");
            String category = req.getParameter("category");
            String minPrice = req.getParameter("minPrice");
            String maxPrice = req.getParameter("maxPrice");
            String size = req.getParameter("size");
            String sortBy = req.getParameter("sortBy");
            
            // Pagination parameters
            int page = 1;
            int pageSize = 12;
            
            try {
                String pageParam = req.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
                
                String pageSizeParam = req.getParameter("pageSize");
                if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                    pageSize = Integer.parseInt(pageSizeParam);
                }
            } catch (NumberFormatException e) {
                page = 1;
                pageSize = 12;
            }
            
            FashionDAOImpl dao = new FashionDAOImpl(DBConnect.getConn());
            List<FashionDtls> searchResults;
            
            // Perform search based on available parameters
            if ((searchTerm != null && !searchTerm.trim().isEmpty()) ||
                (category != null && !category.trim().isEmpty() && !"all".equals(category)) ||
                (minPrice != null && !minPrice.trim().isEmpty()) ||
                (maxPrice != null && !maxPrice.trim().isEmpty()) ||
                (size != null && !size.trim().isEmpty() && !"all".equals(size))) {
                
                // Advanced search
                searchResults = dao.getFashionByAdvancedSearch(searchTerm, category, minPrice, maxPrice, size);
                
            } else {
                // Default: show all active products
                searchResults = dao.getAllRecentFashion();
            }
            
            // Apply sorting if specified
            if (sortBy != null && !sortBy.trim().isEmpty()) {
                searchResults = applySorting(searchResults, sortBy);
            }
            
            // Calculate pagination
            int totalResults = searchResults.size();
            int totalPages = (int) Math.ceil((double) totalResults / pageSize);
            
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, totalResults);
            
            List<FashionDtls> pageResults = dao.getListByPage(
                (java.util.ArrayList<FashionDtls>) searchResults, startIndex, endIndex);
            
            // Set request attributes for JSP
            req.setAttribute("searchResults", pageResults);
            req.setAttribute("totalResults", totalResults);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("pageSize", pageSize);
            req.setAttribute("startIndex", startIndex);
            req.setAttribute("endIndex", endIndex);
            
            // Preserve search parameters
            req.setAttribute("searchTerm", searchTerm);
            req.setAttribute("category", category);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("size", size);
            req.setAttribute("sortBy", sortBy);
            
            // Forward to search results page
            req.getRequestDispatcher("search_results.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = req.getSession();
            session.setAttribute("failedMsg", "Đã xảy ra lỗi khi tìm kiếm: " + e.getMessage());
            resp.sendRedirect("index.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        doGet(req, resp);
    }
    
    /**
     * Apply sorting to search results - Java 7 compatible
     */
    private List<FashionDtls> applySorting(List<FashionDtls> results, String sortBy) {
        if (results == null || results.isEmpty() || sortBy == null) {
            return results;
        }
        
        if ("name_asc".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    return a.getFashionName().compareToIgnoreCase(b.getFashionName());
                }
            });
        } else if ("name_desc".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    return b.getFashionName().compareToIgnoreCase(a.getFashionName());
                }
            });
        } else if ("price_asc".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    try {
                        double priceA = Double.parseDouble(a.getPrice().replaceAll("[^0-9.]", ""));
                        double priceB = Double.parseDouble(b.getPrice().replaceAll("[^0-9.]", ""));
                        return Double.compare(priceA, priceB);
                    } catch (Exception e) {
                        return 0;
                    }
                }
            });
        } else if ("price_desc".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    try {
                        double priceA = Double.parseDouble(a.getPrice().replaceAll("[^0-9.]", ""));
                        double priceB = Double.parseDouble(b.getPrice().replaceAll("[^0-9.]", ""));
                        return Double.compare(priceB, priceA);
                    } catch (Exception e) {
                        return 0;
                    }
                }
            });
        } else if ("newest".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    return Integer.compare(b.getFashionId(), a.getFashionId());
                }
            });
        } else if ("oldest".equals(sortBy.toLowerCase())) {
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    return Integer.compare(a.getFashionId(), b.getFashionId());
                }
            });
        } else {
            // Default: newest first
            Collections.sort(results, new Comparator<FashionDtls>() {
                @Override
                public int compare(FashionDtls a, FashionDtls b) {
                    return Integer.compare(b.getFashionId(), a.getFashionId());
                }
            });
        }
        
        return results;
    }
}