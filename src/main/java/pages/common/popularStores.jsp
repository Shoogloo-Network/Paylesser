<%-- 
    Document   : popularStores
    Created on : 4 Mar, 2016, 4 Mar, 2016 11:13:36 AM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.util.List"%>
<%   
  if(storeListByDomain != null) {
      int count = 0;
%>
<div class="side-col related-stores">
    <h3><%=p.getProperty("public.home.popular")%></h3>    
    <%

      for (Store popStore : storeListByDomain) {
        if (language.getId().equals(popStore.getLanguageId()) && home.getStoreOfferCount(popStore.getId())!=null) {
          count++;
    %>
        <div class="item offer">
            <div class="item-top">
                <div class="offer-value">
                    <img src="<%=cdnPath + popStore.getImageBig()%>" alt="<%= popStore.getName()%> promo code" title="<%= popStore.getName()%> coupon">
                </div>
                <div class="offer-info">
                     <a href="<%=pageUrl + popStore.getSeoUrl()%>"><%= popStore.getName()%>
                         <span class="<%=lft+" "+rtl%>"><%=(home.getStoreOfferCount(popStore.getId()))==null?0: Integer.parseInt(home.getStoreOfferCount(popStore.getId()))%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></span></a>
                </div>
                <div class="clearfix"></div>
            </div>
        </div>
      <%
            if (count >= 5) {
              break;
            }
          }
        }
      %>   
</div>
<% } %>
