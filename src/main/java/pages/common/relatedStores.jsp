<%-- 
    Document   : relatedStores
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:41:37 AM
    Author     : Vivek
--%>

<%@page import="sdigital.pl.products.utilities.SolrUtils"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="java.util.List"%>
<!-- -----Related Store------>
    <%List<String> listSimilarStores=null;
      if(SystemConstant.STORE.equals(pageType)){
        listSimilarStores = !"".equals(pageTypeFk) ? home.getSimilarStores(pageTypeFk, domainId) : null;  
      }else{
        listSimilarStores = home.getSimilarStoresTopPages(storeId, domainId);  
      } 
     int countStore = 0;  
    if (listSimilarStores != null && listSimilarStores.size() > 0) {%>   
<div class="side-col related-stores">
    <% if(SystemConstant.STORE.equals(pageType)){ %>
    <strong><%=p.getProperty("public.category.similiar_stores")%></strong>
    <% } else { %>
    <h3><%=p.getProperty("public.home.popular")%></h3>
    <% } 
        for (String s : listSimilarStores) {
          List<Store> simStoreListById = home.getAllStoreById(s);
          if(simStoreListById != null) {
            for (Store st : simStoreListById) {
              if (st.getLanguageId().equals(language.getId()) && home.getStoreOfferCount(st.getId())!=null) {
                countStore++;                 
    %> 
        <div class="item offer">
            <div class="item-top">
                <div class="offer-value">
                    <img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=cdnPath + st.getImageBig()%>" alt="<%= st.getName()%> promo code" title="<%= st.getName()%> coupon">
                </div>
                <div class="offer-info">
                     <a href="<%=pageUrl + st.getSeoUrl()%>"><%= st.getName()%>
                    <span class="<%=lft+" "+rtl%>"><%=(home.getStoreOfferCount(st.getId()))==null?0: Integer.parseInt(home.getStoreOfferCount(st.getId()))%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></span></a>
                </div>
                <div class="clearfix"></div>
            </div>
            
        </div>
    <% 
        } } } 
        
        if (countStore > 4) {
         break;               
       }
    } 
    %>               
</div>
<% } %>