//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql;

import java.sql.Connection;

public interface Connector {
    Connection getConnection();

    String getDataSourceName();

    Database getDatabaseVendor();

    void close();
}
