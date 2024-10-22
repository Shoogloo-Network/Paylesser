//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.schema;

import java.io.Serializable;
import wawo.sql.Database;

public class ConnectionInfo implements Serializable {
    private String driver = "";
    private String dburl = "";
    private String database = "";
    private String login = "";
    private String password = "";
    private String host = "";
    private String port = "";
    private boolean sid = false;

    public ConnectionInfo() {
    }

    public Database getDatabaseVendor() {
        return JdbcDriver.getDatabase(this.driver);
    }

    public String geDBUrl() {
        return this.dburl != null && this.dburl.trim().length() > 0 ? this.dburl : this.getUrl(this.driver);
    }

    private String getUrl(String driver) {
        if (driver != null && driver.trim().length() > 0) {
            if (driver.contains("oracle")) {
                if (this.port == null || this.port.length() < 0) {
                    this.port = "1521";
                }

                return this.isSid() ? "jdbc:oracle:thin:@" + this.host + ":" + this.port + ":" + this.database : "jdbc:oracle:thin:@" + this.host + ":" + this.port + "/" + this.database;
            } else if (driver.contains("postgresql")) {
                if (this.port == null || this.port.length() < 0) {
                    this.port = "5432";
                }

                return "jdbc:postgresql://" + this.host + ":" + this.port + "/" + this.database;
            } else if (driver.contains("mysql")) {
                if (this.port == null || this.port.length() < 0) {
                    this.port = "3306";
                }

                return "jdbc:mysql://" + this.host + ":" + this.port + "/" + this.database;
            } else if (driver.contains("sqlserver")) {
                if (this.port == null || this.port.length() < 0) {
                    this.port = "1433";
                }

                return "jdbc:microsoft:sqlserverl://" + this.host + ":" + this.port + "/" + this.database;
            } else if (!driver.contains("derby")) {
                throw new NoSuchFieldError("Not implemented driver  " + driver);
            } else {
                if (this.port == null || this.port.length() < 0) {
                    this.port = "1527";
                }

                return driver.equalsIgnoreCase("org.apache.derby.jdbc.EmbeddedDriver") ? "jdbc:derby:" + this.database + ";create=true" : "jdbc:derby://" + this.host + ":" + this.port + "/" + this.database + ";create=true";
            }
        } else {
            throw new NoSuchFieldError("Field Driver is null or empty");
        }
    }

    public void initDB(String login, String password, String driver, String database, String host, String port) {
        this.login = login;
        this.password = password;
        this.driver = driver;
        this.database = database;
        if (host != null && host.length() >= 0) {
            this.host = host;
        } else {
            this.host = "localhost";
        }

        this.port = port;
        this.dburl = this.getUrl(driver);
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getDriver() {
        return this.driver;
    }

    public void setDburl(String dburl) {
        if (this.driver == null || this.driver.trim().length() <= 0) {
            this.driver = JdbcDriver.getDriverFromUrl(dburl);
        }

        this.dburl = dburl;
    }

    public String getDburl() {
        return this.dburl;
    }

    public void setDatabase(String database) {
        this.database = database;
    }

    public String getDatabase() {
        return this.database;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getLogin() {
        return this.login;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return this.password;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getHost() {
        return this.host;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getPort() {
        return this.port;
    }

    public void setSid(boolean sid) {
        this.sid = sid;
    }

    public boolean isSid() {
        return this.sid;
    }
}
