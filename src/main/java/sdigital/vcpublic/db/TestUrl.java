//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.db;

public class TestUrl {
    public TestUrl() {
    }

    public static void main(String[] args) {
        String requestUrl = "http://www.google.com/test/";
        String domainName = null;
        String pageName = null;
        if (requestUrl.contains("http://")) {
            String url = requestUrl.substring(7);
            int len = url.indexOf(47, 1);
            if (len > 0) {
                domainName = url.substring(0, len);
                pageName = url.substring(len, url.length());
            } else {
                domainName = url;
            }
        }

        System.out.println(domainName);
        System.out.println(pageName);
    }
}
