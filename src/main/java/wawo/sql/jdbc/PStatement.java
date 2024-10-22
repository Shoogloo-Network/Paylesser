//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import wawo.sql.Cleaner;
import wawo.sql.Connector;
import wawo.sql.Database;

class PStatement {
    private Connector connector = null;
    private Connection con = null;
    private Map<Integer, PreparedStatement> preparedStatementMap = null;

    PStatement() {
    }

    protected PreparedStatement getExe(String sql, boolean cached) throws SQLException {
        if (!cached) {
            return this.ps(sql);
        } else {
            if (this.preparedStatementMap == null) {
                this.preparedStatementMap = new HashMap();
            }

            int key = sql.hashCode();
            PreparedStatement pm = (PreparedStatement)this.preparedStatementMap.get(key);
            if (pm == null) {
                pm = this.ps(sql);
                this.preparedStatementMap.put(key, pm);
            } else {
                pm.clearParameters();
            }

            return pm;
        }
    }

    protected PreparedStatement getSel(String sql, Object[] params, int scroll) throws SQLException {
        int key = sql.hashCode();
        if (this.preparedStatementMap == null) {
            this.preparedStatementMap = new HashMap();
        }

        PreparedStatement pm = (PreparedStatement)this.preparedStatementMap.get(key);
        if (pm == null) {
            pm = this.getConnection().prepareStatement(sql, scroll, 1007);
            this.preparedStatementMap.put(key, pm);
        } else {
            pm.clearParameters();
        }

        JdbcUtil.setParam(pm, params);
        return pm;
    }

    private PreparedStatement ps(String sql) throws SQLException {
        return Database.MYSQL != this.getVendor() && Database.MICROSOFT_SQL_SERVER != this.getVendor() ? this.getConnection().prepareStatement(sql) : this.getConnection().prepareStatement(sql, 1);
    }

    protected Connection getConnection() {
        return this.con == null && this.connector != null ? this.connector.getConnection() : this.con;
    }

    protected void close() {
        if (this.preparedStatementMap != null) {
            Iterator var1 = this.preparedStatementMap.values().iterator();

            while(var1.hasNext()) {
                PreparedStatement pms = (PreparedStatement)var1.next();
                Cleaner.close(pms);
            }
        }

    }

    protected void destroy() {
        Cleaner.close(this.connector);
        Cleaner.close(this.con);
    }

    protected void setConnector(Connector connector) {
        this.connector = connector;
    }

    protected void setConnection(Connection con) {
        this.con = con;
    }

    protected Database getVendor() {
        return this.connector.getDatabaseVendor();
    }
}
