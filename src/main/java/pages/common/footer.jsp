<%-- 
    Document   : footer
    Created on : Nov 12, 2014, 5:48:05 PM
    Author     : sanith.e
--%>

<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="java.io.File"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%
    int loggedIn = 1;
    int loginDialogError=-1;
    if(session.getAttribute("userObj") == null) {
        loggedIn = 0;
    }
    String logStatus= request.getParameter("log-status"); 
    if(logStatus!=null && logStatus.equals("ko"))
    {
        loginDialogError=0; // error while login
    }else if(logStatus!=null && logStatus=="ok"){
        loginDialogError=1;
    }
%>
<script type="text/javascript">
    var userId = <%=loggedIn%>;
    var loginDialogError = <%=loginDialogError%>;
</script> 

<!-- ======================Login Model Start======================-->
<%--
<div id="loginModal" class="modal fade login" role="dialog">
    <div class="vertical-alignment-helper">    
      <div class="modal-dialog vertical-align-center"> 
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title"><%=p.getProperty("public.home.login")%></h4>
          </div>
          <div class="modal-body">
              <p class="error-msg hidden" id="log-error"><%=p.getProperty("public.home.footer.msginvalid")%></p>
              <form id="f-log" action="<%=pageUrl%>login" method="post">
                <div class="form-group">
                  <input type="text" class="form-control"  id="usr" name="usr" autocomplete="off" value="<%=logMail%>" maxlength="100" placeholder="<%=p.getProperty("public.login.email")%>"/>
                </div>
                <div class="form-group">
                  <input type="password" class="form-control" id="pwd" name="pwd" autocomplete="off" value="<%=logPwd%>" maxlength="30" placeholder="<%=p.getProperty("public.login.password")%>"/>
                </div>
                <div class="form-group pull-left loggedin">
                    <input  name="cookie_save" type="checkbox" value="yes" <%out.print(logSave.equals("yes") ? "checked" : "");%>/>
                     <%=p.getProperty("public.home.footer.kepp_login")%>
                </div> 
                <div class="clearfix"></div>
                 <div class="form-group pull-left forgot">
                    <a href="javascript:togLogin(1);" class="forgot-pwd"><%=p.getProperty("public.login.forgot_password")%></a>
                </div>
                <input id="log-type" name="log-type" type="hidden" value="web"/>
                <input id="red-url" name="red-url" type="hidden"/>
                <input id="log-status" type="hidden" value="<%=login%>"/>
                <div class="form-group pull-right">
                    <button type="button" class="btn green" onclick="javascript:login();"><%=p.getProperty("public.login.submit")%></button>
                </div>
              </form>
                <form id="f-forgot" method="post" style="display:none">
                <div class="div-forgot hide-store">
                   <p class="error-msg" id="forgot-error"><%=p.getProperty("public.login.email_invalid")%></p>
                   <div class="middle-line-wrap">
                      <div class="middle-line">
                         <h4><%=p.getProperty("public.home.forgot")%></h4>
                      </div>
                   </div>
                   <label><%=p.getProperty("public.login.email")%></label> 
                   <div class="form-group"><input type="text" class="form-control" id="fusr" name="usr" autocomplete="off" value="" maxlength="100" placeholder="<%=p.getProperty("public.login.email")%>"></div>
                   <div class="btn-wrap mrt-20">
                      <a href="javascript:forget();" class="submit-btn popup-btn btn green"><%=p.getProperty("public.login.request")%></a> 
                   </div>
                </div>
                <input name="log-type" type="hidden" value="forgot"> <input id="red-furl" name="red-url" type="hidden"> 
             </form>
              <div class="login-or">
                <hr class="hr-or">
                <span class="span-or"><%=p.getProperty("public.login.or")%></span>
              </div>
              <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-12 login-fb">
                  <a href="javascript:loginFB('<%=pageName%>','<%=appId%>','<%=pageUrl%>');" class="facebook"><img src="<%=SystemConstant.PATH%>images/login-fb.png" alt="login-fb"></a>
                </div>               
              </div>
          </div>
          <div class="modal-footer">
            <p><%=p.getProperty("public.login.no_account")%> <a href="<%=pageUrl+signupUrl%>"> <%=p.getProperty("public.login.join_now")%></a></p>
          </div>
        </div>
      </div>
    </div>    
</div>

--%>
<!-- ======================Newsletter Subscription Model Start======================-->    
<%if(domain != null && "1".equals(domain.getPopSt())){ %>
<div id="newsletterModel" class="modal fade newslettermodel">
        <div class="vertical-alignment-helper">
            <div class="modal-dialog vertical-align-center"> 
                <div class="modal-content">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                    <div class="modal-body">

                        <% 
                            //ServletContext con = request.getServletContext();
                            //String path = con.getRealPath(SystemConstant.PATH + "images/popup/pop-"+domain.getId()+".png");
                            //File f = new File(path); 
                            //if(f.exists()){ 
                        %>
                         <!--   <img src="<%=SystemConstant.PATH%>images/popup/pop-<%=domain.getId()%>.png" alt="pop-<%=domain.getId()%>"> -->
                        <%  //}else{ %>
                           <!-- <img src="<%=SystemConstant.PATH%>images/popup/pop-0.png" alt="pop-0"> -->
                        <% //} %>  
                        <img src="<%=SystemConstant.PATH%>images/popup/common-popup.png" alt="pop-0">
                            <%
                                String stylesubscribe="style='font-size:28px'";
                                if(!"1".equals(language.getId())){ // for eng only
                                    stylesubscribe="";
                                }
                            %>
                           <div class="pop-content">
                            <%if(domain != null && domain.getPopH1() != null){ %>
                                  <h4><%=domain.getPopH1()%></h4>
                            <%}%>
                            <%if(domain != null && domain.getPopH1() != null){ %>
                                  <h3><%=domain.getPopH2()%></h3>
                            <%}%>  
                       
                            <form onsubmit="return  false">
                            <div class="form-group form">
                                <input autocomplete="off" class="form-control" type="text" name="email" id="email" placeholder="<%=p.getProperty("public.home.email_address")%>">
                                <div id="loading" style="display:none;"></div>
                                <button class="btn btnSubmit btn-primary"><%=p.getProperty("public.login.join_now")%></button>
                            </div>
                            </form>
                        <ul class="popup-stores">
                            <%  int sCount1 = 0;
                                 if (storeListByDomain != null) {
                                     for (Store store : storeListByDomain) {
                                         sCount1++;
                                         if (language.getId().equals(store.getLanguageId())) {%>
                                 <li><a href="<%=pageUrl + store.getSeoUrl()%>"><img src="<%=cdnPath + store.getImageBig() %>" alt="<%=store.getName()%> offers"></a></li>                       
                              <% } if(sCount1>4){break;}
                     } } %>                                
                            </ul>
                        </div>    
        
                    </div>
                </div>
            </div>
        </div>    
</div>
<%}%>
<nav id="menu">
<ul>                        
    <li><a href="<%=pageUrl + allstoreUrl%>" rel="nofollow">Top Stores</a></li>
    <li><a href="<%=pageUrl + allcategoryUrl%>" rel="nofollow"><%=p.getProperty("public.home.allcategories")%></a></li>
        <!-- <ul>
             <% int storCount=0;
                 if (storeListByDomain != null) {
                   for (Store st : storeListByDomain) {
                         if (storCount < 10) {
                           if (language.getId().equals(st.getLanguageId())) {
                                 storCount++;
             %> 
                             <li><a href="<%=pageUrl + st.getSeoUrl()%>" rel="nofollow"><%=st.getName()%></a></li>  

             <% } } } }%>
             <li><a href="<%=pageUrl + allstoreUrl%>" rel="nofollow"><%=p.getProperty("public.home.allstores")%></a></li>
         </ul>
     
     <ul>
         <% int catgCount = 0;
         if (categoriesListHeader != null) {
         for(Category cat : categoriesListHeader){
             if (catgCount < 10) {
             if (language.getId().equals(cat.getLanguageId())) {
                 catgCount++;
          %> 
         <li><a href="<%=pageUrl + cat.getSeoUrl()%>" rel="nofollow"><%=cat.getName()%></a></li> 
         <% } } } }%>
         <li><a href="<%=pageUrl + allcategoryUrl%>" rel="nofollow"><%=p.getProperty("public.home.allcategories")%></a></li>
     </ul>
            <li><a href="#"><%=p.getProperty("public.home.about")%></a>
             <ul>
                 <% if ("1".equals(homeConfig.getSpecials())) { %>
                     <li><a href="<%=pageUrl + allSpecialUrl%>"><%=p.getProperty("public.special.ourspecials")%></a></li>
                <% } %>
                <li><a href="<%=pageUrl+aboutusUrl%>"><%=p.getProperty("public.home.about_us")%></a></li>
                <li><a href="<%=pageUrl+privacy%>"><%=p.getProperty("public.home.privacy")%></a></li>
                <li><a href="<%=pageUrl+contactusUrl%>"><%=p.getProperty("public.home.contact_us")%></a></li>
                <li><a href="<%=pageUrl+hiringUrl%>"><%=p.getProperty("public.home.hiring")%></a></li>
                <li><a href="<%=managementUrl%>" target="_blank"><%=p.getProperty("public.home.management_team")%></a></li>
                <li><a href="<%=pageUrl%>faq"><%=p.getProperty("public.home.footer.faq")%></a></li>
                <li><a href="/blog/" target="_blank">Blog</a></li>                                     
             </ul>
         </li> -->


         <li><a href="<%=pageUrl + top20OUrl%>" rel="nofollow"><%=p.getProperty("public.home.top")+ p.getProperty("public.home.20")%></a></li>
         <li><a href="<%=pageUrl + exclusiveUrl%>" rel="nofollow"><%=p.getProperty("public.home.exclusive")%></a></li>
         <%
             if ("1".equals(homeConfig.getSpecials())) {
         %>
              <li><a href="<%=pageUrl + allSpecialUrl%>" rel="nofollow"><%=p.getProperty("public.special.ourspecials")%></a></li>
         <% } %>
         <%if(!(spName.isEmpty() || "".equals(spName))){%>
         <li><a href="<%=spSeoUrl%>"  rel="nofollow"><%=spName%></a></li>
         <%}%>

         <%if (session.getAttribute("userObj") == null) {%>
         <li><a href="<%=pageUrl%>user-login" rel="nofollow"><%=p.getProperty("public.home.login")%></a></li>
         <li><a href="<%=pageUrl + signupUrl%>" rel="nofollow"><%=p.getProperty("public.home.signup")%></a></li>
         <%} else {%>
         <li><a href="<%=pageUrl%>user-profile" rel="nofollow"><%=p.getProperty("public.home.profile")%></a></li>
         <li><a href="<%=pageUrl%>logout" rel="nofollow"><%=p.getProperty("public.home.logout")%></a></li>
         <%}%>
     </ul>
 </nav>
<a href="#mm-0" class="scrolltop show" id="back-to-top" title="Back to top"><i class="fa fa-arrow-up" aria-hidden="true"></i></a>
<script>
    fbGraph = '<%=domain.getFbLink() == null ? "0" : domain.getFbLink()%>';
    subCatFilter = 0;
    cord = 0;  
    domainId = <%=domainId%>;
    pageUrl = '<%=pageUrl%>';
    langId = <%=language.getId()%>;
    email_footer = '<%=p.getProperty("public.home.footer.email")%>';
    email_error_message = '<%=p.getProperty("public.home.newsletter.email_error_message")%>';
    email_invalid = '<%=p.getProperty("public.home.newsletter.email_invalid")%>';
    invalid_email = '<%=p.getProperty("public.login.email_invalid")%>';
    email_address = '<%=p.getProperty("public.home.email_address")%>';
    enter_pwd = '<%=p.getProperty("public.login.enter_password")%>';
    add_fav = '<%=p.getProperty("public.login.add_fav")%>';
    log_submit = '<%=p.getProperty("public.login.submit_coupon")%>';
    save_coup = '<%=p.getProperty("public.login.save_coupon")%>';
    context = '<%=SystemConstant.PATH%>';
    couponDetails = '<%=couponDetails%>';
    pageType='<%=pageType%>';
    var productBase="<%="/" + SystemConstant.ROOT_URL +"/"%>";
</script>
<%=domain.getAnalyticsCode()%>
<%/*<script>
window.addEventListener('load',function(){
  jQuery('.my-coupon:contains(Get Coupon)').click(function(){
    (new(Image)).src="//www.googleadservices.com/pagead/conversion/958993065/?label=ukN9CO7X-2sQqaWkyQM&guid=ON&script=0";
  })
  jQuery('.my-coupon:contains(Get Offer)').click(function(){
    (new(Image)).src="//www.googleadservices.com/pagead/conversion/958993065/?label=VrTGCLTZ-2sQqaWkyQM&guid=ON&script=0";
  })
  if(window.location.pathname.match('/offers/')){
    jQuery('[href*="/out?id="]').click(function(){
                                                (new(Image)).src="//www.googleadservices.com/pagead/conversion/958993065/?label=nmYhCJ-H42sQqaWkyQM&guid=ON&script=0";
    })
  }
})
</script>*/%>
<img height="1" width="1" style="border-style:none;display:table;position:fixed;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/875210755/?guid=ON&amp;script=0"/>

                
<g:compress> 
<script  src="<%=SystemConstant.PATH%>js/jquery.min.js"></script>
<script  src="<%=SystemConstant.PATH%>js/jquery-ui.min.js"></script>
<script  src="<%=SystemConstant.PATH%>js/bootstrap.min.js"></script>
<script  src="<%=SystemConstant.PATH%>js/jquery.cookie.js"></script>
<script  src="<%=SystemConstant.PATH%>js/modernizr.custom.js"></script>
<script  src="<%=SystemConstant.PATH%>js/owl.carousel.min.js"></script>
<script type="text/javascript" src="<%=SystemConstant.PATH%>js/pl.js"></script>
<script  src="<%=SystemConstant.PATH%>js/custom.js"></script> 
<script type="text/javascript" src="<%=SystemConstant.PATH%>js/jquery.mmenu.all.min.js"></script>
<script src="<%=SystemConstant.PATH%>js/clipboard.min.js"></script>
<script type="text/javascript" src="<%=SystemConstant.PATH%>js/jRating.jquery.js"></script>
<script type="text/javascript" src="<%=SystemConstant.PATH%>js/jquery.unveil.js"> </script>
</g:compress>  
<script  src="http://code.jquery.com/jquery-migrate-1.0.0.js"></script>
<!--<script  src="<%=SystemConstant.PATH%>js/client.min.js"></script> -->
<script>  
$(document).ready(function() {   
   /* var client = new ClientJS(); 
    var xkey = client.getFingerprint();
    <% //if(session.getAttribute("fPrint")==null){%>
       $.ajax({
            url: '/pages/common/event.jsp?xkey=' +xkey,
           success: function (r) {},
          async: true
        });*/
    <% //}%>
    var clipboard = new Clipboard('.btn');
    clipboard.on('success', function(e) {
    $(".copy-voucher").tooltip('enable');
    $(".copy-voucher").tooltip('show');
    setTimeout(function(){ $(".copy-voucher").tooltip('hide');$(".copy-voucher").tooltip('disable'); }, 1000);
    });
 });
</script>
<!--<script async src="<%=SystemConstant.PATH%>js/facebook.js"></script>
-->


<input type="hidden" value="<%=(System.getenv("HOSTNAME")!=null) && (!System.getenv("HOSTNAME").equals(""))?(System.getenv("HOSTNAME")).replace("ip", "").replace("-", "+"):""%>" />
