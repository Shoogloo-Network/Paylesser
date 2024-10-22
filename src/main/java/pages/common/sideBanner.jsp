<%-- 
    Document   : sideBanner
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:45:57 AM
    Author     : Vivek
--%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.BannerPage"%>
<%//Side banner by ishaq
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId((String)session.getAttribute("domainName"));
    String domainName = (String)session.getAttribute("domainName");
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain 
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    String cdnPath = "";
    if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
    List<BannerPage> bannerPageList = home.getBannerPageByDomainId(domainId);
    String position = (request.getParameter("position")!=null)?request.getParameter("position"):"1";
    String affiliate = (request.getParameter("affiliate")!=null)?request.getParameter("affiliate"):"2";
%>
<%//side banner ishaq
    if (bannerPageList != null) {
                    for (BannerPage b : bannerPageList) {
                      boolean display = false;
                      if("2".equals(b.getAffiliate())){
                          display = true;
                      }else if(affiliate.equals(b.getAffiliate())){
                          display = true;
                      } 
                      if (display && position.equals(b.getBannerPosition())) {
                        if ("1".equals(b.getBannerType())) {
                            if (language.getId().equals(b.getLanguageId())) {
                                if ("".equals(b.getImage()) || b.getImage() == null) { %>
                                    <div class="ad-banner bnr<%=position%>">
                                        <figure>
                                          <a href="<%=b.getRedirectUrl()%>" target="_blank" rel="nofollow"><img src="<%=b.getImageUrl()%>" alt="<%=b.getTitle()%>" /></a>
                                        </figure>
                                    </div>
                        <%  } else {  %>
                <div class="ad-banner">
                    <figure>
                        <a href="<%=b.getRedirectUrl()%>" target="_blank" rel="nofollow"><img src="<%=cdnPath + b.getImage()%>" alt="<%=b.getTitle()%>" /></a>
                    </figure>
                </div>
<%                
                }
            }
        }else{%>
        <div class="fb-widget">
            <figure><%=b.getBannerScript()%></figure>
        </div>
<%        
    }
  }
 }
}
%>