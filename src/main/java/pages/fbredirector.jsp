<%-- 
    Document   : fbredirector
    Created on : Nov 28, 2014, 9:55:02 AM
    Author     : jincy.p
--%>

<%@page import="sdigital.vcpublic.home.SeoUrl"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="wawo.util.StringUtil"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
  LoginInfo lInfo = new LoginInfo();
  lInfo = (LoginInfo) session.getAttribute("userObj");
  String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
  String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log0mail").replaceAll("\\<.*?>", "");
  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  String requestUrl = request.getRequestURL().toString();
  String domainName = "";
  String pageName = "";
  domainName = (String) session.getAttribute("domainName");
  String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
  VcHome home = VcHome.instance();
  VcSession vcsession = VcSession.instance();
  String domainId = home.getDomainId(domainName);
  List<Domains> domains = home.getDomains(domainId);
  Domains domain = home.getDomain(domains, domainId); // active domain
  List<Language> languages = home.getLanguages(domain.getId());
  Language language = vcsession.getLanguage(session, domain.getId(), languages);
  Properties p = home.getLabels(language.getId());
  HomeConfig homeConfig = home.getConfig(domainId);
  List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
  String pageType = SystemConstant.SIGNUP;
  String pageTypeFk = "";
  String appId = home.getAppId(domainId);
%>
<!DOCTYPE html>
<html>
  <head>
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>			
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
    <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>
    <link href="<%=SystemConstant.PATH%>css/screen.css?ver=1.0" media="screen, projection" rel="stylesheet" type="text/css" />
    <title itemprop="name">Redirecting to Paylesser</title>
    <meta name="robots" content="noindex, nofollow">
    <script>
      var pageUrl = '<%=pageUrl%>';
      var fbAppId = '<%=appId%>';
      window.fbAsyncInit = function() {
        FB.init({
          appId: fbAppId,
          cookie: true, // enable cookies to allow the server to access
          xfbml: true, // parse social plugins on this page
          version: 'v2.8' // use version 2.8
        });
        FB.getLoginStatus(function(response) {
          if (response.status === 'connected') {
            console.log('getLoginStatus 1: ' + response.status);
            connectFB();
          }
          else {
            $('#button').css('visibility', 'visible');
            console.log('getLoginStatus else: ' + response.status);
          }
        });
      };
      //Load the SDK asynchronously
      (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));

      function connectFB() {
        FB.api('/me?fields=id,first_name,last_name,gender,email', function(response) {
          if (response.email === '' || typeof response.email === 'undefined') {
            //alert('Your e-mail id is not available, please try again !');
            if (confirm("Your e-mail id is not available, please try again!") == true) {
              $("#fbLoginRedirect").submit();
            }
          }
          else {
            var name = response.first_name + ' ' + response.last_name;
            $.ajax({
              type: "POST",
              url: pageUrl + "fblogin",
              data: "fId=" + response.id + "&fName=" + name + "&fEmail=" + response.email + "&fGender=" + response.gender + "&ct=" + new Date().valueOf(),
              success: function(data) {
                $("#fbLoginRedirect").submit();
              },
              error: function(xml, status, e) {
              },
              global: false
            });
          }
        });
      }

    </script>
  </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
  <body>  
    <div class="fb-login"  style="margin:0 auto;text-align: center">
      <img src="<%=SystemConstant.PATH%>images/pl-logo.png" alt="logo"/>  
      <ul class="dots" style="list-style: none;padding:0">
        <li class="dot1"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot2"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot3"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot4"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot5"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot6"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
        <li class="dot7"><img src="<%=SystemConstant.PATH%>images/dot-single.png" alt="image"/></li>
      </ul>
      <div class="social-logo">
        <img src="<%=SystemConstant.PATH%>images/FB.png" alt="image"/>
      </div>
    </div>  
    <%
      String homeUrl = "";
      for (SeoUrl seo : seoList) {
        if (seo.getLanguageId().equals(language.getId()) && SystemConstant.HOME.equals(seo.getPageType())) { // has to change
          homeUrl = seo.getSeoUrl();
        }
      }
      String url = (String)session.getAttribute("parentUrl");
      url = StringUtil.isEmpty(url) ? homeUrl : url;
    %>
    <form name="fbLoginRedirect" id="fbLoginRedirect" action="<%=url%>" method="post"></form>
    <%session.removeAttribute("parentUrl");%>
  </body>
</compress:html>
</html>