<%-- 
    Document   : report
    Created on : Jan 11, 2017, Jan 11, 2017 4:16:01 PM
    Author     : Rakesh Bhatt
--%>

<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%  if (request != null) {
    
    String key = request.getParameter("key")==null ? "" : request.getParameter("key");
    String reportReq = request.getParameter("key")==null ? "" : request.getParameter("report");
    ResultSet rs = null;
    String query = "";
    String reportName = "";
    String reportPath= "";
    Db db = Connect.newDb();
      if(!key.equals("zxb0198AS")){
         out.println("You are not authorised, Please don't repeat this activity again");   
         return;  
      }
  
    if (null != reportReq && !reportReq.isEmpty()) {
        //queryString = java.net.URLDecoder.decode(request.getQueryString());
        try {
            if (reportReq.equals("CouponsPerformanceReport")) {
                query = "SELECT * from vc_active_offer_stats";
                reportPath = "/var/lib/tomcat8/webapps/ROOT/pages/CouponsPerformanceReport.csv";
                reportName = "CouponsPerformanceReport.csv";
            } else if (reportReq.equals("OffersPerStore")) {
                query = "SELECT * from vc_offer_per_store_view";
                reportPath = "/var/lib/tomcat8/webapps/ROOT/pages/OffersPerStore.csv";
                reportName = "OffersPerStore.csv";
            } else if (reportReq.equals("ContentUpdationReport")) {
                query = "SELECT * from coupon_updation_report";
                reportPath = "/var/lib/tomcat8/webapps/ROOT/pages/ContentUpdationReport.csv";
                reportName = "ContentUpdationReport.csv";
            } else if (reportReq.equals("CouponsExpiringNextWeekReport")) {
                query = "SELECT * from vw_expiring_coupons_next_week";
                reportPath = "/var/lib/tomcat8/webapps/ROOT/pages/CouponsExpiringNextWeekReport.csv";
                reportName = "CouponsExpiringNextWeekReport.csv";
            } else if (reportReq.equals("UserSubscriptionReport")) {
                query = "SELECT * from vw_user_subscription";
                reportPath = "/var/lib/tomcat8/webapps/ROOT/pages/UserSubscriptionReport.csv";
                reportName = "UserSubscriptionReport.csv";
            }else {
                out.println("<pre>Please pass the valid report name in request. </br></br>"
                        + "Valid report names are: </br> "
                        + "1. CouponsPerformanceReport "
                        + "2. OffersPerStore </pre>");
                return;
            }
            rs = db.select().resultSet(query, null);
            PrintWriter csvWriter = new PrintWriter(new File(reportPath)) ;
            ResultSetMetaData meta = rs.getMetaData() ; 
            int numberOfColumns = meta.getColumnCount() ; 
            String dataHeaders = "\"" + meta.getColumnName(1) + "\"" ; 
            for (int i = 2 ; i < numberOfColumns + 1 ; i ++ ) { 
                dataHeaders += ",\"" + meta.getColumnName(i) + "\"" ;
            }
            csvWriter.println(dataHeaders) ;
            while (rs.next()) {
                String row = "\"" + rs.getString(1) + "\""  ; 
                for (int i = 2 ; i < numberOfColumns + 1 ; i ++ ) {
                    if (null != rs.getString(i)) {
                        row += ",\"" + rs.getString(i) + "\"" ;
                    } else {
                        row += ",";
                    }
                }
                csvWriter.println(row) ;
            }
            csvWriter.close();
            response.setContentType("application/csv");
            response.setHeader("content-disposition","filename="+reportName); // Filename
		
		PrintWriter outx = response.getWriter();
                BufferedReader br = new BufferedReader(new FileReader(reportPath));
                String line = "";
                while ((line = br.readLine()) != null) {
                    outx.println(line);
                }
		outx.flush();
		outx.close();
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }
    } else {
        out.println("Please pass the valid report name in request.");
        return;
    }
}



%>
