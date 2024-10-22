//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import wawo.util.PropertyUtil;
import wawo.util.StringUtil;

public class Os {
    private static final int WRITE_BUFFER_DEFAULT = 4096;
    public static int WRITE_BUFFER = 4096;
    private static final int FILE_OBJECT = 1;
    private static final int DIR_OBJECT = 2;
    private static final int FILE_PATH = 3;
    private static final int DIR_PATH = 4;
    private static final int ALL_DIR_FILE_OBJECT = 5;
    private static final int ALL_DIR_FILE_PATH = 6;
    static final String FILE_SEPERATOR;
    static final String FILE_SEPERATOR_LIN = "/";
    static final String DEFAULT_WIN_PATH = "c:/temp/";
    static final String DEFAULT_LIN_PATH = "/usr/tmp/";
    static final String DEFAULT_WIN_NL = "\n";
    static final String DEFAULT_LIN_NL = "\r\n";
    static String TEMP_PATH;
    static String NEW_LINE;

    public static String getDefaultPath() {
        if (TEMP_PATH == null) {
            init();
        }

        return TEMP_PATH;
    }

    public static String getHomePath() {
        return System.getProperty("user.home");
    }

    public static boolean isWindows() {
        return !FILE_SEPERATOR.equals("/");
    }

    public static boolean isLinux() {
        return FILE_SEPERATOR.equals("/");
    }

    public static String getDefaultNewLine() {
        if (NEW_LINE == null) {
            init();
        }

        return NEW_LINE;
    }

    public static void makeFolders(String path) {
        if (path == null) {
            throw new NullPointerException("Given path is null.");
        } else {
            File f1 = new File(path);
            if (!f1.exists()) {
                f1.mkdirs();
            }

        }
    }

    public static boolean exists(String folderOrFile) {
        File f1 = new File(folderOrFile);
        return f1.exists();
    }

    public static boolean isReadOnly(String folderOrFile) {
        return (new File(folderOrFile)).canRead();
    }

    private static void init() {
        if (FILE_SEPERATOR.equals("/")) {
            TEMP_PATH = "/usr/tmp/";
            NEW_LINE = "\r\n";
        } else {
            TEMP_PATH = "c:/temp/";
            NEW_LINE = "\n";
        }

        makeFolders(TEMP_PATH);
    }

    public static ClassLoader getDefaultClassLoader() {
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        if (cl == null) {
            cl = Os.class.getClassLoader();
        }

        return cl;
    }

    public static Process openProgram(String program, String file) throws IOException {
        String[] commands = new String[]{program, file};
        return Runtime.getRuntime().exec(commands);
    }

    public static Process runProgram(String file) throws IOException {
        return Runtime.getRuntime().exec(file);
    }

    public static void writeln(String filePath, String data) throws IOException {
        writeData(filePath, data, true, false);
    }

    public static void writeAppend(String filePath, String data) throws IOException {
        writeData(filePath, data, false, true);
    }

    public static void write(String filePath, String data) throws IOException {
        writeData(filePath, data, false, false);
    }

    public static void write(String filePath, String data, String encoding) throws IOException {
        Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), encoding));

        try {
            ((Writer)out).write(data);
        } finally {
            ((Writer)out).close();
        }

    }

    public static void write(String filePath, String data, String encoding, boolean append) throws IOException {
        Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath, append), encoding));

        try {
            ((Writer)out).write(data);
        } finally {
            ((Writer)out).close();
        }

    }

    public static void write(String filePath, byte[] data) throws IOException {
        writeByte(filePath, data);
    }

    public static String readString(String file) throws IOException {
        return Reader.instance().getStringData(file);
    }

    public static String readString(File file) throws IOException {
        return Reader.instance().getStringData(file.getAbsolutePath());
    }

    public static String readString(String file, String encoding) throws IOException {
        return Reader.instance().getStringData(file, encoding);
    }

    public static Properties readProperties(String file) throws IOException {
        File f = new File(file);
        if (!f.exists()) {
            write(file, "");
        }

        return PropertyUtil.getProperties(file);
    }

    private static void writeData(String filePath, String data, boolean isNewLine, boolean append) throws IOException {
        wawo.io.Writer w = new wawo.io.Writer();

        try {
            w.openWriter(filePath, append);
            w.log(data, isNewLine);
        } finally {
            w.closeWriter();
        }

    }

    private static void writeByte(String filePath, byte[] data) throws IOException {
        wawo.io.Writer w = new wawo.io.Writer();
        w.openWriter(filePath);
        w.log(data);
        w.closeWriter();
    }

    public static void write(String filePath, InputStream is) throws FileNotFoundException, IOException {
        FileOutputStream fos = null;

        try {
            makeFolders(getFolderPath(filePath));
            File outFile = new File(filePath);
            fos = new FileOutputStream(outFile);
            byte[] bin = new byte[WRITE_BUFFER];

            int bread;
            while((bread = is.read(bin, 0, WRITE_BUFFER)) > -1) {
                fos.write(bin, 0, bread);
            }
        } finally {
            IoClean.close(fos, is);
        }

    }

    private static boolean del(String path, boolean isDir) {
        if (path == null) {
            throw new NullPointerException("Given path for deletion is null.");
        } else {
            File f1 = new File(path);
            if (f1.exists()) {
                if (!isDir) {
                    return f1.delete();
                }

                if (f1.isDirectory()) {
                    f1.delete();
                }
            }

            return true;
        }
    }

    public static boolean deleteFile(String path) {
        return del(path, false);
    }

    public static boolean deleteFolder(String path) {
        return del(path, true);
    }

    public static void deleteFolderFiles(String folder) {
        File f1 = new File(folder);
        File[] list = f1.listFiles();
        int i = 0;

        for(int n = list.length; i < n; ++i) {
            list[i].delete();
        }

    }

    public static int deleteFiles(String path) {
        return path == null ? 0 : recurseDelete(new File(path), 1);
    }

    public static int deleteFolders(String path) {
        int i = recurseDelete(new File(path), 1);
        deleteFolder(path);
        return i;
    }

    private static int recurseDelete(File dir, int mode) {
        int cnt = 0;
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                File[] var4 = children;
                int var5 = children.length;

                for(int var6 = 0; var6 < var5; ++var6) {
                    File f1 = var4[var6];
                    if (!f1.isDirectory()) {
                        if (mode == 1) {
                            f1.delete();
                        }

                        ++cnt;
                    } else {
                        recurseDelete(f1, mode);
                        if (mode == 1) {
                            f1.delete();
                            ++cnt;
                        }
                    }
                }
            }
        }

        return cnt;
    }

    public static List<File> findAll(String folder, String... ext) throws IOException {
        return returnFileList(true, folder, 5, true, ext);
    }

    public static List<String> findAllPaths(String folder, String... ext) throws IOException {
        return returnFileNameList(true, folder, 6, true, ext);
    }

    public static List<File> findAllFiles(String folder, String... ext) throws IOException {
        return returnFileList(true, folder, 1, true, ext);
    }

    public static List<String> findAllFilePaths(String folder, String... ext) throws IOException {
        return returnFileNameList(true, folder, 3, true, ext);
    }

    /** @deprecated */
    public static List<File> findFiles(String folder, String... ext) throws IOException {
        return returnFileList(true, folder, 1, false, ext);
    }

    /** @deprecated */
    public static List<File> findFilesIgnoreCase(String folder, String... ext) throws IOException {
        return returnFileList(true, folder, 1, true, ext);
    }

    public static List<File> findAllFolders(String folder, String... ext) throws IOException {
        return returnFileList(true, folder, 2, true, ext);
    }

    public static List<String> findAllFolderPaths(String folder, String... ext) throws IOException {
        return returnFileNameList(true, folder, 4, true, ext);
    }

    public static List<File> findImmediate(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 5, true, ext);
    }

    public static List<String> findImmediatePaths(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 6, true, ext);
    }

    public static List<File> findImmediateFiles(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 1, true, ext);
    }

    public static List<String> findImmediateFilePaths(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 3, true, ext);
    }

    /** @deprecated */
    public static List<File> findFolderFilesIgnoreCase(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 1, true, ext);
    }

    public static List<File> findImmediateFolders(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 2, true, ext);
    }

    public static List<String> findImmediateFolderPaths(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 4, true, ext);
    }

    /** @deprecated */
    public static List<File> findFolderFiles(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 1, false, ext);
    }

    /** @deprecated */
    public static List<File> findFolders(String folder, String... ext) throws IOException {
        return returnFileList(false, folder, 2, false, ext);
    }

    /** @deprecated */
    public static List<String> findFolderPathIgnoreCase(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 3, true, ext);
    }

    /** @deprecated */
    public static List<String> findFoldersPath(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 4, false, ext);
    }

    /** @deprecated */
    public static List<String> findFolderPath(String folder, String... ext) throws IOException {
        return returnFileNameList(false, folder, 3, false, ext);
    }

    private static List<String> returnFileNameList(boolean recurse, String folder, int mode, boolean ignoreCase, String... ext) throws IOException {
        List<String> fileList = new ArrayList();
        if (recurse) {
            recurseFindDir(new File(folder), fileList, mode, ignoreCase, ext);
        } else {
            findCurrentFolderList(folder, fileList, mode, ignoreCase, ext);
        }

        return fileList;
    }

    private static List<File> returnFileList(boolean recurse, String folder, int mode, boolean ignoreCase, String... ext) throws IOException {
        List<File> fileList = new ArrayList();
        if (recurse) {
            recurseFindDir(new File(folder), fileList, mode, ignoreCase, ext);
        } else {
            findCurrentFolderList(folder, fileList, mode, ignoreCase, ext);
        }

        return fileList;
    }

    private static void findCurrentFolderList(String folder, List fileList, int mode, boolean ignoreCase, String... ext) throws IOException {
        File dir = new File(folder);
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                File[] var7 = children;
                int var8 = children.length;

                for(int var9 = 0; var9 < var8; ++var9) {
                    File file = var7[var9];
                    if (!file.isDirectory()) {
                        if (StringUtil.isEmptyArray(ext)) {
                            addList(fileList, mode, file);
                        } else {
                            String[] var11 = ext;
                            int var12 = ext.length;

                            for(int var13 = 0; var13 < var12; ++var13) {
                                String s = var11[var13];
                                if (ignoreCase) {
                                    if (file.getName().toLowerCase().endsWith(s.toLowerCase())) {
                                        addList(fileList, mode, file);
                                    }
                                } else if (file.getName().endsWith(s)) {
                                    addList(fileList, mode, file);
                                }
                            }
                        }
                    } else if (mode == 4 || mode == 2 || mode == 5 || 6 == mode) {
                        addList(fileList, mode, file);
                    }
                }
            }
        }

    }

    private static void addList(List fileList, int mode, File file) throws IOException {
        if (mode != 1 && mode != 2 && 5 != mode) {
            if (mode == 3 || mode == 4 || 6 == mode) {
                fileList.add(file.getAbsolutePath());
            }
        } else {
            fileList.add(file);
        }

    }

    /** @deprecated */
    public static List<String> findPathIgnoreCase(String folder, String... ext) throws IOException {
        return returnFileNameList(true, folder, 3, true, ext);
    }

    /** @deprecated */
    public static List<String> findPath(String folder, String... ext) throws IOException {
        return returnFileNameList(true, folder, 3, false, ext);
    }

    private static void recurseFindDir(File dir, List fileList, int mode, boolean ignoreCase, String... ext) throws IOException {
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                File[] var6 = children;
                int var7 = children.length;

                for(int var8 = 0; var8 < var7; ++var8) {
                    File file = var6[var8];
                    if (!file.isDirectory()) {
                        if (StringUtil.isEmptyArray(ext)) {
                            addList(fileList, mode, file);
                        } else {
                            String[] var10 = ext;
                            int var11 = ext.length;

                            for(int var12 = 0; var12 < var11; ++var12) {
                                String s = var10[var12];
                                if (ignoreCase) {
                                    if (file.getName().toLowerCase().endsWith(s.toLowerCase())) {
                                        addList(fileList, mode, file);
                                    }
                                } else if (file.getName().endsWith(s)) {
                                    addList(fileList, mode, file);
                                }
                            }
                        }
                    } else {
                        if (mode == 4 || mode == 2 || mode == 5 || 6 == mode) {
                            addList(fileList, mode, file);
                        }

                        recurseFindDir(file, fileList, mode, ignoreCase, ext);
                    }
                }
            }
        }

    }

    public static String getSuffixPath(String sourcePath, String sourceFilePath) {
        return sourceFilePath.substring(sourcePath.length());
    }

    public static String getRevisePath(String sourcePath, String sourceFilePath, String destinationPath) {
        return destinationPath + getSuffixPath(sourcePath, sourceFilePath);
    }

    public static String getFolderPath(String filePath) {
        filePath = filePath.replace("\\", "/");
        return filePath.substring(0, filePath.lastIndexOf(47) + 1);
    }

    /** @deprecated */
    public static int copyFolderIgnoreFilterFiles(String fromFolder, String toFolder, String... extFilters) throws IOException {
        return recurseCopyDir(fromFolder, toFolder, new File(fromFolder), true, false, extFilters);
    }

    public static int copyFolderIgnoreFiltered(String fromFolder, String toFolder, String... extFilters) throws IOException {
        return recurseCopyDir(fromFolder, toFolder, new File(fromFolder), true, false, extFilters);
    }

    public static int copyFolderModified(String fromFolder, String toFolder, String... ext) throws IOException {
        return recurseCopyDir(fromFolder, toFolder, new File(fromFolder), true, ext);
    }

    public static int copyFolder(String fromFolder, String toFolder, String... ext) throws IOException {
        return recurseCopyDir(fromFolder, toFolder, new File(fromFolder), false, ext);
    }

    private static int recurseCopyDir(String fromFolder, String toFolder, File dir, boolean onlyModified, String... ext) throws IOException {
        return recurseCopyDir(fromFolder, toFolder, dir, onlyModified, true, ext);
    }

    private static int recurseCopyDir(String fromFolder, String toFolder, File dir, boolean onlyModified, boolean isGivenExt, String... ext) throws IOException {
        int cnt = 0;
        fromFolder = fromFolder.replaceAll("//", "/");
        toFolder = toFolder.replaceAll("//", "/");
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                int i = 0;

                for(int n = children.length; i < n; ++i) {
                    File f1 = children[i];
                    String path;
                    String revisePath;
                    if (f1.isDirectory()) {
                        path = f1.getAbsolutePath();
                        revisePath = getRevisePath(fromFolder, path, toFolder);
                        makeFolders(revisePath);
                        recurseCopyDir(fromFolder, toFolder, f1, onlyModified, isGivenExt, ext);
                        ++cnt;
                    } else {
                        path = f1.getAbsolutePath();
                        revisePath = getRevisePath(fromFolder, path, toFolder);
                        if (StringUtil.isEmptyArray(ext)) {
                            copy(path, revisePath, true, onlyModified);
                            ++cnt;
                        } else {
                            int var15;
                            if (isGivenExt) {
                                String[] var18 = ext;
                                int var19 = ext.length;

                                for(var15 = 0; var15 < var19; ++var15) {
                                    String s = var18[var15];
                                    if (path.endsWith(s)) {
                                        copy(path, revisePath, true, onlyModified);
                                        ++cnt;
                                        break;
                                    }
                                }
                            } else {
                                boolean copy = true;
                                String[] var14 = ext;
                                var15 = ext.length;

                                for(int var16 = 0; var16 < var15; ++var16) {
                                    String s = var14[var16];
                                    if (path.endsWith(s)) {
                                        copy = false;
                                        break;
                                    }
                                }

                                if (copy) {
                                    ++cnt;
                                    copy(path, revisePath, true, onlyModified);
                                }
                            }
                        }
                    }
                }
            }
        }

        return cnt;
    }

    public static void copyFileModified(String from, String to) throws IOException {
        copy(from, to, true, true);
    }

    public static void copyFile(String from, String to, boolean overwrite) throws IOException {
        copy(from, to, overwrite, false);
    }

    public static void copyFile(String from, String to) throws IOException {
        copy(from, to, true, false);
    }

    private static void copy(String from, String to, boolean overwrite, boolean onlyModified) throws IOException {
        File f1 = new File(from);
        File f2 = new File(to);
        if (!from.toLowerCase().endsWith("thumbs.db")) {
            if (!onlyModified) {
                copyFinal(f1, f2, overwrite);
            } else if (!isFileTheSame(f1, f2)) {
                copyFinal(f1, f2, overwrite, true);
            }

        }
    }

    private static void copyFinal(File src, File dst, boolean overwrite) throws IOException {
        copyFinal(src, dst, overwrite, false);
    }

    private static void copyFinal(File src, File dst, boolean overwrite, boolean copyLastModified) throws IOException {
        if (dst.exists()) {
            if (dst.isDirectory()) {
                dst = new File(dst, src.getName());
            } else if (dst.isFile() && !overwrite) {
                return;
            }
        }

        if (!src.isDirectory()) {
            File dstParent = dst.getParentFile();
            if (!dstParent.exists() && !dstParent.mkdirs()) {
                throw new IOException("Failed to create folder " + dstParent.getAbsolutePath());
            } else {
                long fileSize = src.length();
                FileInputStream in;
                FileOutputStream out;
                if (fileSize > 20971520L) {
                    in = null;
                    out = null;

                    try {
                        in = new FileInputStream(src);
                        out = new FileOutputStream(dst);
                        int bufSize = '耀';
                        byte[] buf = new byte[bufSize];

                        int doneCnt;
                        while((doneCnt = in.read(buf, 0, bufSize)) >= 0) {
                            out.write(buf, 0, doneCnt);
                        }

                        out.flush();
                    } finally {
                        IoClean.close(in);
                        IoClean.close(out);
                    }
                } else {
                    in = null;
                    out = null;
//                    FileChannel in = null;
//                    FileChannel out = null;

                    try {
                        in = new FileInputStream(src);
                        out = new FileOutputStream(dst);
                   //     in = in.getChannel();
                   //     out = out.getChannel();
                        long offs = 0L;
                        long copyCnt = Math.min(65536L, fileSize);

//                        do {
//                            long doneCnt = in.transferTo(offs, copyCnt, out);
//                            offs += doneCnt;
//                            fileSize -= doneCnt;
//                        } while(fileSize > 0L);
                    } finally {
                        IoClean.close(in);
                        IoClean.close(out);
                        IoClean.close(in);
                        IoClean.close(out);
                    }
                }

                if (copyLastModified) {
                    dst.setLastModified(src.lastModified());
                }

            }
        }
    }

    private static boolean isFileTheSame(File oldFile, File file) {
        if (oldFile.exists() && file.exists()) {
            if (!file.isDirectory() && oldFile.length() != file.length()) {
                return false;
            } else {
                boolean b = oldFile.lastModified() == file.lastModified();
                return b;
            }
        } else {
            return false;
        }
    }

    public static boolean renameFile(String from, String to) {
        File f1 = new File(from);
        return f1.renameTo(new File(to));
    }

    public static boolean moveFile(String fromFile, String toDir) throws IOException {
        return moveFile(fromFile, toDir, false);
    }

    public static boolean moveFile(String fromFile, String toDir, boolean replace) throws IOException {
        File from = new File(fromFile);
        File to = new File(toDir);
        String toPath = toDir;
        if (to.isDirectory() && !from.isDirectory()) {
            toPath = toDir + from.getName();
        }

        if (replace) {
            File f = new File(toPath);
            if (f.exists() && !f.isDirectory()) {
                f.delete();
            }
        }

        boolean success = from.renameTo(new File(toPath));
        return success ? true : true;
    }

    public static void renameExt(String folder, String currentExt, String newExt) throws IOException {
        File f1 = new File(f(folder));
        File[] f2;
        if (currentExt != null && !currentExt.equals("*")) {
            FilenameFilter filteredFiles = new FileFilterExt(currentExt);
            f2 = f1.listFiles(filteredFiles);
        } else {
            f2 = f1.listFiles();
        }

        if (f2 != null) {
            int i = 0;

            for(int n = f2.length; i < n; ++i) {
                File f = f2[i];
                String path = f.getAbsolutePath();
                int len = path.lastIndexOf(46);
                if (len == -1) {
                    len = path.length();
                }

                path = path.substring(0, len) + "." + newExt;
                f2[i].renameTo(new File(path));
            }
        }

    }

    private static String f(String d) {
        if (!d.endsWith("\\") && !d.endsWith("/")) {
            d = d + File.separator;
        }

        return d;
    }

    private Os() {
    }

    static {
        FILE_SEPERATOR = File.separator;
        TEMP_PATH = null;
        NEW_LINE = null;
    }
}
