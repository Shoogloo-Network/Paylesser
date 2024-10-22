//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.schema;

import java.util.List;
import wawo.sql.format.Format;
import wawo.util.StringUtil;

public class Column {
    private String tableName;
    private String columnName;
    private String columnDefault;
    private String columnComment;
    private String columnDataType;
    private String nativeDataType;
    private int decimalDigits;
    private int columnSize = 0;
    private boolean isPrimarykey = false;
    private boolean isForeignKey = false;
    private Column foreignKeyColumn;
    private boolean nullable = true;
    private List<Referenced> exportedColumnList;
    private DataType dataType = null;
    private DataType nativeType = null;
    private String columnData;
    private String fkDeleteRule;
    private Format inputFormat;

    public Column() {
    }

    public DataType getNativeType() {
        if (this.nativeType == null) {
            this.nativeType = getDataType(this.getNativeDataType());
        }

        return this.nativeType;
    }

    public DataType getDataType() {
        if (this.dataType == null) {
            this.dataType = getDataType(this.getColumnDataType());
        }

        return this.dataType;
    }

    public static DataType getDataType(String columnDataType) {
        if (columnDataType == null) {
            return DataType.STRING;
        } else {
            columnDataType = columnDataType.toLowerCase();
            if (!columnDataType.startsWith("int") && !columnDataType.startsWith("smallint") && !columnDataType.startsWith("bit")) {
                if (columnDataType.startsWith("tinyint")) {
                    return DataType.BOOLEAN;
                } else if (columnDataType.startsWith("num")) {
                    return DataType.NUMBER;
                } else if (columnDataType.startsWith("float")) {
                    return DataType.FLOAT;
                } else if (columnDataType.startsWith("clob")) {
                    return DataType.CLOB;
                } else if (columnDataType.startsWith("blob")) {
                    return DataType.BLOB;
                } else if (columnDataType.startsWith("date")) {
                    return DataType.DATE;
                } else if (columnDataType.startsWith("time")) {
                    return DataType.TIMESTAMP;
                } else if (columnDataType.startsWith("long")) {
                    return DataType.LONG;
                } else {
                    return columnDataType.equals("char") ? DataType.CHAR : DataType.STRING;
                }
            } else {
                return DataType.INT;
            }
        }
    }

    public String getJavaDataType() {
        return this.getJavaDataType(this.getColumnDataType());
    }

    public String getJavaDataType(String columnDataType) {
        columnDataType = columnDataType.toLowerCase();
        if (!columnDataType.startsWith("int") && !columnDataType.startsWith("num") && !columnDataType.startsWith("bit")) {
            if (columnDataType.startsWith("tinyint")) {
                return "Boolean";
            } else if (columnDataType.startsWith("smallint")) {
                return "Short";
            } else {
                return !columnDataType.startsWith("date") && !columnDataType.startsWith("time") ? "String" : "java.util.Date";
            }
        } else {
            return "Integer";
        }
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnName() {
        return this.columnName;
    }

    public void setColumnDataType(String columnDataType) {
        this.columnDataType = columnDataType;
        this.dataType = null;
    }

    public String getColumnDataType() {
        return this.columnDataType;
    }

    public void setPrimarykey(boolean isPrimarykey) {
        this.isPrimarykey = isPrimarykey;
    }

    public boolean isPrimarykey() {
        return this.isPrimarykey;
    }

    public void setForeignKey(boolean isForeignKey) {
        this.isForeignKey = isForeignKey;
    }

    public boolean isForeignKey() {
        return this.isForeignKey;
    }

    public void setColumnSize(int columnSize) {
        this.columnSize = columnSize;
    }

    public int getColumnSize() {
        return this.columnSize;
    }

    public void setNullable(boolean nullable) {
        this.nullable = nullable;
    }

    public boolean isNullable() {
        return this.nullable;
    }

    public void setTableName(String param) {
        this.tableName = param;
    }

    public String getTableName() {
        return this.tableName;
    }

    public void setForeignKeyColumnInfo(Column param) {
        this.foreignKeyColumn = param;
    }

    public Column getForeignKeyColumnInfo() {
        return this.foreignKeyColumn;
    }

    public void setReferencedList(List<Referenced> referencedList) {
        this.exportedColumnList = referencedList;
    }

    public List<Referenced> getReferencedList() {
        return this.exportedColumnList;
    }

    public void setColumnData(String columnData) {
        this.columnData = columnData;
    }

    public String getColumnData() {
        return this.columnData;
    }

    public void setNativeDataType(String nativeDataType) {
        this.nativeDataType = nativeDataType;
    }

    public String getNativeDataType() {
        return this.nativeDataType;
    }

    public void setDecimalDigits(int decimalDigits) {
        this.decimalDigits = decimalDigits;
    }

    public int getDecimalDigits() {
        return this.decimalDigits;
    }

    public void setColumnDefault(String columnDefault) {
        if (columnDefault != null) {
            columnDefault = columnDefault.trim();
        }

        this.columnDefault = columnDefault;
    }

    public String getColumnDefault() {
        return this.columnDefault == null ? "" : this.columnDefault;
    }

    public void setColumnComment(String columnComment) {
        if (columnComment != null) {
            columnComment = columnComment.trim();
        }

        this.columnComment = columnComment;
    }

    public String getColumnComment() {
        return this.columnComment == null ? "" : this.columnComment;
    }

    public void setFkDeleteRule(String fkDeleteRule) {
        this.fkDeleteRule = fkDeleteRule;
    }

    public String getFkDeleteRule() {
        return this.fkDeleteRule == null ? "" : this.fkDeleteRule;
    }

    public Format getInputFormat() {
        return this.inputFormat;
    }

    public void setInputFormat(Format inputFormat) {
        this.inputFormat = inputFormat;
    }

}
