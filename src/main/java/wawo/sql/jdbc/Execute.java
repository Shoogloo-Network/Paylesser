//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.SQLException;
import wawo.sql.DataBaseException;

public interface Execute {
    void close();

    int ddl(String var1);

    long insert(String var1, Object[] var2);

    long update(String var1, Object[] var2);

    long delete(String var1, Object[] var2);

    long insert(String var1, Object[] var2, String var3);

    long insertOrUpdate(String var1, Object[] var2, String var3);

    long updateInLoop(String var1, Object[] var2) throws DataBaseException;

    long deleteInLoop(String var1, Object[] var2) throws DataBaseException;

    long insertInLoop(String var1, Object[] var2, String var3) throws DataBaseException;

    int plsql(String var1, Object[] var2) throws DataBaseException;

    void begin() throws SQLException;

    void commit() throws SQLException;

    void rollback() throws SQLException;

    boolean isTransactionStarted();
}
