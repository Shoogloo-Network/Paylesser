//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

public class AllStores {
    private String alphabet;
    StringBuilder sb = new StringBuilder();

    public AllStores(String alphabet) {
        this.alphabet = alphabet;
    }

    public void addContent(String url, String img, String content) {
        this.sb.append("<li><a href=\"").append(url).append("\">").append(content).append("</a></li>");
    }

    public String getContent() {
        return this.sb.toString();
    }

    public String getAlphabet() {
        return this.alphabet;
    }
}
