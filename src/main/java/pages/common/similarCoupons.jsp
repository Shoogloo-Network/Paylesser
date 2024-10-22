<%-- 
    Document   : similarCoupon
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:40:52 AM
    Author     : Ishahaq
--%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%List<String> listSimilarStores1=null;    
      if(SystemConstant.STORE.equals(pageType)){
        listSimilarStores1 = !"".equals(pageTypeFk) ? home.getSimilarStores(pageTypeFk, domainId):null;  
      }else{
        listSimilarStores1 = home.getSimilarStoresTopPages(storeId, domainId);  
      } %>
<!-- -------------------Similar Offer Filter Start------------------------->
                    <div class="page-header">
                       <div class="row">
                           <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                                <h2><%=p.getProperty("public.store.similar_coupons")%></h2>
                           </div>

                        </div>

                    </div>
                        <!-- -------------------Similar Offer Filter End------------------------->
                    <div class="offer-list">
                        
                        <!-- -------------------Offer Item Start------------------------->
                        <%
                        if(listSimilarStores1 != null){
                         for (String s : listSimilarStores1) {
                            List<Store> simStoreListById = home.getAllStoreById(s);
                            if(simStoreListById != null) {
                              for (Store st1 : simStoreListById) {
                                if (st1.getLanguageId().equals(language.getId())) {
                                    if(!st1.getId().equals(pageTypeFk)){                                       
                                     similarStoreIds += "," + st1.getId();
                                    }
                                  }
                              }
                            }
                          }
                         }
                        vdListById = home.getSimilarStoresOffers(similarStoreIds, language.getId(),catSCIds);     
                        if(vdListById == null || vdListById.size()==0){
                          List<Store> simStoreListById = home.getAllStoresByDomainId(domainId);
                            if(simStoreListById != null) {
                              for (Store st2 : simStoreListById) {
                                if (st2.getLanguageId().equals(language.getId())) {
                                   if(!st2.getId().equals(pageTypeFk)){ 
                                       List<VoucherDeals> vdTempList = home.getAllVDById(st2.getId());
                                       if(vdTempList!=null && vdTempList.size()>0)
                                        vdListById.add(vdTempList.get(0));
                                   } 
                                 }
                                
                              }
                            }                           
                        }
                        if (vdListById != null) {
                           mobileVdListById.clear();
                           deskVdListById.clear();
                         for (VoucherDeals vd : vdListById) {
                            vd.setBenifitType("0");
                            if("1".equals(vd.getExclusive())){ 
                             if("1".equals(vd.getViewType())){
                                 mobileVdListById.add(0,vd);
                             }else if("0".equals(vd.getViewType())){
                                deskVdListById.add(0,vd);
                             }
                            }else{
                              if("1".equals(vd.getViewType())){
                                 mobileVdListById.add(vd);
                             }else if("0".equals(vd.getViewType())){
                                deskVdListById.add(vd);
                             }  
                            }
                          }
                        }%>    
                        
                        <%
                        int couponCountSimilar = 0;
                        if (mobileVdListById != null) {
                          for (VoucherDeals vd : mobileVdListById) {
                             if(couponCountSimilar>14)
                                break;
                            if (vd.getLanguageId().equals(language.getId())) {
                              couponCountSimilar++;
                              if ("1".equals(vd.getOfferType())) {
                                  voucherClass = "click-to-code vpop";
                                  voucherDesc = p.getProperty("public.home.get_voucher");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                  voucherClass = "activate-deal-2 u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                  voucherClass = "activate-deal u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              }
                        %>
                        <%@include file="mobOffer.jsp" %> 
                        <% } } } %>
                        
                        <%
                        couponCountSimilar = 0;
                        if (deskVdListById != null) {
                          for (VoucherDeals vd : deskVdListById) {
                             if(couponCountSimilar>14)
                                break;
                            if (vd.getLanguageId().equals(language.getId())) {
                              couponCountSimilar++;
                              if ("1".equals(vd.getOfferType())) {
                                  voucherClass = "click-to-code vpop";
                                  voucherDesc = p.getProperty("public.home.get_voucher");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() == null || "".equals(vd.getOfferImage()))) {
                                  voucherClass = "activate-deal-2 u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              } else if ("2".equals(vd.getOfferType()) && (vd.getOfferImage() != null || !"".equals(vd.getOfferImage()))) { //product deal
                                  voucherClass = "activate-deal u-deal";
                                  voucherDesc = p.getProperty("public.category.activate_deal");
                              }
                        %>
                        <%@include file="deskOffer.jsp" %> 
                        <% } } } %>
                        <!-- -------------------Offer Item End------------------------->  
                    </div>                                  
                                 