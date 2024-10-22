//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql;

public enum Database {
    FILE("FILE"),
    ORACLE("ORACLE"),
    POSTGRES("POSTGRES"),
    MYSQL("MYSQL"),
    MICROSOFT_SQL_SERVER("MICROSOFT_SQL_SERVER"),
    DERBY("DERBY"),
    ANY_DATABASE("ANY_DATABASE");

    private String db = null;

    private Database(String database) {
        this.db = database;
    }

    public String stringValue() {
        return this.db;
    }

    public boolean equals(String dbname) {
        return this.db.equalsIgnoreCase(dbname);
    }
}
