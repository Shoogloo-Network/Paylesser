//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import wawo.sql.filter.Query;

public interface Select {
    void setTypeScroll(int var1);

    PreparedStatement getPreparedStatement(String var1);

    ResultSet resultSetLazy(Query var1);

    ResultSet resultSet(String var1, Object[] var2);

    boolean exist(String var1, Object[] var2);

    long count(String var1, Object[] var2);

    String first(String var1, Object[] var2);

    List listFirst(String var1, Object[] var2);

    void clean();

    void destroy();

    ResultSet resultSetInLoop(String var1, Object[] var2);
}
