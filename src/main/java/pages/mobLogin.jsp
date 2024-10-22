<%-- 
    Document   : mobLogin
    Created on : Dec 02, 2014, 11:15:28 AM
    Author     : Shabil Basheer
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
String redirect = request.getParameter("redirect") == null ? "" : request.getParameter("redirect").replaceAll("\\<.*?>", "");
String requestUrl = request.getRequestURL().toString();
String domainName = "";
String pageName = "";

if(!redirect.equals("") && session.getAttribute("mobileRedirect") == null) {
    session.setAttribute("mobileRedirect", redirect);
}

domainName = (String)session.getAttribute("domainName");
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
String pageType = SystemConstant.HOME;
String pageTypeFk = "";
List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> 
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html class="no-js"  lang="<%=session.getAttribute("isoCode")%>"> 
    
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">	
<%if("www.testvoucher.asia".equals(domainName) || "www.testcoupon.asia".equals(domainName)){%>
	<meta name="robots" content="noindex">
<%}%>		
        <title itemprop="name">Voucher Codes | Login </title>    
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %>        
        <%@include file="common/header.jsp" %>
        </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
        <body>
            <!--[if lt IE 7]>
                <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
            <![endif]-->
        <%@include file="common/topMenu.jsp" %>
        <div class="page-content clearfix inner-page">
            <div class="wrapper clearfix">           
                <div class="popup-wrap mobile-popup">
                    <div class="popup">
                        <div class="txt-right">
                            <a class="icon-close cursor-href">Close</a>
                        </div>
                        <div class="login-popup">
                            <form id="f-moblogg" action="<%=pageUrl%>login" method="post">
                                <div class="div-login">
                                    <div class="middle-line-wrap">
                                        <p class="error-msg" id="log-error"><%=p.getProperty("public.home.footer.msginvalid")%></p>
                                        <div class="middle-line">
                                            <h2 class="text"><%=p.getProperty("public.home.login")%></h2>
                                        </div>
                                    </div>
                                    <label><%=p.getProperty("public.login.email")%></label>
                                    <input autocomplete="off" id="mobusr" name="usr" type="text" class="login-txt" value="<%=logMail%>"/>
                                    <label><%=p.getProperty("public.login.password")%></label>
                                    <input autocomplete="off" id="mobpwd" name="pwd" type="password" class="login-txt" value="<%=logPwd%>"/>
                                    <div class="remember">
                                        <input name="cookie_save" type="checkbox" value="yes"/>
                                        <%=p.getProperty("public.home.footer.kepp_login")%>
                                    </div>
                                    <a href="javascript:togLogin(1);" class="forgot-pwd"><%=p.getProperty("public.login.forgot_password")%></a>
                                    <div class="btn-wrap">
                                        <a href="javascript:mobAllow();" class="submit-btn popup-btn"><%=p.getProperty("public.login.submit")%></a>
                                        <div class="middle-line-wrap">
                                            <div class="middle-line">
                                                <h3 class="text"><%=p.getProperty("public.login.or")%></h3>
                                            </div>
                                        </div>
                                        <a href="javascript:loginFB('<%=pageName%>','<%=appId%>','<%=pageUrl%>');" class="login-fb"><%=p.getProperty("public.login.fb_login")%></a>
                                    </div>
                                    <p class="no-account"><%=p.getProperty("public.login.no_account")%> <a href="<%=pageUrl+signupUrl%>" class="join-now"><%=p.getProperty("public.login.join_now")%></a> </p>
                                    <input id="log-status" type="hidden" value="<%=login%>"/>
                                    <input name="type" type="hidden" value="mobile"/>
                                </div>
                            </form>
                            <form id="f-mobforgot" action="<%=pageUrl%>login" method="post">
                                <div class="div-forgot hide-store">
                                    <div class="middle-line-wrap">
                                        <p class="error-msg" id="forgot-error"><%=p.getProperty("public.home.footer.notregistered")%></p>
                                        <div class="middle-line">
                                            <h2 class="text"><%=p.getProperty("public.home.forgot")%></h2>
                                        </div>
                                    </div>
                                    <label><%=p.getProperty("public.login.email")%></label>
                                    <input autocomplete="off" id="fusr" name="usr" type="text" class="login-txt" value="<%=logMail%>"/>
                                    <div class="btn-wrap mrt-20">
                                        <a href="javascript:mobForget();" class="submit-btn popup-btn"><%=p.getProperty("public.login.submit")%></a>
                                        <div class="middle-line-wrap">
                                            <div class="middle-line">
                                                <h3 class="text"><%=p.getProperty("public.login.or")%></h3>
                                            </div>
                                        </div>
                                        <a class="login-fb cursor-href"><%=p.getProperty("public.login.fb_login")%></a>
                                    </div>
                                    <p class="no-account"><%=p.getProperty("public.login.account")%> <a href="javascript:togLogin(2);" class="join-now"><%=p.getProperty("public.home.login")%></a> </p>
                                    <input id="log-status" type="hidden" value="<%=login%>"/>
                                    <input name="type" type="hidden" value="mobile"/>
                                    <input name="log-type" type="hidden" value="forgot"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@include file="common/bottomMenu.jsp"%>
</section>
</div>        
<!--<script src="<%=SystemConstant.PATH%>js/jquery.flexslider.js"></script>-->
<%@include file="common/footer.jsp" %>
</body>
</compress:html>
</html>