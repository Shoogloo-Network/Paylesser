<%-- 
    Document   : login
    Created on : Nov 25, 2014, 9:30:05 PM
    Author     : shabil.b
--%>

<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.UUID"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vc.encryption.Encryption"%>
<%@page import="sdigital.vcpublic.mailsender.ActivationMail"%>

<%
java.sql.ResultSet rsLogin = null;
java.sql.ResultSet rsStore = null;
java.sql.ResultSet rsOffer = null;
java.sql.ResultSet rsLastLog = null;
String email = request.getParameter("usr") == null ? "" : request.getParameter("usr").replaceAll("\\<.*?>", "");
email = (email!=null)?email.toLowerCase():"";
String pwd = request.getParameter("pwd") == null ? "" : request.getParameter("pwd").replaceAll("\\<.*?>", "");
String code = request.getParameter("key") == null ? "" : request.getParameter("key").replaceAll("\\<.*?>", "");
String type = request.getParameter("type") == null ? "0" : request.getParameter("type").replaceAll("\\<.*?>", "");
String logType = request.getParameter("log-type") == null ? "" : request.getParameter("log-type").replaceAll("\\<.*?>", "");
String refUrl = request.getParameter("red-url") == null ? "" : request.getParameter("red-url").replaceAll("\\<.*?>", "");
String cookie_save = request.getParameter("cookie_save") == null ? "" : request.getParameter("cookie_save").replaceAll("\\<.*?>", "");
String encPwd = "";
String qry = "";
String domainId = "";
String status = "";
String store = ",";
String offer = ",";
String logred = "";
    
VcHome home = VcHome.instance();
Db db =  Connect.newDb();
long auth = 0;

if(session.getAttribute("mobileRedirect") != null) {
    refUrl = (String) session.getAttribute("mobileRedirect");
}

//Getting active domain
String requestUrl = request.getRequestURL().toString();
String domainName = "";
domainName = (String) session.getAttribute("domainName");
String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
domainName = (String)session.getAttribute("domainName");
domainId = home.getDomainId(domainName);
encPwd = Encryption.md5(pwd);
VcSession vcsession = VcSession.instance();
List<Domains> domains = home.getDomains(domainId);
Domains domain = home.getDomain(domains, domainId); // active domain
List<Language> languages = home.getLanguages(domainId);
Language language = vcsession.getLanguage(session, domainId, languages);
Properties p = home.getLabels(language.getId());
try {
    if("forgot".equals(logType)) {
        qry = "SELECT id, name FROM vc_public_user WHERE email = ? AND domain_id = ? AND trash = 0";
        rsLogin = db.select().resultSet(qry, new Object[]{email, Integer.parseInt(domainId)});
        if(rsLogin.next()) {
            String name = rsLogin.getString(2);
            String secret = UUID.randomUUID().toString();            
            String resetUrl = pageUrl+"user-login?action=reset-password&u="+email+"&uid="+secret;
            try{
                ActivationMail forgotPwd = new ActivationMail();
                forgotPwd.sendMail(domain, language.getId(), email, resetUrl, name, pageUrl, 1, 2);
              } catch (Exception e) { }          
            db.execute().update("UPDATE vc_public_user SET reset_key = ? WHERE id = ?", new Object[]{secret, rsLogin.getInt(1)});
            status = "forgot-ok";
            refUrl = "/";
            session.setAttribute("success", "Please check your mail to reset the password.");
        }
        else {
            status = "forgot-ko";
            refUrl = "/user-login?action=forgot-password";
        }
    }
    else if("reset".equals(logType)) {
        qry = "SELECT id, password FROM vc_public_user WHERE email = ? AND reset_key = ? AND domain_id = ? AND trash = 0";
        rsLogin = db.select().resultSet(qry, new Object[]{email, code, Integer.parseInt(domainId)});
        if(rsLogin.next()) {           
            
            db.execute().update("UPDATE vc_public_user SET password = ? WHERE id = ?", new Object[]{encPwd, rsLogin.getInt(1)});
            status = "reset-ok";
            refUrl = "/user-login";
            session.setAttribute("success", "New Password is saved successfully, Please login to continue.");
        }
        else {
            status = "reset-ko";            
            refUrl = "/user-login?action=reset-password&u="+email+"&uid="+code;
        }
    }
    else {
        qry = "SELECT id, name, lastlogin FROM vc_public_user WHERE email = ? AND password = ? AND domain_id = ? AND trash = 0";
        rsLogin = db.select().resultSet(qry, new Object[]{email, encPwd, Integer.parseInt(domainId)});
        if(rsLogin.next()) {
            LoginInfo lInfo = new LoginInfo();
            lInfo.setPublicUserId(rsLogin.getInt(1));
            lInfo.setPublicUserName(rsLogin.getString(2));
            lInfo.setLastLogin(rsLogin.getDate(3));
            session.setAttribute("userObj", lInfo);

            qry = "SELECT login_at FROM VC_USER_LOG WHERE public_user_id = ? ORDER BY id DESC LIMIT 1";
            rsLastLog = db.select().resultSet(qry, new Object[]{rsLogin.getInt(1)});
            if(rsLastLog.next()) {
                db.execute().update("UPDATE vc_public_user SET lastlogin = ?::timestamp WHERE id = ?", new Object[]{rsLastLog.getString(1), rsLogin.getInt(1)});
            }
            db.execute().insert("INSERT INTO VC_USER_LOG (login_at, public_user_id, id) VALUES (?, ?, ?)", new Object[]{new java.sql.Timestamp(new java.util.Date().getTime()), rsLogin.getInt(1)}, "vc_user_log_seq");

            qry = "SELECT VF.store_id FROM vc_favourite_store VF, vc_store VS WHERE VF.store_id = VS.id AND VF.public_user_id = ? "
                + "AND VS.publish = 1 AND VS.trash = 0";
            rsStore = db.select().resultSet(qry, new Object[]{rsLogin.getInt(1)});
            while(rsStore.next()) {
                store = store+rsStore.getInt(1)+",";
            }
            qry = "SELECT VS.offer_id FROM vc_saved_coupon VS, vc_offer VO WHERE VS.offer_id = VO.id AND VS.public_user_id = ? AND VO.publish = 1 "
                + "AND VO.trash = 0 AND VO.end_date >= CURRENT_DATE";
            rsOffer = db.select().resultSet(qry, new Object[]{rsLogin.getInt(1)});
            while(rsOffer.next()) {
                offer = offer+rsOffer.getInt(1)+",";
            }

            session.setAttribute("favStore", store);
            session.setAttribute("savedOffer", offer);
            session.setAttribute("success", p.getProperty("public.user.welcome")+" "+lInfo.getPublicUserName()+"!");
            status = "ok";
            auth = 1;
        }
        else {
            status = "ko";
            logred = refUrl;
            refUrl = "/user-login";
        }
    }
    
    if("mobile".equals(type) && auth == 0) {
        refUrl = "mobilelogin";
    }else {
        session.removeAttribute("mobileRedirect");
    }
}
catch(Exception e) {
    System.out.println("Error in page login.jsp, cause: "+e);
}
finally {
    Cleaner.close(rsLogin);
    Cleaner.close(rsStore);
    Cleaner.close(rsOffer);
    db.select().clean();
    Connect.close(db);
}%>

<!DOCTYPE html>
<html class="no-js"  lang="<%=session.getAttribute("isoCode")%>">
    <head>		
        <title itemprop="name">Paylesser Login</title>	
        <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>
        <%if(cookie_save.equals("yes") || "ko".equals(status)) {%>
            <script src="<%=SystemConstant.PATH%>js/jquery.cookie.js"></script>
        <%}%>
        <script type="text/javascript">
            var redirect = function() {
                <%if((cookie_save.equals("yes")) && ("ok".equals(status))) {%>
                    $.cookie('@@us__ml__<%=domainId%>', '<%=email%>', {expires: 712});
                    $.cookie('@@us__pw__<%=domainId%>', '<%=pwd%>', {expires: 712});
                <%}
                if("ko".equals(status)) { //Cookie login error
                    if("cook".equals(logType)) { //If login is error while logging from cookie should not show login/error popup
                        status = "";
                    }%>
                    $.removeCookie('@@us__ml__<%=domainId%>');
                    $.removeCookie('@@us__pw__<%=domainId%>');
                <%}%>
                $('#frm-red').submit();
            }
        </script>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body onload="redirect();">
        <form id="frm-red" action="<%=refUrl%>" method="post">
            <input name="log-status" type="hidden" value="<%=status%>"/>
            <%if(status.equals("ko")) {%>
                <input name="log-mail" type="hidden" value="<%=email%>"/>
                <input name="log-pwd" type="hidden" value="<%=pwd%>"/>
                <input name="log-save" type="hidden" value="<%=cookie_save%>"/>
                <input name="log-red" type="hidden" value="<%=logred%>"/>
                <input name="log-error" type="hidden" value="error"/>
            <%}else if(status.equals("reset-ko")){%>
               <input name="pwd" type="hidden" value="<%=pwd%>"/>
               <input name="log-error" type="hidden" value="error"/>     
            <%}else if(status.equals("forgot-ko")){%>
               <input name="log-mail" type="hidden" value="<%=email%>"/>
               <input name="log-error" type="hidden" value="error"/>       
            <%}%>
        </form>
    </body>
</compress:html>
</html>