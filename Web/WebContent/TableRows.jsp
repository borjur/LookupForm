<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*"%>

<%
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	try
	{
		Class.forName("org.apache.derby.jdbc.ClientDriver");
		conn = DriverManager.getConnection("jdbc:derby://localhost:1527/AjaxData");
		
		int currentRow = Integer.parseInt(request.getParameter("Row"));
		int rowsToShow = Integer.parseInt(request.getParameter("RowsToShow"));
		int lowBoundary = currentRow - rowsToShow;
		int highBoundary = (currentRow - 1) + (rowsToShow * 2);
		
		String sql = "SELECT FirstName, LastName, StartYear, EndYear, ImagePath FROM Presidents WHERE PresidentID BETWEEN ? AND ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, Integer.toString(lowBoundary));
		stmt.setString(2, Integer.toString(highBoundary));
		
		rs = stmt.executeQuery();
		response.setContentType("text/xml");
	
		out.write("<Presidents>");
		while (rs.next()) 
		{
			out.write("<President>");
			out.write("<Name>" + rs.getString("FirstName") + " " + rs.getString("LastName") + "</Name>");
			out.write("<Years>" + rs.getString("StartYear") + "-" + rs.getString("EndYear") + "</Years>");
			out.write("<Image>" + rs.getString("ImagePath") + "</Image>");
			out.write("</President>");
		}
		out.write("</Presidents>");
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