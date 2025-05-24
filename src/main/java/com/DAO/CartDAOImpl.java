package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.entity.Cart;
import com.entity.FashionDtls;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {

    private Connection conn;

    public CartDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // Phương thức mới: Kiểm tra số lượng sản phẩm trước khi thêm vào giỏ hàng
    public boolean checkProductAvailability(int fashionId, int requestedQuantity) {
        try {
            // Lấy số lượng hiện có trong kho
            String sql = "SELECT quantity FROM fashion_dtls WHERE fashionId = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int availableQuantity = rs.getInt("quantity");
                return availableQuantity >= requestedQuantity;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra số lượng sản phẩm trong kho: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    public int getCartItemQuantity(int fashionId, int userId) {
        int quantity = 0;
        try {
            String sql = "SELECT COALESCE(SUM(quantity), 0) as total_quantity FROM cart WHERE fid = ? AND uid = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fashionId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                quantity = rs.getInt("total_quantity");
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy số lượng sản phẩm trong giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return quantity;
    }

    @Override
    public boolean addCart(Cart c) {
        boolean f = false;
        try {
            // Kiểm tra sản phẩm đã tồn tại trong giỏ hàng chưa
            String checkSql = "SELECT * FROM cart WHERE fid=? AND uid=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, c.getFid());
            checkPs.setInt(2, c.getUserId());
            ResultSet rs = checkPs.executeQuery();
            
            // Kiểm tra số lượng trong kho
            FashionDAOImpl fashionDAO = new FashionDAOImpl(conn);
            FashionDtls fashion = fashionDAO.getFashionById(c.getFid());
            
            if (fashion == null || fashion.getQuantity() <= 0) {
                System.out.println("Sản phẩm không tồn tại hoặc đã hết hàng");
                return false;
            }
            
            int availableStock = fashion.getQuantity();
            int cartQuantity = getCartItemQuantity(c.getFid(), c.getUserId());
            int requestedQuantity = c.getQuantity(); // Số lượng muốn thêm
            int newTotalQuantity = cartQuantity + requestedQuantity;
            
            // Kiểm tra xem số lượng yêu cầu có vượt quá số lượng trong kho không
            if (newTotalQuantity > availableStock) {
                System.out.println("Không đủ hàng trong kho. Có sẵn: " + availableStock + 
                                 ", Trong giỏ: " + cartQuantity + ", Yêu cầu thêm: " + requestedQuantity);
                return false;
            }
            
            if (rs.next()) {
                // Sản phẩm đã tồn tại, cập nhật số lượng
                int currentQuantity = rs.getInt("quantity");
                int cartId = rs.getInt("cid");
                
                // Tăng số lượng theo requestedQuantity
                int newQuantity = currentQuantity + requestedQuantity;
                
                // Tính lại totalPrice dựa trên số lượng mới
                double price = Double.parseDouble(c.getPrice().replaceAll("[^0-9]", ""));
                double newTotalPrice = price * newQuantity;
                
                String updateSql = "UPDATE cart SET quantity = ?, totalPrice = ? WHERE cid = ?";
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newQuantity);
                updatePs.setString(2, String.valueOf((int)newTotalPrice));
                updatePs.setInt(3, cartId);
                
                int i = updatePs.executeUpdate();
                if (i == 1) {
                    f = true;
                    System.out.println("Đã cập nhật giỏ hàng: " + fashion.getFashionName() + 
                                     " - Số lượng mới: " + newQuantity);
                }
            } else {
                // Thêm sản phẩm mới vào giỏ hàng
                String sql = "INSERT INTO cart(fid, uid, fashionName, size, price, totalPrice, quantity) VALUES(?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, c.getFid());
                ps.setInt(2, c.getUserId());
                ps.setString(3, c.getFashionName());
                ps.setString(4, c.getSize());
                ps.setString(5, c.getPrice());
                
                // Tính totalPrice dựa trên số lượng yêu cầu
                double price = Double.parseDouble(c.getPrice().replaceAll("[^0-9]", ""));
                double totalPrice = price * requestedQuantity;
                
                ps.setString(6, String.valueOf((int)totalPrice));
                ps.setInt(7, requestedQuantity);
                
                int i = ps.executeUpdate();
                if (i == 1) {
                    f = true;
                    System.out.println("Đã thêm vào giỏ hàng: " + c.getFashionName() + 
                                     " - Số lượng: " + requestedQuantity);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi thêm vào giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return f;
    }

    // Cập nhật phương thức addQuantityToCart để kiểm tra số lượng
    @Override
    public boolean addQuantityToCart(int fid, int cid) {
        boolean success = false;
        try {
            // Bắt đầu transaction để đảm bảo tính nhất quán
            conn.setAutoCommit(false);
            
            // Lấy thông tin hiện tại của sản phẩm trong giỏ hàng
            String getInfoSql = "SELECT quantity, price FROM cart WHERE fid = ? AND cid = ?";
            PreparedStatement infoPs = conn.prepareStatement(getInfoSql);
            infoPs.setInt(1, fid);
            infoPs.setInt(2, cid);
            ResultSet infoRs = infoPs.executeQuery();
            
            if (infoRs.next()) {
                int currentQuantity = infoRs.getInt("quantity");
                String priceStr = infoRs.getString("price");
                
                // Lấy số lượng trong kho
                FashionDAOImpl fashionDAO = new FashionDAOImpl(conn);
                FashionDtls fashion = fashionDAO.getFashionById(fid);
                
                if (fashion == null || fashion.getQuantity() <= 0) {
                    conn.rollback();
                    conn.setAutoCommit(true);
                    return false;
                }
                
                int availableStock = fashion.getQuantity();
                
                // Kiểm tra xem có thể tăng số lượng không
                if (currentQuantity >= availableStock) {
                    conn.rollback();
                    conn.setAutoCommit(true);
                    return false;
                }
                
                // Tính toán tổng giá mới
                double price = 0;
                try {
                    // Xử lý giá - loại bỏ các ký tự không phải số
                    String cleanPrice = priceStr.replaceAll("[^0-9]", "");
                    price = Double.parseDouble(cleanPrice);
                } catch (NumberFormatException e) {
                    // Xử lý lỗi chuyển đổi
                    price = 0;
                    System.out.println("Lỗi chuyển đổi giá: " + priceStr);
                }
                
                int newQuantity = currentQuantity + 1;
                double newTotalPrice = price * newQuantity;
                
                // Tăng số lượng và cập nhật tổng giá
                String sql = "UPDATE cart SET quantity = ?, totalPrice = ? WHERE fid = ? AND cid = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, newQuantity);
                ps.setString(2, String.valueOf((int)newTotalPrice));
                ps.setInt(3, fid);
                ps.setInt(4, cid);
                
                int affectedRows = ps.executeUpdate();
                success = affectedRows > 0;
                
                if (success) {
                    System.out.println("Cập nhật thành công: " + newQuantity + " x " + price + " = " + newTotalPrice);
                } else {
                    System.out.println("Không thể cập nhật số lượng");
                }
                
                conn.commit();
            }
            
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Lỗi khi tăng số lượng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    public List<Cart> getFashionByUser(int userId) {
        List<Cart> list = new ArrayList<>();
        Cart c = null;
        try {
            String sql = "SELECT * FROM cart WHERE uid=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                c = new Cart();
                c.setCid(rs.getInt(1));
                c.setFid(rs.getInt(2));
                c.setUserId(rs.getInt(3));
                c.setFashionName(rs.getString(4));
                c.setSize(rs.getString(5));
                c.setPrice(rs.getString(6));
                
                // Lấy tổng giá trực tiếp từ totalPrice
                String totalPriceStr = rs.getString(7);
                int quantity = rs.getInt("quantity");
                
                // Kiểm tra và sửa totalPrice nếu cần
                try {
                    double unitPrice = Double.parseDouble(c.getPrice().replaceAll("[^0-9]", ""));
                    double storedTotalPrice = Double.parseDouble(totalPriceStr.replaceAll("[^0-9]", ""));
                    double calculatedTotalPrice = unitPrice * quantity;
                    
                    // Nếu totalPrice trong DB không đúng, cập nhật lại
                    if (Math.abs(storedTotalPrice - calculatedTotalPrice) > 0.01) {
                        // Cập nhật totalPrice đúng
                        String updateSql = "UPDATE cart SET totalPrice = ? WHERE cid = ?";
                        PreparedStatement updatePs = conn.prepareStatement(updateSql);
                        updatePs.setString(1, String.valueOf((int)calculatedTotalPrice));
                        updatePs.setInt(2, c.getCid());
                        updatePs.executeUpdate();
                        
                        // Sử dụng giá đã tính toán
                        c.setTotalPrice(String.valueOf((int)calculatedTotalPrice));
                        System.out.println("Đã sửa totalPrice cho sản phẩm " + c.getFashionName() + ": " + storedTotalPrice + " -> " + calculatedTotalPrice);
                    } else {
                        c.setTotalPrice(totalPriceStr);
                    }
                } catch (NumberFormatException e) {
                    // Nếu có lỗi, tính lại từ đầu
                    double unitPrice = Double.parseDouble(c.getPrice().replaceAll("[^0-9]", ""));
                    double calculatedTotalPrice = unitPrice * quantity;
                    c.setTotalPrice(String.valueOf((int)calculatedTotalPrice));
                    System.out.println("Lỗi xử lý giá, đã tính lại: " + calculatedTotalPrice);
                }
                
                // Lấy số lượng
                c.setQuantity(quantity);
                
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi lấy sản phẩm từ giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return list;
    }

    public boolean deleteFashion(int fid, int uid, int cid) {
        boolean f = false;
        try {
            String sql = "DELETE FROM cart WHERE fid=? AND uid=? AND cid=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fid);
            ps.setInt(2, uid);
            ps.setInt(3, cid);
            
            int i = ps.executeUpdate();
            if (i == 1) {
                f = true;
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi xóa sản phẩm khỏi giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return f;
    }

    @Override
    public boolean updateQuantityToCart(int quantity, int uid, int fid, int cid) {
        boolean success = false;
        try {
            if (quantity < 1) {
                return false; // Không cho phép số lượng < 1
            }
            
            // Kiểm tra số lượng trong kho trước khi cập nhật
            FashionDAOImpl fashionDAO = new FashionDAOImpl(conn);
            FashionDtls fashion = fashionDAO.getFashionById(fid);
            
            if (fashion == null) {
                System.out.println("Không tìm thấy sản phẩm với ID: " + fid);
                return false;
            }
            
            int availableStock = fashion.getQuantity();
            if (quantity > availableStock) {
                System.out.println("Số lượng yêu cầu (" + quantity + ") vượt quá tồn kho (" + availableStock + ")");
                return false;
            }
            
            // Lấy giá hiện tại của sản phẩm
            String getPrice = "SELECT price FROM cart WHERE cid = ?";
            PreparedStatement pricePs = conn.prepareStatement(getPrice);
            pricePs.setInt(1, cid);
            ResultSet priceRs = pricePs.executeQuery();
            
            if (priceRs.next()) {
                String priceStr = priceRs.getString("price");
                try {
                    // Tính lại tổng giá dựa trên số lượng mới
                    double price = Double.parseDouble(priceStr.replaceAll("[^0-9]", ""));
                    double newTotalPrice = price * quantity;
                    
                    // Cập nhật số lượng và tổng giá
                    String sql = "UPDATE cart SET quantity = ?, totalPrice = ? WHERE uid = ? AND fid = ? AND cid = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, quantity);
                    ps.setString(2, String.valueOf((int)newTotalPrice));
                    ps.setInt(3, uid);
                    ps.setInt(4, fid);
                    ps.setInt(5, cid);
                    
                    int affectedRows = ps.executeUpdate();
                    success = affectedRows > 0;
                    
                    if (success) {
                        System.out.println("Cập nhật số lượng thành công: " + quantity + " x " + price + " = " + newTotalPrice);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Lỗi chuyển đổi giá: " + priceStr + " - " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật số lượng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    // Phương thức mới để thêm số lượng tùy ý
    public boolean addQuantityToCartByAmount(int fid, int cid, int amount) {
        boolean success = false;
        try {
            if (amount <= 0) {
                return false; // Không cho phép thêm số lượng <= 0
            }
            
            // Bắt đầu transaction để đảm bảo tính nhất quán
            conn.setAutoCommit(false);
            
            // Lấy thông tin hiện tại của sản phẩm trong giỏ hàng
            String getInfoSql = "SELECT quantity, price FROM cart WHERE fid = ? AND cid = ?";
            PreparedStatement infoPs = conn.prepareStatement(getInfoSql);
            infoPs.setInt(1, fid);
            infoPs.setInt(2, cid);
            ResultSet infoRs = infoPs.executeQuery();
            
            if (infoRs.next()) {
                int currentQuantity = infoRs.getInt("quantity");
                String priceStr = infoRs.getString("price");
                
                // Lấy số lượng trong kho
                FashionDAOImpl fashionDAO = new FashionDAOImpl(conn);
                FashionDtls fashion = fashionDAO.getFashionById(fid);
                
                if (fashion == null || fashion.getQuantity() <= 0) {
                    conn.rollback();
                    conn.setAutoCommit(true);
                    return false;
                }
                
                int availableStock = fashion.getQuantity();
                int newQuantity = currentQuantity + amount;
                
                // Kiểm tra xem có thể tăng số lượng không
                if (newQuantity > availableStock) {
                    System.out.println("Không thể thêm " + amount + " sản phẩm. Tồn kho: " + availableStock + 
                                     ", Hiện tại trong giỏ: " + currentQuantity);
                    conn.rollback();
                    conn.setAutoCommit(true);
                    return false;
                }
                
                // Tính toán tổng giá mới
                double price = 0;
                try {
                    // Xử lý giá - loại bỏ các ký tự không phải số
                    String cleanPrice = priceStr.replaceAll("[^0-9]", "");
                    price = Double.parseDouble(cleanPrice);
                } catch (NumberFormatException e) {
                    // Xử lý lỗi chuyển đổi
                    price = 0;
                    System.out.println("Lỗi chuyển đổi giá: " + priceStr);
                }
                
                double newTotalPrice = price * newQuantity;
                
                // Cập nhật số lượng và tổng giá
                String sql = "UPDATE cart SET quantity = ?, totalPrice = ? WHERE fid = ? AND cid = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, newQuantity);
                ps.setString(2, String.valueOf((int)newTotalPrice));
                ps.setInt(3, fid);
                ps.setInt(4, cid);
                
                int affectedRows = ps.executeUpdate();
                success = affectedRows > 0;
                
                if (success) {
                    System.out.println("Đã thêm " + amount + " sản phẩm. Số lượng mới: " + newQuantity + 
                                     " x " + price + " = " + newTotalPrice);
                } else {
                    System.out.println("Không thể cập nhật số lượng");
                }
                
                conn.commit();
            }
            
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            try {
                conn.rollback();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.out.println("Lỗi khi thêm số lượng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    @Override
    public boolean subQuantityToCart(int fid, int cid) {
        boolean success = false;
        try {
            // Lấy thông tin hiện tại
            String getInfo = "SELECT quantity, price FROM cart WHERE fid = ? AND cid = ?";
            PreparedStatement infoPs = conn.prepareStatement(getInfo);
            infoPs.setInt(1, fid);
            infoPs.setInt(2, cid);
            ResultSet infoRs = infoPs.executeQuery();
            
            if (infoRs.next()) {
                int currentQuantity = infoRs.getInt("quantity");
                String priceStr = infoRs.getString("price");
                
                if (currentQuantity > 1) {
                    try {
                        // Tính tổng giá mới
                        double price = Double.parseDouble(priceStr.replaceAll("[^0-9]", ""));
                        int newQuantity = currentQuantity - 1;
                        double newTotalPrice = price * newQuantity;
                        
                        // Cập nhật số lượng và tổng giá
                        String sql = "UPDATE cart SET quantity = ?, totalPrice = ? WHERE fid = ? AND cid = ?";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, newQuantity);
                        ps.setString(2, String.valueOf((int)newTotalPrice));
                        ps.setInt(3, fid);
                        ps.setInt(4, cid);
                        
                        int affectedRows = ps.executeUpdate();
                        success = affectedRows > 0;
                        
                        if (success) {
                            System.out.println("Giảm số lượng thành công: " + newQuantity + " x " + price + " = " + newTotalPrice);
                        }
                    } catch (NumberFormatException e) {
                        System.out.println("Lỗi chuyển đổi giá: " + priceStr + " - " + e.getMessage());
                    }
                } else {
                    // Không giảm nếu số lượng = 1
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi giảm số lượng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    // Phương thức kiểm tra xem giỏ hàng có trống không
    public boolean isCartEmpty(int userId) {
        boolean isEmpty = true;
        try {
            String sql = "SELECT COUNT(*) FROM cart WHERE uid = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                isEmpty = (count == 0);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi kiểm tra giỏ hàng trống: " + e.getMessage());
            e.printStackTrace();
        }
        
        return isEmpty;
    }

    // Phương thức tính tổng giá trị giỏ hàng
    public double getCartTotal(int userId) {
        double total = 0.0;
        try {
            String sql = "SELECT SUM(CAST(totalPrice AS DECIMAL(10,2))) FROM cart WHERE uid = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next() && rs.getString(1) != null) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi tính tổng giá trị giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return total;
    }

    public boolean deleteUserCart(int userId) {
        boolean success = false;
        try {
            String sql = "DELETE FROM cart WHERE uid=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            int rowsAffected = ps.executeUpdate();
            success = true; // Xóa thành công ngay cả khi không có dòng nào bị ảnh hưởng
            System.out.println("Đã xóa " + rowsAffected + " sản phẩm từ giỏ hàng của người dùng ID: " + userId);
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa giỏ hàng của người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    // Thêm phương thức này để hỗ trợ thực hiện các truy vấn DELETE với điều kiện phức tạp hơn
    public boolean deleteCartItems(String condition, Object... params) {
        boolean success = false;
        try {
            String sql = "DELETE FROM cart WHERE " + condition;
            PreparedStatement ps = conn.prepareStatement(sql);
            
            // Thiết lập các tham số
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            
            int rowsAffected = ps.executeUpdate();
            success = rowsAffected > 0;
            System.out.println("Đã xóa " + rowsAffected + " sản phẩm từ giỏ hàng theo điều kiện: " + condition);
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa sản phẩm từ giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }

    /**
     * Xóa tất cả sản phẩm đã đặt hàng thành công.
     * @param userId ID của người dùng
     * @param orderItems Danh sách mã sản phẩm đã đặt hàng
     * @return true nếu xóa thành công, false nếu không
     */
    public boolean deleteOrderedItems(int userId, List<Integer> orderItems) {
        if (orderItems == null || orderItems.isEmpty()) {
            return true; // Không có gì để xóa
        }
        
        boolean success = false;
        try {
            // Tạo một chuỗi các dấu ? cho danh sách sản phẩm
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < orderItems.size(); i++) {
                placeholders.append("?");
                if (i < orderItems.size() - 1) {
                    placeholders.append(",");
                }
            }
            
            String sql = "DELETE FROM cart WHERE uid=? AND fid IN (" + placeholders.toString() + ")";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            for (int i = 0; i < orderItems.size(); i++) {
                ps.setInt(i + 2, orderItems.get(i));
            }
            
            int rowsAffected = ps.executeUpdate();
            success = true; // Xóa thành công ngay cả khi không có dòng nào bị ảnh hưởng
            System.out.println("Đã xóa " + rowsAffected + " sản phẩm đã đặt hàng từ giỏ hàng của người dùng ID: " + userId);
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa sản phẩm đã đặt hàng từ giỏ hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return success;
    }
}