//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.File;
import java.io.FilenameFilter;

public class FileFilterExt implements FilenameFilter {
    private String ext = "";

    public FileFilterExt(String ext) {
        if (ext.startsWith(".")) {
            this.ext = ext;
        } else {
            this.ext = "." + ext;
        }

    }

    public boolean accept(File dir, String name) {
        return name.endsWith(this.ext);
    }
}
