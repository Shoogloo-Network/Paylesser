//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.jdbc;

import wawo.sql.Connector;

public class Db {
    private Connector connector = null;
    private Select select = null;
    private Execute execute = null;

    public Db(Connector connector) {
        this.connector = connector;
    }

    public Select select() {
        if (this.select == null) {
            this.select = new SelectImpl(this.connector);
        }

        return this.select;
    }

    public Execute execute() {
        if (this.execute == null) {
            this.execute = new ExecuteImpl(this.connector);
        }

        return this.execute;
    }

    public void close() {
        if (this.select != null) {
            this.select.clean();
        }

        if (this.execute != null) {
            this.execute.close();
        }

        if (this.connector != null) {
            this.connector.close();
        }

    }
}
