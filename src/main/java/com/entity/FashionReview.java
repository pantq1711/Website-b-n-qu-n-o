package com.entity;

import java.sql.Timestamp;

public class FashionReview {
    private int reviewId;
    private int fashionId;
    private int userId;
    private String orderId;
    private int rating;
    private String reviewTitle;
    private String reviewContent;
    private Timestamp reviewDate;
    private boolean verifiedPurchase;
    private int helpfulCount;
    
    // Thông tin bổ sung từ join với các bảng khác
    private String userName;
    private String fashionName;
    private String userEmail;
    
    // Constructors
    public FashionReview() {
        super();
    }
    
    public FashionReview(int fashionId, int userId, String orderId, int rating, 
                        String reviewTitle, String reviewContent) {
        this.fashionId = fashionId;
        this.userId = userId;
        this.orderId = orderId;
        this.rating = rating;
        this.reviewTitle = reviewTitle;
        this.reviewContent = reviewContent;
        this.verifiedPurchase = true;
        this.helpfulCount = 0;
    }
    
    // Getters and Setters
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public int getFashionId() {
        return fashionId;
    }
    
    public void setFashionId(int fashionId) {
        this.fashionId = fashionId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getReviewTitle() {
        return reviewTitle;
    }
    
    public void setReviewTitle(String reviewTitle) {
        this.reviewTitle = reviewTitle;
    }
    
    public String getReviewContent() {
        return reviewContent;
    }
    
    public void setReviewContent(String reviewContent) {
        this.reviewContent = reviewContent;
    }
    
    public Timestamp getReviewDate() {
        return reviewDate;
    }
    
    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }
    
    public boolean isVerifiedPurchase() {
        return verifiedPurchase;
    }
    
    public void setVerifiedPurchase(boolean verifiedPurchase) {
        this.verifiedPurchase = verifiedPurchase;
    }
    
    public int getHelpfulCount() {
        return helpfulCount;
    }
    
    public void setHelpfulCount(int helpfulCount) {
        this.helpfulCount = helpfulCount;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getFashionName() {
        return fashionName;
    }
    
    public void setFashionName(String fashionName) {
        this.fashionName = fashionName;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    // Utility methods
    public String getStarRating() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public String getShortReviewContent(int maxLength) {
        if (reviewContent == null) return "";
        if (reviewContent.length() <= maxLength) {
            return reviewContent;
        }
        return reviewContent.substring(0, maxLength) + "...";
    }
    
    @Override
    public String toString() {
        return "FashionReview [reviewId=" + reviewId + ", fashionId=" + fashionId + 
               ", userId=" + userId + ", rating=" + rating + ", reviewTitle=" + reviewTitle + "]";
    }
}