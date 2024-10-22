<%--
    Document   : signupdb
    Created on : Nov 27, 2014, 9:52:58 AM
    Author     : jincy.p
--%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.mailsender.ActivationMail"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vc.encryption.Encryption"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
  Db db = Connect.newDb();
  ResultSet rs = null;
  String status = "OK";
  String store = ",";
  String offer = ",";
  int id = 0;
  Integer domainId=0;
  long lastInsertedId = 0;
  String pageUrl = "";
  String domainName = "";
  String refUrl = request.getParameter("red-url") == null ? "" : request.getParameter("red-url").replaceAll("\\<.*?>", "");
  String signupUrl = (String)request.getHeader("referer");
  try {
    String ip = request.getHeader("X-FORWARDED-FOR");
    if ("127.0.0.1".equals(ip)) {
        ip = request.getHeader("X-Real-IP");
    }
    if (ip == null) {
        ip = request.getRemoteAddr();
    }
    String userEmail = request.getParameter("userEmail") == null ? "" : request.getParameter("userEmail").replaceAll("\\<.*?>", "");
    userEmail = (userEmail!=null)?userEmail.toLowerCase():"";
    String userName = request.getParameter("userName") == null ? "" : request.getParameter("userName").replaceAll("\\<.*?>", "");
    String city = request.getParameter("userCity") == null ? "" : request.getParameter("userCity").replaceAll("\\<.*?>", "");
    String userPassword = request.getParameter("userPassword") == null ? "" : request.getParameter("userPassword").replaceAll("\\<.*?>", "");
    userPassword = Encryption.md5(userPassword);
    domainId = Integer.parseInt(request.getParameter("domainId") == null ? "0" : request.getParameter("domainId").replaceAll("\\<.*?>", ""));
    Integer languageId = Integer.parseInt(request.getParameter("languageId") == null ? "0" : request.getParameter("languageId").replaceAll("\\<.*?>", ""));
    domainName = (String)session.getAttribute("domainName");
    VcHome home = VcHome.instance().instance();
    Properties p = home.getLabels(language.getId());
    List<Domains> domains = home.getDomains(domainId.toString());
    Domains domain = home.getDomain(domains, domainId.toString()); // active domain
    pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    Integer rsDomain = 0;
    String queryDomainId = "SELECT id FROM vc_domain WHERE domain_url= ?";
    ResultSet rsDomainId = db.select().resultSet(queryDomainId, new Object[]{domainName});
    while (rsDomainId.next()) {
      rsDomain = Integer.parseInt(rsDomainId.getString("id"));
    }
    ResultSet r = db.select().resultSet("SELECT email FROM vc_public_user WHERE email=? AND domain_id=?",new Object[]{userEmail,domainId});
    if(!r.next() && domainId != 0 && rsDomain != 0 && domainId == rsDomain){    
		java.sql.Timestamp today = new java.sql.Timestamp(new java.util.Date().getTime());
		db.execute().insert("INSERT INTO vc_public_user(domain_id,name,password,email,ip,user_agent,reg_date,last_modified, city,gender, id) VALUES(?,?,?,?,?,?,?,?,?,?,?)", new Object[]{domainId, userName, userPassword, userEmail, ip, request.getHeader("User-Agent"), today, today, city, null}, "vc_public_user_seq");
		rs = db.select().resultSet("SELECT currval('vc_public_user_seq')", null);
		LoginInfo lInfo = new LoginInfo();
		if (rs.next()) {
		  id = rs.getInt(1);
		}
		db.execute().insert("INSERT INTO VC_USER_LOG (login_at, public_user_id, id) VALUES (?, ?, ?)", new Object[]{new java.sql.Timestamp(new java.util.Date().getTime()), id}, "vc_user_log_seq");                
                ResultSet r1 = db.select().resultSet("SELECT id, subscription_status FROM nl_subscription WHERE email=? AND domain_id=?",new Object[]{userEmail,domainId});
                int subActive = 1;
                if(r1.next()){
                     subActive = r1.getInt(2);
                     db.execute().update("UPDATE nl_subscription SET public_user_id = ? WHERE id = ?", new Object[]{id, r1.getInt(1)});                
                }else{ 
                    subActive = 0;
                    lastInsertedId = db.execute().insert("INSERT INTO nl_subscription (domain_id, language_id, public_user_id, email, subscription_status,newsletter_type,ip,user_agent, id) VALUES(?,?,?,?,?,?,?,?,?)",
                                    new Object[]{domainId, languageId, id, userEmail,0, 1, ip, request.getHeader("User-Agent")}, "nl_subscription_seq");
                    db.execute().insert("INSERT INTO nl_subscription_details (subscription_id, general,subscription_date, id) VALUES(?,?,?,?)", new Object[]{lastInsertedId, 1, new java.sql.Timestamp(new java.util.Date().getTime())}, "nl_subscription_details_seq");
                }
                String actUrl = pageUrl + "confirmSubscription?email=" + wawo.security.Base64.encodeToString(userEmail, false) + "&domainId=" + wawo.security.Base64.encodeToString(domainId.toString(), false);
                try{
                    ActivationMail actMail = new ActivationMail();
                    actMail.sendMail(domain,languageId.toString(), userEmail, actUrl, userName, pageUrl, subActive, 1);
		 } catch (Exception e) { } 
                lInfo.setPublicUserId(id);
		lInfo.setPublicUserName(userName);
		lInfo.setLastLogin(null);
		session.setAttribute("userObj", lInfo);
		session.setAttribute("favStore", store);
		session.setAttribute("savedOffer", offer);
                session.setAttribute("success", p.getProperty("public.user.welcome")+" "+lInfo.getPublicUserName()+"!");
                status = "ok";
                signupUrl = refUrl;
		}else{
                  status = "ko";
            throw new Exception("Domain Id in req=" + domainId +"Domain Id in Db="+rsDomain+ "Domain Name ="+domainName);
        }
  } catch (Exception e) {
     status = "ko";
    Logger.getLogger("signup.jsp").log(Level.SEVERE, null, e);
  } finally {
    Cleaner.close(rs);
    db.select().clean();
    Connect.close(db);
  }
%>
<html>
  <head>	
    <script>
      function submitIt() {
        document.frmSubmit.submit();
      }
    </script>
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
  <body onload="javascript:submitIt()">
      <form action="<%=signupUrl%>" method="post" name="frmSubmit" id="frmSubmit">
      <%if(status.equals("ko")){%>
        <input type="hidden" name="log-error" id="log-error" value="error"/>
        <input type="hidden" name="sign-red" id="sign-red" value="<%=refUrl%>"/>
      <%}%>
    </form>
      <%if(domainId==36){%>
        <script>
        !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
        n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
        document,'script','https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '1124456777649259');
        fbq('track', 'PageView');
        </script>
        <noscript><img height="1" width="1" style="display:none"
        src="https://www.facebook.com/tr?id=1124456777649259&ev=PageView&noscript=1"
        /></noscript>
        <!-- DO NOT MODIFY -->
        <!-- End Facebook Pixel Code -->
        <%}%>
  </body>
</compress:html>
</html>