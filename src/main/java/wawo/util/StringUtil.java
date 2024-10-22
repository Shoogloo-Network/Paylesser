//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.util;

import java.text.FieldPosition;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

public class StringUtil {
    private static final int PAD_LIMIT = 8192;

    private StringUtil() {
    }

    protected static ClassLoader getCurrentClassLoader(Object defaultObject) {
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        if (loader == null) {
            loader = defaultObject.getClass().getClassLoader();
        }

        return loader;
    }

    public static String getMessageResourceString(String bundleName, String key, Object[] params, Locale locale) {
        if (bundleName == null) {
            StringBuilder sb = new StringBuilder();
            sb.append("??????????? bundleName is null, define in classpath or faces-fonfig.xml ");
            sb.append("<application>\n");
            sb.append("\t<locale-config>\n");
            sb.append("\t\t<default-locale>en</default-locale>\n");
            sb.append("\t\t<supported-locale>en</supported-locale>\n");
            sb.append("\t\t<supported-locale>en_US</supported-locale>\n");
            sb.append("\t</locale-config>\n");
            sb.append("\t<message-bundle>com.project.common.properties.ModuleMessageResources</message-bundle>\n");
            sb.append("</application>");
            return sb.toString();
        } else {
            ResourceBundle bundle = ResourceBundle.getBundle(bundleName, locale, getCurrentClassLoader(params));

            String text;
            try {
                text = bundle.getString(key);
            } catch (MissingResourceException var7) {
                text = "??????????? key \"" + key + "\" not found in message bundle " + bundleName;
            }

            if (params != null) {
                MessageFormat mf = new MessageFormat(text, locale);
                text = mf.format(params, new StringBuffer(), (FieldPosition)null).toString();
            }

            return text;
        }
    }

    public static boolean isEmpty(String string) {
        return string == null || string.trim().length() <= 0;
    }

    public static String trim(String string) {
        return isEmpty(string) ? "" : string.trim();
    }

    public static boolean equalsIgnoreCase(String string1, String string2) {
        return trim(string1).equalsIgnoreCase(trim(string2));
    }

    public static boolean equals(String string1, String string2) {
        return trim(string1).equals(trim(string2));
    }

    public static boolean isUpperCase(String string1) {
        return trim(string1).equals(trim(string1.toUpperCase()));
    }

    public static boolean isLowerCase(String string1) {
        return trim(string1).equals(trim(string1.toLowerCase()));
    }

    private static String padding(int repeat, char padChar) throws IndexOutOfBoundsException {
        if (repeat < 0) {
            throw new IndexOutOfBoundsException("Cannot pad a negative amount: " + repeat);
        } else {
            char[] buf = new char[repeat];

            for(int i = 0; i < buf.length; ++i) {
                buf[i] = padChar;
            }

            return new String(buf);
        }
    }

    private static String rightPad(String str, int size, char padChar) {
        if (str == null) {
            str = "";
        }

        int pads = size - str.length();
        return pads > 8192 ? rightPad(str, size, String.valueOf(padChar)) : str.concat(padding(pads, padChar));
    }

    public static String rightPad(String str, int size, String padStr) {
        if (isEmpty(padStr)) {
            padStr = " ";
        }

        String val = str;
        if (val == null) {
            val = "";
        }

        int padLen = padStr.length();
        int strLen = val.length();
        int pads = size - strLen;
        if (pads <= 0) {
            return val;
        } else if (padLen == 1 && pads <= 8192) {
            return rightPad(val, size, padStr.charAt(0));
        } else if (pads == padLen) {
            return val.concat(padStr);
        } else if (pads < padLen) {
            return val.concat(padStr.substring(0, pads));
        } else {
            char[] padding = new char[pads];
            char[] padChars = padStr.toCharArray();

            for(int i = 0; i < pads; ++i) {
                padding[i] = padChars[i % padLen];
            }

            return val.concat(new String(padding));
        }
    }

    public static boolean isEmptyArray(String[] string) {
        return string == null || string.length < 1;
    }

    public static boolean isEmptyList(List list) {
        return list == null || list.size() < 1;
    }

    public static String[] copyArray(String[] fromArray, String[] toArray) {
        int size = 0;
        if (isEmptyArray(fromArray)) {
            return toArray;
        } else {
            size += fromArray.length;
            if (isEmptyArray(toArray)) {
                return fromArray;
            } else {
                size += toArray.length;
                String[] copy = new String[size];
                System.arraycopy(toArray, 0, copy, 0, toArray.length);
                System.arraycopy(fromArray, 0, copy, toArray.length, fromArray.length);
                return copy;
            }
        }
    }

    public static List arrayToList(String[] arr) {
        List l = new ArrayList();
        if (arr == null) {
            return l;
        } else {
            int i = 0;

            for(int n = arr.length; i < n; ++i) {
                l.add(arr[i]);
            }

            return l;
        }
    }

    public static String listToString(List<String> list, String seperator) {
        StringBuilder sb = new StringBuilder();
        if (list == null) {
            return "";
        } else {
            int i = 0;

            for(int n = list.size(); i < n; ++i) {
                if (i > 0 && seperator != null) {
                    sb.append(seperator);
                }

                sb.append((String)list.get(i));
            }

            return sb.toString();
        }
    }

    public static String arrayToString(Object[] arr, String seperator) {
        StringBuilder sb = new StringBuilder();
        if (arr == null) {
            return "";
        } else {
            int i = 0;

            for(int n = arr.length; i < n; ++i) {
                if (i > 0 && seperator != null) {
                    sb.append(seperator);
                }

                sb.append(arr[i]);
            }

            return sb.toString();
        }
    }

    public static String arrayToString(Object[] arr) {
        StringBuilder sb = new StringBuilder();
        if (arr == null) {
            return "";
        } else {
            int i = 0;

            for(int n = arr.length; i < n; ++i) {
                sb.append(arr[i]);
            }

            return sb.toString();
        }
    }

    public static String replaceAll(String contentString, String replaceWord, String replaceWithWord) {
        return contentString.replaceAll(replaceWord, replaceWithWord);
    }

    public static void main(String[] args) {
    }
}
