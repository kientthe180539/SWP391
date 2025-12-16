package DAL.Amenity;

import DAL.DAO;
import Model.Amenity;
import Model.RoomTypeAmenity;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AmenityDAO extends DAO {

    public List<Amenity> getAllAmenities() {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT * FROM amenities WHERE is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAmenity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Amenity getAmenityById(int id) {
        String sql = "SELECT * FROM amenities WHERE amenity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAmenity(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createAmenity(Amenity a) {
        String sql = "{CALL sp_create_amenity(?, ?, ?, ?)}";
        try (java.sql.CallableStatement cs = connection.prepareCall(sql)) {
            cs.setString(1, a.getName());
            cs.setString(2, a.getDescription());
            cs.setBigDecimal(3, a.getPrice());
            cs.registerOutParameter(4, java.sql.Types.INTEGER);

            cs.execute();
            int newId = cs.getInt(4);
            return newId > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAmenity(Amenity a) {
        String sql = "UPDATE amenities SET name = ?, description = ?, price = ?, is_active = ? WHERE amenity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getDescription());
            ps.setBigDecimal(3, a.getPrice());
            ps.setBoolean(4, a.getActive());
            ps.setInt(5, a.getAmenityId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAmenity(int id) {
        // Soft delete
        String sql = "UPDATE amenities SET is_active = 0 WHERE amenity_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Room Type Amenities
    public List<RoomTypeAmenity> getAmenitiesByRoomType(int roomTypeId) {
        List<RoomTypeAmenity> list = new ArrayList<>();
        String sql = "SELECT rta.*, a.name, a.description, a.price, a.is_active " +
                "FROM room_type_amenities rta " +
                "JOIN amenities a ON rta.amenity_id = a.amenity_id " +
                "WHERE rta.room_type_id = ? AND a.is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeAmenity rta = new RoomTypeAmenity();
                    rta.setId(rs.getInt("id"));
                    rta.setRoomTypeId(rs.getInt("room_type_id"));
                    rta.setAmenityId(rs.getInt("amenity_id"));
                    rta.setDefaultQuantity(rs.getInt("default_quantity"));

                    Amenity a = mapAmenity(rs);
                    rta.setAmenity(a);

                    list.add(rta);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Amenity mapAmenity(ResultSet rs) throws SQLException {
        Amenity a = new Amenity();
        a.setAmenityId(rs.getInt("amenity_id"));
        a.setName(rs.getString("name"));
        a.setDescription(rs.getString("description"));
        a.setPrice(rs.getBigDecimal("price"));
        a.setActive(rs.getBoolean("is_active"));
        return a;
    }

    public boolean addAmenityToRoomType(int roomTypeId, int amenityId, int quantity) {
        String sql = "{CALL sp_assign_amenity_to_room_type(?, ?, ?, ?)}";
        try (java.sql.CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, roomTypeId);
            cs.setInt(2, amenityId);
            cs.setInt(3, quantity);
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.execute();
            return cs.getInt(4) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
