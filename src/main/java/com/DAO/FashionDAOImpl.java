package com.DAO;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.entity.FashionDtls;

public class FashionDAOImpl implements FashionDAO {

	private Connection conn;

	public FashionDAOImpl(Connection conn) {
		super();
		this.conn = conn;

	}


	public boolean addFashions(FashionDtls b) {
	    boolean f = false;
	    try {
	        String sql = "insert into fashion_dtls(fashionName, size, price, fashionCategory, status, photoName, email, priceBuy, quantity,des) values(?,?,?,?,?,?,?,?,?,?)";
	        PreparedStatement ps = conn.prepareStatement(sql);

	        ps.setString(1, b.getFashionName());
	        ps.setString(2, b.getSize());
	        ps.setString(3, b.getPrice());
	        ps.setString(4, b.getFashionCategory());
	        ps.setString(5, b.getStatus());
	        ps.setString(6, b.getPhotoName());
	        ps.setString(7, b.getEmail());

	        if ("Cũ".equals(b.getFashionCategory())) {
	            ps.setString(8, "0"); 
	        } else {
	            ps.setString(8, b.getPriceBuy());
	        }

	        ps.setInt(9, b.getQuantity());
	        ps.setString(10, b.getDescribe());
	        int i = ps.executeUpdate();
	        if (i == 1) {
	            f = true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return f;
	}


	public List<FashionDtls> getAllFashions() {
		List<FashionDtls> list = new ArrayList<FashionDtls>();
		FashionDtls b = null;

		try {
			String sql = "select * from fashion_dtls";
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public FashionDtls getFashionById(int id) {
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionId=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	public boolean updateEditFashions(FashionDtls b) {
        boolean f = false;
        try {
            // Lấy thông tin hiện tại của sản phẩm
            FashionDtls currentFashion = getFashionById(b.getFashionId());
           
            
            // Sửa lại thứ tự tham số để khớp với câu SQL
            String sql = "update fashion_dtls set fashionName=?, size=?, price=?, status=?, quantity=?, des=? where fashionId=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, b.getFashionName());
            ps.setString(2, b.getSize()); 
            ps.setString(3, b.getPrice());
            ps.setString(4, b.getStatus());
            ps.setInt(5, b.getQuantity());
            ps.setString(6, b.getDescribe()); // Set mô tả vào trường des
            ps.setInt(7, b.getFashionId());
            
            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
                System.out.println("Cập nhật thành công!");
            } else {
                System.out.println("Cập nhật thất bại, không có dòng nào bị ảnh hưởng.");
            }
        } catch (Exception e) {
            System.out.println("Lỗi trong updateEditFashions: " + e.getMessage());
            e.printStackTrace();
        }
        return f;
    }

	public boolean deleteFashions(int id) {
		boolean f = false;
		try {
			String sql = "delete from fashion_dtls where fashionId=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

	public List<FashionDtls> getNewFashion() {
		List<FashionDtls> list = new ArrayList<FashionDtls>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionCategory=? and status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Mới");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
				i++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<FashionDtls> getRecentFashions() {
		List<FashionDtls> list = new ArrayList<FashionDtls>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
				i++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public List<FashionDtls> getOldFashions() {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionCategory=? and status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Cũ");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();
			int i = 1;
			while (rs.next() && i <= 4) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
				i++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}


	public List<FashionDtls> getAllRecentFashion() {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Active");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<FashionDtls> getAllNewFashion() {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionCategory=? and status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Mới");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<FashionDtls> getAllOldFashion() {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionCategory=? and status=? order by fashionId DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "Cũ");
			ps.setString(2, "Active");
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<FashionDtls> getFashionByOld(String email, String cate) {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionCategory=? and email=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cate);
			ps.setString(2, email);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
	            b.setPriceBuy("0", "Cũ");
	            b.setQuantity(rs.getInt("quantity"));
	            b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public boolean oldFashionDelete(String email, String cat, int id) {
		boolean f = false;
		try {
			String sql = "delete from fashion_dtls where fashionCategory=? and email=? and fashionId=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, cat);
			ps.setString(2, email);
			ps.setInt(3, id);

			int i = ps.executeUpdate();
			if (i == 1) {
				f = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return f;
	}

	public List<FashionDtls> getFashionBySearch(String ch) {
		List<FashionDtls> list = new ArrayList<>();
		FashionDtls b = null;
		try {
			String sql = "select * from fashion_dtls where fashionName like ? or Size like ? or fashionCategory like ? and status=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "%" + ch + "%");
			ps.setString(2, "%" + ch + "%");
			ps.setString(3, "%" + ch + "%");
			ps.setString(4, "Active");

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<FashionDtls> getListByPage(ArrayList<FashionDtls> list, int start, int end){
		ArrayList<FashionDtls> arr = new ArrayList<>();
		for(int i=start; i<end; i++) {
			arr.add(list.get(i));
		}
		return arr;
	}
	
	public List<FashionDtls> getSortedFashion(String sortingOption, String category) {
        List<FashionDtls> list = new ArrayList<>();
        FashionDtls b = null;
        if(category.equals("recent"))
        {
            try {
                String sql = "";

                switch (sortingOption) {
                    case "a-z":
                        sql = "SELECT * FROM fashion_dtls ORDER BY fashionName";
                        break;
                    case "z-a":
                        sql = "SELECT * FROM fashion_dtls ORDER BY fashionName DESC";
                        break;
                    case "price-asc":
                        sql = "SELECT * FROM fashion_dtls ORDER BY CAST(price AS DECIMAL)";
                        break;
                    case "price-desc":
                        sql = "SELECT * FROM fashion_dtls ORDER BY CAST(price AS DECIMAL) DESC";
                        break;
                    default:
                        // default sorting (if sortingOption is not recognized)
                        sql = "SELECT * FROM fashion_dtls";
                        break;
                }

                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    b = new FashionDtls();
                    b.setFashionId(rs.getInt(1));
                    b.setFashionName(rs.getString(2));
                    b.setSize(rs.getString(3));
                    b.setPrice(rs.getString(4));
                    b.setFashionCategory(rs.getString(5));
                    b.setStatus(rs.getString(6));
                    b.setPhotoName(rs.getString(7));
                    b.setEmail(rs.getString(8));
                    b.setPriceBuy(rs.getString(9), b.getFashionCategory());
                    b.setQuantity(rs.getInt(10));
                    b.setDescribe(rs.getString(11));
                    list.add(b);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else if(category.equals("new"))
        {
            try {
                String sql = "";
                
                switch (sortingOption) {
                    case "a-z":
                        sql = "SELECT * FROM fashion_dtls where fashionCategory='Mới' ORDER BY fashionName";
                        
                        break;
                    case "z-a":
                        sql = "SELECT * FROM fashion_dtls where fashionCategory='Mới' ORDER BY fashionName DESC";
                        break;
                    case "price-asc":
                        sql = "SELECT * FROM fashion_dtls where fashionCategory='Mới' ORDER BY CAST(price AS DECIMAL)";
                        break;
                    case "price-desc":
                        sql = "SELECT * FROM fashion_dtls where fashionCategory='Mới' ORDER BY CAST(price AS DECIMAL) DESC";
                        break;
                    default:
                        // default sorting (if sortingOption is not recognized)
                        sql = "SELECT * FROM fashion_dtls where fashionCategory='Mới'";
                        break;
                }

                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    b = new FashionDtls();
                    b.setFashionId(rs.getInt(1));
                    b.setFashionName(rs.getString(2));
                    b.setSize(rs.getString(3));
                    b.setPrice(rs.getString(4));
                    b.setFashionCategory(rs.getString(5));
                    b.setStatus(rs.getString(6));
                    b.setPhotoName(rs.getString(7));
                    b.setEmail(rs.getString(8));
                    b.setPriceBuy(rs.getString(9), b.getFashionCategory());
                    b.setQuantity(rs.getInt(10));
                    b.setDescribe(rs.getString(11));
                    list.add(b);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else {
                try {
                    String sql = "";

                    switch (sortingOption) {
                        case "a-z":
                            sql = "SELECT * FROM fashion_dtls where fashionCategory='Cũ' ORDER BY fashionName";
                            break;
                        case "z-a":
                            sql = "SELECT * FROM fashion_dtls where fashionCategory='Cũ' ORDER BY fashionName DESC";
                            break;
                        case "price-asc":
                            sql = "SELECT * FROM fashion_dtls where fashionCategory='Cũ' ORDER BY CAST(price AS DECIMAL)";
                            break;
                        case "price-desc":
                            sql = "SELECT * FROM fashion_dtls where fashionCategory='Cũ' ORDER BY  CAST(price AS DECIMAL) DESC";
                            break;
                        default:
                            // default sorting (if sortingOption is not recognized)
                            sql = "SELECT * FROM fashion_dtls where fashionCategory='Cũ'";
                            break;
                    }

                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        b = new FashionDtls();
                        b.setFashionId(rs.getInt(1));
                        b.setFashionName(rs.getString(2));
                        b.setSize(rs.getString(3));
                        b.setPrice(rs.getString(4));
                        b.setFashionCategory(rs.getString(5));
                        b.setStatus(rs.getString(6));
                        b.setPhotoName(rs.getString(7));
                        b.setEmail(rs.getString(8));
                        b.setPriceBuy(rs.getString(9), b.getFashionCategory());
                        b.setQuantity(rs.getInt(10));
                        b.setDescribe(rs.getString(11));
                        list.add(b);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            }
        }
        return list;
	}
	
	public long getGiaNhap()
	{
		long res = 0;
		List<FashionDtls> list = new ArrayList<FashionDtls>();
		FashionDtls b = null;

		try {
			String sql = "select * from fashion_dtls";
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				String priceString = b.getPrice().replaceAll("[^0-9]", ""); // Remove non-numeric characters
			    long price = Long.parseLong(priceString);
			    res += price * b.getQuantity();
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}
     
	public List<FashionDtls> getFashionsExpired() {
		List<FashionDtls> list = new ArrayList<FashionDtls>();
		FashionDtls b = null;

		try {
			String sql = "select * from fashion_dtls where quantity = 0";
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				b = new FashionDtls();
				b.setFashionId(rs.getInt(1));
				b.setFashionName(rs.getString(2));
				b.setSize(rs.getString(3));
				b.setPrice(rs.getString(4));
				b.setFashionCategory(rs.getString(5));
				b.setStatus(rs.getString(6));
				b.setPhotoName(rs.getString(7));
				b.setEmail(rs.getString(8));
				b.setPriceBuy(rs.getString(9), b.getFashionCategory());
				b.setQuantity(rs.getInt(10));
				b.setDescribe(rs.getString(11));
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
    // Thêm phương thức kiểm tra số lượng trong kho
    public boolean checkStock(int fashionId, int requestedQuantity) {
        boolean hasStock = false;
        try {
            String sql = "SELECT quantity FROM fashion_dtls WHERE fashionId = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int availableQuantity = rs.getInt("quantity");
                hasStock = availableQuantity >= requestedQuantity;
                
                if (!hasStock) {
                    System.out.println("Số lượng trong kho không đủ. Sản phẩm ID " + fashionId + 
                                     " còn " + availableQuantity + " (yêu cầu: " + requestedQuantity + ")");
                }
            } else {
                System.out.println("Không tìm thấy sản phẩm với ID: " + fashionId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hasStock;
    }
    
    // Phương thức cập nhật số lượng an toàn (không cho phép số lượng âm)
    public boolean safeUpdateQuantity(int fashionId, int quantityToDecrease) {
        boolean success = false;
        try {
            // Bắt đầu transaction
            conn.setAutoCommit(false);
            
            // Kiểm tra số lượng trước khi cập nhật
            String checkSql = "SELECT quantity FROM fashion_dtls WHERE fashionId = ? FOR UPDATE";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, fashionId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                int currentQuantity = rs.getInt("quantity");
                
                // Chỉ cập nhật khi số lượng đủ
                if (currentQuantity >= quantityToDecrease) {
                    String updateSql = "UPDATE fashion_dtls SET quantity = quantity - ? WHERE fashionId = ?";
                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                    updatePs.setInt(1, quantityToDecrease);
                    updatePs.setInt(2, fashionId);
                    
                    int affectedRows = updatePs.executeUpdate();
                    success = affectedRows > 0;
                    
                    System.out.println("Đã cập nhật số lượng sản phẩm ID " + fashionId + 
                                     ". Số lượng mới: " + (currentQuantity - quantityToDecrease));
                } else {
                    // Nếu số lượng không đủ, đặt lại về 0 (không cho âm)
                    if (currentQuantity > 0) {
                        String updateSql = "UPDATE fashion_dtls SET quantity = 0 WHERE fashionId = ?";
                        PreparedStatement updatePs = conn.prepareStatement(updateSql);
                        updatePs.setInt(1, fashionId);
                        updatePs.executeUpdate();
                        
                        System.out.println("Cảnh báo: Số lượng yêu cầu vượt quá số lượng có sẵn. " +
                                         "Đã đặt số lượng sản phẩm ID " + fashionId + " về 0");
                        success = true; // Vẫn coi như thành công vì đã xử lý
                    }
                }
            } else {
                System.out.println("Không tìm thấy sản phẩm với ID: " + fashionId);
            }
            
            // Kết thúc transaction
            conn.commit();
            conn.setAutoCommit(true);
            
        } catch (Exception e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return success;
    }
    
    // Phương thức cập nhật số lượng theo tên sản phẩm (phương thức này có thể được sử dụng bởi FashionOrderDAOImpl)
    public boolean updateQuantityByName(String fashionName, int quantityToDecrease) {
        boolean success = false;
        try {
            // Tìm sản phẩm theo tên
            String findSql = "SELECT fashionId FROM fashion_dtls WHERE fashionName = ?";
            PreparedStatement findPs = conn.prepareStatement(findSql);
            findPs.setString(1, fashionName);
            ResultSet rs = findPs.executeQuery();
            
            if (rs.next()) {
                int fashionId = rs.getInt("fashionId");
                success = safeUpdateQuantity(fashionId, quantityToDecrease);
            } else {
                System.out.println("Không tìm thấy sản phẩm có tên: " + fashionName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
 // Add this method to your existing FashionDAOImpl.java class

    /**
     * Restore quantity to product inventory when order is cancelled
     * @param fashionName Name of the fashion product
     * @param quantityToRestore Amount to add back to inventory
     * @return true if successful, false otherwise
     */
    public boolean restoreQuantity(String fashionName, int quantityToRestore) {
        boolean success = false;
        
        if (quantityToRestore <= 0) {
            System.out.println("Invalid quantity to restore: " + quantityToRestore);
            return false;
        }
        
        try {
            // Start transaction
            conn.setAutoCommit(false);
            
            // First, check if the product exists
            String checkSql = "SELECT fashionId, quantity FROM fashion_dtls WHERE fashionName = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, fashionName);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                int fashionId = rs.getInt("fashionId");
                int currentQuantity = rs.getInt("quantity");
                int newQuantity = currentQuantity + quantityToRestore;
                
                // Update the quantity
                String updateSql = "UPDATE fashion_dtls SET quantity = ? WHERE fashionId = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newQuantity);
                updatePs.setInt(2, fashionId);
                
                int affectedRows = updatePs.executeUpdate();
                success = affectedRows > 0;
                
                if (success) {
                    System.out.println("Successfully restored " + quantityToRestore + 
                                     " units to " + fashionName + 
                                     ". New quantity: " + newQuantity);
                } else {
                    System.out.println("Failed to restore quantity for " + fashionName);
                }
            } else {
                System.out.println("Product not found: " + fashionName);
            }
            
            // Commit transaction
            if (success) {
                conn.commit();
            } else {
                conn.rollback();
            }
            conn.setAutoCommit(true);
            
        } catch (Exception e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            
            System.out.println("Error restoring quantity for " + fashionName + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    /**
     * Restore quantity by fashion ID (alternative method)
     * @param fashionId ID of the fashion product
     * @param quantityToRestore Amount to add back to inventory
     * @return true if successful, false otherwise
     */
    public boolean restoreQuantityById(int fashionId, int quantityToRestore) {
        boolean success = false;
        
        if (quantityToRestore <= 0) {
            System.out.println("Invalid quantity to restore: " + quantityToRestore);
            return false;
        }
        
        try {
            // Start transaction
            conn.setAutoCommit(false);
            
            // Get current quantity
            String checkSql = "SELECT quantity, fashionName FROM fashion_dtls WHERE fashionId = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, fashionId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                int currentQuantity = rs.getInt("quantity");
                String fashionName = rs.getString("fashionName");
                int newQuantity = currentQuantity + quantityToRestore;
                
                // Update the quantity
                String updateSql = "UPDATE fashion_dtls SET quantity = ? WHERE fashionId = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newQuantity);
                updatePs.setInt(2, fashionId);
                
                int affectedRows = updatePs.executeUpdate();
                success = affectedRows > 0;
                
                if (success) {
                    System.out.println("Successfully restored " + quantityToRestore + 
                                     " units to " + fashionName + " (ID: " + fashionId + 
                                     "). New quantity: " + newQuantity);
                } else {
                    System.out.println("Failed to restore quantity for fashion ID: " + fashionId);
                }
            } else {
                System.out.println("Product not found with ID: " + fashionId);
            }
            
            // Commit transaction
            if (success) {
                conn.commit();
            } else {
                conn.rollback();
            }
            conn.setAutoCommit(true);
            
        } catch (Exception e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            
            System.out.println("Error restoring quantity for fashion ID " + fashionId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }
}