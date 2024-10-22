//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.util.logging.Level;
import java.util.logging.Logger;

public class IoLog {
    private static final Logger logger = Logger.getLogger("wawo.io.IoLog");

    private IoLog() {
    }

    public static void fine(String m) {
        logger.log(Level.FINE, m);
    }

    public static void fatal(String m, Throwable t) {
        logger.log(Level.SEVERE, m, t);
    }

    public static void info(String m) {
        logger.log(Level.INFO, m);
    }

    public static void warn(String m) {
        logger.log(Level.WARNING, m);
    }

    public static void warn(String m, Throwable t) {
        logger.log(Level.WARNING, m, t);
    }
}
