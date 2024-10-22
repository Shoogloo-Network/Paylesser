//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.db;

import java.sql.SQLException;
import wawo.tool.sql.LeakFinder;

public class LeakTest {
    public LeakTest() {
    }

    public static void main(String[] args) throws SQLException, Exception {
        LeakFinder lf = new LeakFinder();
        lf.setRecurse(true);
        lf.setReportSavePath("D:/projects/vcpublic/src/main/java/");
        lf.findLeaks("D:/projects/vcpublic/src/main/", new String[]{".jsp", ".java"});
    }
}
