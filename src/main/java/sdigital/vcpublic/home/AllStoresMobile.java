//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

public class AllStoresMobile {
    private String alphabet;
    StringBuilder sb = new StringBuilder();

    public AllStoresMobile(String alphabet) {
        this.alphabet = alphabet;
    }

    public void addContent(String url, String content, String image, String offerCount) {
        image = "http://cdn2.vouchercodes.in" + image;
        this.sb.append("<a href=\"storeDetails.html\"><div class=\"offerItem\"><div class=\"details\"><dt><img src=\"" + image + "\">").append("</dt><dd><h6>").append(content).append("<p>").append(offerCount).append(" offer</p><a href=\"storeDetails.html\" class=\"btnMore\"></a></dd></div></div></a>");
    }

    public String getContent() {
        return this.sb.toString();
    }

    public String getAlphabet() {
        return this.alphabet;
    }
}
