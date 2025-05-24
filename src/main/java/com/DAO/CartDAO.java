package com.DAO;

import java.util.List;
import com.entity.Cart;

public interface CartDAO {

    public boolean addCart(Cart c);

    public List<Cart> getFashionByUser(int userId);

    public boolean deleteFashion(int fid, int uid, int cid);

    public boolean updateQuantityToCart(int quantity, int uid, int fid, int cid);

    public boolean addQuantityToCart(int fid, int cid);

    public boolean subQuantityToCart(int fid, int cid);
    
    // Phương thức mới để thêm số lượng tùy ý
    public boolean addQuantityToCartByAmount(int fid, int cid, int amount);
    
    // Phương thức kiểm tra tồn kho
    public boolean checkProductAvailability(int fashionId, int requestedQuantity);
    
    // Phương thức lấy số lượng sản phẩm trong giỏ hàng
    public int getCartItemQuantity(int fashionId, int userId);
}