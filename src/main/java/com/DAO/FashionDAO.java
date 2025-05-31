package com.DAO;

import java.util.ArrayList;
import java.util.List;

import com.entity.FashionDtls;

public interface FashionDAO {

    public boolean addFashions(FashionDtls b);

    public List<FashionDtls> getAllFashions();

    public FashionDtls getFashionById(int id);

    public boolean updateEditFashions(FashionDtls b);

    public boolean deleteFashions(int id);

    public List<FashionDtls> getNewFashion();

    public List<FashionDtls> getRecentFashions();

    public List<FashionDtls> getOldFashions();

    public List<FashionDtls> getAllRecentFashion();

    public List<FashionDtls> getAllNewFashion();

    public List<FashionDtls> getAllOldFashion();

    public List<FashionDtls> getFashionByOld(String email, String cate);

    public boolean oldFashionDelete(String email, String cat, int id);

    // Enhanced search methods
    public List<FashionDtls> getFashionBySearch(String searchTerm);
    
    public List<FashionDtls> getFashionByAdvancedSearch(String searchTerm, String category, 
                                                       String minPrice, String maxPrice, String size);
    
    public List<FashionDtls> getFashionByCategory(String category);
    
    public List<FashionDtls> getFashionByPriceRange(String minPrice, String maxPrice);
    
    public List<FashionDtls> getFashionBySize(String size);
    
    public List<FashionDtls> getListByPage(ArrayList<FashionDtls> list, int start, int end);
    
    public List<FashionDtls> getSortedFashion(String sortingOption, String category);
    
    public List<FashionDtls> getFashionsExpired();
    
    // New methods for delete validation
    public boolean hasPendingOrders(int fashionId);
    
    public int getPendingOrderCount(int fashionId);
    
    public List<String> getPendingOrderIds(int fashionId);
    
    // Safe delete method
    public boolean safeDeleteFashion(int fashionId);
}