//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnectorDs implements Connector {
    private String dataSourceName = null;
    private DataSource sqlDataSource = null;
    private Connection con = null;
    private Database dataBase;

    public ConnectorDs(String dataSourceName, Database dataBase) {
        this.dataBase = Database.ANY_DATABASE;
        this.dataSourceName = dataSourceName;
        this.dataBase = dataBase;
    }

    public Connection getConnection() throws DataBaseException {
        try {
            if (this.sqlDataSource == null) {
                Context ctx = new InitialContext();
                this.sqlDataSource = (DataSource)ctx.lookup(this.dataSourceName);
            }

            if (this.con == null || this.con.isClosed()) {
                this.con = this.sqlDataSource.getConnection();
            }

            return this.con;
        } catch (NamingException | SQLException var2) {
            Exception ex = var2;
            throw new DataBaseException(ex);
        }
    }

    public String getDataSourceName() {
        return this.dataSourceName;
    }

    public Database getDatabaseVendor() {
        return this.dataBase;
    }

    public void close() {
        Cleaner.close(this.con);
    }
}
