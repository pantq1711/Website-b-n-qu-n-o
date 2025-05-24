<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.DB.DBConnect" %>

<html>
<head>
    <title>Fashion Order Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<canvas id="myBarChart" width="20" height="10"></canvas>
<%
Connection conn = DBConnect.getConn();

if (conn != null) {
    try {
        // Tắt ONLY_FULL_GROUP_BY để tránh lỗi
        Statement stmt = conn.createStatement();
        stmt.execute("SET sql_mode = '';");

        // Thực hiện truy vấn SQL để lấy dữ liệu
        String sql = "SELECT DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%W') AS weekday, " +
                     "COALESCE(SUM(quantity), 0) AS total_quantity " +
                     "FROM fashion_order " +
                     "GROUP BY WEEKDAY(STR_TO_DATE(date, '%d/%m/%Y')) " +
                     "ORDER BY WEEKDAY(STR_TO_DATE(date, '%d/%m/%Y'))";

        PreparedStatement preparedStatement = conn.prepareStatement(sql);
        ResultSet resultSet = preparedStatement.executeQuery();

        // Tổng hợp dữ liệu theo ngày
        Map<String, Integer> quantitiesByDay = new HashMap<>();
        while (resultSet.next()) {
            String weekday = resultSet.getString("weekday");
            int totalQuantity = resultSet.getInt("total_quantity");
            quantitiesByDay.put(weekday, totalQuantity);
        }

        // Chuyển dữ liệu sang mảng
        int[] quantitiesArray = new int[7];
        String[] weekdays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};

        for (int i = 0; i < weekdays.length; i++) {
            quantitiesArray[i] = quantitiesByDay.getOrDefault(weekdays[i], 0);
        }

%>

<script>
    var ctx = document.getElementById('myBarChart').getContext('2d');

    var data = {
        labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
        datasets: [{
            label: 'Số lượng sản phẩm order',
            backgroundColor: 'rgb(75, 192, 192)',
            borderColor: 'rgb(75, 192, 192)',
            data: <%= Arrays.toString(quantitiesArray) %>,
            fill: false,
        }]
    };

    var config = {
        type: 'bar',
        data: data,
        options: {
            scales: {
                x: {
                    type: 'category',
                    labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                    ticks: {
                        fontSize: 14, // Kích thước chữ cho trục x
                    }
                },
                y: {
                    beginAtZero: true,
                    ticks: {
                        fontSize: 14, // Kích thước chữ cho trục y
                    }
                }
            },
            plugins: {
                legend: {
                    labels: {
                        fontSize: 50 // Kích thước chữ cho chú thích
                    }
                }
            }
        }
    };

    var myBarChart = new Chart(ctx, config);
</script>
<%
        // Đóng kết nối
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>

</body>
</html>
