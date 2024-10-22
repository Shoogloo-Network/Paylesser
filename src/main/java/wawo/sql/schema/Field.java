//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.schema;

public class Field {
    private DataType dataType;
    public String name;
    public String prefixName;
    public String data;

    public Field(String name) {
        this((String)null, name, (DataType)null, (String)null);
    }

    public Field(String prefixName, String name) {
        this(prefixName, name, (DataType)null, (String)null);
    }

    public Field(String prefixName, String name, DataType fieldDataType) {
        this(prefixName, name, fieldDataType, (String)null);
    }

    public Field(String prefixName, String name, DataType fieldDataType, String data) {
        this.dataType = DataType.STRING;
        this.name = name;
        if (fieldDataType == null) {
            this.dataType = DataType.STRING;
        } else {
            this.dataType = fieldDataType;
        }

        this.prefixName = prefixName;
        this.data = data;
    }

    public String getQueryField() {
        if (this.prefixName != null && !this.prefixName.isEmpty()) {
            return this.prefixName.endsWith(".") ? this.prefixName + this.name : this.prefixName + "." + this.name;
        } else {
            return this.name;
        }
    }

    public boolean isNumberFamily() {
        return this.dataType == DataType.INT || this.dataType == DataType.FLOAT || this.dataType == DataType.LONG || this.dataType == DataType.NUMBER || this.dataType == DataType.BOOLEAN;
    }

    public boolean isDateFamily() {
        return this.dataType == DataType.DATE || this.dataType == DataType.TIMESTAMP;
    }

    public boolean isStringFamily() {
        return this.dataType == DataType.STRING || this.dataType == DataType.CLOB || this.dataType == DataType.CHAR;
    }
}
