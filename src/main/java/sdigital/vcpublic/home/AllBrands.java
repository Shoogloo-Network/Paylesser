//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

public class AllBrands {
    private String alphabet;
    StringBuilder sb = new StringBuilder();

    public AllBrands(String alphabet) {
        this.alphabet = alphabet;
    }

    public void addContent(String url, String img, String content) {
        this.sb.append("<li><a href=\"").append(url).append("\"><img data-src='").append(img).append("' src='resources/images/imgLoader.gif'/><span>").append(content).append("</span></a></li>");
    }

    public String getContent() {
        return this.sb.toString();
    }

    public String getAlphabet() {
        return this.alphabet;
    }
}
