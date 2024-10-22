//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.channels.FileChannel;
import java.util.zip.ZipOutputStream;

public class IoClean {
    public static void close(FileOutputStream fos, InputStream is) {
        close(fos);
        close(is);
    }

    public static void close(FileOutputStream fos, OutputStreamWriter osw) {
        close(fos);
        close(osw);
    }

    public static void close(FileInputStream fis, InputStreamReader isr) {
        close(fis);
        close(isr);
    }

    public static void close(BufferedReader br) {
        if (br != null) {
            try {
                br.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(BufferedInputStream bis) {
        if (bis != null) {
            try {
                bis.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(BufferedWriter bw) {
        if (bw != null) {
            try {
                bw.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(InputStreamReader isr) {
        if (isr != null) {
            try {
                isr.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(OutputStreamWriter osw) {
        if (osw != null) {
            try {
                osw.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(OutputStream os) {
        if (os != null) {
            try {
                os.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(InputStream is) {
        if (is != null) {
            try {
                is.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(FileInputStream fis) {
        if (fis != null) {
            try {
                fis.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(FileOutputStream fos) {
        if (fos != null) {
            try {
                fos.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(FileChannel fc) {
        if (fc != null) {
            try {
                fc.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    public static void close(ZipOutputStream zipout) {
        if (zipout != null) {
            try {
                zipout.closeEntry();
                zipout.finish();
                zipout.close();
            } catch (IOException var2) {
                IOException ex = var2;
                IoLog.warn((String)null, ex);
            }
        }

    }

    private IoClean() {
    }
}
