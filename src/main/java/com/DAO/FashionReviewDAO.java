package com.DAO;

import com.entity.FashionReview;
import java.util.List;
import java.util.Map;

public interface FashionReviewDAO {
    
    // Thêm đánh giá mới
    public boolean addReview(FashionReview review);
    
    // Kiểm tra người dùng đã mua sản phẩm chưa
    public boolean hasUserPurchasedProduct(int userId, int fashionId);
    
    // Kiểm tra người dùng đã đánh giá sản phẩm chưa
    public boolean hasUserReviewedProduct(int userId, int fashionId, String orderId);
    
    // Lấy tất cả đánh giá của một sản phẩm
    public List<FashionReview> getReviewsByFashionId(int fashionId);
    
    // Lấy đánh giá có phân trang
    public List<FashionReview> getReviewsByFashionId(int fashionId, int page, int pageSize);
    
    // Lấy đánh giá của một người dùng
    public List<FashionReview> getReviewsByUserId(int userId);
    
    // Lấy thống kê đánh giá của sản phẩm
    public Map<String, Object> getReviewStatistics(int fashionId);
    
    // Cập nhật helpful count
    public boolean updateHelpfulCount(int reviewId, int increment);
    
    // Cập nhật điểm trung bình cho sản phẩm
    public boolean updateProductRating(int fashionId);
    
    // Xóa đánh giá
    public boolean deleteReview(int reviewId, int userId);
    
    // Lấy các đơn hàng mà người dùng có thể đánh giá
    public List<Map<String, Object>> getReviewableOrders(int userId);
}
