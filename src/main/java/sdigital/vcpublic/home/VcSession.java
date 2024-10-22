//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpSession;

public class VcSession {
    private static VcSession session = new VcSession();

    private VcSession() {
    }

    public static VcSession instance() {
        return session;
    }

    public void changeLanguage(HttpSession session, String langId, String domainId) {
        Iterator var4 = VcHome.instance().getLanguages(domainId).iterator();

        while(var4.hasNext()) {
            Language lang = (Language)var4.next();
            if (lang.getId().equals(langId)) {
                session.setAttribute("lang", lang);
            }
        }

    }

    public Language getLanguage(HttpSession session, String domainId, List<Language> languages) {
        Object obj = session.getAttribute("lang");
        if (obj == null) {
            VcHome home = VcHome.instance();
            Iterator var6 = languages.iterator();

            while(var6.hasNext()) {
                Language lang = (Language)var6.next();
                if (lang.isIsDefault()) {
                    session.setAttribute("lang", lang);
                    return lang;
                }
            }
        }

        return (Language)obj;
    }
}
