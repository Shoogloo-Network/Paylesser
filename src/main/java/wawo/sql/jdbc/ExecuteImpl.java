//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import wawo.sql.Cleaner;
import wawo.sql.Connector;
import wawo.sql.DataBaseException;
import wawo.sql.Database;
import wawo.sql.format.FormatSequence;

public class ExecuteImpl implements Execute {
    private FormatSequence seq;
    private PStatement dba = new PStatement();
    private static final int insert = 0;
    private static final int update = 1;
    private boolean tranStarted = false;

    public void setConnection(Connection con) {
        this.dba.setConnection(con);
    }

    public ExecuteImpl(Connector connector) {
        this.dba.setConnector(connector);
    }

    private long getSequence(String seqName) throws SQLException {
        if (this.seq == null) {
            this.seq = new FormatSequence(this.dba.getVendor());
        }

        Statement st = null;
        ResultSet rs = null;
        String sql = this.seq.seqSelect(seqName);

        long var5;
        try {
            st = this.dba.getConnection().createStatement();
            rs = st.executeQuery(sql);
            if (!rs.next()) {
                throw new DataBaseException("Unable to get sequence value from squence sql " + sql);
            }

            var5 = rs.getLong(1);
        } finally {
            Cleaner.close(rs);
            Cleaner.close(st);
        }

        return var5;
    }

    public void close() {
        if (this.dba != null) {
            this.dba.close();
        }

    }

    public long insert(String sql, Object[] params, String pkSequenceName) throws DataBaseException {
        return this.execute(sql, params, false, pkSequenceName, 0);
    }

    public long update(String sql, Object[] params) throws DataBaseException {
        return this.execute(sql, params, false, (String)null, 1);
    }

    public long delete(String sql, Object[] params) throws DataBaseException {
        return this.execute(sql, params, false, (String)null, 1);
    }

    public int ddl(String sql) {
        Statement st = null;

        int var9;
        try {
            st = this.dba.getConnection().createStatement();
            st.execute(sql);
            var9 = st.getUpdateCount();
        } catch (SQLException var7) {
            SQLException t = var7;
            JdbcUtil.print(sql, (Object[])null, true);
            throw new DataBaseException(sql, t);
        } finally {
            Cleaner.close(st);
        }

        return var9;
    }

    private long execute(String sql, Object[] params, boolean cached, String pkSequenceName, int type) throws DataBaseException {
        Statement st = null;
        PreparedStatement pm = null;

        long var15;
        try {
            if (params == null) {
                st = this.dba.getConnection().createStatement();
                var15 = this.getKey(st, (PreparedStatement)null, sql, 0, type);
                return var15;
            }

            pm = this.dba.getExe(sql, cached);
            JdbcUtil.setParam(pm, params);
            var15 = this.getKey((Statement)null, pm, pkSequenceName, params.length, type);
        } catch (SQLException var13) {
            SQLException t = var13;
            JdbcUtil.print(sql, params, true);
            throw new DataBaseException(t);
        } finally {
            if (!cached) {
                Cleaner.close(pm);
            }

            Cleaner.close(st);
        }

        return var15;
    }

    private long getKey(Statement st, PreparedStatement pm, String sql, int len, int type) throws SQLException {
        ResultSet rsKey = null;
        long key = 0L;

        try {
            long s;
            if (st != null) {
                if (0 != type) {
                    s = (long)st.executeUpdate(sql);
                    return s;
                }

                if (Database.MYSQL != this.dba.getVendor() && Database.MICROSOFT_SQL_SERVER != this.dba.getVendor()) {
                    s = (long)st.executeUpdate(sql);
                    return s;
                }

                st.executeUpdate(sql, 1);
                rsKey = st.getGeneratedKeys();
            } else if (pm != null) {
                if (sql != null) {
                    s = this.getSequence(sql);
                    pm.setLong(len + 1, s);
                    pm.executeUpdate();
                    long var11 = s;
                    return var11;
                }

                pm.executeUpdate();
                if (0 == type) {
                    rsKey = pm.getGeneratedKeys();
                }
            }

            if (0 == type) {
                if (rsKey == null) {
                    throw new DataBaseException("Unable to retrive auto incremented primary key");
                }

                if (rsKey.next()) {
                    key = rsKey.getLong(1);
                }

                if (key == 0L) {
                    throw new DataBaseException("Unable to retrive auto incremented primary key");
                }
            }
        } finally {
            Cleaner.close(rsKey);
        }

        return key;
    }

    public int plsql(String procedureSql, Object[] params) throws DataBaseException {
        CallableStatement st = null;

        int i;
        try {
            st = this.dba.getConnection().prepareCall("{call " + procedureSql + "}");
            if (params != null) {
                i = 0;

                for(int len = params.length; i < len; ++i) {
                    st.setObject(i + 1, params[i]);
                }
            }

            i = st.executeUpdate();
        } catch (SQLException var9) {
            SQLException ex = var9;
            JdbcUtil.print(procedureSql, params, true);
            throw new DataBaseException(ex);
        } finally {
            Cleaner.close(st);
        }

        return i;
    }

    public long insert(String sql, Object[] params) {
        return this.insert(sql, params, (String)null);
    }

    public long updateInLoop(String sql, Object[] params) throws DataBaseException {
        return this.execute(sql, params, true, (String)null, 1);
    }

    public long deleteInLoop(String sql, Object[] params) throws DataBaseException {
        return this.execute(sql, params, true, (String)null, 1);
    }

    public long insertInLoop(String sql, Object[] params, String pkSequenceName) throws DataBaseException {
        return this.execute(sql, params, true, pkSequenceName, 0);
    }

    public long insertOrUpdate(String sql, Object[] params, String pkSequenceName) {
        return sql.toLowerCase().startsWith("insert") ? this.insert(sql, params, pkSequenceName) : this.update(sql, params);
    }

    public void begin() throws DataBaseException {
        this.tranStarted = false;

        try {
            this.dba.getConnection().setAutoCommit(false);
        } catch (SQLException var2) {
            SQLException ex = var2;
            throw new DataBaseException(ex);
        }
    }

    public void commit() throws DataBaseException {
        this.tranStarted = false;

        try {
            this.dba.getConnection().commit();
        } catch (SQLException var2) {
            SQLException ex = var2;
            throw new DataBaseException(ex);
        }
    }

    public void rollback() throws DataBaseException {
        this.tranStarted = false;

        try {
            this.dba.getConnection().rollback();
        } catch (SQLException var2) {
            SQLException ex = var2;
            throw new DataBaseException(ex);
        }
    }

    public boolean isTransactionStarted() {
        return this.tranStarted;
    }

    public Connection getConnection() {
        return this.dba.getConnection();
    }
}
