//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.filter;

import java.util.HashMap;
import java.util.Map;
import wawo.sql.schema.DataType;
import wawo.sql.schema.Field;

public class Format {
    private Map<String, Field> columnFormatterMap;
    private String defaultAlias;
    private DataType defaultDataType;

    public Format() {
        this.columnFormatterMap = null;
        this.defaultAlias = "";
        this.defaultDataType = DataType.STRING;
    }

    public Format(String defaultAlias) {
        this.columnFormatterMap = null;
        this.defaultAlias = "";
        this.defaultDataType = DataType.STRING;
        this.defaultAlias = defaultAlias;
    }

    public Format(String defaultAlias, DataType defaultDataType) {
        this(defaultAlias);
        this.defaultDataType = defaultDataType;
    }

    protected Map<String, Field> getColumnFormatterMap() {
        return this.columnFormatterMap;
    }

    public void add(String column) {
        this.add(this.getDefaultAlias(), column);
    }

    public void add(String column, DataType dataType) {
        this.add(this.getDefaultAlias(), column, dataType);
    }

    public void add(String prefix, String column) {
        this.add(prefix, column, this.getDefaultDataType());
    }

    public void add(String prefix, String column, DataType dataType) {
        if (this.columnFormatterMap == null) {
            this.columnFormatterMap = new HashMap();
        }

        if (prefix != null && prefix.isEmpty()) {
            this.columnFormatterMap.put(prefix + "." + column, new Field(prefix, column, dataType));
        } else {
            this.columnFormatterMap.put(column, new Field(prefix, column, dataType));
        }

    }

    public void setDefaultAlias(String defaultAlias) {
        this.defaultAlias = defaultAlias;
    }

    public String getDefaultAlias() {
        return this.defaultAlias;
    }

    public void setDefaultDataType(DataType defaultDataType) {
        this.defaultDataType = defaultDataType;
    }

    public DataType getDefaultDataType() {
        return this.defaultDataType;
    }
}
