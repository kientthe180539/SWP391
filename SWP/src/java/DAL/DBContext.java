package DAL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    protected Connection connection;

    public DBContext() {
        //@Students: You are allowed to edit user, pass, url variables to fit 
        //your system configuration
        try {
            // Thay đổi 1: Cập nhật thông tin đăng nhập (ví dụ)
            String user = "root"; // Tên người dùng MySQL của bạn
            String pass = "yourpassword"; // Mật khẩu MySQL của bạn
//            String pass = "123456"; // Mật khẩu MySQL của bạn

            // Thay đổi 2: Cập nhật URL kết nối cho MySQL
            // Ví dụ: kết nối đến database 'my_database' trên localhost, cổng 3306
            String url = "jdbc:mysql://localhost:3306/hotel_manager_db";

            // Thay đổi 3: Cập nhật Driver Class cho MySQL
            // Đối với các phiên bản JDBC hiện đại, dòng này thường không bắt buộc, 
            // nhưng nên giữ lại để đảm bảo tính tương thích và rõ ràng.
            Class.forName("com.mysql.cj.jdbc.Driver");

            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void main(String[] args) {
        // Kiểm tra kết nối
        Connection conn = new DBContext().connection;
        if (conn != null) {
            System.out.println("Kết nối MySQL thành công: " + conn);
        } else {
            System.out.println("Kết nối MySQL thất bại.");
        }
    }
}
