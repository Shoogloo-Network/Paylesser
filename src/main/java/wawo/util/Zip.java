//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;
import wawo.io.FileUtil;
import wawo.io.IoClean;
import wawo.io.Os;

public class Zip {
    public static List<String> zipListExist(String destFolder, String zipFile, String... ext) throws IOException {
        ZipFile zf = new ZipFile(zipFile);
        List<String> zipList = new ArrayList();
        Enumeration enumeration = zf.entries();

        try {
            while(enumeration.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry)enumeration.nextElement();
                String zipFileName = zipEntry.getName();
                zipFileName = zipFileName.replace('\\', '/');
                if (!zipFileName.endsWith("/")) {
                    String file = destFolder + zipFileName;
                    if (StringUtil.isEmptyArray(ext)) {
                        zipList.add(file);
                    } else if (Os.exists(file)) {
                        String[] var9 = ext;
                        int var10 = ext.length;

                        for(int var11 = 0; var11 < var10; ++var11) {
                            String s = var9[var11];
                            if (file.endsWith(s)) {
                                zipList.add(file);
                            }
                        }
                    }
                }
            }
        } finally {
            if (zf != null) {
                zf.close();
            }

        }

        return zipList;
    }

    public static List<String> zipList(String unZipToDir, String zipFile, String... ext) throws IOException {
        ZipFile zf = new ZipFile(zipFile);
        List<String> zipList = new ArrayList();
        Enumeration enumeration = zf.entries();

        try {
            while(enumeration.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry)enumeration.nextElement();
                String zipFileName = zipEntry.getName();
                zipFileName = zipFileName.replace('\\', '/');
                if (!zipFileName.endsWith("/")) {
                    String file = unZipToDir + zipFileName;
                    if (StringUtil.isEmptyArray(ext)) {
                        zipList.add(file);
                    } else {
                        String[] var9 = ext;
                        int var10 = ext.length;

                        for(int var11 = 0; var11 < var10; ++var11) {
                            String s = var9[var11];
                            if (file.endsWith(s)) {
                                zipList.add(file);
                            }
                        }
                    }
                }
            }
        } finally {
            if (zf != null) {
                zf.close();
            }

        }

        return zipList;
    }

    public static void unZip(String unZipToDir, String zipFile) throws IOException {
        ZipFile zf = new ZipFile(zipFile);
        Enumeration enumeration = zf.entries();

        try {
            while(enumeration.hasMoreElements()) {
                ZipEntry zipEntry = (ZipEntry)enumeration.nextElement();
                String zipFileName = zipEntry.getName().replace('\\', '/');
                if (zipEntry.isDirectory()) {
                    Os.makeFolders(unZipToDir + "/" + zipFileName);
                }

                if (!zipFileName.endsWith("/")) {
                    Os.write(unZipToDir + zipFileName, zf.getInputStream(zipEntry));
                }
            }
        } finally {
            if (zf != null) {
                zf.close();
            }

        }

    }

    public static void zipFolder(String fromFolder, String toZipFile, String... filter) throws IOException {
        List<String> allFiles = Os.findAllPaths(fromFolder, filter);
        zipFilePaths(allFiles, fromFolder, toZipFile);
    }

    public static void zipFiles(List<File> filesToZip, String fromFolder, String toZipFile) throws FileNotFoundException, IOException {
        toZipFile = FileUtil.formatForSave(toZipFile);
        File fFromFolder = new File(fromFolder);
        int fromFolderLen = fFromFolder.getAbsolutePath().length();
        byte[] buf = new byte[14096];
        ZipOutputStream zipout = null;
        BufferedInputStream bis = null;
        FileInputStream fis = null;
        FileOutputStream fos = null;
        StringBuilder name = new StringBuilder();

        try {
            fos = new FileOutputStream(toZipFile);
            zipout = new ZipOutputStream(fos);
            zipout.setComment("Created using Wawo api.");

            for(Iterator var12 = filesToZip.iterator(); var12.hasNext(); zipout.closeEntry()) {
                File f = (File)var12.next();
                name.setLength(0);
                name.append(f.getAbsolutePath().substring(fromFolderLen + 1));
                if (f.isDirectory()) {
                    name.append("/");
                }

                ZipEntry zipEntry = new ZipEntry(name.toString().replace('\\', '/'));
                zipout.putNextEntry(zipEntry);
                if (f.canRead() && !f.isDirectory()) {
                    fis = new FileInputStream(f);
                    bis = new BufferedInputStream(fis);

                    int len;
                    while((len = bis.read(buf)) > 0) {
                        zipout.write(buf, 0, len);
                    }

                    IoClean.close(bis);
                    IoClean.close(fis);
                }
            }
        } finally {
            IoClean.close(bis);
            IoClean.close(fis);
            IoClean.close(fos);
            IoClean.close(zipout);
        }

    }

    public static void zipFilePaths(List<String> filesToZip, String fromFolder, String toZipFile) throws FileNotFoundException, IOException {
        toZipFile = FileUtil.formatForSave(toZipFile);
        File fFromFolder = new File(fromFolder);
        int fromFolderLen = fFromFolder.getAbsolutePath().length();
        byte[] buf = new byte[14096];
        ZipOutputStream zipout = null;
        BufferedInputStream bis = null;
        FileInputStream fis = null;
        FileOutputStream fos = null;
        StringBuilder name = new StringBuilder();

        try {
            fos = new FileOutputStream(toZipFile);
            zipout = new ZipOutputStream(fos);
            zipout.setComment("Created using Wawo api.");

            for(Iterator var13 = filesToZip.iterator(); var13.hasNext(); zipout.closeEntry()) {
                String file = (String)var13.next();
                name.setLength(0);
                name.append(file.substring(fromFolderLen + 1));
                File f = new File(file);
                if (f.isDirectory()) {
                    name.append("/");
                }

                ZipEntry zipEntry = new ZipEntry(name.toString().replace('\\', '/'));
                zipout.putNextEntry(zipEntry);
                if (f.canRead() && !f.isDirectory()) {
                    fis = new FileInputStream(f);
                    bis = new BufferedInputStream(fis);

                    int len;
                    while((len = bis.read(buf)) > 0) {
                        zipout.write(buf, 0, len);
                    }

                    IoClean.close(bis);
                    IoClean.close(fis);
                }
            }
        } finally {
            IoClean.close(bis);
            IoClean.close(fis);
            IoClean.close(zipout);
            IoClean.close(fos);
        }

    }

    private Zip() {
    }
}
