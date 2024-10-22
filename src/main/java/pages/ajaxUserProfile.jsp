<%-- 
    Document   : ajaxUserProfile
    Created on : Dec 10, 2014, 6:16:30 PM
    Author     : shabil.b
--%>

<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="sdigital.vcpublic.home.*"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>

<%
String strType = request.getParameter("type") == null ? "" : request.getParameter("type").replaceAll("\\<.*?>", "");
String pageUrl = request.getParameter("pgurl") == null ? "" : request.getParameter("pgurl").replaceAll("\\<.*?>", "");
String signupUrl = request.getParameter("sgnurl") == null ? "" : request.getParameter("sgnurl").replaceAll("\\<.*?>", "");
String strQry = "";
String strIds = "";
String sessionStore = "";
String favStore = "";
String domainName = (String)session.getAttribute("domainName");
String cdnPath = "";
  if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
int langId = request.getParameter("lang") == null ? 0 : Integer.parseInt(request.getParameter("lang"));
int cnt = 6;
Integer uId = null;
StringBuffer strBuffer = new StringBuffer();
java.sql.PreparedStatement psQry = null;
java.sql.ResultSet rsQry = null;
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId);
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage(session, domain.getId(), languages);
Properties p = home.getLabels(language.getId());
  
if(session.getAttribute("userObj") != null) {
    LoginInfo linfo = (LoginInfo) session.getAttribute("userObj");
    uId = linfo.getPublicUserId();
}

if(session.getAttribute("favStore") != null) {
    favStore = (String) session.getAttribute("favStore");
}
  
Db db = Connect.newDb();
try {
    if("saved".equals(strType)) {
        if(session.getAttribute("savedOffer") != null) {
            strIds = "0"+(String)session.getAttribute("savedOffer")+"0";
            strQry = "SELECT TOF.id AS offer_id, COALESCE(TOF.image, TST.image_small) AS offer_image, TOFL.offer_heading AS heading, "
                   + "TOFL.offer_description AS desc, TOF.offer_type AS type, VSL.seo_url AS url FROM vc_offer TOF, vc_offer_lang TOFL, "
                   + "vc_store TST, vc_store_lang VSL WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND VSL.store_id = TST.id "
                   + "AND TOF.end_date >= CURRENT_DATE AND TOF.publish = 1 AND TST.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND "
                   + "TOFL.language_id = ? AND VSL.language_id = ? AND TOF.id IN("+strIds+") ORDER BY TOF.start_date DESC, TOF.id "
                   + "DESC LIMIT 3";

            psQry = db.select().getPreparedStatement(strQry);
            psQry.clearParameters();
            psQry.setInt(1, langId);
            psQry.setInt(2, langId);
            rsQry = psQry.executeQuery();

            strBuffer.append("<h3>"+p.getProperty("public.home.saved_coupons")+"</h3>");
            strBuffer.append("<ul class=\"offer-list\">");
                while(rsQry.next()) {
                    strBuffer.append("<li>");
                        strBuffer.append("<ul class=\"offer-item clearfix\">");
                            strBuffer.append("<li class=\"company-logo\">");
                                strBuffer.append("<figure>");
                                    /*if("1".equals(rsQry.getString("type"))) {
                                        strBuffer.append("<a data-type=\"20\" data-lang=\""+langId+"\" id=\"20-"+rsQry.getString("offer_id")+"\" class=\"vpop cursor-href\"><img src=\""+cdnPath+rsQry.getString("offer_image")+"\" alt=\"image\"></a>");
                                    }
                                    else {
                                        strBuffer.append("<a data-of=\""+rsQry.getString("offer_id")+"\" href=\""+rsQry.getString("url")+"\" target=\"_blank\" class=\"u-deal\"><img src=\""+cdnPath+rsQry.getString("offer_image")+"\" alt=\"image\"></a>");
                                    }*/
                                    strBuffer.append("<a href=\""+pageUrl+rsQry.getString("url")+"\"><img src=\""+cdnPath+rsQry.getString("offer_image")+"\" alt=\"image\"></a>");
                                strBuffer.append("</figure>");
                            strBuffer.append("</li>");
                            strBuffer.append("<li class=\"offer-desc\">");
                                strBuffer.append("<h2><a href=\"#\">"+rsQry.getString("heading")+"</a></h2>");
                                //strBuffer.append("<p class=\"screen tagline-p\">"+rsQry.getString("desc")+"</p>");
                            strBuffer.append("</li>");
                        strBuffer.append("</ul>");
                    strBuffer.append("</li>");
                }
            strBuffer.append("</ul>");
            strBuffer.append("<a href=\""+pageUrl+"saved-coupon\" class=\"view-all\">");
                strBuffer.append("<span class=\"icon\"><img class=\"mrt-5\" src=\""+SystemConstant.PATH+"images/icon-save.png\" alt=\"image\"/></span>");
                strBuffer.append("<span>"+p.getProperty("public.home.view.all")+"</span>");
            strBuffer.append("</a>");
        }
        else {
            strBuffer.append("<h3>"+p.getProperty("public.home.no.saved")+"</h3>");
            strBuffer.append("<p>"+p.getProperty("public.home.login.click")+" <span><img src=\""+SystemConstant.PATH+"images/dis-save.png\" alt=\"image\" /></span> "+p.getProperty("public.home.star.along")+"</p>");
            strBuffer.append("<ul class=\"btn-wrap clearfix\">");
                strBuffer.append("<li><a class=\"pop-login cursor-href\">Login</a></li>");
                strBuffer.append("<li><a href=\""+pageUrl+signupUrl+"\" class=\"btn-primary\">"+p.getProperty("public.home.join.for")+" <span> "+p.getProperty("public.home.free")+"</span></a></li>");
            strBuffer.append("</ul>");
        }
    }
    else if("fav".equals(strType)) {
        if(session.getAttribute("favStore") != null) {
            strIds = "0"+(String)session.getAttribute("favStore")+"0";
            //strQry = "SELECT affiliate_url, image_small FROM vc_store WHERE publish = 1 AND trash = 0 AND id IN ("+strIds+") ORDER BY id LIMIT 6";
            strQry = "SELECT VS.affiliate_url, VS.image_small, VSL.seo_url FROM vc_store VS, vc_store_lang VSL WHERE VSL.store_id = VS.id AND "
                   + "VS.publish = 1 AND VS.trash = 0 AND VS.id IN ("+strIds+") AND VSL.language_id = ? ORDER BY VS.id LIMIT 6";

            psQry = db.select().getPreparedStatement(strQry);
            psQry.clearParameters();
            psQry.setInt(1, langId);
            rsQry = psQry.executeQuery();
            
            strBuffer.append("<h3>"+p.getProperty("public.home.favourite_stores")+"</h3>");
            strBuffer.append("<ul class=\"websites store-list clearfix\">");
                while(rsQry.next()) {
                    strBuffer.append("<li><a href=\""+pageUrl+rsQry.getString("seo_url")+"\"><img src=\""+cdnPath+rsQry.getString("image_small")+"\" alt=\"image\"></a></li>");
                    cnt--;
                }
                for(int i=cnt; i>0; i--) {
                    strBuffer.append("<li><a href=\""+pageUrl+"add-stores\"><img src=\""+SystemConstant.PATH+"images/add-logo.png\" alt=\"image\"></a></li>");
                }
            strBuffer.append("</ul>");
            strBuffer.append("<a href=\""+pageUrl+"favourite-stores\" class=\"view-all\">");
                strBuffer.append("<span class=\"icon\"><img class=\"mrt-5\" src=\""+SystemConstant.PATH+"images/icon-fav-top.png\" alt=\"image\"/></span>");
                strBuffer.append("<span>"+p.getProperty("public.home.view.favourite")+"</span>");
            strBuffer.append("</a>");
        }
        else {
            strBuffer.append("<h3>"+p.getProperty("public.home.no.favourite")+"</h3>");
            strBuffer.append("<p>"+p.getProperty("public.home.login.tosee")+"</p>");
            strBuffer.append("<ul class=\"btn-wrap clearfix\">");
                strBuffer.append("<li><a class=\"pop-login cursor-href\">Login</a></li>");
                strBuffer.append("<li><a href=\""+pageUrl+signupUrl+"\" class=\"btn-primary\">"+p.getProperty("public.home.join.for")+" <span> "+p.getProperty("public.home.free")+"</span></a></li>");
            strBuffer.append("</ul>");
        }
    }
    else if("add-fav".equals(strType)) {
        String favId = request.getParameter("fav") == null ? "" : request.getParameter("fav").replaceAll("\\<.*?>", "");
        
        db.execute().insert("INSERT INTO vc_favourite_store(store_id, public_user_id, ip, user_agent, id) VALUES (?, ?, ?, ?, ?)", new Object[]{Integer.parseInt(favId), uId, request.getRemoteAddr(), request.getHeader("User-Agent")}, "vc_favourite_store_seq");
        strBuffer.append("add");
        favStore = favStore + Integer.parseInt(favId) + ",";
        session.setAttribute("favStore", favStore);
    }
    else if("rem-fav".equals(strType)) {
        sessionStore = (String)session.getAttribute("favStore");
        strIds = request.getParameter("store") == null ? "-1" : request.getParameter("store").replaceAll("\\<.*?>", "");
        sessionStore = sessionStore.replace(","+Integer.parseInt(strIds), "");
        session.setAttribute("favStore", sessionStore);
        strQry = "DELETE FROM vc_favourite_store WHERE id = ?";
        db.execute().delete(strQry, new Object[]{Integer.parseInt(request.getParameter("fav") == null ? "0" : request.getParameter("fav"))});
    }
    else if("search".equals(strType)) {
        String searchKey = request.getParameter("key") == null ? "" : request.getParameter("key").replaceAll(" ", "%").replaceAll("\\<.*?>", "");
        String favClass = "";
        strQry = "SELECT VS.id, VS.image_small, VSL.name, VSL.seo_url FROM vc_store VS, vc_store_lang VSL WHERE VS.id = VSL.store_id AND "
               + "VS.publish = 1 AND VS.trash = 0 AND VS.domain_id = ? AND VSL.language_id = ? AND UPPER(VSL.name) LIKE "
               + "'%"+searchKey.toUpperCase()+"%' ORDER BY VS.priority LIMIT 52";
        
        psQry = db.select().getPreparedStatement(strQry);
        psQry.clearParameters();
        psQry.setInt(1, Integer.parseInt(request.getParameter("domain") == null ? "0" : request.getParameter("domain")));
        psQry.setInt(2, langId);
        rsQry = psQry.executeQuery();
        
        while(rsQry.next()) {
            favClass = favStore.contains(","+rsQry.getString("id")+",") ? "fav-added" : "fav-add";
            strBuffer.append("<li>");
                strBuffer.append("<a href=\""+pageUrl+rsQry.getString("seo_url")+"\"><img src=\""+cdnPath+rsQry.getString("image_small")+"\" alt=\""+rsQry.getString("name")+"\"></a>");
                strBuffer.append("<a class=\""+favClass+" cursor-href\" data-fav=\""+rsQry.getString("id")+"\"></a>");
            strBuffer.append("</li>");
        }
    }
    response.setContentType("text/html");
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader("Expires", 0); //prevents caching at the proxy server
    response.getWriter().write(strBuffer.toString());
}
catch(Exception e) {
    Logger.getLogger("ajaxUserProfile.jsp").log(Level.SEVERE, null, e);
}
finally {
    Cleaner.close(psQry);
    Cleaner.close(rsQry);
    db.select().clean();
    Connect.close(db);
}
%>