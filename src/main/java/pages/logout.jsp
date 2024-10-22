<%-- 
    Document   : logout
    Created on : Nov 28, 2014, 10:39:57 AM
    Author     : shabil.b
--%>

<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String redirect = request.getParameter("goto") == null ? "" : request.getParameter("goto").replaceAll("\\<.*?>", "");
    String domainName = (String) session.getAttribute("domainName");
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    String appId = home.getAppId(domainId);
    if (session.getAttribute("userObj") != null) {
        session.removeAttribute("userObj");
        session.removeAttribute("favStore");
        session.removeAttribute("savedOffer");
        //session.invalidate();
        session.setAttribute("success","You have been safely logged out.");
    }   
    String refUrl = (String)request.getHeader("referer");
    if(null!=refUrl){
        pageUrl = refUrl;
    }
%>
<!DOCTYPE html>
<html class="no-js"  lang="<%=session.getAttribute("isoCode")%>">
    <head>					
        <title itemprop="name">Paylesser Logout</title>	       
        <meta http-equiv="refresh" content="0; url=<%=pageUrl %>" />  
        <script src="<%=SystemConstant.PATH%>js/vendor/jquery-1.11.0.min.js"></script>
        <script src="<%=SystemConstant.PATH%>js/jquery.cookie.js"></script>
        <script type="text/javascript">
            redirect();
         /*   var fbAppId = '<%=appId%>';
            window.fbAsyncInit = function () {
                FB.init({
                    appId: fbAppId,
                    cookie: true, // enable cookies to allow the server to access
                    xfbml: true, // parse social plugins on this page
                    version: 'v2.0' // use version 2.0
                });
                FB.getLoginStatus(function (response) {
                    if (response.status === 'connected') {
                        console.log('getLoginStatus 1: ' + response.status);
                        disconnectFB();
                    }
                    else {
                        console.log('getLoginStatus else: ' + response.status);
                        redirect();
                    }
                });
            }; */
            //Load the SDK asynchronously
         /*   (function (d, s, id) {
                var js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(id))
                    return;
                js = d.createElement(s);
                js.id = id;
                js.src = "<%=pageUrl%>resources/js/sdk.js";
                fjs.parentNode.insertBefore(js, fjs);
            }(document, 'script', 'facebook-jssdk'));

            function disconnectFB() {
                FB.logout();
                redirect();
            } */
            var redirect = function () {
                $.removeCookie('@@us__ml__' +<%=domainId%>);
                $.removeCookie('@@us__pw__' +<%=domainId%>);
                //$('#f-red').submit();
            }
        </script>
    </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
    <body >
       <!-- <form id="f-red" action="<%=redirect%>" method="post"></form>-->
    </body>
</compress:html>
</html>