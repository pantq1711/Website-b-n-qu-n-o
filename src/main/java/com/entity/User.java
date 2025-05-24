
/**
 *
 * @author Anphan
 */
package com.entity;

public class User {

	private int id;

	private String name;
	private String email;
	private String password;
	private String phno;
	private String address;
	private String numhouse;
	private String city;
	private String province;
	public User() {
		super();
		// TODO Auto-generated constructor stub
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPhno() {
		return this.phno;
	}

	public void setPhno(String phno) {
		this.phno = phno;
	}

	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getCity() {
		return this.city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getNumhouse() {
		return numhouse;
	}

	public void setNumhouse(String state) {
		this.numhouse = state;
	}

	public String getProvince() {
		return this.province;
	}

	public void setProvince(String pincode) {
		this.province = pincode;
	}
	
	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", emaiil=" + email + ", password=" + password + ", phno=" + phno
				+ ", address=" + address + ", numhouse=" + numhouse + ", city=" + city + ", province=" + province
				;
	}

}
