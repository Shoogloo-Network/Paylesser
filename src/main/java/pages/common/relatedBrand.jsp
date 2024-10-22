<%-- 
    Document   : relatedBrand
    Created on : 7 Mar, 2016, 7 Mar, 2016 5:08:31 PM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.home.StoreBrand"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%   
if(storeBrandList != null) {
    int countList = 0; 
%>
<div class="side-col related-brand">
    <h3><%=storeName%>&nbsp;<%=p.getProperty("public.store.brands")%></h3>
        <ul>
            <%
            for(StoreBrand storeBrand : storeBrandList) {
              if(storeBrand.getLanguageId().equals(language.getId())) {
                int count = 0;               
                List<VoucherDeals> dealsList1 = !"".equals(pageTypeFk)?home.getStorBrandOfferByStoreId(pageTypeFk, storeBrand.getId()):null;
                 if(dealsList1 != null){
                  for(VoucherDeals vd : dealsList1){
                      if(storeBrand.getId().equalsIgnoreCase(vd.getBrandId())){
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
            <li class="filterByBra" style="display:none"><a href="<%=pageUrl + storeBrand.getSeoUrl()%>"><%=storeBrand.getName()%><span><%=count%></span></a></li>
            <%}else{%>
            <li class="filterByBra"><a  href="<%=pageUrl + storeBrand.getSeoUrl()%>"><%=storeBrand.getName()%><span><%=count%></span></a></li>
            <%}countList++; } } } %>
            <%
            if(countList>5){
            %> 
            <li style="text-align:right" class="pointer" onclick="if($(this).text()==='More'){$(this).text('Less');$(this).parent().find('li').show();}else{$(this).parent().find('li.filterByBra:gt(4)').hide();$(this).text('More');}"><%=p.getProperty("public.store.more")%></li>
            <%}%>
        </ul>  
</div>
<% } %>
