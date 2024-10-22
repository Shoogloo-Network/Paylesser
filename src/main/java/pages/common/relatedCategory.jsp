<%-- 
    Document   : relatedCategory
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:39:39 AM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.StoreCategory"%>
<!-- -----Related Category------>
<%     
if(storeCategoryList != null) {
 int countList = 0;
%>
<div class="side-col related-category">
    <h3><%=storeName%>&nbsp;<%=p.getProperty("public.store.categories")%></h3>
        <ul>
            <%    
            for(StoreCategory storeCat: storeCategoryList) {
              if(storeCat.getLanguageId().equals(language.getId())) {
                int count = 0;             
                List<VoucherDeals> dealsList1 = !"".equals(pageTypeFk)?home.getStoreCatOfferByStoreId(pageTypeFk, storeCat.getParentId()):null;         
                 if(dealsList1 != null){
                  for(VoucherDeals vd : dealsList1){
                      if(storeCat.getParentId().equalsIgnoreCase(vd.getCategoryId())){
                           if((request.getHeader("User-Agent").indexOf("Mobile") != -1)) {
                                 count++;
                            }else if("0".equals(vd.getViewType())){
                                 count++;
                           }                                                 
                      }
                  }
              } 
              if(count>0) {
              if (countList >= 5) { 
            %>  
            
            <li class="filterByCat" style="display:none"><a href="<%=pageUrl + storeCat.getSeoUrl()%>"><%=storeCat.getName()%><span><%=count%></span></a></li>
             <%}else{%>
            <li class="filterByCat"><a href="<%=pageUrl + storeCat.getSeoUrl()%>"><%=storeCat.getName()%><span><%=count%></span></a></li>
            <%}countList++; } } } %>   
            
            <%
            if(countList>5){
            %> 
            <li style="text-align:right" class="pointer" onclick="if($(this).text()==='More'){$(this).text('Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByCat:gt(4)').hide();$(this).text('More');}"><%=p.getProperty("public.store.more")%></li>
            <%}%>
        </ul>    
</div>
<% } %>