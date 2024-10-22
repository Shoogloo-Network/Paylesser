//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.config;

import java.io.File;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import sdigital.vcpublic.home.VcHome;
import wawo.io.FileUtil;
import wawo.io.Os;

public class ContextListenerServlet implements ServletContextListener {
    private static final Logger log = Logger.getLogger(ContextListenerServlet.class.getName());
    public static String CONTEXT_NAME;
    public static String ROOT_PATH;
    public static String ROOT_PATH_UNIX;
    public static String CONTEXT_PATH;
    public static String CONTEXT_PATH_UNIX;

    public ContextListenerServlet() {
    }

    public void contextInitialized(ServletContextEvent servletContextEvent) {
        log.log(Level.INFO, "Started Loading Runtime Settings...");
        CONTEXT_NAME = servletContextEvent.getServletContext().getContextPath();
        String var10000 = servletContextEvent.getServletContext().getRealPath("");
        ROOT_PATH = var10000 + File.separator;
        ROOT_PATH_UNIX = FileUtil.formatToUnix(ROOT_PATH);
        CONTEXT_PATH = ROOT_PATH + CONTEXT_NAME + File.separator;
        CONTEXT_PATH_UNIX = FileUtil.formatToUnix(CONTEXT_PATH);
        log.log(Level.INFO, "CONTEXT_NAME {0} ", CONTEXT_NAME);
        log.log(Level.INFO, "ROOT_PATH {0}", ROOT_PATH);
        log.log(Level.INFO, "ROOT_PATH_UNIX {0}", ROOT_PATH_UNIX);
        log.log(Level.INFO, "CONTEXT_PATH {0}", CONTEXT_PATH);
        log.log(Level.INFO, "CONTEXT_PATH_UNIX {0}", CONTEXT_PATH_UNIX);

        try {
            String path = ROOT_PATH + "WEB-INF" + File.separator + "properties" + File.separator + "sys-config.properties";
            if (Os.exists(path)) {
                log.log(Level.INFO, "Reading System properties from {0}", path);
                Properties prop = Os.readProperties(path);
                SystemConstant.load(prop, CONTEXT_NAME);
                log.log(Level.INFO, "Loaded system properties Ok {0}", CONTEXT_NAME);
                prop.clear();
            } else {
                log.log(Level.WARNING, "No System properties found at {0}", path);
            }

            VcHome.loadData();
        } catch (IOException var7) {
             var7 = var7;
            log.log(Level.SEVERE, "Loading system properties FAILED.", var7);
        } finally {
            ;
        }

        log.log(Level.INFO, "Succesfully Loaded Runtime Settings.");
    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        log.log(Level.INFO, "UnLoaded context in progress.");
        log.log(Level.INFO, "Succesfully UnLoaded the context.");
    }
}
