package com.DAO;

import com.entity.FashionDtls;
import com.entity.Fashion_Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

public class FashionOrderDAOImpl implements FashionOrderDAO {

    private Connection conn;
    private boolean hasPaymentTypeColumn = false;
    private boolean hasPaymentColumn = false;

    public FashionOrderDAOImpl(Connection conn) {
        super();
        this.conn = conn;
        checkPaymentColumns();
    }
    
    // Kiểm tra các cột liên quan đến payment
    private void checkPaymentColumns() {
        try {
            List<String> columns = getTableColumns("fashion_order");
            hasPaymentTypeColumn = columns.contains("paymenttype");
            hasPaymentColumn = columns.contains("payment");
            
            System.out.println("Có cột paymentType: " + hasPaymentTypeColumn);
            System.out.println("Có cột payment: " + hasPaymentColumn);
        } catch (Exception e) {
            System.out.println("Lỗi khi kiểm tra cột payment: " + e.getMessage());
        }
    }
    
    public boolean updateFashionQuantity(String name, int quantity) {
    	 boolean success = false;

    	    try {
    	        String sql = "UPDATE fashion_dtls SET quantity = quantity - ? WHERE fashionName = ?";
    	        PreparedStatement ps = conn.prepareStatement(sql);
    	        ps.setInt(1, quantity);
    	        ps.setString(2, name);

    	        int rowsAffected = ps.executeUpdate();

    	        if (rowsAffected > 0) {
    	            success = true;
    	        }
    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return success;
    }

    @Override
    public boolean saveOrder(List<Fashion_Order> orderList) {
        boolean success = false;

        try {
            // Kiểm tra cấu trúc bảng trước khi thêm dữ liệu
            List<String> tableColumns = getTableColumns("fashion_order");
            System.out.println("Các cột trong bảng fashion_order: " + tableColumns);
            
            conn.setAutoCommit(false);

            // Xây dựng truy vấn SQL dựa trên các cột thực tế trong bảng
            StringBuilder columns = new StringBuilder();
            StringBuilder placeholders = new StringBuilder();
            
            // Thêm các cột cơ bản
            if (tableColumns.contains("order_id")) {
                addColumnAndPlaceholder("order_id", columns, placeholders);
            }
            
            if (tableColumns.contains("user_name")) {
                addColumnAndPlaceholder("user_name", columns, placeholders);
            } else if (tableColumns.contains("username")) {
                addColumnAndPlaceholder("username", columns, placeholders);
            }
            
            if (tableColumns.contains("fashionname")) {
                addColumnAndPlaceholder("fashionname", columns, placeholders);
            } else if (tableColumns.contains("fashionName")) {
                addColumnAndPlaceholder("fashionName", columns, placeholders);
            }
            
            if (tableColumns.contains("size")) {
                addColumnAndPlaceholder("size", columns, placeholders);
            }
            
            if (tableColumns.contains("price")) {
                addColumnAndPlaceholder("price", columns, placeholders);
            }
            
            if (tableColumns.contains("paymenttype")) {
                addColumnAndPlaceholder("paymenttype", columns, placeholders);
                hasPaymentTypeColumn = true;
            } else if (tableColumns.contains("payment")) {
                addColumnAndPlaceholder("payment", columns, placeholders);
                hasPaymentColumn = true;
            }
            
            if (tableColumns.contains("quantity")) {
                addColumnAndPlaceholder("quantity", columns, placeholders);
            }
            
            if (tableColumns.contains("date")) {
                addColumnAndPlaceholder("date", columns, placeholders);
            }
            
            // Thêm các cột phụ nếu có
            if (tableColumns.contains("email")) {
                addColumnAndPlaceholder("email", columns, placeholders);
            }
            
            if (tableColumns.contains("address")) {
                addColumnAndPlaceholder("address", columns, placeholders);
            }
            
            if (tableColumns.contains("phno")) {
                addColumnAndPlaceholder("phno", columns, placeholders);
            }
            
            // Xây dựng câu truy vấn SQL hoàn chỉnh
            String sql = "INSERT INTO fashion_order(" + columns.toString() + ") VALUES(" + placeholders.toString() + ")";
            System.out.println("SQL Query: " + sql);
            
            PreparedStatement ps = conn.prepareStatement(sql);

            for (Fashion_Order order : orderList) {
                int paramIndex = 1;
                
                // Thiết lập các tham số theo đúng thứ tự cột
                if (tableColumns.contains("order_id")) {
                    ps.setString(paramIndex++, order.getOrderId());
                }
                
                if (tableColumns.contains("user_name")) {
                    ps.setString(paramIndex++, order.getUserName());
                } else if (tableColumns.contains("username")) {
                    ps.setString(paramIndex++, order.getUserName());
                }
                
                if (tableColumns.contains("fashionname")) {
                    ps.setString(paramIndex++, order.getFashionName());
                } else if (tableColumns.contains("fashionName")) {
                    ps.setString(paramIndex++, order.getFashionName());
                }
                
                if (tableColumns.contains("size")) {
                    ps.setString(paramIndex++, order.getSize());
                }
                
                if (tableColumns.contains("price")) {
                    ps.setString(paramIndex++, order.getPrice());
                }
                
                if (tableColumns.contains("paymenttype")) {
                    ps.setString(paramIndex++, order.getPaymentType());
                } else if (tableColumns.contains("payment")) {
                    ps.setString(paramIndex++, order.getPaymentType());
                }
                
                if (tableColumns.contains("quantity")) {
                    ps.setInt(paramIndex++, order.getQuantity());
                }
                
                if (tableColumns.contains("date")) {
                    ps.setString(paramIndex++, order.getDate());
                }
                
                // Thiết lập các tham số cho cột phụ nếu có
                if (tableColumns.contains("email")) {
                    ps.setString(paramIndex++, order.getEmail());
                }
                
                if (tableColumns.contains("address")) {
                    ps.setString(paramIndex++, order.getFullAdd());
                }
                
                if (tableColumns.contains("phno")) {
                    ps.setString(paramIndex++, order.getPhno());
                }

                ps.addBatch();
            }

            int[] count = ps.executeBatch();
            conn.commit();
            success = true;
            conn.setAutoCommit(true);

        } catch (Exception e) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }

        return success;
    }
    
    // Phương thức hỗ trợ để thêm tên cột và placeholder vào câu truy vấn
    private void addColumnAndPlaceholder(String columnName, StringBuilder columns, StringBuilder placeholders) {
        if (columns.length() > 0) {
            columns.append(", ");
            placeholders.append(", ");
        }
        columns.append(columnName);
        placeholders.append("?");
    }
    
    // Phương thức để lấy danh sách các cột trong bảng
    private List<String> getTableColumns(String tableName) {
        List<String> columns = new ArrayList<>();
        try {
            ResultSet rs = conn.getMetaData().getColumns(null, null, tableName, null);
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME").toLowerCase();
                columns.add(columnName);
//                System.out.println("Cột tìm thấy: " + columnName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return columns;
    }

    @Override
    public List<Fashion_Order> getAllOrder() {
        List<Fashion_Order> list = new ArrayList<>();
        Fashion_Order o = null;

        try {
            String sql = "select * from fashion_order";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                o = new Fashion_Order();
                
                // Lấy các giá trị cơ bản theo vị trí cột
                o.setId(rs.getInt(1));
                
                try {
                    o.setOrderId(rs.getString("order_id"));
                } catch (SQLException e) {
                    System.out.println("Không tìm thấy cột order_id");
                }
                
                try {
                    o.setUserName(rs.getString("user_name"));
                } catch (SQLException e) {
                    try {
                        o.setUserName(rs.getString("username"));
                    } catch (SQLException e2) {
                        System.out.println("Không tìm thấy cột user_name hoặc username");
                    }
                }
                
                // Các cột phụ có thể không tồn tại
                try {
                    o.setEmail(rs.getString("email"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setFullAdd(rs.getString("address"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setPhno(rs.getString("phno"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setFashionName(rs.getString("fashionName"));
                } catch (SQLException e) {
                    try {
                        o.setFashionName(rs.getString("fashionname"));
                    } catch (SQLException e2) {
                        System.out.println("Không tìm thấy cột fashionName hoặc fashionname");
                    }
                }
                
                try {
                    o.setSize(rs.getString("size"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setPrice(rs.getString("price"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                // Xử lý đặc biệt cho paymentType
                if (hasPaymentTypeColumn) {
                    try {
                        o.setPaymentType(rs.getString("paymenttype"));
                    } catch (SQLException e) {
                        System.out.println("Lỗi khi lấy paymenttype: " + e.getMessage());
                        o.setPaymentType("COD"); // Giá trị mặc định
                    }
                } else if (hasPaymentColumn) {
                    try {
                        o.setPaymentType(rs.getString("payment"));
                    } catch (SQLException e) {
                        System.out.println("Lỗi khi lấy payment: " + e.getMessage());
                        o.setPaymentType("COD"); // Giá trị mặc định
                    }
                } else {
                    o.setPaymentType("COD"); // Giá trị mặc định nếu không có cột
                }
                
                try {
                    o.setQuantity(rs.getInt("quantity"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setDate(rs.getString("date"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Fashion_Order> getFashion(String email) {
        List<Fashion_Order> list = new ArrayList<>();
        
        // Kiểm tra xem bảng có cột email không
        List<String> tableColumns = getTableColumns("fashion_order");
        if (!tableColumns.contains("email")) {
            System.out.println("Cột email không tồn tại trong bảng fashion_order");
            return list; // Trả về danh sách trống nếu không có cột email
        }
        
        try {
            String sql = "select * from fashion_order where email=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Fashion_Order o = new Fashion_Order();
                
                // Lấy các giá trị cơ bản theo vị trí cột
                o.setId(rs.getInt(1));
                
                try {
                    o.setOrderId(rs.getString("order_id"));
                } catch (SQLException e) {
//                    System.out.println("Không tìm thấy cột order_id");
                }
                
                try {
                    o.setUserName(rs.getString("user_name"));
                } catch (SQLException e) {
                    try {
                        o.setUserName(rs.getString("username"));
                    } catch (SQLException e2) {
//                        System.out.println("Không tìm thấy cột user_name hoặc username");
                    }
                }
                
                o.setEmail(email);
                
                // Các cột phụ có thể không tồn tại
                try {
                    o.setFullAdd(rs.getString("address"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setPhno(rs.getString("phno"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setFashionName(rs.getString("fashionName"));
                } catch (SQLException e) {
                    try {
                        o.setFashionName(rs.getString("fashionname"));
                    } catch (SQLException e2) {
                        System.out.println("Không tìm thấy cột fashionName hoặc fashionname");
                    }
                }
                
                try {
                    o.setSize(rs.getString("size"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setPrice(rs.getString("price"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                // Xử lý đặc biệt cho paymentType
                if (hasPaymentTypeColumn) {
                    try {
                        o.setPaymentType(rs.getString("paymenttype"));
                    } catch (SQLException e) {
                        o.setPaymentType("COD"); // Giá trị mặc định
                    }
                } else if (hasPaymentColumn) {
                    try {
                        o.setPaymentType(rs.getString("payment"));
                    } catch (SQLException e) {
                        o.setPaymentType("COD"); // Giá trị mặc định
                    }
                } else {
                    o.setPaymentType("COD"); // Giá trị mặc định nếu không có cột
                }
                
                try {
                    o.setQuantity(rs.getInt("quantity"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                try {
                    o.setDate(rs.getString("date"));
                } catch (SQLException e) {
                    // Bỏ qua nếu cột không tồn tại
                }
                
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Fashion_Order> getFashion() {
        return getAllOrder(); // Sử dụng lại phương thức getAllOrder
    }
    
    public HashMap<String, String> getTop5FashionOrder() {
    	HashMap <String, String> map = new LinkedHashMap<>();
		try {
			String sql = "SELECT fashionName, SUM(quantity) AS totalQuantity FROM fashion_order GROUP BY fashionName ORDER BY totalQuantity DESC LIMIT 5;";
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				if(!map.containsKey(rs.getString(1))) {
				    map.put(rs.getString(1), rs.getString(2));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	public HashMap<String, String> getTop5User() {
		HashMap <String, String> map = new LinkedHashMap<>();
		try {
		    // Kiểm tra cấu trúc bảng trước khi truy vấn
            List<String> tableColumns = getTableColumns("fashion_order");
            
            String userNameColumn = tableColumns.contains("user_name") ? "user_name" : 
                                   (tableColumns.contains("username") ? "username" : null);
            
            // Kiểm tra xem bảng có cột user_name/username không
            if (userNameColumn == null) {
                System.out.println("Cột user_name/username không tồn tại trong bảng fashion_order");
                return map; // Trả về map trống nếu không có cột user_name/username
            }
            
            // Điều chỉnh truy vấn SQL dựa trên cấu trúc bảng thực tế
            String sql = "SELECT fo." + userNameColumn + ", SUM(fd.price * fo.quantity) AS totalValue " +
                         "FROM fashion_order fo JOIN fashion_dtls fd ON fo.fashionName = fd.fashionName " +
                         "GROUP BY fo." + userNameColumn + " ORDER BY totalValue DESC LIMIT 5;";
                         
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				if(!map.containsKey(rs.getString(1))) {
				    map.put(rs.getString(1), rs.getString(2));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}
	
	public long getDoanhThu() {
		long res = 0;
		List<Fashion_Order> list = getAllOrder();
			
		for(Fashion_Order f : list) {
			try {
    			String priceString = f.getPrice().replaceAll("[^0-9]", ""); // Remove non-numeric characters
    		    long price = Long.parseLong(priceString);
    		    res += price * f.getQuantity();
			} catch (NumberFormatException e) {
			    System.out.println("Lỗi khi xử lý giá: " + f.getPrice());
			}
		}
        return res;
	}
	
	// Phương thức kiểm tra và hiển thị cấu trúc bảng fashion_order
    public void checkTableStructure() {
        try {
            ResultSet columns = conn.getMetaData().getColumns(null, null, "fashion_order", null);
            System.out.println("Cấu trúc bảng fashion_order:");
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int size = columns.getInt("COLUMN_SIZE");
                System.out.println(columnName + " - " + dataType + "(" + size + ")");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Phương thức để thêm cột vào bảng fashion_order
    public boolean addPaymentTypeColumn() {
        boolean success = false;
        try {
            // Kiểm tra xem cột đã tồn tại chưa
            List<String> columns = getTableColumns("fashion_order");
            if (columns.contains("paymenttype") || columns.contains("payment")) {
                System.out.println("Cột payment/paymentType đã tồn tại");
                return true;
            }
            
            // Thêm cột mới
            String sql = "ALTER TABLE fashion_order ADD COLUMN payment VARCHAR(45) AFTER price";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate();
            
            // Cập nhật cột với giá trị mặc định
            sql = "UPDATE fashion_order SET payment = 'COD'";
            ps = conn.prepareStatement(sql);
            ps.executeUpdate();
            
//            System.out.println("Đã thêm cột payment và cập nhật giá trị mặc định");
            success = true;
            
            // Cập nhật lại trạng thái
            hasPaymentColumn = true;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
 // Add these methods to your existing FashionOrderDAOImpl.java class

    /**
     * Get all orders by order ID
     * @param orderId The order ID to search for
     * @return List of Fashion_Order objects with the same order ID
     */
    public List<Fashion_Order> getOrdersByOrderId(String orderId) {
        List<Fashion_Order> list = new ArrayList<>();
        
        try {
            // Check if order_id column exists
            List<String> tableColumns = getTableColumns("fashion_order");
            
            String sql;
            if (tableColumns.contains("order_id")) {
                sql = "SELECT * FROM fashion_order WHERE order_id = ?";
            } else {
                // Fallback: search by a pattern in other fields or use ID
                sql = "SELECT * FROM fashion_order WHERE id = ?";
            }
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Fashion_Order o = new Fashion_Order();
                
                // Set basic information
                o.setId(rs.getInt(1));
                
                try {
                    o.setOrderId(rs.getString("order_id"));
                } catch (SQLException e) {
                    o.setOrderId(orderId); // Set the searched order ID
                }
                
                // Set user information
                try {
                    o.setUserName(rs.getString("user_name"));
                } catch (SQLException e) {
                    try {
                        o.setUserName(rs.getString("username"));
                    } catch (SQLException e2) {
                        o.setUserName("Unknown");
                    }
                }
                
                // Set optional columns
                try {
                    o.setEmail(rs.getString("email"));
                } catch (SQLException e) {
                    // Column doesn't exist, skip
                }
                
                try {
                    o.setFullAdd(rs.getString("address"));
                } catch (SQLException e) {
                    // Column doesn't exist, skip
                }
                
                try {
                    o.setPhno(rs.getString("phno"));
                } catch (SQLException e) {
                    // Column doesn't exist, skip
                }
                
                // Set product information
                try {
                    o.setFashionName(rs.getString("fashionName"));
                } catch (SQLException e) {
                    try {
                        o.setFashionName(rs.getString("fashionname"));
                    } catch (SQLException e2) {
                        o.setFashionName("Unknown Product");
                    }
                }
                
                try {
                    o.setSize(rs.getString("size"));
                } catch (SQLException e) {
                    o.setSize("N/A");
                }
                
                try {
                    o.setPrice(rs.getString("price"));
                } catch (SQLException e) {
                    o.setPrice("0");
                }
                
                // Set payment type
                if (hasPaymentTypeColumn) {
                    try {
                        o.setPaymentType(rs.getString("paymenttype"));
                    } catch (SQLException e) {
                        o.setPaymentType("COD");
                    }
                } else if (hasPaymentColumn) {
                    try {
                        o.setPaymentType(rs.getString("payment"));
                    } catch (SQLException e) {
                        o.setPaymentType("COD");
                    }
                } else {
                    o.setPaymentType("COD");
                }
                
                try {
                    o.setQuantity(rs.getInt("quantity"));
                } catch (SQLException e) {
                    o.setQuantity(1);
                }
                
                try {
                    o.setDate(rs.getString("date"));
                } catch (SQLException e) {
                    o.setDate("N/A");
                }
                
                list.add(o);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }

    /**
     * Cancel an order by order ID
     * @param orderId The order ID to cancel
     * @return true if successful, false otherwise
     */
    public boolean cancelOrder(String orderId) {
        boolean success = false;
        
        try {
            // Check if order_id column exists
            List<String> tableColumns = getTableColumns("fashion_order");
            
            String sql;
            if (tableColumns.contains("order_id")) {
                sql = "DELETE FROM fashion_order WHERE order_id = ?";
            } else {
                // Fallback: delete by ID (this assumes orderId is actually the primary key ID)
                try {
                    int id = Integer.parseInt(orderId.replaceAll("\\D+", "")); // Extract numbers from order ID
                    sql = "DELETE FROM fashion_order WHERE id = ?";
                } catch (NumberFormatException e) {
                    System.out.println("Cannot parse order ID for deletion: " + orderId);
                    return false;
                }
            }
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, orderId);
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
            
            if (success) {
                System.out.println("Successfully cancelled order: " + orderId + " (" + rowsAffected + " rows affected)");
            } else {
                System.out.println("No rows affected when trying to cancel order: " + orderId);
            }
            
        } catch (Exception e) {
            System.out.println("Error cancelling order " + orderId + ": " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

   
}