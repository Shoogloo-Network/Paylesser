<%-- 
    Document   : product.jsp
    Created on : Jul 14, 2016, Jul 14, 2016 5:31:16 PM
    Author     : Vivek
--%>
<%@page import="sdigital.pl.products.utilities.SolrUtils"%>


<div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
        <div class="item">
           <div class="item-img">
               <a class="product-image btn-prod"  data-href="<%=outURL+"?id="+pro.getId()%>" target="_blank" rel="nofollow"> <img class="feed-prod-img" alt="<%=pro.getName().replace('"', ' ')%>" src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%= cdn + "/"+ SolrUtils.getPathFromUrl(pro.getImageurl())%>"> </a>
                <div class="add-to-cart"><a class="btn-prod" data-href="<%=outURL+"?id="+pro.getId()%>" target="_blank" rel="nofollow"><span>Shop From <%=pro.getStore()%></span> </a></div>
           </div>
           <div class="item-info">
            <h4><a><%=pro.getName()%></a></h4>
            <%if(pro.getDiscountI()>0){%>
            <p class="discount"><span><%=Math.round(pro.getDiscountI())%>% Off</span></p>
            <%}%>
            <p class="price">
                <%if(pro.getDiscountI()>0){%>
                <span class="old"><%=currenySysmbol  + ' '%> <%=Math.round(pro.getMrpD()) %></span>
                <% } %>
                <span class="new"><%=currenySysmbol + ' '%><%=Math.round(pro.getPrice()) %></span>
            </p>
           </div>
        </div>
</div>
