//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.File;
import java.util.Comparator;

public class FileComparator implements Comparator {
    private SortBy sortBy;

    FileComparator() {
        this.sortBy = SortBy.NAME_ASC;
    }

    public FileComparator(SortBy sortBy) {
        this.sortBy = sortBy;
    }

    public void setSortBy(SortBy sortBy) {
        this.sortBy = sortBy;
    }

    public int compare(Object o1, Object o2) {
        File f1 = (File)o1;
        File f2 = (File)o2;
        if (f1.isDirectory()) {
            if (f2.isDirectory()) {
                return switch (this.sortBy) {
                    case NAME_ASC -> f1.getAbsolutePath().toUpperCase().compareTo(f2.getAbsolutePath().toUpperCase());
                    case SIZE_ASC -> (Long.valueOf(f1.length())).compareTo(Long.valueOf(f2.length()));
                    case DATE_MODIFIED_ASC ->
                            (Long.valueOf(f1.lastModified())).compareTo(Long.valueOf(f2.lastModified()));
                    case EXT_ASC -> f1.getAbsolutePath().toUpperCase().compareTo(f2.getAbsolutePath().toUpperCase());
                    case PATH_ASC -> f1.getAbsolutePath().toUpperCase().compareTo(f2.getAbsolutePath().toUpperCase());
                    case DATE_MODIFIED_DESC ->
                            (Long.valueOf(f2.lastModified())).compareTo(Long.valueOf(f1.lastModified()));
                    case NAME_DESC -> f2.getAbsolutePath().toUpperCase().compareTo(f1.getAbsolutePath().toUpperCase());
                    case SIZE_DESC -> (Long.valueOf(f2.length())).compareTo(Long.valueOf(f1.length()));
                    case EXT_DESC -> f2.getAbsolutePath().toUpperCase().compareTo(f1.getAbsolutePath().toUpperCase());
                    case PATH_DESC -> f2.getAbsolutePath().toUpperCase().compareTo(f1.getAbsolutePath().toUpperCase());
                    default -> 1;
                };
            } else {
                return -1;
            }
        } else if (f2.isDirectory()) {
            return 1;
        } else {
            switch (this.sortBy) {
                case NAME_ASC:
                    return f1.getAbsolutePath().toUpperCase().compareTo(f2.getAbsolutePath().toUpperCase());
                case SIZE_ASC:
                    return (Long.valueOf(f1.length())).compareTo(Long.valueOf(f2.length()));
                case DATE_MODIFIED_ASC:
                    return (Long.valueOf(f1.lastModified())).compareTo(Long.valueOf(f2.lastModified()));
                case EXT_ASC:
                    return this.ext(f1.getAbsolutePath().toUpperCase(), f2.getAbsolutePath().toUpperCase());
                case PATH_ASC:
                default:
                    return 1;
                case DATE_MODIFIED_DESC:
                    return (Long.valueOf(f2.lastModified())).compareTo(Long.valueOf(f1.lastModified()));
                case NAME_DESC:
                    return f2.getAbsolutePath().toUpperCase().compareTo(f1.getAbsolutePath().toUpperCase());
                case SIZE_DESC:
                    return (Long.valueOf(f2.length())).compareTo(Long.valueOf(f1.length()));
                case EXT_DESC:
                    return this.ext(f2.getAbsolutePath().toUpperCase(), f1.getAbsolutePath().toUpperCase());
            }
        }
    }

    private int ext(String fp1, String fp2) {
        int tempIndexf1 = fp1.lastIndexOf(46);
        int tempIndexf2 = fp2.lastIndexOf(46);
        if (tempIndexf1 == -1 && tempIndexf2 == -1) {
            return fp1.compareTo(fp2);
        } else if (tempIndexf1 == -1) {
            return -1;
        } else if (tempIndexf2 == -1) {
            return 1;
        } else {
            String tempEndf1 = fp1.substring(tempIndexf1);
            String tempEndf2 = fp2.substring(tempIndexf2);
            return tempEndf1.compareTo(tempEndf2);
        }
    }
}
