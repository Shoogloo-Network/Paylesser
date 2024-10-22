//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.io;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

public final class Writer {
    private static byte[] newLine = Os.getDefaultNewLine().getBytes();
    private static byte[] nullBytes = "null".getBytes();
    private OutputStream writer;
    private String filePath;
    private static Writer instance = null;

    public Writer() {
        this.writer = null;
        this.filePath = null;
    }

    public static Writer instance() {
        if (instance == null) {
            instance = new Writer();
        }

        return instance;
    }

    public Writer(String filePath) throws IOException {
        this();
        this.openWriter(filePath, false);
    }

    public Writer(String filePath, boolean append, String newLineStr) throws IOException {
        this();
        this.openWriter(filePath, append, newLineStr);
    }

    public Writer(String filePath, boolean append) throws IOException {
        this();
        this.openWriter(filePath, append);
    }

    public void openWriter(String filePath) throws IOException {
        this.openWriter(filePath, false);
    }

    public void openWriter(String filePath, boolean append, String newLineStr) throws IOException {
        if (newLineStr == null) {
            throw new IOException("Illegal new line string, newLine is null");
        } else {
            newLine = newLineStr.getBytes();
            this.openWriter(filePath, append);
        }
    }

    public void openWriter(String filePath, boolean append) throws IOException {
        if (filePath == null) {
            throw new IOException("Not a valid filePath, File path is null");
        } else {
            this.filePath = FileUtil.formatForSave(filePath);
            if (this.writer != null) {
                this.writer.close();
            }

            this.writer = new FileOutputStream(filePath, append);
        }
    }

    public void log(String mess) throws IOException {
        this.log(mess, true);
    }

    public void log(String mess, boolean insertNewLine) throws IOException {
        if (this.writer == null) {
            throw new IOException("Writer is null open a new file using Writer.openWriter() option");
        } else {
            if (mess == null) {
                this.writer.write(nullBytes);
            } else {
                this.writer.write(mess.getBytes());
            }

            if (insertNewLine) {
                this.writer.write(newLine);
            }

            this.writer.flush();
        }
    }

    public void closeWriter() {
        try {
            if (this.writer != null) {
                this.writer.close();
            }
        } catch (IOException var5) {
            Logger.getLogger(Writer.class.getName()).log(Level.WARNING, "wawo.io.Writer closeWriter(), Unable to close writer while processing file: {0}", this.filePath);
        } finally {
            this.writer = null;
        }

    }

    public void log(byte[] mess) throws IOException {
        if (this.writer == null) {
            throw new IOException("Writer is null open a new file using openWriter() option");
        } else {
            this.writer.write(mess);
            this.writer.flush();
        }
    }

    public void writeObject(Object object) throws IOException {
        ObjectOutputStream os = null;

        try {
            os = new ObjectOutputStream(this.writer);
            os.writeObject(object);
        } finally {
            this.closeWriter();
            if (os != null) {
                os.flush();
                os.close();
            }

        }

    }
}
