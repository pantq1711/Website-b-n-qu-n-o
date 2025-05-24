
/**
 *
 * @author Anphan
 */
package com.entity;

public class Cart {
	private int cid;
	private int fid;
	private int userId;
	private String fashionName;
	private String size;
	private String price;
	private String totalPrice;
	private String paymentType;
	private int quantity;
	
	public int getCid() {
		return cid;
	}

	public void setCid(int cid) {
		this.cid = cid;
	}
	
	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int cid) {
		this.quantity = cid;
	}

	public int getFid() {
		return fid;
	}

	public void setFid(int fid) {
		this.fid = fid;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
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

	public String getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(String totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

}