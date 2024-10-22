//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.schema;

import wawo.sql.Database;

public abstract class JdbcDriver {
    public static final String POSTGRES = "org.postgresql.Driver";
    public static final String ORACLE = "oracle.jdbc.OracleDriver";
    public static final String JDBCODBC = "sun.jdbc.odbc.JdbcOdbcDriver";
    public static final String MICROSOFT_SQL_SERVER = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
    public static final String MYSQL = "com.mysql.jdbc.Driver";
    public static final String DERBY = "org.apache.derby.jdbc.ClientDriver";
    public static final String DERBY_EMBEDDED = "org.apache.derby.jdbc.EmbeddedDriver";

    public JdbcDriver() {
    }

    public static Database getDatabase(String databaseDriverClass) {
        String dbDriver = databaseDriverClass.toLowerCase();
        if (!dbDriver.equals("org.postgresql.Driver") && !dbDriver.contains("postgres")) {
            if (!dbDriver.equals("oracle.jdbc.OracleDriver") && !dbDriver.contains("oracle")) {
                if (!dbDriver.equals("com.mysql.jdbc.Driver") && !dbDriver.contains("mysql")) {
                    if (!dbDriver.equals("com.microsoft.jdbc.sqlserver.SQLServerDriver") && !dbDriver.contains("sqlserver")) {
                        return !dbDriver.equals("org.apache.derby.jdbc.ClientDriver") && !dbDriver.contains("derby") ? Database.ANY_DATABASE : Database.DERBY;
                    } else {
                        return Database.MICROSOFT_SQL_SERVER;
                    }
                } else {
                    return Database.MYSQL;
                }
            } else {
                return Database.ORACLE;
            }
        } else {
            return Database.POSTGRES;
        }
    }

    public static String getDriverFromUrl(String dbUrl) {
        if (dbUrl != null && dbUrl.trim().length() > 0) {
            if (dbUrl.contains("oracle")) {
                return "oracle.jdbc.OracleDriver";
            } else if (dbUrl.contains("postgresql")) {
                return "org.postgresql.Driver";
            } else if (dbUrl.contains("mysql")) {
                return "com.mysql.jdbc.Driver";
            } else if (dbUrl.contains("sqlserver")) {
                return "com.microsoft.jdbc.sqlserver.SQLServerDriver";
            } else if (dbUrl.startsWith("jdbc:derby://")) {
                return "org.apache.derby.jdbc.ClientDriver";
            } else if (dbUrl.startsWith("jdbc:derby:")) {
                return "org.apache.derby.jdbc.EmbeddedDriver";
            } else {
                throw new NoSuchFieldError("Not implemented driver for dburl " + dbUrl);
            }
        } else {
            throw new NoSuchFieldError("dburl is null or empty");
        }
    }

    public static String getDriver(Database database) {
        if (Database.ORACLE == database) {
            return "oracle.jdbc.OracleDriver";
        } else if (Database.POSTGRES == database) {
            return "org.postgresql.Driver";
        } else if (Database.MYSQL == database) {
            return "com.mysql.jdbc.Driver";
        } else if (Database.MICROSOFT_SQL_SERVER == database) {
            return "com.microsoft.jdbc.sqlserver.SQLServerDriver";
        } else if (Database.DERBY == database) {
            return "org.apache.derby.jdbc.ClientDriver";
        } else if (Database.DERBY == database) {
            return "org.apache.derby.jdbc.EmbeddedDriver";
        } else {
            throw new NoSuchFieldError("Not implemented driver for database  " + database.stringValue());
        }
    }
}
