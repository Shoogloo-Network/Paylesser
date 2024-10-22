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
  String email = request.getParameter("u") == null ? "" : request.getParameter("u").replaceAll("\\<.*?>", "");
  String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
  String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
  String logError = request.getParameter("log-error") == null ? "" : request.getParameter("log-error").replaceAll("\\<.*?>", "");  
  String action = request.getParameter("action") == null ? "" : request.getParameter("action").replaceAll("\\<.*?>", "");  
  String code = request.getParameter("uid") == null ? "" : request.getParameter("uid").replaceAll("\\<.*?>", "");    
  String logRed = request.getParameter("log-red") == null ? "" : request.getParameter("log-red").replaceAll("\\<.*?>", "");
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
  String pageType = SystemConstant.LOGIN;
  String pageTypeFk = "";
  List<MetaTags> metaList = home.getMetaByDomainId(domainId);
  String refUrl = (String)request.getHeader("referer");
  if(!"".equals(logRed)){
      refUrl = logRed;
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
    <meta name="keywords" content="<%=s.getMetaKeyword()%>">\
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
                                              
                        <%if("forgot-password".equals(action)){%>
                          
                                <h3 style=""><%=p.getProperty("public.home.forgot")%></h3>
                                 <%if("error".equals(logError)){%> 
                                   <p class="error-msg" style="color:red"><%=p.getProperty("public.home.invalidcredential")%></p>
                                   <p class="error-msg" ><a href="<%=pageUrl+signupUrl%>" ><b><%=p.getProperty("public.login.join_now")%></b></a></p>
                                 <%}%>
                                 <form id="f-forgot" method="post" >
                                    <div class="login-box">                           

                                        <div class="form-item">
                                          <input  class="input-login" type="text" id="fusr" name="usr" autocomplete="off" value="<%=logMail%>" maxlength="100" placeholder="<%=p.getProperty("public.login.email")%>">                  
                                        </div> 

                                       <div class="form-item">
                                          <input id="forgot-btn" value="<%=p.getProperty("public.login.request")%>" class="input-login submit-login" onclick="javascript:forget();" type="button">
                                      </div>
                                    </div>
                                    <input name="usr" type="hidden" value="<%=email%>">   
                                    <input name="log-type" type="hidden" value="forgot">
                                    <input id="red-furl" name="redf-url" type="hidden">                                    
                                 </form>      
                         <%}else if("reset-password".equals(action) && !"".equals(email) && !"".equals(code)){%>                                                     
                               <h3 style="">Reset Password</h3>
                                <%if("error".equals(logError)){%> 
                                 <p class="error-msg" style="color:red"><%=p.getProperty("public.home.updateerror")%></p>
                                <%}%>  
                                <form id="f-reset" method="post" >
                                   <div class="login-box">    

                                     <div class="form-item">
                                         <input  class="input-login" type="password"  id="pwd" name="pwd" autocomplete="off" value="<%=logPwd%>" maxlength="30" placeholder="<%=p.getProperty("public.login.password")%>"/>
                                         <p class="error" id ="errPassword"></p>
                                     </div>

                                     <div class="form-item">
                                         <input  class="input-login" type="password"  id="cpwd" name="cpwd" autocomplete="off" value="<%=logPwd%>" maxlength="30" placeholder="<%=p.getProperty("public.signup.cpassword")%>"/>
                                         <p class="error" id ="errCpassword"></p>
                                     </div>

                                      <div class="form-item">
                                         <input class="input-login submit-login" value="<%=p.getProperty("public.login.submit")%>" id="reset-btn" onclick="javascript:resetpass();" type="button">
                                     </div>
                                   </div>
                                   <input name="log-type" type="hidden" value="reset">
                                   <input name="key" type="hidden" value="<%=code%>">
                                   <input name="usr" type="hidden" value="<%=email%>">
                                   <input id="red-rurl" name="redr-url" type="hidden"> 
                                </form>       
                              
                           <%}else{%>  
                              <h3 style=""><%=p.getProperty("public.home.login")%></h3>
                              <%if(!"".equals(logError)){%>
                                <p class="error-msg" style="color:red"><%=p.getProperty("public.home.footer.msginvalid")%></p>
                              <%}%>
                              <form  id="f-log" action="<%=pageUrl%>login" method="post">
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
                                          <input  class="input-login error" type="text"  id="usr" name="usr" autocomplete="off" value="<%=logMail%>" maxlength="100" placeholder="<%=p.getProperty("public.login.email")%>"/>
                                          <p class="error" id="errEmail"></p>
                                      </div>
                                      <div class="form-item">
                                          <input class="input-login" type="password"  id="pwd" name="pwd" autocomplete="off" value="<%=logPwd%>" maxlength="30" placeholder="<%=p.getProperty("public.login.password")%>"/>
                                          <p class="error" id="errPassword"></p>
                                      </div>

                                    <div class="form-item pull-left loggedin">
                                        <input  name="cookie_save" type="checkbox" value="yes" <%out.print(logSave.equals("yes") ? "checked" : "");%>/>
                                         <%=p.getProperty("public.home.footer.kepp_login")%>
                                    </div> 
                                                                   
                                    <input id="log-type" name="log-type" type="hidden" value="web"/>
                                    <input id="red-url" name="red-url" type="hidden"/>
                                    <input id="log-status" type="hidden" value="<%=login%>"/>
                                    <div class="form-item">
                                        <input id="login-btn" type="button" value="<%=p.getProperty("public.login.submit")%>" class="input-login submit-login" onclick="javascript:login();" />
                                    </div>
                                   
                                    <div class="login-click "><%=p.getProperty("public.login.forgot_password")+" "%><a href="/user-login?action=forgot-password" class="show-user-login-dropdown"><%=p.getProperty("public.home.reset")%></a></div>
                                    <div class="login-click"><%=p.getProperty("public.login.no_account") + " "%><a href="<%=pageUrl+signupUrl%>" class="show-user-login-dropdown"><%=p.getProperty("public.login.join_now")%></a></div>
                                </div>
                              </form>
                           <%}%>      
                
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
      $(document).ready(function(){  
        $('#red-url').val('<%= refUrl %>');
        initFB(); // dont load fb on other pages
      });
    </script>
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
     
</body>
</compress:html>
</html>

