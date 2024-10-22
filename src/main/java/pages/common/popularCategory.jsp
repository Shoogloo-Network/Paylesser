<%-- 
    Document   : relatedCategory
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:39:39 AM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.home.Category"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.StoreCategory"%>
<!-- -----Related Category------>
<%   
int count1 = 0;    
if(categoryList != null) {
%>
<div class="side-col related-category">
    <h3><%=p.getProperty("public.store.categories")%></h3>
        <ul>
            <%    
             for (Category cat : categoryList) {
                if (language.getId().equals(cat.getLanguageId())) {
                  count1++;
              %>
            <li><a href="<%=pageUrl + cat.getSeoUrl()%>"><%=cat.getName()%></a></li>
            <%
            if (count1 >= 6) {
              break;
            }
          }
        }
      %>
        </ul> 
</div>
<% } %>