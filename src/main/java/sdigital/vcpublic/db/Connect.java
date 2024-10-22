//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.db;

import wawo.sql.ConnectorDs;
import wawo.sql.Database;
import wawo.sql.jdbc.Db;
import wawo.sql.schema.ConnectionInfo;

public class Connect {
    static ConnectionInfo ci;

    public Connect() {
    }

    public static Db newDb() {
        return new Db(new ConnectorDs("java:/comp/env/jdbc/vcPublicDS", Database.POSTGRES));
    }

    public static void close(Db db) {
        if (db != null) {
            db.close();
        }

    }
}
