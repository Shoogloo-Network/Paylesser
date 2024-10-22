<%-- 
    Document   : signup
    Created on : Nov 26, 2014, 5:15:28 PM
    Author     : jincy.p
--%>

<%
  LoginInfo lInfo = new LoginInfo();
  lInfo = (LoginInfo)session.getAttribute("userObj");
  String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
  String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  String logError = request.getParameter("log-error") == null ? "" : request.getParameter("log-error").replaceAll("\\<.*?>", "");  
  String requestUrl = request.getRequestURL().toString();
  String domainName = "";
  String pageName = "";
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
  String pageType = SystemConstant.SIGNUP;
  String pageTypeFk = "";
  List<MetaTags> metaList = home.getMetaByDomainId(domainId);
  String signupRed = request.getParameter("sign-red") == null ? "" : request.getParameter("sign-red").replaceAll("\\<.*?>", "");
  String refUrl = (String)request.getHeader("referer");
  if(!"".equals(signupRed)){
      refUrl = signupRed;
  }
  String langId = CommonUtils.getcntryLangCd(domainId);
%>
<!DOCTYPE html>
<%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html lang="<%=langId%>" itemscope itemtype="https://schema.org/WebPage"> 
    
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">	
    <meta name=viewport content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex">		
    <%for (SeoUrl s : seoList) {
        if (pageType.equals(s.getPageType())) {
          if (language.getId().equals(s.getLanguageId())) {
    %>
    <title itemprop="name"><%=s.getPageTitle()%></title>
    <meta name="description" content="<%=s.getMetaDesc()%>">
    <meta name="keywords" content="<%=s.getMetaKeyword()%>">
    <%
            break;
          }
        }
      }%>
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
    <!-- ======================Main Wraper Start==================== -->
<div id="wraper" class="inner">   
    <%@include file="common/topMenu.jsp" %>
     <div class="store-middle">
        <div class="container">
            <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="login-outer">
                            <div class="login-form" style="display: block;">
                                <h3 style="">SignUp</h3>
                                 <%if("error".equals(logError)){%> 
                                    <p class="error-msg" style="color:red">Some error occurred, please submit again</p>
                                 <%}%>
                                <form name="frmSignUp" id="frmSignUp" action="/signupdb" method="post">              
                                    <div class="login-box">
                                        <div class="social-block">
                                            <div class="facebook-button" onclick="javascript:loginFB('<%=pageName%>','<%=appId%>','<%=pageUrl%>');">
                                                <div class="icon-facebook"></div>
                                                <span><i class="fa fa-facebook" aria-hidden="true"></i>
                                                        Log In With Facebook</span>
                                            </div>
                                           
                                            <h5>OR</h5>
                                        </div>

                                        <div class="form-item">
                                            <input  class="input-login" type="text" name="userName" id="userName" placeholder="<%=p.getProperty("public.signup.name")%>">
                                            <p class="error" id ="errName"></p>
                                        </div>  
                                        <div class="form-item">
                                            <input  class="input-login error" placeholder="<%=p.getProperty("public.login.email")%>" type="text" name="userEmail" id="userEmail">
                                            <p class="error" id="errEmail"></p>
                                        </div>
                                        <div class="form-item">
                                            <input class="input-login" placeholder="<%=p.getProperty("public.login.password")%>" type="password" name="userPassword" id="userPassword">
                                            <p class="error" id="errPassword"></p>
                                        </div>
                                        <div class="form-item">
                                            <input class="input-login" placeholder="<%=p.getProperty("public.home.city")%>" type="text" name="userCity" id="userCity">
                                            <p class="error" id="errCity"></p>
                                        </div>
                                            
                                        
                                       <div class="form-item">
                                            <input id="signup-btn" value="<%=p.getProperty("public.signup.create_account")%>" class="input-login submit-login" onclick="javascript:signIn('<%=domainId%>','<%=pageUrl%>');" type="button">
                                        </div>
                                        <div class="login-click "><%=p.getProperty("public.signup.member")%><a href="/user-login" class="show-user-login-dropdown"><%=p.getProperty("public.signup.signin")%></a></div>
                                    </div>
                                    <input type="hidden" name="domainId" id="domainId" value="<%=domainId%>"/>
                                    <input type="hidden" name="languageId" id="languageId" value="<%=language.getId()%>"/>
                                    <input id="red-url" name="red-url" type="hidden" value="<%=refUrl%>">
                               </form>
                            </div>
                    </div>   
                </div>
                
                        
                            
            </div>    
        </div>
    </div>
    
  <!-- ======================Company Profile End==================== -->
  </div>
<!-- ======================Main Wraper End======================= -->   
   
 <%@include file="common/bottomMenu.jsp"%>   
<%@include file="common/footer.jsp" %>
<script>
  emailRequired = '<%=p.getProperty("public.messages.emailRequired")%>';
  emailInvalid = '<%=p.getProperty("public.messages.emailInvalid")%>';
  nameRequired = '<%=p.getProperty("public.messages.nameRequired")%>';
  passwordRequired = '<%=p.getProperty("public.messages.passwordRequired")%>';
  cpasswordRequired = '<%=p.getProperty("public.messages.cpasswordRequired")%>';
  passwordMismatch = '<%=p.getProperty("public.messages.passwordMismatch")%>';
  emailexist = '<%=p.getProperty("public.messages.emailexist")%>';
  passwordlength = '<%=p.getProperty("public.messages.passwordLength")%>';
</script>
<script src="<%=SystemConstant.PATH%>js/signup.js"></script>
</body>
</compress:html>
</html>

