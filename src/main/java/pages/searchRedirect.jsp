<%-- 
    Document   : search
    Created on : Jan 20, 2015, 1:14:12 PM
    Author     : sanith.e
--%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.sql.SQLException"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.*" %>
<%
Db db = null;  
java.sql.ResultSet rs = null;
try {
String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");   
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
boolean top = true;
boolean vouchers = true;
boolean deals = true;
//out.println(request.getRequestURL());
String requestUrl = request.getRequestURL().toString();
String pageName = "";
String domainName = (String)session.getAttribute("domainName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
String pageType = SystemConstant.SEARCH_RESULT;
String q = CommonUtils.sanitizeQuery((request.getParameter("q") == null ? "" : request.getParameter("q")));
VcHome home = VcHome.instance();
VcSession vcsession = VcSession.instance();
String domainId = home.getDomainId(domainName);
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId); // active domain
List<Language> languages = home.getLanguages(domain.getId());
Language language = vcsession.getLanguage(session, domain.getId(), languages);
List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
//List<VoucherDeals> offerDealList = home.getSeachResult(q,domainId,language.getId());

String qry = "SELECT TSEO.seo_url,1 AS s_type FROM  vc_domain_seo_config TSEO,gl_category TC,bg_category_domain TBCD "
+ "WHERE TSEO.page_type = 4 AND TSEO.archieved = 0 AND LOWER(TC.name) LIKE LOWER(?) "
+  "AND TBCD.domain_id = ? AND TBCD.category_id = TC.id AND TSEO.pagetype_fk = TC.id AND TSEO.domain_id = ? "
+  "union "
+ "SELECT TSEO.seo_url,2 AS s_type FROM  vc_domain_seo_config TSEO, vc_store TST, vc_store_lang TSL "
+ "WHERE TSL.store_id = TST.id AND TST.PUBLISH = 1 AND TST.trash = 0 AND TSEO.pagetype_fk = TST.id "
+  "AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 "
+  "AND TSEO.domain_id = ? AND LOWER(TSL.name) LIKE LOWER(?)";



String searchType = "";
String redirectSUrl = "";
String catId = "";
String searchUrl = "";
for (SeoUrl seo : seoList) {
    if (SystemConstant.SEARCH_RESULT.equals(seo.getPageType())  && language.getId().equals(seo.getLanguageId())) {
        searchUrl = seo.getSeoUrl();
        break;
    }
}

db = Connect.newDb();
int dId = Integer.parseInt(domainId);
rs = db.select().resultSet(qry, new Object[]{q,dId, dId, dId, q});

String ipAddress = CommonUtils.getClientIP(request);
String userAgent = request.getHeader("user-agent");
String fPrint = ""; 
if (session.getAttribute("fPrint") != null) {
   fPrint = (String)session.getAttribute("fPrint");
}
if(!"182.73.219.210".equals(ipAddress)){
    db.execute().insert("INSERT INTO vc_search_log (domain_id,ip,user_agent, fprint, search_date,query,id) VALUES(?,?,?,?,?,?,?)", new Object[]{Integer.parseInt(domainId), ipAddress, userAgent, fPrint, new Timestamp(new Date().getTime()), q}, "vc_search_log_seq");
}
while (rs.next()) {
    searchType = rs.getString("s_type");
    redirectSUrl = rs.getString("seo_url");
}

if("1".equals(searchType)) {  
  catId = home.getCatId(q,language.getId());
  redirectSUrl = redirectSUrl;
} else if("2".equals(searchType)) {
  redirectSUrl = redirectSUrl;
} else if("3".equals(searchType)) {
  redirectSUrl = searchUrl+"?q="+q.replaceAll("&", "--");
} else {
  redirectSUrl = searchUrl+"?q="+q.replaceAll("&", "--");
}

%>
<script>
    window.location = "<%=pageUrl+redirectSUrl%>";
</script>

<%}
catch(Throwable e) {
    Logger.getLogger("searchRedirect.jsp").log(Level.SEVERE, null, e);
}finally {
    Cleaner.close(rs);
    db.select().clean();
    Connect.close(db);
}%>
