<%-- 
    Document   : weRecommend
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:40:52 AM
    Author     : Vivek
--%>

<%@page import="sdigital.vcpublic.home.Store"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="sdigital.vcpublic.home.StoreCategory"%>
<!-- -----We Recommend------>
<div class="section-title">
    <h2><%=p.getProperty("public.store.recommend")%></h2>              
</div>
 <%
List<String> listSimStores=new ArrayList<String>();    
if(SystemConstant.STORE.equals(pageType)){
  listSimStores = !"".equals(pageTypeFk)?home.getSimilarStores(pageTypeFk, domainId):null;  
}else{
  listSimStores = !"".equals(storeId)?home.getSimilarStoresTopPages(storeId, domainId):null;  
}     
     
 List<VoucherDeals> dealsList = new ArrayList<VoucherDeals>();
 if(listSimStores != null && listSimStores.size() > 0) {
     for(String s : listSimStores) {
          List<Store> simStoreListById = home.getAllStoreById(s);
          if(simStoreListById != null) {
            for (Store st3 : simStoreListById) {
              if (st3.getLanguageId().equals(language.getId())) {
                 if(topDealList!=null){ 
                  for(VoucherDeals vd : topDealList){
                      if(st3.getId().equalsIgnoreCase(vd.getStoreId())){
                         dealsList.add(vd);
                      }
                  }
              } 
              }  
          }
     }      
 }
 }else{
    dealsList =  topDealList;
 }
if(dealsList != null && dealsList.size()<10){     
    if(listSimStores != null && listSimStores.size() > 0) {
     int perStoreReq = ((10 - dealsList.size())/(listSimStores.size()))+1;   
     for(String s : listSimStores) {
          List<Store> simStoreListById = home.getAllStoreById(s);
          if(simStoreListById != null) {
            for (Store st4 : simStoreListById) {
              if (st4.getLanguageId().equals(language.getId())) {
                  int i =0;
                  List<VoucherDeals> vdList = home.getAllVDById(st4.getId());
                  if(vdList != null){
                  for(VoucherDeals vd : vdList){
                      if(vd.getStoreSeoUrl()==null){
                          vd.setStoreSeoUrl(st4.getSeoUrl());
                      }
                      if(dealsList.size()>=10 || i>=perStoreReq){
                         break; 
                      }
                      if(st4.getId().equalsIgnoreCase(vd.getStoreId())){
                         dealsList.add(vd);
                      }
                      i++;
                  }
              }
              }   
          }
     }      
 }
 }

}
if(dealsList==null){
    dealsList =  topDealList;
}else if(dealsList!=null && dealsList.size()<1){  
    dealsList =  topDealList;
}
 
 %>       
 <aside id="we-recommend" >
        <div class="slider-items">
            <%
            int top20 = 0;
            if (dealsList != null) {
              for (VoucherDeals od : dealsList) {
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
                        <a href="<%=pageUrl + od.getStoreSeoUrl()%>"><img src="<%=SystemConstant.PATH%>images/loading.gif" data-src="<%=imagePath%>" alt="<%=od.getStoreName()%> offer" title="<%=od.getStoreName()%> voucher code"/></a>
                     </div>
                     <div class="item-info">
                        <p><%=od.getOfferHeading()%></p>
                        <a data-of="<%=od.getId()%>" href="/cout?id=<%=od.getId()%>" target="_blank" rel="nofollow" class="my-btn cursor-href"><%=p.getProperty("public.category.activate_deal")%></a> 
                        <span class="available <%=rtl%>"><%=(home.getStoreOfferCount(od.getStoreId()))==null?0: Integer.parseInt(home.getStoreOfferCount(od.getStoreId()))-1%>&nbsp;<%=p.getProperty("public.store.more")%>&nbsp;<%=p.getProperty("public.home.oavlbl")%></span>   
                     </div>
                  </div>
               </div>
            <% } } } } %>  
         </div>
      </aside>
             
