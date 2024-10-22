<%-- 
    Document   : bottomMenu
    Created on : 17 Feb, 2016, 17 Feb, 2016 4:06:11 PM
    Author     : Vivek
--%>
<%@page import="sdigital.vcpublic.home.Testimonial"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%
int catCount = 0;
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
try {%>
<!-- =============Footer Start============= -->
 <% if (!SystemConstant.HOME.equals(pageType)) { %>
  <!-- ================================Newsletter Start===================================--> 
  <section class="category hidden-md hidden-lg" id="newsletter">
    <div class="container">
      <div class="row">
        <div class="col-md-4 col-sm-4 col-xs-12">
              <div class="news-text" >
                <h3>Signup for our newsletter</h3>
              </div>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
            <input id="emailbottom" type="text" name="emailbottom" class="searchbox" placeholder="<%=p.getProperty("public.home.footer.email")%>" />
            <div id="loadingBottomM" class="loading" style="display:none;"><img src="<%=SystemConstant.PATH%>images/loading.gif" alt="loading"></div>
            <button class="button-submit search-btn-bg" id="button-submit">Subscribe</button>
        </div>
        <div class="col-md-4 col-sm-4 col-xs-12">
            <ul>
                <%
                if(domain.getFbLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getFbLink()%>" target="_blank" rel="nofollow"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getTwLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getTwLink()%>" target="_blank" rel="nofollow"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getGpLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getGpLink()%>" target="_blank" rel="nofollow"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                <%}
                if(domain.getPnLink() == null) {
                %>
                <li><a href="<%=pageUrl%>"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <%} else {%> 
                <li><a href="<%=domain.getPnLink()%>" target="_blank" rel="nofollow"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                <% } %>
            </ul>
        </div>  
      </div>
    </div>
  </section>
 <% } %>

   <footer>
    <% if(SystemConstant.HOME.equals(pageType)){ %>    
    <div class="footer-keywords hidden-xs hidden-sm hidden-md <%=rtl%>">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <!-- <div class="keyword-group">
                        <h4 class="keyword-ttl"><%=p.getProperty("public.home.mostpopular_store")%></h4>
                        <ul>
                        <% int storCount=0;
                            if (storeListByDomain != null) {
                              for (Store st : storeListByDomain) {
                                    if (storCount < 11) {
                                      if (language.getId().equals(st.getLanguageId())) {
                                            storCount++;
                        %> 
                         <li><a href="<%=pageUrl + st.getSeoUrl()%>"><%=st.getName()%></a></li>  
                        <% } } } }%>
                        <li><a href="<%=pageUrl + allstoreUrl%>"><%=p.getProperty("public.home.allstores")%></a></li>  
                    </ul>
                    </div> -->
                    <div class="keyword-group">
                        <h4 class="keyword-ttl"><%=p.getProperty("public.home.top")%>&nbsp;<%=p.getProperty("public.category.categories")%></h4>
                        <ul>
                        <%
                        if (categoriesListHeader != null) {
                          for (Category cat : categoriesListHeader) {
                            if (cat.getLanguageId().equals(language.getId())) {
                              if(catCount < 8) {
                                catCount++;
                        %>
                        <li><a href="<%=pageUrl+cat.getSeoUrl()%>"><%=cat.getName()%></a></li>
                        <% } } } }%>
                        </ul>
                    </div>
                    
                    <!--<div class="keyword-group">
                        <h4 class="keyword-ttl"><%=p.getProperty("public.home.top")%>&nbsp;<%=p.getProperty("public.home.coupons")%></h4>
                        <ul>
                        <li><a href="<%=pageUrl+voucherUrl%>"><%=p.getProperty("public.home.top15vouchers")%></a></li>
                        <li><a href="<%=pageUrl+offerUrl%>"><%=p.getProperty("public.home.top15offers")%></a></li>
                        <li><a href="<%=pageUrl+newVc%>"><%=p.getProperty("public.home.new_voucher_codes")%></a></li>
                        <li><a href="<%=pageUrl+latestD%>"><%=p.getProperty("public.home.latest_deals")%></a></li>
                        <li><a href="<%=pageUrl+endingSoon%>"><%=p.getProperty("public.home.ending_soon")%></a></li>
                        <li><a href="<%=pageUrl+expired%>"><%=p.getProperty("public.home.expired_vouchers")%></a></li>
                        <li><a href="/latest-vouchers">Latest Vouchers</a></li>
                        <li><a href="<%=pageUrl+dealUrl%>"><%=p.getProperty("public.home.top15deals")%></a></li>
                        </ul>
                    </div>-->
                    
                    <div class="keyword-group">
                        <h4 class="keyword-ttl"><%=p.getProperty("public.home.about")%></h4>
                        <ul>
                        <li><a href="https://www.paylesser.com/about-us.html" target="_blank"><%=p.getProperty("public.home.about_us")%></a></li>
                        <li><a href="https://www.paylesser.com/privacy-policy.html" target="_blank"><%=p.getProperty("public.home.privacy")%></a></li>
                        <li><a href="https://www.paylesser.com/contact-us.html" target="_blank"><%=p.getProperty("public.home.contact_us")%></a></li>
                        <!--<li><a href="<%=pageUrl+hiringUrl%>"><%=p.getProperty("public.home.hiring")%></a></li>-->
                        <li><a href="https://www.paylesser.com/faqs.html"><%=p.getProperty("public.home.footer.faq")%></a></li>
                        <!--<li><a href="<%=managementUrl%>" target="_blank" rel="nofollow"><%=p.getProperty("public.home.management_team")%></a></li>-->
                        <%if("8".equals(domainId) || "14".equals(domainId) || "17".equals(domainId) || "18".equals(domainId) || "19".equals(domainId) || "20".equals(domainId) || "24".equals(domainId) || "36".equals(domainId)){%>
                        <li><a href="http://blog.paylesser.com/<%=domain.getCountryName().toLowerCase().replace(' ', '-')%>" target="_blank">Blog</a></li> 
                        <% } else { %>
                        <li><a href="/blog/" target="_blank"><%=p.getProperty("public.footer.blog")%></a></li>
                        <% } %>
                        </ul>
                    </div>
                        
                    <div class="keyword-group">
                        <h4 class="keyword-ttl"><%=p.getProperty("public.footer.international")%></h4>
                        <ul>
                         <li class="flags">
                            <ul class="all-country">
                                <%if (domainsCountry != null && domainsCountry.size() > 1) {
                                for (Domains d : domainsCountry) {
                                if((d.getCountryName().contains("India") || d.getCountryName().contains("United Kingdom") || d.getCountryName().contains("Australia") || d.getCountryName().contains("Malaysia")|| d.getCountryName().contains("Singapore") || d.getCountryName().contains("Indonesia") ||
                                 d.getCountryName().contains("Hong Kong") || d.getCountryName().contains("Philippines") || d.getCountryName().contains("UAE") )){ 
                                if (!d.getId().equals(domain.getId())) {
                                String[] sprite = d.getImage().replace("/images/common/", "") .split("\\.");
                                 if(!("5".equals(d.getId()) || "www.stagingserver.co.in".equalsIgnoreCase(d.getDomainUrl()))){ %>
                                <li><a href="https://<%=d.getDomainUrl()%>"><span class="sprite x<%=sprite[0]%>"></span><%=d.getCountryName()%></a></li>   
                                <% } } } } }%>
                            </ul>
                         </li>
                        
                    </ul>
                    </div>    
                </div>
            </div>
        </div>    
    </div>     
    <%}%>  
    <div class="copyrights">
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-sm-4 col-xs-12">
                    <p>© 2016-17  Paylesser.com. <%=p.getProperty("public.footer.allrights")%></p>
                   
                </div>
                <div class="col-md-8 col-sm-8 col-xs-12">
                    <%if("5".equals(domainId)) { %>
                    <ul style="margin-top:-10px">
                        <li><a href="https://play.google.com/store/apps/details?id=com.eteam.vouchercodes&hl=en" target="_blank"><img src="<%=SystemConstant.PATH%>images/android-app.png" style="max-width:150px;"></a></li>
                    </ul>
                    <% } else { %>
                    <ul class="top-social">
                        <%
                        if(domain.getFbLink() == null) {
                        %>
                        <li><a href="<%=pageUrl%>"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                        <%} else {%> 
                        <li><a href="<%=domain.getFbLink()%>" target="_blank"><i class="fa fa-facebook" aria-hidden="true"></i></a></li>
                        <%}
                        if(domain.getTwLink() == null) {
                        %>
                        <li><a href="<%=pageUrl%>"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                        <%} else {%> 
                        <li><a href="<%=domain.getTwLink()%>" target="_blank"><i class="fa fa-twitter" aria-hidden="true"></i></a></li>
                        <%}
                        if(domain.getGpLink() == null) {
                        %>
                        <li><a href="<%=pageUrl%>"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                        <%} else {%> 
                        <li><a href="<%=domain.getGpLink()%>" target="_blank"><i class="fa fa-google-plus" aria-hidden="true"></i></a></li>
                        <%}
                        if(domain.getPnLink() == null) {
                        %>
                        <li><a href="<%=pageUrl%>"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                        <%} else {%> 
                        <li><a href="<%=domain.getPnLink()%>" target="_blank"><i class="fa fa-pinterest" aria-hidden="true"></i></a></li>
                        <% } %>
                    </ul>
                    <% } %>
                </div> 
            </div>
        </div>    
    </div>
    <div class="managed-by hidden-xs hidden-sm">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12 <%=rtl%>">
                    <p itemprop="license"><%=p.getProperty("public.home.allrights")%>&nbsp;<%=domainName%>&nbsp;<%=p.getProperty("public.home.allrights1")%></p>
                </div>
            </div>
        </div>        
    </div>
  </footer>      
  <%if("16".equals(domainId)) {%>
      <div class="cookiePolicy accepted">
          <div class="wrapper" style="padding: 10px;background-color:greenyellow;position: fixed;bottom: 0;width: 100%;display:none;z-index:100000;text-align:center">
          Our website uses cookies to improve your experience on our website. Check our cookie <a href="<%=pageUrl+privacy%>">cookie policy</a> or accept to explore the website.
          <a href="javascript:add_cookies();" class="btn btn-info" style="max-width: 100px;padding: 2px 5px;margin: 0 0 0 20px;">Accept</a>
        </div>
      </div>  
    <%}%> 
  <!-- =============Footer End============= --> 
<%}
catch(Exception e) {
    System.out.println("Error in page bottomMenu.jsp, cause: "+e);
}%>


