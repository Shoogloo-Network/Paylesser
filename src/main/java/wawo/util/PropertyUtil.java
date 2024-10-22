//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.Properties;
import wawo.io.FileUtil;
import wawo.io.IoClean;
import wawo.io.IoLog;

public class PropertyUtil {
    public static Properties getProperties(InputStream inputStream) throws IOException {
        return getProperties((InputStream)inputStream, (String)null);
    }

    public static Properties getProperties(InputStream inputStream, String encoding) throws IOException {
        Properties prop = new Properties();
        InputStreamReader insr = null;

        try {
            if (StringUtil.isEmpty(encoding)) {
                if (inputStream == null) {
                    throw new IOException("InputStream is null");
                }

                prop.load(inputStream);
            } else {
                insr = new InputStreamReader(inputStream, encoding);
                if (insr == null) {
                    throw new IOException("Unable to load Encoding=" + encoding);
                }

                prop.load(insr);
            }
        } finally {
            IoClean.close(inputStream);
            IoClean.close(insr);
        }

        return prop;
    }

    public static Properties getProperties(String fileName, String encoding) throws IOException {
        Properties prop = new Properties();
        FileInputStream is = null;
        InputStreamReader insr = null;

        try {
            if (StringUtil.isEmpty(encoding)) {
                is = new FileInputStream(fileName);
                if (is == null) {
                    throw new IOException("Unable to load property file =" + fileName);
                }

                prop.load(is);
            } else {
                insr = new InputStreamReader(is, encoding);
                if (insr == null) {
                    throw new IOException("Unable to load property file =" + fileName + " Encoding=" + encoding);
                }

                prop.load(insr);
            }
        } catch (FileNotFoundException var9) {
            IoLog.warn(fileName + " Not Found. So created an empty file");
            saveProperties(prop, fileName);
        } finally {
            IoClean.close(is, insr);
        }

        return prop;
    }

    public static Properties getProperties(String fileName) throws IOException {
        return getProperties((String)fileName, (String)null);
    }

    public static boolean saveProperties(Properties prop, String filePath) throws IOException {
        return saveProperties(prop, filePath, (String)null);
    }

    public static boolean saveProperties(Properties prop, String filePath, String encoding) throws IOException {
        OutputStreamWriter osw = null;
        FileOutputStream out = null;

        try {
            FileUtil.formatForSave(filePath);
            out = new FileOutputStream(filePath);
            if (StringUtil.isEmpty(encoding)) {
                prop.store(out, filePath);
            } else {
                osw = new OutputStreamWriter(out, encoding);
                prop.store(osw, filePath);
            }
        } finally {
            IoClean.close(out, osw);
        }

        return true;
    }

    private PropertyUtil() {
    }
}
