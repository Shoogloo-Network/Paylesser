<%-- 
    Document   : editProfile
    Created on : Mar 15, 2016, 2:47:36 PM
    Author     : IshahaqKhan
--%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sdigital.vcpublic.home.*" %>
<%@page import="java.util.Properties"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.config.*" %>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>

<%
String name = "";
LoginInfo lInfo = new LoginInfo();
if(session.getAttribute("userObj") != null) {
    lInfo = (LoginInfo)session.getAttribute("userObj");
    if(lInfo.getPublicUserName().contains(" ")) {
        name = lInfo.getPublicUserName().substring(0, lInfo.getPublicUserName().indexOf(" "));
    } 
    else {
        name = lInfo.getPublicUserName();
    }
}

SimpleDateFormat format = new SimpleDateFormat("dd MMM yyyy");
SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-mm-dd");
SimpleDateFormat dbformat = new SimpleDateFormat("yyyy-mm-dd");
java.util.Date date = new Date();
java.sql.ResultSet rs = null;

String login = request.getParameter("log-status") == null ? "" : request.getParameter("log-status").replaceAll("\\<.*?>", "");
String logMail = request.getParameter("log-mail") == null ? "" : request.getParameter("log-mail").replaceAll("\\<.*?>", "");
String logPwd = request.getParameter("log-pwd") == null ? "" : request.getParameter("log-pwd").replaceAll("\\<.*?>", "");
String logSave = request.getParameter("log-save") == null ? "" : request.getParameter("log-save").replaceAll("\\<.*?>", "");
String qry = "SELECT name, password, gender, dob, email, address, city FROM vc_public_user WHERE id = ?";

String voucherClass = "";
String voucherDesc = "";
String storeId = "0";
String strDate = "";
String imagePath = "";
Db db =  Connect.newDb();

try {
    boolean top = true;
    boolean vouchers = true;
    boolean deals = true;
    String requestUrl = request.getRequestURL().toString();
    String domainName = "";
    String pageName = "";
    if (requestUrl.indexOf("http://") > -1) {
        String[] str1 = requestUrl.split("http://");
        if (str1[1].indexOf("/", 1) > -1) {
            domainName = str1[1].substring(0, str1[1].indexOf("/", 1));
        } 
        else {
            domainName = str1[1];
        }

        //Check the validity of DOMAIN and get the DOMAIN_PKID and default language ID
        // if exits 
        if (str1[1].indexOf("/", 1) > -1 && str1[1].indexOf("/", 1) < str1[1].length()) {
            pageName = str1[1].substring(str1[1].indexOf("/", 1) + 1, str1[1].length());
        } 
        else { // direct to index page

        }
    }
    String pageUrl = (String)session.getAttribute("scheme")+"://" + domainName + "/";
    String pageType = "0";
    String pageTypeFk = "";
    VcHome home = VcHome.instance();
    VcSession vcsession = VcSession.instance();
    String domainId = home.getDomainId(domainName);
    List<Domains> domains = home.getDomains(domainId);
    Domains domain = home.getDomain(domains, domainId); // active domain
    List<Language> languages = home.getLanguages(domain.getId());
    Language language = vcsession.getLanguage(session, domain.getId(), languages);
    Properties p = home.getLabels(language.getId());
    HomeConfig homeConfig = home.getConfig(domainId);
    List<SeoUrl> seoList = home.getSeoByDomainId(domainId);
    List<VoucherDeals> topDealList = home.getTopDealByDomainId(domainId);
    List<MetaTags> metaList = home.getMetaByDomainId(domainId);
%>
    <!DOCTYPE html>
    <!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
    <!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
    <!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
    <!--[if gt IE 8]><!-->
    <%@ taglib uri="http://htmlcompressor.googlecode.com/taglib/compressor" prefix="compress" %>
<%@ taglib uri="http://granule.com/tags" prefix="g" %>  
<html class="no-js"  lang="<%=session.getAttribute("isoCode")%>"> 
    
        <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">	
	
            <title itemprop="name">Paylesser | <%=p.getProperty("public.home.profile")%></title>
            <meta name="description" content="">
            <meta name="viewport" content="width=device-width, initial-scale=1">
        <%
        if(metaList != null) {
          for(MetaTags m : metaList) {
        %>  
        <%=m.getMetaTags()%>
        <%}
        }
        %>           
            <link href="<%=SystemConstant.PATH%>css/mixins.css" rel="stylesheet"/>
            <%@include file="common/header.jsp" %>
        </head>
<compress:html enabled="true" removeComments="true" compressJavaScript="false" yuiJsDisableOptimizations="true">
        <body>
            
<style>

    /* --------- date picker --------- */
.date-picker {
	font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
	font-size: 13px;
	color: #444;
	text-align: center;
	cursor: default;

	border: 1px solid #ccc;
	margin: 6px 0;
	background: #fff;
	border-radius: 3px;
	box-shadow: 6px 6px 12px rgba(0, 0, 0, 0.1);
}
.date-picker.has-week-no {
	box-shadow: 6px 6px 12px rgba(0, 0, 0, 0.1),
		inset 30px 61px 0px -1px rgba(255, 255, 255, 1),
		inset 30px 61px 0px 0px rgba(204, 204, 204, 1);
}

.date-picker:before, .date-picker:after {
	content: "";
    display: block;
    position: absolute;
    top: -9px;
    left: 8px;
    border: 8px solid #ccc;
    border-width: 0px 8px 8px;
    border-color: transparent transparent #ccc;
}
.date-picker:after {
    top: -8px;
    border-color: transparent transparent #eee;
}
.date-picker .cal-month {
	margin: 2px;
}

/* ------ months ------ */
.date-picker .cal-month td {
	position: relative;
	box-sizing: border-box;
	width: 27px;
	height: 27px;
	border-radius: 2px;
}
.date-picker .cal-month th {
	padding-bottom: 4px;
}

.week-end {
	color: #77A;
}
.disabled {
	color: #aaa;
}
.week-end.next-month, .week-end.prev-month {
	color: #ddd;
}
.cal-month tbody td:not(.disabled):not(.week-no):hover {
	background-color: #eee;
	color: #000;
	cursor: pointer;
}
.selected-day {
	background-color: #ddd;
}
.today {
	border: 1px solid #bbb;
}
.event:after {
	content: "";
	position: absolute;
	left: 1px;
	top: 1px;
	width: 0;
	height: 0;
	border: 3px solid #ccc;
	border-color: #ccc transparent transparent #ccc;
}
.week-no {
	color: #999;
	padding-right: 6px;
}

/* ------ the UI for the picker (next, prev, month, year and time) ------ */
.dp-title, .dp-footer {
	text-align: center;
	min-width: 140px;
	font-size: 15px;
    padding: 5px;
    
    background: #f0f0f0;
	border-radius: 0 0 3px 3px;
}
.dp-title {
    border-radius: 3px 3px 0 0;
}
.dp-label {
	margin: 0 2px -4px;
}
.dp-label-month {
	font-weight: bold;
}
.dp-label:hover {
    color: #000;
}
/* bigger buttons */
.dp-prev, .dp-next {
	display: block;
    position: relative;
    outline: none;

    width: 30px;
    height: 30px;
    text-indent: 30px;
    white-space: nowrap;
    border: none;

    margin: -4px -1px;

    opacity: .5;
}
.dp-prev:after, .dp-next:after {
	content: "";
	position: absolute;
	top: 50%;
	left: 50%;
	width: 0px;
	height: 0px;
	margin: -6px -12px;

	border: 6px solid #000;
}
.dp-prev:after {
	border-color: transparent #000 transparent transparent;
}

.dp-next:after {
	border-color: transparent transparent transparent #000;
	margin: -6px 0px;
}
.dp-prev[disabled]:after, .dp-next[disabled]:after {
	visibility: hidden;
}
.dp-prev:hover, .dp-next:hover {
	opacity: 1;
}


.date-picker { /* options.datePickerClass; the picker itself */
	position: absolute;
}
.previous-month, .next-month { /* option.prevMonthClass ,... */
	color: #ddd; /* days outside of current month */
}
.disabled { /* options.disabledClass */
	color: #666;
	/*text-decoration: line-through;*/
}

/* --- the UI for the picker (next, prev, month, year and time) --- */
.dp-title, .dp-footer { /* defined in HTML of option.header and option.footer */
	text-align: center;
	min-width: 140px; /* good for time picker or year/month only */
}
.dp-label {
	position: relative;
	display: inline-block;
	overflow: hidden;
}
.dp-title select, .dp-footer select {
	position: absolute;
	left: 0; /* cover text but... */
	top: 0;
	opacity: 0; /* ...make other text visible */
}
.dp-prev, .dp-next { /* options.nextButtonClass, ... */
	overflow: hidden;
	background-color: transparent;
	padding: 0;

	float: left; /* will be overwritten for .dp-next */

	width: 0px; /* draw arrow with borders */
	height: 0px;
	border: 6px solid #000;
	border-color: transparent #000 transparent transparent;
}
.dp-next {
	border-color: transparent transparent transparent #000;
	float: right;
}
.dp-prev[disabled], .dp-next[disabled] {
	border-color: transparent; /* or display:none */
}


                
 </style>  
            
            
            
            <!--[if lt IE 7]>
                <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
            <![endif]-->
            <!-- ======================Main Wraper Start==================== -->
            <div id="wraper" class="inner">   
                <%@include file="common/topMenu.jsp" %>
              <div class="store-middle">
                <div class="container">
                    <div class="row">
                <!-- -------------------CMS Pages Start------------------------->
                <div class="col-lg-9 col-md-9 col-sm-12 col-xs-12">
                    <div class="cms-pages">
                        <div class="content-box1">
                            <div class="user-profile-page">
                             <%@include file="common/commonProfile.jsp" %>
                <div class="user-profile-body">
                    <div class="user-body-content">
                        <h2><%=p.getProperty("public.saved_coupon.edit")%></h2>
                        <div class="edit profile content-box">
                            <form role="form"id="frm" method="post" action="editprofiledb">
                                <%rs = db.select().resultSet(qry, new Object[]{lInfo.getPublicUserId()});
                                if(rs.next()) {
                                    if(rs.getString("dob") != null && !"".equals(rs.getString("dob"))) {
                                        date = dbformat.parse(rs.getString("dob"));
                                        strDate = sFormat.format(date);
                                    }}%>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.signup.name")%></label>
                                     <input class="form-control" id="usr-name" name="usr-name" type="text" value="<%=rs.getString("name")%>" maxlength="30"/>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.login.email")%></label>
                                    <input type="text" id="usr-mail" name="usr-mail" class="form-control" value="<%=rs.getString("email")%>" disabled="disabled"/>                                 
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.home.mail.password")%></label>
                                    <input type="password" class="form-control" id="usr-pwd" name="usr-pwd" value="<%=rs.getString("password")%>" maxlength="30"/>
                                </div>
                                <div class="form-group">
                                     <label><%=p.getProperty("public.signup.cpassword")%></label>
                                     <input type="password" class="form-control" id="usr-conpwd" name="usr-conpwd" value="<%=rs.getString("password")%>" maxlength="30"/>
                                </div>
                                <div class="form-group">
                                    <label><%=p.getProperty("public.signup.gender")%></label>
                                        <select id="profile-select" name="gender">
                                            <option value="null" <%=rs.getString("gender")== null ? "":"selected=\"selected\""%>>Select Gender</option>
                                            <option value="1" <%="1".equals(rs.getString("gender")) ? "selected=\"selected\"" : ""%>>Male</option>
                                            <option value="0" <%="0".equals(rs.getString("gender")) ? "selected=\"selected\"" : ""%>>Female</option>
                                        </select>
                                </div>
                                <div class="form-group">
                                     <label><%=p.getProperty("public.signup.birthday")%>(Select from calender)</label>
                                     <input type="text"  id="usr-bday" name="usr-bday" class="form-control" value="<%=strDate%>" maxlength="12"/>
                                </div>
                                <div class="form-group">
                                     <label><%=p.getProperty("public.signup.address")%></label>
                                     <textarea class="form-control" id="usr-addr" name="usr-addr" rows="4" cols="4" maxlength="255"><%=rs.getString("address") == null ? "" : rs.getString("address")%></textarea>
                                </div>  
                                <div class="form-group">
                                    <label><%=p.getProperty("public.home.city")%></label>
                                    <input class="form-control" value="<%=rs.getString("city")== null ? "":rs.getString("city")%>" type="text" name="userCity" id="userCity">
                                </div>
                                
                                <input name="hid-pwd" type="hidden" value="<%=rs.getString("password")%>"/>
                                <input name="red-url" type="hidden" value="<%=pageUrl%>"/>
                                <div class="form-group">
                                    <button type="submit" class="btn green" ><%=p.getProperty("public.signup.savechanges")%></button>
                                </div>
                            </form>   
                        </div>
                        <!-- -------------------CMS Pages End-------------------------> 
                    </div>   
                </div>
                </div></div></div></div>
                <!-- -------------------Sidebar Start------------------------->
                <div class="col-lg-3 col-md-3 col-sm-12 col-xs-12 hidden-xs">
                    <div class="sidebar">
                        <!-- -----Popular Category------>
                        <%@include file="common/popularCategory.jsp" %>
                      <!-- -----Related Store------>
                        <%@include file="common/popularStores.jsp" %>
                        
                    </div>        
                </div>
                <!-- -------------------Sidebar End---------------------------->
            </div>    
        </div>
    </div>
             <!-- ======================Company Profile End==================== -->
            </div>
          <!-- ======================Main Wraper End======================= -->   

           <%@include file="common/bottomMenu.jsp"%>   
           <%@include file="common/footer.jsp" %>
           
           <script src="<%=SystemConstant.PATH%>js/datePicker.min.js"></script>
            <script>
                usrProfile = '<%=p.getProperty("public.home.saved_coupons")%>';
                favStores = '<%=p.getProperty("public.home.favourite_stores")%>';
                accntPrefer = '<%=p.getProperty("public.saved_coupon.account")%>';
                notMatching = '<%=p.getProperty("public.edit_profile.not_matching")%>';
                enterConfirm = '<%=p.getProperty("public.edit_profile.enter_confirm")%>';
                enterPwd = '<%=p.getProperty("public.edit_profile.enter_password")%>';
                enterName = '<%=p.getProperty("public.edit_profile.enter_name")%>';
       
                window.myDatePicker = new DatePicker('#usr-bday', {
                    datePickerClass: 'date-picker has-week-no',
                    sundayBased: false,
                    renderWeekNo: true
	       });
                
            </script>
            <script src="<%=SystemConstant.PATH%>js/user-profile.js"></script>
            
        </body>
</compress:html>
    </html>
<%} 
catch(Throwable e) {
    Logger.getLogger("editProfile.jsp").log(Level.SEVERE, null, e);
}
finally {
    Cleaner.close(rs);
    db.select().clean();
    Connect.close(db);
}%>