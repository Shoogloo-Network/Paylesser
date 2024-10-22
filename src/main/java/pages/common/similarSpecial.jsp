<%-- 
    Document   : similarSpecial
    Created on : 16 Mar, 2016, 16 Mar, 2016 3:23:50 PM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.Specials"%>
<%@page import="java.util.List"%>
<!-- -----Related Store------>
<%
  if(SystemConstant.SPECIAL.equals(pageType)){     
    List<Specials> listSimilarSpecialOffers = home.getSimilarCatSpecials(domainId,language.getId(),pageTypeFk);
    int countSpec = 0;
    if(listSimilarSpecialOffers!=null && listSimilarSpecialOffers.size() > 0){
%>  
<div class="side-clo related-stores">
    <h3><%=p.getProperty("public.category.similiar_special_offers")%></h3>
    <%
    for (Specials sp : listSimilarSpecialOffers) {         
        if (sp.getLanguageId().equals(language.getId())) {
          countSpec++;
  %> 
        <div class="store-item">
            <a href="<%=pageUrl + sp.getSeoUrl()%>"><img src="<%=cdnPath + sp.getImage()%>" alt="<%=sp.getName()%>"></a>            
        </div>
    <% if (countSpec >= 6) { break;}
          }                
      }
      %>                
</div>
<% } }%>
