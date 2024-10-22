//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.tool.sql;

public class Found {
    private int lineNo;
    private String field;

    public Found(int lineNo, String field) {
        this.lineNo = lineNo;
        this.field = field;
    }

    public int getLineNo() {
        return this.lineNo;
    }

    public void setLineNo(int lineNo) {
        this.lineNo = lineNo;
    }

    public String getField() {
        return this.field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public boolean equals(Object obj) {
        return this.field.equalsIgnoreCase(((Found)obj).getField());
    }
}
