//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.format;

import wawo.sql.Database;

public class FormatSequence {
    private Database database;

    public FormatSequence(Database database) {
        this.database = database;
    }

    public String seqVal(String sequenceName) {
        if (Database.ORACLE == this.database) {
            return sequenceName + ".nextval";
        } else if (Database.POSTGRES == this.database) {
            return "nextval('" + sequenceName + "')";
        } else {
            throw new UnsupportedOperationException("Not yet implemented, Database sequence is not implemented for database " + this.database);
        }
    }

    public String seqSelect(String sequenceName) {
        if (Database.ORACLE == this.database) {
            return "select " + this.seqVal(sequenceName) + " from dual";
        } else if (Database.POSTGRES == this.database) {
            return "select " + this.seqVal(sequenceName);
        } else {
            throw new UnsupportedOperationException("Not yet implemented, Database sequence is not implemented for database " + this.database);
        }
    }

    public String seqCreate(String sequenceName, int startwith) {
        if (Database.ORACLE == this.database) {
            return "create sequence " + this.seqVal(sequenceName) + " start with " + startwith + " increment by 1 ";
        } else if (Database.POSTGRES == this.database) {
            return "create sequence " + this.seqVal(sequenceName) + " start with " + startwith + " increment by 1 ";
        } else {
            throw new UnsupportedOperationException("Not yet implemented, Database sequence is not implemented for database " + this.database);
        }
    }
}
