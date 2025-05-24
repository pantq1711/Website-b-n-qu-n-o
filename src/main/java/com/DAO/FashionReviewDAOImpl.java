// Implementation
package com.DAO;
import com.entity.*;
import java.sql.*;
import java.util.*;

public class FashionReviewDAOImpl implements FashionReviewDAO {
    
    private Connection conn;
    
    public FashionReviewDAOImpl(Connection conn) {
        this.conn = conn;
    }
    
    @Override
    public boolean addReview(FashionReview review) {
        boolean success = false;
        try {
            conn.setAutoCommit(false);
            
            String sql = "INSERT INTO fashion_reviews (fashion_id, user_id, order_id, rating, " +
                        "review_title, review_content, is_verified_purchase) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, review.getFashionId());
            ps.setInt(2, review.getUserId());
            ps.setString(3, review.getOrderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getReviewTitle());
            ps.setString(6, review.getReviewContent());
            ps.setBoolean(7, review.isVerifiedPurchase());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Cập nhật điểm trung bình cho sản phẩm
                updateProductRating(review.getFashionId());
                success = true;
            }
            
            conn.commit();
            conn.setAutoCommit(true);
        } catch (Exception e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return success;
    }
    
    @Override
    public boolean hasUserPurchasedProduct(int userId, int fashionId) {
        boolean hasPurchased = false;
        try {
            // Kiểm tra trong bảng fashion_order
            String sql = "SELECT COUNT(*) FROM fashion_order fo " +
                        "JOIN fashion_dtls fd ON fo.fashionName = fd.fashionName " +
                        "WHERE fo.user_name = (SELECT name FROM user WHERE id = ?) " +
                        "AND fd.fashionId = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, fashionId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                hasPurchased = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hasPurchased;
    }
    
    @Override
    public boolean hasUserReviewedProduct(int userId, int fashionId, String orderId) {
        boolean hasReviewed = false;
        try {
            String sql = "SELECT COUNT(*) FROM fashion_reviews WHERE user_id = ? AND fashion_id = ? AND order_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, fashionId);
            ps.setString(3, orderId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                hasReviewed = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hasReviewed;
    }
    
    @Override
    public List<FashionReview> getReviewsByFashionId(int fashionId) {
        return getReviewsByFashionId(fashionId, 1, 50); // Default: page 1, 50 reviews
    }
    
    @Override
    public List<FashionReview> getReviewsByFashionId(int fashionId, int page, int pageSize) {
        List<FashionReview> reviews = new ArrayList<>();
        try {
            int offset = (page - 1) * pageSize;
            
            String sql = "SELECT fr.*, u.name as user_name, u.email as user_email " +
                        "FROM fashion_reviews fr " +
                        "JOIN user u ON fr.user_id = u.id " +
                        "WHERE fr.fashion_id = ? " +
                        "ORDER BY fr.review_date DESC " +
                        "LIMIT ? OFFSET ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FashionReview review = new FashionReview();
                review.setReviewId(rs.getInt("review_id"));
                review.setFashionId(rs.getInt("fashion_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setOrderId(rs.getString("order_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewTitle(rs.getString("review_title"));
                review.setReviewContent(rs.getString("review_content"));
                review.setReviewDate(rs.getTimestamp("review_date"));
                review.setVerifiedPurchase(rs.getBoolean("is_verified_purchase"));
                review.setHelpfulCount(rs.getInt("helpful_count"));
                review.setUserName(rs.getString("user_name"));
                review.setUserEmail(rs.getString("user_email"));
                
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    @Override
    public List<FashionReview> getReviewsByUserId(int userId) {
        List<FashionReview> reviews = new ArrayList<>();
        try {
            String sql = "SELECT fr.*, fd.fashionName " +
                        "FROM fashion_reviews fr " +
                        "JOIN fashion_dtls fd ON fr.fashion_id = fd.fashionId " +
                        "WHERE fr.user_id = ? " +
                        "ORDER BY fr.review_date DESC";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FashionReview review = new FashionReview();
                review.setReviewId(rs.getInt("review_id"));
                review.setFashionId(rs.getInt("fashion_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setOrderId(rs.getString("order_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewTitle(rs.getString("review_title"));
                review.setReviewContent(rs.getString("review_content"));
                review.setReviewDate(rs.getTimestamp("review_date"));
                review.setVerifiedPurchase(rs.getBoolean("is_verified_purchase"));
                review.setHelpfulCount(rs.getInt("helpful_count"));
                review.setFashionName(rs.getString("fashionName"));
                
                reviews.add(review);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    @Override
    public Map<String, Object> getReviewStatistics(int fashionId) {
        Map<String, Object> stats = new HashMap<>();
        try {
            String sql = "SELECT " +
                        "COUNT(*) as total_reviews, " +
                        "AVG(rating) as average_rating, " +
                        "SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as five_star, " +
                        "SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as four_star, " +
                        "SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as three_star, " +
                        "SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as two_star, " +
                        "SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as one_star " +
                        "FROM fashion_reviews WHERE fashion_id = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalReviews", rs.getInt("total_reviews"));
                stats.put("averageRating", rs.getDouble("average_rating"));
                stats.put("fiveStar", rs.getInt("five_star"));
                stats.put("fourStar", rs.getInt("four_star"));
                stats.put("threeStar", rs.getInt("three_star"));
                stats.put("twoStar", rs.getInt("two_star"));
                stats.put("oneStar", rs.getInt("one_star"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    @Override
    public boolean updateHelpfulCount(int reviewId, int increment) {
        boolean success = false;
        try {
            String sql = "UPDATE fashion_reviews SET helpful_count = helpful_count + ? WHERE review_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, increment);
            ps.setInt(2, reviewId);
            
            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
    
    @Override
    public boolean updateProductRating(int fashionId) {
        boolean success = false;
        try {
            String sql = "UPDATE fashion_dtls SET " +
                        "average_rating = (SELECT AVG(rating) FROM fashion_reviews WHERE fashion_id = ?), " +
                        "total_reviews = (SELECT COUNT(*) FROM fashion_reviews WHERE fashion_id = ?) " +
                        "WHERE fashionId = ?";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ps.setInt(2, fashionId);
            ps.setInt(3, fashionId);
            
            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
    
    @Override
    public boolean deleteReview(int reviewId, int userId) {
        boolean success = false;
        try {
            conn.setAutoCommit(false);
            
            // Lấy thông tin fashionId trước khi xóa
            String getFashionIdSql = "SELECT fashion_id FROM fashion_reviews WHERE review_id = ? AND user_id = ?";
            PreparedStatement getPs = conn.prepareStatement(getFashionIdSql);
            getPs.setInt(1, reviewId);
            getPs.setInt(2, userId);
            
            ResultSet rs = getPs.executeQuery();
            int fashionId = 0;
            if (rs.next()) {
                fashionId = rs.getInt("fashion_id");
            }
            
            if (fashionId > 0) {
                String deleteSql = "DELETE FROM fashion_reviews WHERE review_id = ? AND user_id = ?";
                PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                deletePs.setInt(1, reviewId);
                deletePs.setInt(2, userId);
                
                int deleted = deletePs.executeUpdate();
                if (deleted > 0) {
                    // Cập nhật lại điểm trung bình
                    updateProductRating(fashionId);
                    success = true;
                }
            }
            
            conn.commit();
            conn.setAutoCommit(true);
        } catch (Exception e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return success;
    }
    
    @Override
    public List<Map<String, Object>> getReviewableOrders(int userId) {
        List<Map<String, Object>> orders = new ArrayList<>();
        try {
            String sql = "SELECT fo.order_id, fo.fashionName, fd.fashionId, fo.date, " +
                        "CASE WHEN fr.review_id IS NULL THEN 0 ELSE 1 END as has_review " +
                        "FROM fashion_order fo " +
                        "JOIN fashion_dtls fd ON fo.fashionName = fd.fashionName " +
                        "LEFT JOIN fashion_reviews fr ON fr.fashion_id = fd.fashionId " +
                        "   AND fr.user_id = ? AND fr.order_id = fo.order_id " +
                        "WHERE fo.user_name = (SELECT name FROM user WHERE id = ?) " +
                        "ORDER BY fo.date DESC";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("orderId", rs.getString("order_id"));
                order.put("fashionName", rs.getString("fashionName"));
                order.put("fashionId", rs.getInt("fashionId"));
                order.put("orderDate", rs.getString("date"));
                order.put("hasReview", rs.getInt("has_review") == 1);
                
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }
}