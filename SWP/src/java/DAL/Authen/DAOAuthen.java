/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL.Authen;

import DAL.DAO;
import Model.User;
import java.sql.*;

/**
 *
 * @author PC
 */
public class DAOAuthen extends DAO {

    public static DAOAuthen INSTANCE = new DAOAuthen();

    private DAOAuthen() {
    }

    //create new customer
//    public int registerCustomer(User u) {
//        int n = 0;
//        String sql = "INSERT INTO users (username, password_hash, full_name, email, phone, role_id, is_active) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
//
//        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
//            ps.setString(1, u.getUsername());
//            ps.setString(2, u.getPasswordHash());
//            ps.setString(3, u.getFullName());
//            ps.setString(4, u.getEmail());
//            ps.setString(5, u.getPhone());
//            ps.setInt(6, u.getRoleId());
//            ps.setBoolean(7, u.getActive());
//
//            n = ps.executeUpdate();
//            if (n > 0) {
//                System.out.println("User created successfully!");
//            } else {
//                System.out.println("User creation failed!");
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return n;
//    }
    
    public int registerCustomer(User u) {
    int n = 0;
    System.out.println("Attempting to register user: " + u.getEmail());
    
    String sql = "INSERT INTO users (username, password_hash, full_name, email, phone, role_id, is_active) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement ps = this.connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, u.getUsername());
        ps.setString(2, u.getPasswordHash());
        ps.setString(3, u.getFullName());
        ps.setString(4, u.getEmail());
        ps.setString(5, u.getPhone());
        ps.setInt(6, u.getRoleId());
        ps.setBoolean(7, u.getActive());

        System.out.println("Executing query: " + ps.toString());
        n = ps.executeUpdate();
        
        if (n > 0) {
            System.out.println("User created successfully!");
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    System.out.println("New user ID: " + newId);
                }
            }
        } else {
            System.out.println("User creation failed - no rows affected");
        }

    } catch (SQLException e) {
        System.err.println("SQL Error during registration: " + e.getMessage());
        e.printStackTrace();
    }
    return n;
}

    
    //login
    public User login(String identifier, String password) {
        String sql = "SELECT * FROM users WHERE email = ? OR phone = ? LIMIT 1";

        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setActive(rs.getBoolean("is_active"));

                if (u.checkPasswordRaw(password)) {
                    return u;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
