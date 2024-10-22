<%-- 
    Document   : loadData
    Created on : Dec 9, 2014, 4:46:56 PM
    Author     : Ishahaq
--%>

<%@page import="java.text.ParseException"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Map"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.io.File"%>
<%@page import="wawo.util.StringUtil"%>
<%@page import="sdigital.vcpublic.home.LoginInfo"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.Properties"%>
<%@page import="sdigital.vcpublic.home.Language"%>
<%@page import="sdigital.vcpublic.home.Domains"%>
<%@page import="sdigital.vcpublic.home.Category"%>
<%@page import="sdigital.vcpublic.home.VoucherDeals"%>
<%@page import="java.util.List"%>
<%@page import="sdigital.vcpublic.home.VcSession"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="sdigital.vcpublic.config.SystemConstant"%>
<%@page import="sdigital.vcpublic.home.VcHome"%>
<%@page import="sdigital.vcpublic.home.HomeConfig"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="sdigital.vcpublic.db.Connect"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="wawo.sql.Cleaner"%>
<%@page import="wawo.sql.jdbc.Db"%>
<%@page import="sdigital.vcpublic.db.Connect"%>


<%
  String code = request.getParameter("secret") == null ? "0" : request.getParameter("secret");  
  String pass = request.getParameter("pass")==null ? "" : request.getParameter("pass");
  
  Db db=null;
  ResultSet r = null;
  ResultSet rs = null;
  Db dbIn = null;
  Calendar calCurrent = Calendar.getInstance();
  Calendar calRec = Calendar.getInstance();
  calCurrent.setTime(new java.util.Date());
  boolean sameDay = false;
  try{  
    SimpleDateFormat formatter = new SimpleDateFormat("ddMMyyyy");  
    calRec.setTime(formatter.parse(pass));
    sameDay = calCurrent.get(Calendar.YEAR) == calRec.get(Calendar.YEAR) &&
                      calCurrent.get(Calendar.DAY_OF_YEAR) == calRec.get(Calendar.DAY_OF_YEAR);  
  }catch(ParseException  e){
     out.println("You are not authorised, Please don't repeat this activity again");   
     return; 
  }
  if(!sameDay){
     out.println("You are not authorised, Please don't repeat this activity again");   
     return;  
  }
  
  try {
    
      db = Connect.newDb();
      ResultSet rT = db.select().resultSet("SELECT refreshed_at FROM gl_cache_status WHERE status = ?", new Object[]{1}); 
      if(rT.next()){
        long rTime = (rT.getTimestamp("refreshed_at")).getTime();
        long cTime = new java.util.Date().getTime();
        if((cTime-rTime)>300000){
             db.execute().update("UPDATE gl_cache_status SET status = ? WHERE status = ?", new Object[]{3, 1});
        }
        Cleaner.close(rT);
      }
      r = db.select().resultSet("SELECT status FROM gl_cache_status WHERE status = ?", new Object[]{1});    
      if(r.next()){
          out.println("Data reload is already in progress by some other user. Please try again after 5 minutes.");
      }else{
        dbIn = Connect.newDb();  
        java.sql.Timestamp today = new java.sql.Timestamp(new java.util.Date().getTime());  
        dbIn.execute().insert("INSERT INTO gl_cache_status(status, refreshed_at, id) VALUES(?,?,?)",new Object[]{1, today}, "gl_cache_status_seq");
        rs = dbIn.select().resultSet("SELECT currval('gl_cache_status_seq')", null);
        Cleaner.close(rs);
        dbIn.select().clean();
        Connect.close(dbIn);
        VcHome home = VcHome.instance();
        home.loadData();
        db.execute().update("UPDATE gl_cache_status SET status = ? WHERE status = ?", new Object[]{2, 1});
        if("1".equals(code)){
        out.println("<h1>Data Reload Statics</h1>");
        out.println("<p>"+System.getenv("HOSTNAME")+"</p>");
        out.println(home.getStatics());
        }else{
          out.println("Data Reloaded");  
        }        
      }
    
  } catch (Exception e) {
    Cleaner.close(rs);
    dbIn.select().clean();
    Connect.close(dbIn);  
    db.execute().update("UPDATE gl_cache_status SET status = ? WHERE status = ?", new Object[]{3, 1});
    Logger.getLogger("LoadData.java").log(Level.SEVERE, null, e);
  } finally {    
    Cleaner.close(r);
    db.select().clean();
    Connect.close(db);
  }
%>

