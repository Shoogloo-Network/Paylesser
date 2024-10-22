//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import wawo.sql.Cleaner;
import wawo.sql.Connector;
import wawo.sql.ConnectorDs;
import wawo.sql.DataBaseException;
import wawo.sql.Database;
import wawo.sql.filter.Query;

public class SelectImpl implements Select {
    private List<Statement> statements = null;
    private List<ResultSet> resultsets = null;
    private List<PreparedStatement> pmstatements = null;
    private int typeScroll = 1003;
    private PStatement dba = new PStatement();

    public SelectImpl(Connector connector) {
        this.dba.setConnector(connector);
    }

    public SelectImpl(String dataSource) {
        this.dba.setConnector(new ConnectorDs(dataSource, Database.ANY_DATABASE));
    }

    private Statement getStatement(boolean add) throws SQLException {
        return this.getStatement(add, this.typeScroll);
    }

    private Statement getStatement(boolean add, int scroll) throws SQLException {
        Statement st = this.dba.getConnection().createStatement(scroll, 1007);
        if (add) {
            this.add(st);
        }

        return st;
    }

    public void setTypeScroll(int typeScroll) {
        this.typeScroll = typeScroll;
    }

    public PreparedStatement getPreparedStatement(String sql) {
        try {
            return this.getPreparedStatement(sql, (Object[])null, true);
        } catch (SQLException var3) {
            SQLException ex = var3;
            throw new DataBaseException(ex);
        }
    }

    private PreparedStatement getPreparedStatement(String sql, Object[] params, boolean keep) throws SQLException {
        return this.getPreparedStatement(sql, params, keep, this.typeScroll);
    }

    private PreparedStatement getPreparedStatement(String sql, Object[] params, boolean keep, int scroll) throws SQLException {
        PreparedStatement pm = null;

        try {
            pm = this.dba.getConnection().prepareStatement(sql, scroll, 1007);
            JdbcUtil.setParam(pm, params);
        } catch (SQLException var7) {
            SQLException t = var7;
            JdbcUtil.print(sql, params);
            Cleaner.close(pm);
            throw t;
        }

        if (keep) {
            this.add(pm);
        }

        return pm;
    }

    public ResultSet resultSetLazy(Query query) {
        ResultSet rs = null;
        String sql = query.getFinalLazyQuery();
        Object[] params = query.mainQueryParams;

        try {
            int scroll = query.TYPE_SCROLL == 1003 ? 1004 : query.TYPE_SCROLL;
            rs = params == null ? this.getStatement(true, scroll).executeQuery(sql) : this.getPreparedStatement(sql, params, true, scroll).executeQuery();
            Long totalRecords = query.getQueryFilter().getTotalRecords();
            if (totalRecords == null || totalRecords == 0L) {
                sql = query.getFinalCountQuery();
                params = query.countQueryParams;
                totalRecords = this.count(sql, params);
                query.getQueryFilter().setTotalRecords(totalRecords);
            }
        } catch (Throwable var7) {
            Throwable ex = var7;
            Cleaner.close(rs);
            JdbcUtil.print(sql, params, true);
            throw new DataBaseException(ex);
        }

        this.add(rs);
        return rs;
    }

    public ResultSet resultSet(String sql, Object[] params) {
        ResultSet rs = null;

        try {
            rs = params == null ? this.getStatement(true).executeQuery(sql) : this.getPreparedStatement(sql, params, true).executeQuery();
        } catch (Throwable var5) {
            Throwable ex = var5;
            Cleaner.close(rs);
            JdbcUtil.print(sql, params, true);
            throw new DataBaseException(ex);
        }

        this.add(rs);
        return rs;
    }

    public ResultSet resultSetInLoop(String sql, Object[] params) {
        ResultSet rs = null;

        try {
            rs = this.dba.getSel(sql, params, this.typeScroll).executeQuery();
        } catch (Throwable var5) {
            Throwable ex = var5;
            Cleaner.close(rs);
            JdbcUtil.print(sql, params, true);
            throw new DataBaseException(ex);
        }

        this.add(rs);
        return rs;
    }

    public long count(String sql, Object[] params) {
        String result = this.first(sql, params);
        if (result == null) {
            return 0L;
        } else {
            try {
                return Long.valueOf(result);
            } catch (Throwable var5) {
                Throwable ex = var5;
                JdbcUtil.print(sql, params, true);
                throw new DataBaseException(ex);
            }
        }
    }

    public void clean() {
        Iterator var1;
        if (this.resultsets != null) {
            var1 = this.resultsets.iterator();

            while(var1.hasNext()) {
                ResultSet rs = (ResultSet)var1.next();
                Cleaner.close(rs);
            }

            this.resultsets.clear();
        }

        if (this.statements != null) {
            var1 = this.statements.iterator();

            while(var1.hasNext()) {
                Statement st = (Statement)var1.next();
                Cleaner.close(st);
            }

            this.statements.clear();
        }

        if (this.pmstatements != null) {
            var1 = this.pmstatements.iterator();

            while(var1.hasNext()) {
                PreparedStatement pm = (PreparedStatement)var1.next();
                Cleaner.close(pm);
            }

            this.pmstatements.clear();
        }

        this.dba.close();
    }

    private void add(Statement st) {
        if (this.statements == null) {
            this.statements = new ArrayList(2);
        }

        this.statements.add(st);
    }

    private void add(PreparedStatement pm) {
        if (this.pmstatements == null) {
            this.pmstatements = new ArrayList(2);
        }

        this.pmstatements.add(pm);
    }

    private void add(ResultSet rs) {
        if (this.resultsets == null) {
            this.resultsets = new ArrayList(2);
        }

        this.resultsets.add(rs);
    }

    public String first(String sql, Object[] params) {
        return this.f1(sql, params, (List)null);
    }

    public List listFirst(String sql, Object[] params) {
        List col = new ArrayList();
        this.f1(sql, params, col);
        return col;
    }

    private String f1(String sql, Object[] params, List list) {
        Statement st = null;
        PreparedStatement pm = null;
        ResultSet rs = null;

        try {
            Throwable ex;
            try {
                if (params == null) {
                    st = this.getStatement(false);
                    rs = st.executeQuery(sql);
                } else {
                    pm = this.getPreparedStatement(sql, params, false);
                    rs = pm.executeQuery();
                }

                if (rs == null) {
                    ex = null;
                    return ""+ ex;
                } else if (list == null) {
                    if (!rs.next()) {
                        return null;
                    } else {
                        String var13 = rs.getString(1);
                        return var13;
                    }
                } else {
                    while(rs.next()) {
                        list.add(rs.getString(1));
                    }

                    ex = null;
                    return ""+ex;
                }
            } catch (Throwable var11) {
                ex = var11;
                JdbcUtil.print(sql, params, true);
                throw new DataBaseException(ex);
            }
        } finally {
            Cleaner.close(rs);
            Cleaner.close(pm);
            Cleaner.close(st);
        }
    }

    public boolean exist(String sql, Object[] params) {
        Statement st = null;
        ResultSet rs = null;
        PreparedStatement pm = null;

        boolean var12;
        try {
            if (params == null) {
                st = this.getStatement(false);
                rs = st.executeQuery(sql);
            } else {
                pm = this.getPreparedStatement(sql, params, false);
                rs = pm.executeQuery();
            }

            if (rs == null) {
                var12 = false;
                return var12;
            }

            var12 = rs.next();
        } catch (Throwable var10) {
            Throwable ex = var10;
            JdbcUtil.print(sql, params, true);
            throw new DataBaseException(ex);
        } finally {
            Cleaner.close(rs);
            Cleaner.close(pm);
            Cleaner.close(st);
        }

        return var12;
    }

    public void destroy() {
        this.dba.destroy();
    }

    public void setConnection(Connection connection) {
        this.dba.setConnection(connection);
    }

    public Connection getConnection() {
        return this.dba.getConnection();
    }
}
