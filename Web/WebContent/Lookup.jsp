<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%>

<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try
	{
		Class.forName("org.apache.derby.jdbc.ClientDriver");
		conn = DriverManager.getConnection("jdbc:derby://localhost:1527/AjaxData");
		
		String sql = "SELECT FirstName, LastName, StartYear, EndYear FROM Presidents WHERE StartYear <= ? AND EndYear >= ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, request.getParameter("year"));
		stmt.setString(2, request.getParameter("year"));
		
		rs = stmt.executeQuery();
		int i = 0;
		while (rs.next())
		{
			out.write(rs.getString("FirstName") + " " + rs.getString("LastName"));
			out.write(" (" + rs.getString("StartYear") + " - " + rs.getString("EndYear") + ")<br/>");
			i++;
		}
		if (i==0)
		{
			out.write("No results");
		}
	}
	catch(Exception e)
	{
		out.write("failed: " + e.toString());
	}
	finally 
	{
		if (rs != null) rs.close();
		if (stmt != null) stmt.close();
		if (conn != null) conn.close();
	}
%>