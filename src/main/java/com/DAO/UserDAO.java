package com.DAO;

import com.entity.User;

public interface UserDAO {

    public boolean userRegister(User us);

    public User login(String email, String password);

    public boolean checkPassword(int id, String ps);

    public boolean updateProfile(User us);
    
    public boolean updateAddress(User us);

    public boolean checkUser(String em);
    
    // Thêm method getUserById
    public User getUserById(int id);
   
}