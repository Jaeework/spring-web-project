package org.zerock.persistence;

import lombok.extern.log4j.Log4j2;
import org.junit.Test;

import java.sql.Connection;
import java.sql.DriverManager;

import static org.junit.jupiter.api.Assertions.fail;

@Log4j2
public class JDBCTests {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testConnection() {

        try(Connection con =
                    DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/springdb",
                            "root",
                            "test"
                    )) {

            log.info(con);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
}
