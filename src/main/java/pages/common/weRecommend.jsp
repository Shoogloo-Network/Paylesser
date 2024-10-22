<%-- 
    Document   : weRecommend
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:40:52 AM
    Author     : Vivek
--%>

<!-- -----We Recommend------>
<!--<div class="section-title">
    <h2>We Recommend</h2>              
</div>
  
 <div id="we-recommend" >
                <div class="slider-items">
                     <%
                        int top20 = 0;
                        if (topDealList != null) {
                          for (VoucherDeals od : topDealList) {
                            if (od.getLanguageId().equals(language.getId())) {
                              if (top20 < 10) {
                                top20++;
                                   if ("2".equals(od.getOfferType()) && (od.getOfferImage() == null || "".equals(od.getOfferImage()))) {
                                    voucherClass = "activate-deal-1 u-deal";
                                    voucherDesc = p.getProperty("public.category.activate_deal");
                                  } else if ("2".equals(od.getOfferType()) && (od.getOfferImage() != null || !"".equals(od.getOfferImage()))) { //product deal
                                    voucherClass = "activate-deal-prod u-deal";
                                    voucherDesc = p.getProperty("public.category.activate_deal");
                                  }
                                  if(od.getOfferImage() != null && !"".equals(od.getOfferImage())) {
                                    imagePath = cdnPath + od.getOfferImage();
                                  } else {
                                    imagePath = cdnPath + od.getImageSmall();
                                  }                              

                        %>
                        <div class="item">
                            <div class="item-inner">
                               <div class="item-image">
                                  <a href="<%=pageUrl + od.getStoreSeoUrl()%>"><img src="<%=imagePath%>" alt="<%=od.getStoreCaption()%>"/></a>
                               </div>
                               <div class="item-info">
                                  <p><a class="couponDetails <%=od.getId()%> cursor-href pointer"><%=od.getOfferHeading()%></a></p>
                                  <a data-of="<%=od.getId()%>" class="my-btn u-deal cursor-href"><%=p.getProperty("public.category.activate_deal")%></a> 
                                  <a href="#" class="available"><%=(home.getStoreOfferCount(od.getStoreId()))==null?0: home.getStoreOfferCount(od.getStoreId())%> More Offers Available</a>   
                               </div>
                            </div>
                        </div>          
                   <% } } } } %>         
    </div>    
</div>-->

