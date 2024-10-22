<%-- 
    Document   : commonProfile
    Created on : 1 Apr, 2016, 1 Apr, 2016 11:54:25 AM
    Author     : Vivek
--%>

<%@page import="java.util.Date"%>

<%
String activeP = ""; 
String activeE = ""; 
String activeS = "";
String activeU = "";
String activeF = ""; 
if(requestUrl.indexOf("user-profile") > -1){
    activeP="active";
}else if(requestUrl.indexOf("edit-profile") > -1){
    activeE="active";
}if(requestUrl.indexOf("saved-coupon") > -1){
    activeS="active";
}if(requestUrl.indexOf("favourite-stores") > -1 || requestUrl.indexOf("add-stores") > -1){
    activeF="active";
}if(requestUrl.indexOf("user-preferences") > -1){
    activeU="active";
}
%>
<div class="common">
    <div class="user-overview">
        <div  class="user-profile-pic"></div>
        <div class="user-profile-detail">
            <span class="user-name"><a href="<%=pageUrl%>user-profile">
                            <%if (lInfo.getPublicUserName().contains(" ")) {
                                    out.print(lInfo.getPublicUserName().substring(0, lInfo.getPublicUserName().indexOf(" ")));
                                } else {
                                    out.print(lInfo.getPublicUserName());
                                    }%>
                        </a></span>
            <div class="user-info">     
                <%if (lInfo.getLastLogin() != null && !"".equals(lInfo.getLastLogin())) {
                     out.print(p.getProperty("public.saved_coupon.last_login") + format.format(lInfo.getLastLogin()));
                  }else{
                     out.print(p.getProperty("public.saved_coupon.last_login") + format.format(new Date()));
                }%>
            </div>
           
        </div>

    </div>
    <ul class="user-tabs">
        <li class="Dashboard <%=activeP%>"><a class="" href="<%=pageUrl%>user-profile">Dashboard</a></li>
            <li class="saved-coupons <%=activeS%>"><a href="<%=pageUrl%>saved-coupon"><%=p.getProperty("public.home.saved_coupons")%></a></li>
            <li class="fav-stores <%=activeF%>"><a href="<%=pageUrl%>favourite-stores"><%=p.getProperty("public.home.favourite_stores")%></a></li>
            <li class="acc-preference <%=activeU%>"><a href="<%=pageUrl%>user-preferences"><%=p.getProperty("public.saved_coupon.account")%></a></li>
            <li class="edit-profile <%=activeE%>"><a href="<%=pageUrl%>edit-profile" ><%=p.getProperty("public.saved_coupon.edit")%></a></li>
            
    </ul>
</div>
