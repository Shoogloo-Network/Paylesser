<%-- 
    Document   : topMenu
    Created on : 17 Feb, 2016, 17 Feb, 2016 12:07:08 PM
    Author     : Vivek
--%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.*" %>
<%
  List<Category> categoryList = home.getHomeCatByDomainId(domainId);
  List<Category> categoriesListHeader = home.getCatByDomainId(domainId);
  List<SeoUrl> seoList1 = home.getSeoByDomainId(domainId);
  List<Domains> domainsCountry = home.getDomainsCountry();
  List<Store> storeListByDomain = home.getStoreByDomainId(domainId);
  List<AboutUs> aboutusList = home.getAboutUs(domainId);
  List<Specials> allSpecialListTop = home.getAllSpecial(domainId);
  List<Testimonial> testimonialList = home.getTestimonialByDomainId(domainId);
  String success = session.getAttribute("success") == null ? "" : ((String)session.getAttribute("success")).replaceAll("\\<.*?>", "");  
  String desc = "";
  String homeUrl = "";
  String voucherUrl = "";
  String offerUrl = "";
  String dealUrl = "";
  String newVc = "";
  String endingSoon = "";
  String expired = "";
  String top20OUrl = "";
  String latestV = "";
  String latestD = "";
  String contactusUrl = "";
  String signupUrl = "";
  String aboutusUrl = "";
  String favStores = "";
  String savedOffers = "";
  String hiringUrl = "";
  String managementUrl = "";
  String allcategoryUrl = "";
  String allstoreUrl = "";
  String exclusiveUrl = "";
  String privacy = "";
  String searchUrl = "";
  String appId = "";
  String couponDetails = "";
  String guaranteeUrl = "";
  String allSpecialUrl = "";
  int catCounter = 0;
  String locName = "";
  String locSeo = "";
  String headBread = "";
  String offerCountBC = "";
  String part1 = "";
  String part2 = "";
  String part3 = "";
  String param = "";
  String cdnPath = "";
  String homeSeo = "";
  String marquee = "";
  String rtl = "";
  String lft = "";
  if("8".equals(language.getId())){ // for arabic only
    rtl="rtl";
    lft="lft";
  }
  
  if ((null != home.getMarquee(domainId)) && !(home.getMarquee(domainId).equalsIgnoreCase(""))) {
      marquee = "<div class=\"marquee\">" 
                        + home.getMarquee(domainId) 
                        + "</div>";
  }
  if(domainName.startsWith("www")){
      cdnPath = "http://cdn3." + domainName.substring(4, domainName.length());
  }else{
      cdnPath = SystemConstant.IMAGE_PATH + domainName.substring(3, domainName.length());
  }
  String spSeoUrl = "";
  String spName = "";
  if(allSpecialListTop != null){  
      for(Specials sp : allSpecialListTop){
          if("1".equals(sp.getTopView())){
              spName = sp.getName();
              spSeoUrl= sp.getSeoUrl();
              break;
          }
      }       
  }
  try {
    appId = home.getAppId(domainId);
    if (session.getAttribute("favStore") != null) {
      favStores = (String) session.getAttribute("favStore");
    }

    if (session.getAttribute("savedOffer") != null) {
      savedOffers = (String) session.getAttribute("savedOffer");
    }

    for (SeoUrl seo : seoList1) {
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.HOME.equals(seo.getPageType())) { // has to change
        homeUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.TOP_20_V.equals(seo.getPageType())) { // has to change
        voucherUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.TOP_20_O.equals(seo.getPageType())) { // has to change
        offerUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.TOP_20_D.equals(seo.getPageType())) { // has to change
        dealUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.NEW_VC.equals(seo.getPageType())) { // has to change
        newVc = seo.getSeoUrl();
      }
      
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ENDING_SOON.equals(seo.getPageType())) { // has to change
        endingSoon = seo.getSeoUrl();
      }
       if (seo.getLanguageId().equals(language.getId()) && SystemConstant.EXCLUSIVE.equals(seo.getPageType())) { // has to change
        exclusiveUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.EXPIRED.equals(seo.getPageType())) { // has to change
        expired = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.TOP_20.equals(seo.getPageType())) { // has to change
        top20OUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.LATEST_VOUCHERS.equals(seo.getPageType())) { // has to change
        latestV = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.LATEST_DEALS.equals(seo.getPageType())) { // has to change
        latestD = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.SIGNUP.equals(seo.getPageType())) { // has to change
        signupUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.CONTACT_US.equals(seo.getPageType())) { // has to change
        contactusUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ABOUT_US.equals(seo.getPageType())) { // has to change
        aboutusUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.HIRING.equals(seo.getPageType())) { // has to change
        hiringUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.MANAGEMENT_TEAM.equals(seo.getPageType())) { // has to change
        managementUrl = "http://www.shoogloodigital.com/#meet-team";
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ALL_CATEGORIES.equals(seo.getPageType())) { // has to change
        allcategoryUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ALL_STORES.equals(seo.getPageType())) { // has to change
        allstoreUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.PRIVACY.equals(seo.getPageType())) { // has to change
        privacy = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.COUPON_DATILS.equals(seo.getPageType())) { // has to change
        couponDetails = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.GUARANTEE_INFO.equals(seo.getPageType())) { // has to change
        guaranteeUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && SystemConstant.ALL_SPECIALS.equals(seo.getPageType())) { // has to change
        allSpecialUrl = seo.getSeoUrl();
      }

    }

    for (SeoUrl seo : seoList1) {
      if (SystemConstant.HOME.equals(seo.getPageType())) {
                homeSeo = seo.getSeoUrl();
        }  
      if (SystemConstant.SEARCH_RESULT.equals(seo.getPageType()) && language.getId().equals(seo.getLanguageId())) {
        searchUrl = seo.getSeoUrl();
      }
      if (seo.getLanguageId().equals(language.getId()) && (SystemConstant.PUBLIC + seo.getSeoUrl()).equals(session.getAttribute("pageName"))) {
        if (SystemConstant.STORE.equals(seo.getPageType())) {
          locName = p.getProperty("public.home.stores");
          locSeo = allstoreUrl;
          headBread = home.getStoreName(domainId, seo.getSeoUrl())+ " " + p.getProperty("public.store.offers");
          offerCountBC  = home.getStoreOfferCountDesk(pageTypeFk);

        if(offerCountBC==null||offerCountBC=="")
            {
              offerCountBC="0";
            }
            // if(Integer.parseInt(offerCountBC)>=30)
           //offerCountBC="30"; 

        } else if (SystemConstant.CATEGORY.equals(seo.getPageType())) {
          locName = p.getProperty("public.home.allcategories");
          locSeo = allcategoryUrl;
          headBread = home.getCatName(domainId, seo.getSeoUrl(),language.getId());
        } 
        else if (SystemConstant.SPECIAL_CATEGORY.equals(seo.getPageType())) {
          locName = p.getProperty("public.special.ourspecials");
          locSeo = allSpecialUrl;
          String catIdSpec = request.getParameter("d") == null ? "" : request.getParameter("d").replaceAll("\\<.*?>", "");
          headBread = home.getSpecialCat(catIdSpec);   
        } 
        else if (SystemConstant.SPECIAL.equals(seo.getPageType())) {         
          locName = p.getProperty("public.special.ourspecials");
          locSeo = allSpecialUrl;                     
          String specId = request.getParameter("s") == null ? "" : request.getParameter("s").replaceAll("\\<.*?>", "");          
          headBread = home.getSpecialDet(specId);
          String[] parts = headBread.split("###");
          headBread = parts[0];          
        } else if (SystemConstant.ALL_STORES.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.allstores");
        } else if (SystemConstant.ALL_CATEGORIES.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.allcategories");
        } else if (SystemConstant.ALL_SPECIALS.equals(seo.getPageType())) {
          headBread = p.getProperty("public.special.ourspecials");
        } else if (SystemConstant.TOP_20_V.equals(seo.getPageType())) {
          headBread = p.getProperty("public.topvouchers");
        } else if (SystemConstant.TOP_20_O.equals(seo.getPageType())) {
          headBread = p.getProperty("public.topoffers");
        } else if (SystemConstant.TOP_20_D.equals(seo.getPageType())) {
          headBread = p.getProperty("public.topdeals");
        } else if (SystemConstant.TOP_20.equals(seo.getPageType())) {
          headBread = p.getProperty("public.toptwenty");
        } else if (SystemConstant.LATEST_VOUCHERS.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.latest") + " " + p.getProperty("public.home.latest_vouchers");
        } else if (SystemConstant.LATEST_DEALS.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.latest") + " " + p.getProperty("public.home.latest_deals");
        } else if (SystemConstant.NEW_VC.equals(seo.getPageType())) {
          headBread = p.getProperty("public.newvc.vc");
        } else if (SystemConstant.ENDING_SOON.equals(seo.getPageType())) {
          headBread = p.getProperty("public.endingsoon.heading");
        } else if (SystemConstant.EXCLUSIVE.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.exclusive");  
        } else if (SystemConstant.EXPIRED.equals(seo.getPageType())) {
          headBread = p.getProperty("public.expiredv.heading");
        } else if (SystemConstant.ABOUT_US.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.about_us");
        } else if (SystemConstant.PRIVACY.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.privacy");
        } else if (SystemConstant.CONTACT_US.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.contact_us");
        } else if (SystemConstant.HIRING.equals(seo.getPageType())) {
          headBread = p.getProperty("public.hiring.heading");
        } else if (SystemConstant.MANAGEMENT_TEAM.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.management_team");
        } else if (SystemConstant.SIGNUP.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.signup");
        } else if (SystemConstant.SEARCH_RESULT.equals(seo.getPageType())) {
          headBread = p.getProperty("public.home.search_result") + " \"" + CommonUtils.sanitizeQuery(request.getParameter("q")) + "\"";
          param = "?q="+CommonUtils.sanitizeQuery(request.getParameter("q"));
        } else if (SystemConstant.HOW_TO_USE.equals(seo.getPageType())) {
          headBread = p.getProperty("public.howto.heading");
        } else if (SystemConstant.STORE_CATEGORY.equals(seo.getPageType())) {
          locName = p.getProperty("public.home.allstores");
          locSeo = allstoreUrl;
          headBread = home.getStoreCatNameTopMenu(domainId, seo.getSeoUrl(), language.getId());
          String[] parts = headBread.split("###");
          part1 = parts[0];
          part2 = pageUrl + parts[1];
          part3 = parts[2];
          headBread = "";
        } else if (SystemConstant.STORE_BRAND.equals(seo.getPageType())) {
          locName = p.getProperty("public.home.allstores");
          locSeo = allstoreUrl;
          headBread = home.getStoreBrandName(domainId, seo.getSeoUrl(), language.getId());
          String[] parts = headBread.split("###");
          part1 = parts[0];
          part2 = pageUrl + parts[1];
          part3 = parts[2];
          headBread = "";
        } else if (SystemConstant.COUPON_DATILS.equals(seo.getPageType())) {
          String coupId = request.getParameter("vc");
          locName = p.getProperty("public.home.allstores");
          locSeo = allstoreUrl;
          headBread = home.getStoreCoupon(domainId, coupId);
          String[] parts = headBread.split("###");
          part1 = parts[0];
          part2 = pageUrl + parts[1];
          part3 = parts[2];
	  if("Coupon".equals(part3.trim())){ 
            part3 = p.getProperty("public.home.coupondetails.coupon"); 
          } else if("Offer".equals(part3.trim())){ 
            part3 = p.getProperty("public.home.coupondetails.offer"); 
          } else if("Deal".equals(part3.trim())){ 
            part3 = p.getProperty("public.home.coupondetails.deal"); 
          } else if("Sale".equals(part3.trim())){ 
            part3 = p.getProperty("public.home.coupondetails.sale"); 
          } 

          headBread = "";
          param = "?vc="+coupId;
        } 
      }
      
    }
    if ("/articles-detail".equals(request.getRequestURI())) {
        headBread = p.getProperty("public.articles.header");
    }
    if ("/articles".equals(request.getRequestURI())) {
        headBread = p.getProperty("public.articles.header");
    }
    if (SystemConstant.LOGIN_PAGE.equals(request.getRequestURI())) {
          headBread = p.getProperty("public.home.login");
    }     
    if("".equals(domain.getFbLink())) {
    domain.setFbLink(null);
    }
    if("".equals(domain.getTwLink())) {
        domain.setTwLink(null);
    }
    if("".equals(domain.getGpLink())) {
        domain.setGpLink(null);
    }
    if("".equals(domain.getPnLink())) {
        domain.setPnLink(null);
    }
    
%>
<!-- ================================Header Start ===================================-->
<%if(!"".equals(success)){%> 
   <div class="notification success">
        <p><%=success%></p>
        <span class="close">X</span>
    </div>  
<%session.removeAttribute("success");}%>   
<header class="new-header">
   <!--     <div class="top-strip hidden-xs">
            <div class="container">
                <div class="row">
                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-12"> 
                        <ul class="top-social">
                            <li>We are on Social:</li>
                            <%
                            if(domain.getFbLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-facebook-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getFbLink()%>" target="_blank"><i class="fa fa-facebook-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getTwLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-twitter-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getTwLink()%>" target="_blank"><i class="fa fa-twitter-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getGpLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-google-plus-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getGpLink()%>" target="_blank"><i class="fa fa-google-plus-square" aria-hidden="true"></i></a></li>
                            <%}
                            if(domain.getPnLink() == null) {
                            %>
                            <li><a href="<%=pageUrl%>"><i class="fa fa-pinterest-square" aria-hidden="true"></i></a></li>
                            <%} else {%> 
                            <li><a href="<%=domain.getPnLink()%>" target="_blank"><i class="fa fa-pinterest-square" aria-hidden="true"></i></a></li>
                            <% } %>
                        </ul>
                    </div>
                    <%if ((null != home.getMarquee(domainId)) && !(home.getMarquee(domainId).equalsIgnoreCase(""))) {%>    
                        <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 ">
                            <%out.write(marquee);%>
                        </div>
                    <%}%>
                    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-12 pull-right"> 
                        <ul class="top-links">
                            <li><a style="color:#1074ba" href="<%=pageUrl + top20OUrl%>"><%=p.getProperty("public.home.top")+" "+p.getProperty("public.home.20")%></a></li>
                            <li><a style="color:#ff8827" href="<%=pageUrl + exclusiveUrl%>"><%=p.getProperty("public.home.exclusive")%></a></li>
                            
                            <li><a href="<%=pageUrl + allcategoryUrl%>"><%=p.getProperty("public.home.allcategories")%></a>
                            <ul>
                                <%
                                if (categoriesListHeader != null) {
                                for(Category cat : categoriesListHeader){
                                    if (language.getId().equals(cat.getLanguageId())) {
                                 %>
                                 <li><a href="<%=pageUrl + cat.getSeoUrl()%>"><span><%=cat.getName()%></span></a></li>
                                 <% } } } %>
                            </ul>
                            </li>
                            <li><a href="<%=pageUrl + allstoreUrl%>"><%=p.getProperty("public.home.allstores")%></a>
                                <ul>
                                    <%
                                        if (storeListByDomain != null) {
                                            for (Store store : storeListByDomain) {
                                                if (language.getId().equals(store.getLanguageId())) {%>
                                        <li><a href="<%=pageUrl + store.getSeoUrl()%>"><span><%=store.getName()%></span></a></li>        
                                    <% } } } %>
                                </ul>
                            </li>                           
                            <li><a href="/blog/" target="_blank">Blog</a></li>                           
                            
                            <% String[] sprit = domain.getImage().replace("/images/common/", "") .split("\\.");%>
                           <li class="flags"><a class="current-flag" href="https://<%=domain.getDomainUrl()%>"><span class="sprite x<%=sprit[0]%>" style="display:block;float:left;height:16px;margin-right:10px;"></span><%=domain.getCountryName()%><i class="fa fa-angle-down" aria-hidden="true"></i></a>
                            <ul class="all-country">
                                <%if (domainsCountry != null && domainsCountry.size() > 1) {
                                for (Domains d : domainsCountry) {
                                if((d.getCountryName().contains("India") || d.getCountryName().contains("United Kingdom") || d.getCountryName().contains("Australia") || d.getCountryName().contains("Malaysia")|| d.getCountryName().contains("Singapore") || d.getCountryName().contains("Indonesia") ||
                                 d.getCountryName().contains("Hong Kong") || d.getCountryName().contains("Philippines"))){ 
                                if (!d.getId().equals(domain.getId())) {
                                String[] sprite = d.getImage().replace("/images/common/", "") .split("\\.");
                                 if(!("5".equals(d.getId()) || "www.stagingserver.co.in".equalsIgnoreCase(d.getDomainUrl()))){ %>
                                <li><a href="https://<%=d.getDomainUrl()%>" rel="nofollow"><span class="sprite x<%=sprite[0]%>"></span><%=d.getCountryName()%></a></li>   
                                <% } } } } }%>
                            </ul>
                            </li>  
                        </ul>
                    </div>
                    
                </div>
            </div>
        </div>  -->
       <div class="">
          <div class="container">
            <div class="row">
              <div class="col-lg-3 col-md-3 col-sm-5 col-xs-12"> 
                <div class="logo"> <a title="" href="/"><img alt="Paylesser <%=p.getProperty("public.home.coupons")+" "+p.getProperty("public.store.offers")%>" src="<%=SystemConstant.PATH%>images/pl-logo.png"  /> </a> </div>
              </div>
              <div class="col-lg-9 col-md-9 col-sm-7 col-xs-3">
                  <div class="user-account">
                      <ul>                                              
                          <%if (session.getAttribute("userObj") == null) {%>
                            <li class="login" rel="nofollow"><a href="<%=pageUrl%>user-login" rel="nofollow"> <i class="fa fa-unlock-alt" aria-hidden="true"></i> <%=p.getProperty("public.home.login")%></a></li>
                           <!-- <li class="signup"><a href="<%=pageUrl + signupUrl%>" rel="nofollow"><i class="fa fa-user-plus" aria-hidden="true"></i> <%=p.getProperty("public.home.signup")%></a></li> -->                                                           
                            <% } else { %>                            
                            <li class="login"><a href="<%=pageUrl%>user-profile"><i class="fa fa-user" aria-hidden="true"></i> <%=p.getProperty("public.home.profile")%></a></li>                                
                            <!--<li class="signup"><a href="<%=pageUrl%>logout"><i class="fa fa-sign-out" aria-hidden="true"></i> <%=p.getProperty("public.home.logout")%></a></li>-->
                            <% } %>                                                      
                      </ul>
                   </div>
                <!--      <div id="google_translate_element"></div> -->
                  <div class="search-box">
                      <form method="post"  name="search-top" id="form-search-top">
                        <input type="text" class="search_text write search-result-top autocomplete-search-top searchbox" placeholder="<%=p.getProperty("public.home.search")%>" >
                        <button class="search-btn-bg search_btn_top" ><i class="fa fa-search"></i></button>
                      </form>
                   </div>
                        
                       
                        
              </div>
            </div>
          </div>
        
        <!-- ================================Navigation Start===================================-->
             
          <nav>
            <div class="container">
                <a href="#" id="toggle"><i class="fa fa-bars"></i></a>
                <ul id="nav" class="hidden-xs1">
                     <li><a href="<%=pageUrl + allstoreUrl%>" class="active"><span><%=p.getProperty("public.home.topstores")%></span></a>
                      <div class="my-megamenu">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <ul>  
                              <% int storCountD=0;
                                            if (storeListByDomain != null) {
                                              for (Store st : storeListByDomain) {
                                                    if (storCountD < 29) {
                                                      if (language.getId().equals(st.getLanguageId())) {
                                                            storCountD++;
                                        %> 
                                        <li><a href="<%=pageUrl + st.getSeoUrl()%>"><span><%=st.getName()%></span></a></li>  

                                        <% } } } }%> 
                                      <li class="go-all"><a href="<%=pageUrl + allstoreUrl%>" class="active"><span>View All</span></a></li>   
                            </ul>
                                           
                        </div> 
                      </div>
                    </li>
                    
                    <li><a href="<%=pageUrl + allcategoryUrl%>" class="active"><span><%=p.getProperty("public.store.categories")%></span></a></li>
                      <!--<div class="my-megamenu">
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <ul>  
                             <% int catgCountD = 0;
                                    if (categoriesListHeader != null) {
                                    for(Category cat : categoriesListHeader){
                                        if (catgCountD < 30) {
                                        if (language.getId().equals(cat.getLanguageId())) {
                                            catgCountD++;
                                     %> 
                                    <li><a href="<%=pageUrl + cat.getSeoUrl()%>"><%=cat.getName()%></a></li> 
                                    <% } } } }%> 
                                    <li class="go-all"><a href="<%=pageUrl + allcategoryUrl%>" class="active"><span>View All</span></a>   
                            </ul>                           
                        </div> 
                      </div>-->
                    
                    
                    <li><a href="<%=pageUrl + top20OUrl%>"><%=p.getProperty("public.home.top")+ p.getProperty("public.home.20")%></a></li>
                    <li><a href="<%=pageUrl + exclusiveUrl%>"><%=p.getProperty("public.home.exclusive")%></a></li>
                    <%
                     if ("1".equals(homeConfig.getSpecials())) {
                    %>
                    <li><a href="<%=pageUrl + allSpecialUrl%>"><%=p.getProperty("public.special.ourspecials")%></a></li>
                   <% } %>
                    <%if(!(spName.isEmpty() || "".equals(spName))){%>
                    <li><a href="<%=spSeoUrl%>"><%=spName%></a></li>
                    <%}%>
                    
                    <% if("FEED".equals(domain.getThemeType())){%>
                    <li class="coupon-link"><a href="/<%=SystemConstant.ROOT_URL%>" rel="nofollow"><span><i class="fa fa-tags" aria-hidden="true"></i> Offers</span></a> </li>
                   <% } %>  
                 </ul>
            </div>
        </nav>    

        <!-- ================================Navigation End===================================-->   
   </div>
  </header>
  <!-- ================================Header End ===================================-->
  <div class="mobile-header">
      <a class="open-left" href="#menu"><i class="fa fa-bars" aria-hidden="true"></i></a>		
              
      <a class="mobile-logo" href="/"><img src="<%=SystemConstant.PATH%>images/pl-logo.png" alt="Paylesser"></a>   
      <div class="user-account-mm">
          <div id="sb-search" class="sb-search">
            <form method="get" action="/searchRedirect" name="search-box" id="form-search-box">
                <input id="search" type="text" name="q" class="sb-search-input search_text write search-result-box autocomplete-search-box" placeholder="<%=p.getProperty("public.home.search")%>" required="required" maxlength="128">
                <input class="sb-search-submit" type="button" id="form-search-box-bttn" value="">
                <span class="sb-icon-search"><i class="fa fa-search"></i></span>
            </form>
          </div>
          <% if("FEED".equals(domain.getThemeType())){ %>
          <a class="go-copupon" href="/<%=SystemConstant.ROOT_URL%>"><i class="fa fa-tags" aria-hidden="true"></i></a>
          <% } %>
      </div>
    </div>
  <!-- ======================Breadcrumb Start==================== -->
  <%if(!"".equals(headBread) || !"".equals(part1)){%>   
    <div class="category" style="margin:0">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
                  <div id="bradcrumb">
                    <%   
                        domainName = (String)session.getAttribute("domainName");
                        pageName =  pageUrl +(String)session.getAttribute("pageName"); //changed by ishahaq
                        //pageName = "http://" + domainName +(String)session.getAttribute("pageName");
                        if(!"".equals(param)){
                          pageName = pageName + param;    
                        }  
                        if (!"".equals(headBread) || !"".equals(part1)) {  %>
                    <ul>
                        <li> 
                            <% if("FEED".equals(domain.getThemeType())){ %>
                            <a href="/<%=homeSeo%>"><span><%=p.getProperty("public.home.breadcrumb_home")%></span></a>
                            <% } else { %>
                            <a href="/"><span><%=p.getProperty("public.home.breadcrumb_home")%></span></a>
                            <% } %>
                        </li>
                        <%}
                            if (!"".equals(locName)) { 
                        %>   
                         <li> <a href="<%=pageUrl + locSeo%>"><span><%=locName%></span></a></li> 
                        <%}
                        if (!"".equals(headBread)) {
                        %>
                         <li> <a href="<%=pageName%>"><strong itemprop="name"><%=headBread%></strong></a></li> 
                        <% }
                        if(!"".equals(part1) && !"".equals(part2) && !"".equals(part3)){ %>
                         <li> <a href="<%=part2%>"><span><%=part1%></span></a></li> 
                         <li> <a href="<%=pageName%>" ><span><%=part3%></span></a></li>
                         <%}
                            if (!"".equals(headBread) || !"".equals(part1)) {  %>     
                                </ul>
                            <%}%>
                  </div>    
                </div>
            </div>    
        </div>    
    </div>
    <%}%>
  <!-- ======================Breadcrumb End==================== --> 
   <div id="fb-root"></div>
    
<script>
var appId="<%=appId%>";
</script>

<%} catch (Throwable e) {
Logger.getLogger("topMenu.jsp").log(Level.SEVERE, null, e);
} finally {

}%>
