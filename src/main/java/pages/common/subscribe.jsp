<%-- 
    Document   : subscribe
    Created on : 28 Mar, 2016, 28 Mar, 2016 4:07:22 PM
    Author     : Vivek
--%>
<div class="side-col newsletter-sub <%=rtl%>">
        <h3><%=p.getProperty("public.category.never_miss")+" "+storeName%></h3>
        <p><%=p.getProperty("public.category.best_vouchercodes")%></p>
        <input type="text" class="email-store form-control" name="email-store" id="email-store" placeholder="<%=p.getProperty("public.home.email_address")%>"/>
        <label class="newsletter-msg-category"></label>
        <button type="submit" id="nlstoresub" class="nlstoresub cursor-href btn rtl"><%=p.getProperty("public.home.newsletter.subscribe")+" "+ p.getProperty("public.store.now")%></button>
        <div id="loading" class="loading" style="display:none"><img src="<%=SystemConstant.PATH%>images/loading.gif" alt="loading"/></div>
</div>
