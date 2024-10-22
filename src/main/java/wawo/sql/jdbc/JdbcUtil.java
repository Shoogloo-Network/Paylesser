//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class JdbcUtil {
    private static final Logger log = Logger.getLogger("wawo.sql.jdbc");

    public static void info(String message) {
        info(message, false);
    }

    public static void info(String message, boolean error) {
        if (error) {
            log.log(Level.SEVERE, message);
        }

    }

    protected static void warn(String message, Throwable t) {
        log.log(Level.WARNING, message, t);
    }

    public static void setParam(PreparedStatement pm, Object[] params) throws SQLException {
        if (params != null) {
            int i = 0;

            for(int len = params.length; i < len; ++i) {
                pm.setObject(i + 1, parseForPreparedStatement(params[i]));
            }
        }

    }

    private static Object parseForPreparedStatement(Object param) {
        StringBuilder sb;
        int i;
        int n;
        if (param instanceof String[]) {
            String[] params = (String[])((String[])param);
            sb = new StringBuilder();
            i = 0;

            for(n = params.length; i < n; ++i) {
                sb.append("'");
                sb.append(params[i]);
                sb.append("'");
                if (i < n - 1) {
                    sb.append(",");
                }
            }

            return sb.toString();
        } else if (param instanceof Integer[]) {
            Integer[] params = (Integer[])((Integer[])param);
            sb = new StringBuilder();
            i = 0;

            for(n = params.length; i < n; ++i) {
                sb.append(params[i]);
                if (i < n - 1) {
                    sb.append(",");
                }
            }

            return sb.toString();
        } else {
            return param;
        }
    }

    protected static void print(String sql, Object[] params) {
        print(sql, params, false);
    }

    protected static void print(String sql, Object[] params, boolean error) {
        StringBuilder sb = new StringBuilder();
        sb.append(sql);
        if (params == null) {
            sb.append("; no params");
        } else {
            int i = 0;

            for(int len = params.length; i < len; ++i) {
                sb.append("\n").append(i + 1).append("=").append(parseForPreparedStatement(params[i]));
            }
        }

        info(sb.toString(), error);
    }

    private JdbcUtil() {
    }
}
