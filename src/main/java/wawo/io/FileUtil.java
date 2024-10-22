//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import javax.imageio.ImageIO;

public class FileUtil {
    private FileUtil() {
    }

    public static String getFileFolder(String filePath) {
        if (filePath == null) {
            return null;
        } else {
            String p = formatToUnix(filePath);
            if (p.endsWith("/")) {
                p = p.substring(0, p.length() - 1);
            }

            return filePath.substring(0, p.lastIndexOf(47) + 1);
        }
    }

    public static String getFileNameOnly(String filePath) {
        return processFileName(filePath, true);
    }

    public static String getFileNameWithExt(String filePath) {
        return processFileName(filePath, false);
    }

    private static String processFileName(String filePath, boolean isFileNameOnly) {
        if (filePath == null) {
            return null;
        } else {
            String p = formatToUnix(filePath);
            int dot = p.lastIndexOf(46);
            if (isFileNameOnly && dot > 0) {
                String s = p.substring(dot + 1);
                if (s.indexOf(47) >= 0) {
                    dot = filePath.length();
                    processFileName(s, isFileNameOnly);
                }

                return filePath.substring(p.lastIndexOf(47) + 1, dot);
            } else {
                return filePath.substring(p.lastIndexOf(47) + 1, p.length());
            }
        }
    }

    public static String getFileExtWithDot(String filePath) {
        return processFileExt(filePath, 0);
    }

    public static String getFileExtWithOutDot(String filePath) {
        return processFileExt(filePath, 1);
    }

    private static String processFileExt(String filePath, int isDot) {
        if (filePath == null) {
            return null;
        } else {
            int len = filePath.lastIndexOf(46);
            if (len > 0) {
                String s = filePath.substring(len + isDot, filePath.length());
                len = formatToUnix(s).lastIndexOf(47);
                return len > 0 ? s.substring(len + 1, s.length()) : s;
            } else {
                return null;
            }
        }
    }

    public static String formatToUnix(String filePath) {
        return filePath == null ? null : filePath.replace('\\', '/');
    }

    public static String formatForSave(String filePath) {
        String _filePath = getFileFolder(filePath);
        Os.makeFolders(_filePath);
        return formatToUnix(filePath);
    }

    public static String formatToDateTimeName(String fileName) {
        return formatToDateTimeName(fileName, "ddMMyyyyHHmmss", "_");
    }

    public static String formatToDateTimeName(String fileName, String suffix) {
        return formatToDateTimeName(fileName, "ddMMyyyyHHmmss", suffix);
    }

    public static String formatToSuffixName(String fileName, String suffix) {
        return formatToDateTimeName(fileName, (String)null, suffix);
    }

    public static String addEndingSlash(String path) {
        if (path == null) {
            return null;
        } else {
            if (!path.endsWith("\\") && !path.endsWith("/")) {
                path = path + File.separator;
            }

            return path;
        }
    }

    public static String formatToDateTimeName(String fileName, String format, String suffix) {
        if (format != null) {
            format = (new SimpleDateFormat(format)).format(new Date());
        } else {
            format = "";
        }

        if (fileName == null) {
            fileName = "";
        }

        int end = fileName.lastIndexOf(46);
        return end > 0 ? fileName.substring(0, end) + suffix + format + fileName.substring(end, fileName.length()) : fileName + suffix + format;
    }

    public static String formatToUniqueName(String fileName) {
        return formatToUniqueName(fileName, "");
    }

    public static String formatToUniqueName(String fileName, String suffix) {
        if (fileName == null) {
            fileName = "";
        }

        int end = fileName.lastIndexOf(46);
        return end > 0 ? fileName.substring(0, end) + suffix + System.currentTimeMillis() + fileName.substring(end, fileName.length()) : fileName + suffix + System.currentTimeMillis();
    }

    public static File[] getSortFile(File dir, SortBy sortProperty) {
        File[] entry = dir.listFiles();
        Arrays.sort(entry, new FileComparator(sortProperty));
        return entry;
    }

    public static File[] sortFile(File[] dirs, SortBy sortProperty) {
        Arrays.sort(dirs, new FileComparator(sortProperty));
        return dirs;
    }

    public static String getClassFolder(Class clz) {
        URL location = clz.getProtectionDomain().getCodeSource().getLocation();
        return location.getPath();
    }

    public static void imageThumb(String originalFile, String thumbnailFile, int thumbWidth, int thumbHeight, int quality) throws IOException {
        formatForSave(originalFile);
        formatForSave(thumbnailFile);
        String file = originalFile.toLowerCase();
        if (!file.endsWith(".jpg") && !file.endsWith(".jpeg") && !file.endsWith(".gif") && !file.endsWith(".png") && !file.endsWith(".bmp") && !file.endsWith(".jpe") && !file.endsWith(".tif") && !file.endsWith(".tiff")) {
            throw new IOException("Error: Unsupported image type, please only either JPG, GIF or PNG, BMP, TIF");
        } else {
            Image image = ImageIO.read(new File(originalFile));
            double thumbRatio = (double)thumbWidth / (double)thumbHeight;
            int imageWidth = ((Image)image).getWidth((ImageObserver)null);
            int imageHeight = ((Image)image).getHeight((ImageObserver)null);
            double imageRatio = (double)imageWidth / (double)imageHeight;
            if (thumbRatio < imageRatio) {
                thumbHeight = (int)((double)thumbWidth / imageRatio);
            } else {
                thumbWidth = (int)((double)thumbHeight * imageRatio);
            }

            if (imageWidth < thumbWidth && imageHeight < thumbHeight) {
                thumbWidth = imageWidth;
                thumbHeight = imageHeight;
            } else if (imageWidth < thumbWidth) {
                thumbWidth = imageWidth;
            } else if (imageHeight < thumbHeight) {
                thumbHeight = imageHeight;
            }

            BufferedImage thumbImage = new BufferedImage(thumbWidth, thumbHeight, 1);
            Graphics2D graphics2D = thumbImage.createGraphics();
            graphics2D.setBackground(Color.WHITE);
            graphics2D.setPaint(Color.WHITE);
            graphics2D.fillRect(0, 0, thumbWidth, thumbHeight);
            graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            graphics2D.drawImage(image, 0, 0, thumbWidth, thumbHeight, (ImageObserver)null);
            ImageIO.write(thumbImage, "JPG", new File(thumbnailFile));
        }
    }
}
