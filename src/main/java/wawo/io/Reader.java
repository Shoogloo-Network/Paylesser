//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;

public class Reader {
    private String newLine = Os.getDefaultNewLine();
    public static final int READ_ALL = 0;
    private static Reader instance = null;
    private String encoding = null;

    private Reader() {
    }

    public static Reader instance() {
        if (instance == null) {
            instance = new Reader();
        }

        return instance;
    }

    public void setEncoding(String encoding) {
        this.encoding = encoding;
    }

    public static Reader newInstance() {
        return new Reader();
    }

    public String getStringData(String file) throws IOException {
        return this.getStringData(file, 0);
    }

    public String getStringData(String file, String encoding) throws IOException {
        this.setEncoding(encoding);
        return this.getStringData(file, 0);
    }

    public String getStringData(String file, int rowNum) throws IOException {
        return this.getStringData(new File(file), rowNum, -1, -1);
    }

    public String getStringData(String file, int from, int to) throws IOException {
        return this.getStringData(new File(file), -1, from, to);
    }

    public String[] getStringArray(String file, int from, int to) throws IOException {
        FileReader fis = null;
        String[] data = null;
        BufferedReader br;
        if (this.encoding == null) {
            fis = new FileReader(file);
            br = new BufferedReader(fis);
        } else {
            br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(file)), "UTF-8"));
        }

        try {
            int i = 0;
            boolean start = true;
            if (to > from && (from > 0 || to > 0)) {
                data = new String[to - from];

                String row;
                while((row = br.readLine()) != null) {
                    ++i;
                    if (from == i) {
                        start = true;
                    }

                    if (start) {
                        if (this.newLine != null) {
                            row = row + this.newLine;
                        }

                        data[i - 1] = row;
                    }

                    if (to == i) {
                        start = false;
                    }
                }

                String[] var10 = data;
                return var10;
            }
        } finally {
            IoClean.close(fis);
            IoClean.close(br);
        }

        return data;
    }

    private String getStringData(File file, int rowNum, int from, int to) throws IOException {
        StringBuilder data = new StringBuilder();
        FileReader fis = null;
        BufferedReader br;
        if (this.encoding == null) {
            fis = new FileReader(file);
            br = new BufferedReader(fis);
        } else {
            br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"));
        }

        String var11;
        try {
            int i = 0;
            boolean start = true;
            String row;
            if (from > 0 || to > 0) {
                while((row = br.readLine()) != null) {
                    ++i;
                    if (from == i) {
                        start = true;
                    }

                    if (start) {
                        data.append(row);
                        if (this.newLine != null) {
                            data.append(this.newLine);
                        }
                    }

                    if (to == i) {
                        start = false;
                    }
                }

                var11 = data.toString();
                return var11;
            }

            if (rowNum <= 0) {
                while((row = br.readLine()) != null) {
                    data.append(row);
                    if (this.newLine != null) {
                        data.append(this.newLine);
                    }
                }

                return data.toString();
            }

            while((row = br.readLine()) != null) {
                ++i;
                if (rowNum == i) {
                    var11 = row;
                    return var11;
                }
            }

            if (i == 0) {
                var11 = "";
                return var11;
            }

            var11 = "Record you are looking in the file is not found Max Record =" + i;
        } finally {
            IoClean.close(fis);
            IoClean.close(br);
        }

        return var11;
    }

    public String getStringData(InputStream inputStream) throws IOException {
        StringBuilder data = new StringBuilder();
        InputStreamReader isr = null;
        BufferedReader br = null;

        try {
            isr = new InputStreamReader(inputStream);
            br = new BufferedReader(isr);

            String row;
            while((row = br.readLine()) != null) {
                data.append(row);
                if (this.newLine != null) {
                    data.append(this.newLine);
                }
            }
        } finally {
            IoClean.close(inputStream);
            IoClean.close(isr);
            IoClean.close(br);
        }

        return data.toString();
    }

    public InputStream readStream(String path) throws FileNotFoundException {
        return new FileInputStream(new File(path));
    }

    public static Object readObject(String fileName) throws IOException, ClassNotFoundException {
        FileInputStream fin = null;
        ObjectInputStream ois = null;

        Object var3;
        try {
            fin = new FileInputStream(fileName);
            ois = new ObjectInputStream(fin);
            var3 = ois.readObject();
        } finally {
            IoClean.close(fin);
            IoClean.close(ois);
        }

        return var3;
    }

    public void setNewLine(String newLine) {
        this.newLine = newLine;
    }
}
