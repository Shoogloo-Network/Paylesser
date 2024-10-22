//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql;

public abstract class SqlEscape {
    private static final String[][] myql = new String[][]{{"\\\\", "\\\\\\\\\\\\\\\\"}, {"'", "''"}, {"_", "\\\\\\\\_"}, {"%", "\\\\\\\\%"}};
    private static final String[][] oracle = new String[][]{{"\\\\", "\\\\\\\\\\\\"}, {"'", "''"}, {"_", "\\\\_"}, {"%", "\\\\%"}};

    public static String mysql(String s) {
        if (s != null) {
            String[][] var1 = myql;
            int var2 = var1.length;

            for(int var3 = 0; var3 < var2; ++var3) {
                String[] srr = var1[var3];
                s = s.replaceAll(srr[0], srr[1]);
            }
        }

        return s;
    }

    public static String oracle(String s) {
        if (s != null) {
            String[][] var1 = oracle;
            int var2 = var1.length;

            for(int var3 = 0; var3 < var2; ++var3) {
                String[] srr = var1[var3];
                s = s.replaceAll(srr[0], srr[1]);
            }
        }

        return s;
    }

    public static String postgres(String s) {
        return mysql(s);
    }

    public static String parse(String s, Database database) {
        if (Database.MYSQL == database) {
            return mysql(s);
        } else if (Database.ORACLE == database) {
            return oracle(s);
        } else {
            return Database.POSTGRES == database ? postgres(s) : mysql(s);
        }
    }

    public static String appendQuote(String str) {
        if (str != null && str.indexOf(39) >= 0) {
            str = str.replaceAll("'", "''");
        }

        return str;
    }

    private SqlEscape() {
    }
}
