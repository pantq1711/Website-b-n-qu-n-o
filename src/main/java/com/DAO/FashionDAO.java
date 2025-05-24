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

    public List<FashionDtls> getFashionBySearch(String ch);
    
    public List<FashionDtls> getListByPage(ArrayList<FashionDtls> list, int start, int end);
    
    public List<FashionDtls> getSortedFashion(String sortingOption, String category);
    public List<FashionDtls> getFashionsExpired();

}
