package com.entity;

public class Fashion_Order {
    private int id;
    private String orderId;
    private String userName; // Tên người dùng - cần khớp với tên cột trong DB
    private String email;
    private String fullAdd; // Địa chỉ đầy đủ
    private String phno;    // Số điện thoại
    private String fashionName;
    private String size;
    private String price;
    private String paymentType;
    private int quantity;
    private String date;
    
    public Fashion_Order() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullAdd() {
        return fullAdd;
    }

    public void setFullAdd(String fullAdd) {
        this.fullAdd = fullAdd;
    }

    public String getPhno() {
        return phno;
    }

    public void setPhno(String phno) {
        this.phno = phno;
    }

    public String getFashionName() {
        return fashionName;
    }

    public void setFashionName(String fashionName) {
        this.fashionName = fashionName;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "Fashion_Order [id=" + id + ", orderId=" + orderId + ", userName=" + userName + ", email=" + email
                + ", fullAdd=" + fullAdd + ", phno=" + phno + ", fashionName=" + fashionName + ", size=" + size
                + ", price=" + price + ", paymentType=" + paymentType + ", quantity=" + quantity + ", date=" + date
                + "]";
    }
}