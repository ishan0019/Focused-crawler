<%@ page language="java" import="java.io.*,java.util.*,java.sql.*"%>

<%
    String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
		
	String connectionURL = "jdbc:mysql://localhost:3306/temp2";
	Connection con = null;
	PreparedStatement pst = null;
	ResultSet rs = null;
	java.util.Properties properties = new java.util.Properties();
	properties.put("user", "root");
	properties.put("password", "");
	
	
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	 con = DriverManager.getConnection(connectionURL, properties); //to_date(('"+tDate+"')
     
	 String labName="";//used for fetching hits for a lab       
	
	//String connectionURL = "jdbc:mysql://10.1.52.241/drdo"; 
	 //properties.put("user", "drdo");
	//properties.put("password", "a*3DeczH2g");
	
%>

