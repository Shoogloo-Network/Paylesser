<%-- 
    Document   : bottomMenu
    Created on : 12 Jul, 2016, 12:53:00 PM
    Author     : IshahaqKhan
--%>

<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<!-- ================================Footer Start===================================-->
  <footer>
      <% if("-1".equals(pageType)){ %> 
    <div class="footer-menu hidden-xs hidden-sm">
        <div class="container">
            <div class="row">
                <div class="col-md-20">
                    <h4 class="">Top Brands</h4>
                    <ul>
                    <%if(topBrand!=null){
                       for(ProductBrand brand : topBrand){%>
                     <li><a href="/<%=SystemConstant.ROOT_URL%>/<%=brand.getSeo()%>"><span><%=SolrUtils.toDisplayCase(brand.getName())%></span></a>
                   <%}}%>
                    </ul>
                </div>
                <div class="col-md-20">
                    <h4 class="">Top Categories</h4>
                    <ul>
                        <%if(topCat!=null){
                         for(ProductCategory cat : topCat){%>
                        <li><a href="/<%=SystemConstant.ROOT_URL%>/<%=cat.getSeo()%>"><span><%=SolrUtils.toDisplayCase(cat.getName())%></span></a>
                      <%}}%>
                    </ul>
                </div>
                <div class="col-md-20">
                    <h4 class="">Top Stores</h4>
                    <ul>
                        <% int storCount=0;
                            if (storeListByDomain != null) {
                              for (Store st : storeListByDomain) {
                                    if (storCount < 10) {
                                      if (language.getId().equals(st.getLanguageId())) {
                                            storCount++;
                        %> 
                        <li><a href="<%=pageUrl + st.getSeoUrl()%>"><%=st.getName()%></a></li>                     
                        <% } } } }%>
                    </ul>
                </div>
                <div class="col-md-20">
                    <h4 class="">Company</h4>
                    <ul>  
                        <li><a href="https://www.paylesser.com/about-us.html" target="_blank"><%=p.getProperty("public.home.about_us")%></a></li>
                        <!--<li><a href="<%=managementUrl%>" target="_blank" rel="nofollow"><%=p.getProperty("public.home.management_team")%></a></li>-->
                        <li><a href="https://www.paylesser.com/contact-us.html" target="_blank"><%=p.getProperty("public.home.contact_us")%></a></li>
                        <li><a href="<%=pageUrl%>faq"><%=p.getProperty("public.home.footer.faq")%></a></li>
                        <li><a href="https://www.paylesser.com/privacy-policy.html" target="_blank"><%=p.getProperty("public.home.privacy")%></a></li>                        
                        <!--<li><a href="<%=pageUrl+hiringUrl%>"><%=p.getProperty("public.home.hiring")%></a></li>-->
                      
                        
                    </ul>
                </div>
                <div class="col-md-20">
                    <h4 class="">International Sites</h4>
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
                                <li><a href="https://<%=d.getDomainUrl()%>" rel="nofollow"><span class="sprite x<%=sprite[0]%>"></span><%=d.getCountryName()%></a></li>   
                                <% } } } } }%>
                            </ul>
                         </li>
                        
                    </ul>
                </div>
            </div>
        </div>    
    </div>  
      
    <div class="footer-keywords hidden-xs hidden-sm hidden-md">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    
                   <% 
                      if(tagFeedMetaListMap!=null){
                      for(Map.Entry ftm:tagFeedMetaListMap.entrySet()){
                          if(ftm!=null){  %>  
                          <div class="keyword-group">
                          <% List<FeedMeta> fdmetaList = (List<FeedMeta>)ftm.getValue();
                              if(fdmetaList!=null && !("TRENDING SEARCH".equals(ftm.getKey()))) {%>
                                 <h4 class="keyword-ttl"><%=ftm.getKey()%></h4>
                                 <ul>
                                    
                                           
                                    <% 
                                        for(FeedMeta fdmeta:fdmetaList){ %>
                                           <li> <a href="/<%=SystemConstant.ROOT_URL+"/"+fdmeta.getKey()%>"><%=SolrUtils.toDisplayCase(fdmeta.getName())%></a></li>
                                        <%}
                                    %>
                                 </ul>
                             <%}}%> 
                          </div>
                    <%}}%>
                    
                    
                    
                </div>
            </div>
        </div>    
    </div>  
      
    <% } %>                
                    
    <div class="copyrights">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <p>&copy; 2016  Paylesser.com. All Rights Reserved</p>
                   <img src="<%=SystemConstant.PATH%>images/pl-logo.png" alt="Paylesser">
                </div>
            </div>
        </div>    
    </div>
    <div class="managed-by hidden-xs hidden-sm">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <p itemprop="license"><%=p.getProperty("public.home.allrights")%><%=domainName%>&nbsp;<%=p.getProperty("public.home.allrights1")%></p>
                </div>
            </div>
        </div>        
    </div>
  </footer>
  <!-- ================================Footer End===================================-->

