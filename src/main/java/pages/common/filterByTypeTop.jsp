     
<div class="btn-group pull-right filter-by-type">
         <button class="btn btn-default btn-sm dropdown-toggle " type="button" id="offerFilter" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
          <%=p.getProperty("public.store.filter")%> : 
           <span class="caret"></span>
         </button>
         <ul class="dropdown-menu" aria-labelledby="offerFilter">
           <li class="filterCoupon" name="category" data-type="4" data-cod="3" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.store.all")%></span></a></li>
           <li class="filterCoupon" name="category" data-type="5" data-cod="1" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.home.coupondetails.coupon")%></span></a></li>
           <li class="filterCoupon" name="category" data-type="6" data-cod="4" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.home.coupondetails.deal")%></span></a></li>
           <!--<li class="filterByStore" name="category" data-type="6" data-cod="2" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.store.deals")%></span></a></li>
           <li class="filterByStore" name="category" data-type="6" data-cod="5" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.home.sale")%></span></a></li>
           <li role="separator" class="divider"></li>
           <li class="filterByStore" name="category" data-type="3" data-cod="0" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.store.most_recent")%></span></a></li>
           <li class="filterByStore" name="category" data-type="1" data-cod="0" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.store.most")%></span></a></li>
           <li class="filterByStore" name="category" data-type="2" data-cod="0" data-page="<%=storePageType%>" data-cat="<%=childId%>" data-brand="<%=childId%>"><a><span><%=p.getProperty("public.store.top")%></span></a></li>-->
         </ul>
       </div>
