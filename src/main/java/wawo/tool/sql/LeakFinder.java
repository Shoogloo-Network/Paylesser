//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.tool.sql;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Stack;
import wawo.io.Os;
import wawo.io.Writer;
import wawo.util.StringUtil;

public class LeakFinder {
    private boolean recurse = false;
    private String reportSavePath;
    private String savedReportFile;
    private Writer wr = new Writer();

    public LeakFinder() {
    }

    public static void main(String[] args) throws IOException, FileNotFoundException, Exception {
        findLeak();
    }

    public void setReportSavePath(String reportSavePath) {
        this.reportSavePath = reportSavePath;
        Os.makeFolders(reportSavePath);
    }

    public String getReportSavePath() {
        return this.reportSavePath;
    }

    public String getSavedReportFile() {
        return this.savedReportFile;
    }

    public void setRecurse(boolean recurse) {
        this.recurse = recurse;
    }

    public boolean isRecurse() {
        return this.recurse;
    }

    private static void findLeak() throws IOException, FileNotFoundException, Exception {
        LeakFinder ff = new LeakFinder();
        ff.setRecurse(true);
        String s = "D:\\projects\\zcms\\";
        ff.findLeaks(s, ".java", ".jsp");
        s = Os.readString(s + "Leaks.txt");
        System.out.println(s);
    }

    public void findLeaks(String path, String... ext) throws FileNotFoundException, IOException, Exception {
        List files;
        if (this.isRecurse()) {
            files = Os.findAllFilePaths(path, ext);
        } else {
            files = Os.findImmediateFilePaths(path, ext);
        }

        this.open(path);
        Stack<Found> resource = new Stack();
        Stack<Found> removed = new Stack();
        int i = 0;

        for(int n = files.size(); i < n; ++i) {
            String str = (String)files.get(i);
            removed.clear();
            resource.clear();
            File f = new File(str);
            BufferedReader br = new BufferedReader(new FileReader(str));
            int lineCnt = 0;

            while((str = br.readLine()) != null) {
                ++lineCnt;
                if (str == null) {
                    str = "";
                }

                str = str.trim();
                if (str != null && str.length() > 0) {
                    this.addFinder(resource, str, lineCnt, "ResultSet ");
                    this.addFinder(resource, str, lineCnt, "PreparedStatement ");
                    this.addFinder(resource, str, lineCnt, "Statement ");
                    this.addFinder(resource, str, lineCnt, "Connection ");
                    this.addFinder(resource, str, lineCnt, "Connector ");
                    this.addFinder(resource, str, lineCnt, "Db ");
                    this.addFinder(resource, str, lineCnt, "Select ");
                    this.addFinder(resource, str, lineCnt, "Jpa ");
                    this.addFinder(resource, str, lineCnt, "Execute ");
                    this.removeFound(resource, removed, str);
                }
            }

            this.write(path, f, resource, removed);
        }

        this.close();
    }

    private void open(String path) throws IOException {
        if (this.reportSavePath == null) {
            this.reportSavePath = path;
        }

        this.savedReportFile = this.reportSavePath + "/Leaks.txt";
        this.wr.openWriter(this.savedReportFile);
    }

    private void write(String witeFolder, File file, Stack<Found> resource, Stack<Found> removed) throws IOException {
        int k = 0;
        Iterator<Found> it = resource.iterator();

        while(it.hasNext()) {
            Found variable = (Found)it.next();
            ++k;
            if (k == 1) {
                String writePath = file.getAbsolutePath();
                this.wr.log(writePath.substring(witeFolder.length()), false);
            }

            this.wr.log("\t", false);
            this.wr.log(variable.getField() + " = " + variable.getLineNo(), false);
            int next = removed.search(variable);
            if (next != -1) {
                this.wr.log(" Also check [", false);
            }

            Iterator<Found> it1 = removed.iterator();

            while(it1.hasNext()) {
                Found variable1 = (Found)it1.next();
                if (variable.getField().equals(variable1.getField()) && variable.getLineNo() != variable1.getLineNo()) {
                    this.wr.log(String.valueOf(variable1.getLineNo() + " "), false);
                }
            }

            if (next != -1) {
                this.wr.log("]", false);
            }
        }

        if (k != 0) {
            this.wr.log("");
        }

    }

    private void close() {
        this.wr.closeWriter();
    }

    private void addFinder(Stack<Found> resource, String str, int lineCnt, String toCheck) {
        if (str.indexOf(toCheck) > -1 && str.startsWith(toCheck)) {
            str = str.substring(toCheck.length());
            str = str.trim();
            String[] arr = str.split(" ");
            if (!StringUtil.isEmptyArray(arr)) {
                String x = arr[0].replaceAll(";", "").trim();
                resource.push(new Found(lineCnt, x));
            }
        }

    }

    private void removeFound(Stack<Found> resource, Stack<Found> removed, String str) {
        Iterator<Found> it = resource.iterator();

        while(it.hasNext()) {
            Found variable = (Found)it.next();
            String key = variable.getField();
            if (str.indexOf(key + ".shutdown()") > -1 || str.indexOf(key + ".destroy()") > -1 || str.indexOf(key + ".clean()") > -1 || str.indexOf(key + ".close()") > -1 || str.indexOf("Cleaner.close(" + key + ")") > -1) {
                removed.add(variable);
                resource.remove(variable);
                break;
            }
        }

    }
}
