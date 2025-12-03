package DAL;

public class DAO {

    protected java.sql.Connection connection;
    protected String status = "OK";

    public DAO() {
        try {
            connection = new DBContext().connection;
        } catch (Exception e) {
            status = "Error connect at: " + e.getMessage();
        }
    }

}
