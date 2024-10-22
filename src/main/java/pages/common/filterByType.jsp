<%--
    Document   : filterByType
    Created on : 3 Mar, 2016, 3 Mar, 2016 10:37:32 AM
    Author     : Vivek
--%>
<!-- -----Filter By Type------>
<div class="row">
    <div class="m-filter ">
          <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
              <ul>
                  <li class="active filterCoupon" name="category" data-type="4" data-cod="3" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a rel="nofollow" href="javascript:void();"><%=p.getProperty("public.store.all")%></a></li>
                  <li class="filterCoupon" name="category" data-type="5" data-cod="1" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a rel="nofollow" href="javascript:void();"><%=p.getProperty("public.store.coupon")%></a></li>
                  <li class="filterCoupon" name="category" data-type="6" data-cod="4" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a rel="nofollow" href="javascript:void();"><%=p.getProperty("public.store.deals")%></a></li>
              </ul>
          </div>
    </div>
 </div> 