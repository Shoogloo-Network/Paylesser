//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.schema;

public class Referenced {
    public String tableName;
    public String columnName;

    public Referenced() {
    }

    public String getReferencedTableColumn() {
        return this.tableName + "." + this.columnName;
    }
}
